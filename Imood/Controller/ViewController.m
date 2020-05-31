//
//  ViewController.m
//  Composer
//
//  Created by 马 爱林 on 14/10/29.
//  Copyright (c) 2014年 马 爱林. All rights reserved.
//

#import "ViewController.h"
#import "CompViewController.h"
#import "GPUImage.h"
#import <AVKit/AVKit.h>
#import <Toast.h>
#import <ReactiveObjC.h>
#import "PlayerContentView.h"
//#import <ZLPhotoBrowser/ZLPhotoBrowser.h>

@interface ViewController ()< AVAudioPlayerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate,FeSlideFilterViewDataSource, FeSlideFilterViewDelegate,UIAlertViewDelegate,UIScrollViewDelegate>

@property(strong, nonatomic)UIImagePickerController *picker;
@property(strong, nonatomic)NSData *imageData;
@property(strong, nonatomic)UIImageView *m_pCameraImage;
@property(strong, nonatomic)AVAudioPlayer *myPlay;
@property(strong, nonatomic)UISwipeGestureRecognizer *recognizer;
@property(strong, nonatomic)UIImage* resultLab;
@property (nonatomic, strong) UIButton *albumBtn;

@property(strong, nonatomic)NSMutableArray *imgArray;//放选加滤镜后的照片
@property(strong, nonatomic)NSMutableArray *originalImageArray;//放选择好的原使照片

@property(strong, nonatomic)NSURL *mixMusicURL;//混合后音频路径
@property(strong, nonatomic)NSURL *videoPath;//混合后视频路径
@property(strong, nonatomic)NSURL *theEndVideoURL;//最终视频路径
@property(strong, nonatomic)PlayerContentView *movieplay;//视频播放器
@property(strong, nonatomic)UISlider *slider;//调节播放时间
@property(strong, nonatomic)UIButton *compositionPlay;//最终合成播放
//滤镜
@property (strong, nonatomic) FeSlideFilterView *slideFilterView;
@property (strong, nonatomic) NSMutableArray *arrPhoto;
@property (strong, nonatomic) NSArray *arrTittleFilter;
@property (nonatomic, strong) UIButton *addMusicBtn;

@end
@implementation ViewController{
    int imgWidth ;//预览图片大小
    NSInteger imgCount ;//加载的图片数
    UIScrollView *scroll;//选择图片
    UILabel *selectedLabel;//选中图片标记
    UIView *loadView;//覆盖view
    NSInteger btnIndex;//选中的图片下标
    NSInteger indexFilter;//选择第几个滤镜
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.navigationController.navigationBar.translucent =YES;
    //self.title =@"创歌";
    //显示照片
    self.m_pCameraImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, kStatusBarH, SCR_WIDTH, SCR_WIDTH)];
    if (IS_4INCH_DEVICE || iPadAir ||iPad2) {
        self.m_pCameraImage.frame =CGRectMake(0, kStatusBarH, SCR_WIDTH, SCR_WIDTH/1.5);
    }
    self.m_pCameraImage.image = [UIImage imageNamed:@"background"];
    [self.view addSubview:self.m_pCameraImage];
    [self.m_pCameraImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.width.height.with.offset(SCR_WIDTH);
        make.top.equalTo(self.view).with.offset(0);
    }];
    //加滤镜的显示照片
//    _slideFilterView = [[FeSlideFilterView alloc] initWithFrame:CGRectMake(0, 90, SCR_WIDTH, SCR_WIDTH)];
//    _slideFilterView.dataSource = self;
//    _slideFilterView.delegate = self;
//    [self.view addSubview:_slideFilterView];

    //图片合成视频按钮
    self.compositionPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    self.compositionPlay.frame = CGRectMake(0, kStatusBarH, SCR_WIDTH, SCR_WIDTH);
    [self.compositionPlay setImage:[UIImage imageNamed:@"play_btn"]  forState:UIControlStateNormal];
    [self.compositionPlay addTarget:self action:@selector(selectMixVideoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:self.compositionPlay];
    [self.view addSubview:self.compositionPlay];
    //
    self.imgArray = [NSMutableArray arrayWithCapacity:10];//加滤镜的图片
    self.originalImageArray =[NSMutableArray arrayWithCapacity:10];//放原始图片
    indexFilter =0;//默认滤镜0
    //选择照片的scroll
    scroll =[[UIScrollView alloc]initWithFrame:CGRectMake(0, kStatusBarH+SCR_WIDTH, SCR_WIDTH, SCR_WIDTH/5+6)];
    [self.view addSubview:scroll];
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.with.offset(SCR_WIDTH);
        make.height.with.offset(SCR_WIDTH/5+6);
        make.left.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(SCR_WIDTH);
    }];
    scroll.backgroundColor =[UIColor colorWithRed:0.200000F green:0.423529F blue:0.549020F alpha:1.0F];
    if (IS_4INCH_DEVICE || iPadAir ||iPad2) {
        scroll.frame =CGRectMake(0, 64+SCR_WIDTH/1.5, SCR_WIDTH, SCR_WIDTH/5+6);
    }
    scroll.delegate =self;
    scroll.showsHorizontalScrollIndicator =NO;
    scroll.contentSize=CGSizeMake(2*SCR_WIDTH, SCR_WIDTH/5);
    //从相册添加照片
    self.albumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.albumBtn.frame =CGRectMake(3, 6, SCR_WIDTH/5-6, SCR_WIDTH/5-6);
    [self.albumBtn setBackgroundImage:[UIImage imageNamed:@"album_add"] forState:UIControlStateNormal];
    [self.albumBtn addTarget:self action:@selector(selectForAlbumButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:self.albumBtn];
    //
    self.slider = [[UISlider alloc]init];
    [self.slider addTarget:self action:@selector(updatePlayTime) forControlEvents:UIControlEventValueChanged];
    [self.slider setMinimumValue:10];
    [self.slider setMaximumValue:30];
    self.slider.thumbTintColor =[UIColor greenColor];
    self.slider.value = 20;
    [self.slider setThumbImage:[UIImage imageNamed:@"faderKey"] forState:UIControlStateNormal];
    [self.slider setThumbImage:[UIImage imageNamed:@"faderKey"] forState:UIControlStateHighlighted];
    [self.view addSubview:self.slider];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self->scroll).with.offset(70);
        make.size.mas_equalTo(CGSizeMake(SCR_WIDTH*2/3, 44));
    }];
    //自定义音乐
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    [btn setImage:[UIImage imageNamed:@"music_add"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(customMusic) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).with.offset(-5 *SCR_WIDTH/12);
        make.centerY.equalTo(self.slider).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(30, 37));
    }];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        NSInteger k =scrollView.contentOffset.x*5/SCR_WIDTH;
        scroll.contentOffset =CGPointMake(k *SCR_WIDTH/5, 0);
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger k =scrollView.contentOffset.x*5/SCR_WIDTH;
    scroll.contentOffset =CGPointMake(k *SCR_WIDTH/5, 0);
}
-(void)updatePlayTime{
    NSLog(@"更新视频时间__%f",self.slider.value);
    [self.view makeToast:[NSString stringWithFormat:@"%.0f s ",self.slider.value] duration:1 position:nil];
}
-(void)playMovie{
    if (!self.originalImageArray.count) {
        [self.view makeToast:@"请加载图片" duration:1 position:nil];
        return;
    }
    if (self.movieplay.playerLayer.player.timeControlStatus  == AVPlayerTimeControlStatusPlaying) {
        [self.movieplay.playerLayer.player pause];
        [self.compositionPlay setImage:[UIImage imageNamed:@"play_btn"]  forState:UIControlStateNormal];
    }
    else if((self.movieplay.playerLayer.player.timeControlStatus == AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate) ){
        [self.movieplay.playerLayer.player play];
        [self.compositionPlay setImage:nil forState:UIControlStateNormal];
    }else{
        [self.movieplay removeFromSuperview];
        self.movieplay = [[PlayerContentView alloc]init];
        [self.movieplay playWithUrl:self.theEndVideoURL];
        [self.movieplay setFrame:self.m_pCameraImage.frame];
        if (IS_4INCH_DEVICE || iPadAir ||iPad2) {
            [self.movieplay setFrame:CGRectMake(0, kStatusBarH, SCR_WIDTH, SCR_WIDTH/1.5)];
        }
        [self.view addSubview:self.movieplay];
        self.compositionPlay.frame =self.movieplay.frame;
        [self.compositionPlay setImage:nil forState:UIControlStateNormal];
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackDidFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    }
    [self.view bringSubviewToFront:self.compositionPlay];
}
- (void)moviePlayerPlaybackDidFinish{
    [self.compositionPlay setImage:[UIImage imageNamed:@"play_btn"]  forState:UIControlStateNormal];
}
-(void)selectMixVideoButtonClick:(UIButton *)sender{
    //把原始图片给self.imgArray
    [self.imgArray removeAllObjects];
    self.imgArray =[NSMutableArray arrayWithCapacity:0];
    self.imgArray =[self.originalImageArray mutableCopy];//把原始图片给self.imgArray
    
    if ([self.imgArray count] &&self.movieplay.playerLayer.player.timeControlStatus == AVPlayerTimeControlStatusPaused) {
        if (indexFilter>=1&&indexFilter<=4) {
            for (NSInteger i=0; i <self.imgArray.count; i++) {
                //给所有图片上滤镜
               // NSLog(@"%ld",(long)indexFilter);
                NSString *nameLUT = [NSString stringWithFormat:@"filter_lut_%ld",(long)indexFilter];
                UIImage *photo = self.imgArray[i];
                // Create filter
                CIFilter *lutFilter = [CIFilter filterWithLUT:nameLUT dimension:64];
                // Set parameter
                CIImage *ciImage = [[CIImage alloc] initWithImage:photo];
                [lutFilter setValue:ciImage forKey:@"inputImage"];
                CIImage *outputImage = [lutFilter outputImage];
                CIContext *context = [CIContext contextWithOptions:[NSDictionary dictionaryWithObject:(__bridge id)(CGColorSpaceCreateDeviceRGB()) forKey:kCIContextWorkingColorSpace]];
                UIImage *newImage = [UIImage imageWithCGImage:[context createCGImage:outputImage fromRect:outputImage.extent]];
                [self.imgArray replaceObjectAtIndex:i withObject:newImage];//给所有图片换滤镜
            }
        }
        //覆盖整个屏幕
        [loadView removeFromSuperview];
        loadView =[[UIView alloc]initWithFrame:self.view.bounds];
        loadView.backgroundColor =[UIColor clearColor];
        [self.view addSubview:loadView];

        UIActivityIndicatorView *indicator =[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, SCR_WIDTH/5, SCR_WIDTH/5)];
        indicator.activityIndicatorViewStyle =UIActivityIndicatorViewStyleWhiteLarge;
        indicator.center =CGPointMake(SCR_WIDTH/2, SCR_WIDTH/2);
        indicator.backgroundColor =[UIColor grayColor];
        indicator.layer.masksToBounds =YES;
        indicator.layer.cornerRadius =10;
        indicator.alpha =0.8;
        indicator.clipsToBounds =NO;
        [indicator startAnimating];
        [loadView addSubview:indicator];
        UILabel *indicatorLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, SCR_WIDTH/5, SCR_WIDTH, 30)];
        indicatorLabel.text =@"正在加载...";
        indicatorLabel.textColor =[UIColor whiteColor];
        indicatorLabel.center =CGPointMake(self.view.center.x, indicator.center.y+SCR_WIDTH/10+15);
        indicatorLabel.textAlignment =NSTextAlignmentCenter;
        [loadView addSubview:indicatorLabel];

        NSString *moviePath =[NSTemporaryDirectory() stringByAppendingPathComponent:@"photo.mov"];
        if([[NSFileManager defaultManager]fileExistsAtPath:moviePath]){
            [[NSFileManager defaultManager]removeItemAtPath:moviePath error:nil];
        }
        NSURL *url = [NSURL fileURLWithPath:moviePath];
        self.videoPath = url;
        CGSize size =CGSizeMake(320*4,320*4);//定义视频的大小
        [self writeImages:self.imgArray ToMovieAtPath:moviePath withSize:size inDuration:self.slider.value byFPS:30];//第2中方法
    }else{
        [self playMovie];
    }
}
//图片合成视频方法二
- (void)writeImages:(NSArray *)imagesArray ToMovieAtPath:(NSString *) path withSize:(CGSize) size
         inDuration:(float)duration byFPS:(int32_t)fps{
    //Wire the writer:
    NSError *error =nil;
    unlink([path UTF8String]);
    AVAssetWriter *videoWriter =[[AVAssetWriter alloc]initWithURL:[NSURL fileURLWithPath:path]
                                                         fileType:AVFileTypeQuickTimeMovie
                                                            error:&error];

    NSParameterAssert(videoWriter);
    NSDictionary *videoSettings =[NSDictionary dictionaryWithObjectsAndKeys:
                                  AVVideoCodecH264,AVVideoCodecKey,
                                  [NSNumber numberWithInt:size.width],AVVideoWidthKey,
                                  [NSNumber numberWithInt:size.height],AVVideoHeightKey,
                                  nil];
    AVAssetWriterInput* videoWriterInput =[AVAssetWriterInput
                                           assetWriterInputWithMediaType:AVMediaTypeVideo
                                           outputSettings:videoSettings];
    NSDictionary *sourcePixelBufferAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ARGB],kCVPixelBufferPixelFormatTypeKey, nil];
    AVAssetWriterInputPixelBufferAdaptor *adaptor =[AVAssetWriterInputPixelBufferAdaptor
                                                    assetWriterInputPixelBufferAdaptorWithAssetWriterInput:videoWriterInput
                                                    sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
    NSParameterAssert(videoWriterInput);
    NSParameterAssert([videoWriter canAddInput:videoWriterInput]);
    [videoWriter addInput:videoWriterInput];
    //Start a session:
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];

    int imagesCount = (int)[imagesArray count];
    float averageTime = duration/imagesCount;
   
    //合成多张图片为一个视频文件
    dispatch_queue_t dispatchQueue =dispatch_queue_create("mediaInputQueue",NULL);
    int __block frame =0;
    @weakify(self)
    [videoWriterInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
        @strongify(self)
        while([videoWriterInput isReadyForMoreMediaData]){
            if(++frame >=[self.imgArray count]*10){
                [videoWriterInput markAsFinished];
                [videoWriter finishWritingWithCompletionHandler:^{
                    [self theVideoWithMixMusic];
                }];
                break;
            }
            CVPixelBufferRef buffer =NULL;
            int idx =frame/10;
            //NSLog(@"idx==%d",idx);
            buffer =(CVPixelBufferRef)[self pixelBufferFromCGImage:[[imagesArray objectAtIndex:idx]CGImage] size:size ];
            if (buffer){
//                CMTime t=CMTimeMake(frame *averageTime, 10);
//                CMTimeShow(t);
                if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame*averageTime,10)])
                    NSLog(@"FAIL");
                else
                    NSLog(@"OK");
                CFRelease(buffer);
            }
        }
    }];
}
- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size{
    NSDictionary *options =[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithBool:YES],kCVPixelBufferCGImageCompatibilityKey,
                            [NSNumber numberWithBool:YES],kCVPixelBufferCGBitmapContextCompatibilityKey,nil];
    CVPixelBufferRef pxbuffer =NULL;
    CVReturn status =CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef)options, &pxbuffer);
    
    NSParameterAssert(status ==kCVReturnSuccess && pxbuffer !=NULL);
    CVPixelBufferLockBaseAddress(pxbuffer,0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata !=NULL);
    CGColorSpaceRef rgbColorSpace=CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width, size.height, 8, 4*size.width, rgbColorSpace,kCGImageAlphaPremultipliedFirst);
    NSParameterAssert(context);
    CGContextDrawImage(context,CGRectMake(0,0,CGImageGetWidth(image),CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    CVPixelBufferUnlockBaseAddress(pxbuffer,0);
    return pxbuffer;

}
//最终音频和视频混合
-(void)theVideoWithMixMusic{
    //声音来源路径（最终混合的音频）
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *exportPath =[[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"exportMusic.m4a"]];
    NSURL    *outputUrl = [NSURL fileURLWithPath:exportPath];
    self.mixMusicURL =outputUrl;
    NSURL  *audio_inputFileUrl =self.mixMusicURL;
    
    //视频来源路径
    NSURL   *video_inputFileUrl = self.videoPath;
    NSLog(@"%@_________%@",audio_inputFileUrl,video_inputFileUrl);
    //最终合成输出路径
    NSArray *path =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *outputFilePath =[[path objectAtIndex:0]stringByAppendingPathComponent:@"final_video.mov"];
    NSURL   *outputFileUrl = [NSURL fileURLWithPath:outputFilePath];
    if([[NSFileManager defaultManager]fileExistsAtPath:outputFilePath])
        [[NSFileManager defaultManager]removeItemAtPath:outputFilePath error:nil];
    
    CMTime nextClipStartTime =kCMTimeZero;
    
    //创建可变的音频视频组合
    AVMutableComposition* mixComposition =[AVMutableComposition composition];
    
    //视频采集
    AVURLAsset* videoAsset =[[AVURLAsset alloc]initWithURL:video_inputFileUrl options:nil];
    CMTimeRange video_timeRange =CMTimeRangeMake(kCMTimeZero,videoAsset.duration);
    AVMutableCompositionTrack*a_compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [a_compositionVideoTrack insertTimeRange:video_timeRange ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo]objectAtIndex:0]atTime:nextClipStartTime error:nil];
    
    //声音采集
    if ([[NSFileManager defaultManager]fileExistsAtPath:exportPath] ) {
        AVURLAsset* audioAsset =[[AVURLAsset alloc]initWithURL:audio_inputFileUrl options:nil];
        CMTimeRange audio_timeRange =CMTimeRangeMake(kCMTimeZero,videoAsset.duration);//声音长度截取范围==视频长度
        AVMutableCompositionTrack *b_compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [b_compositionAudioTrack insertTimeRange:audio_timeRange ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0]atTime:nextClipStartTime error:nil];
    }
    //创建一个输出
    AVAssetExportSession* _assetExport =[[AVAssetExportSession alloc]initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
    _assetExport.outputFileType =AVFileTypeQuickTimeMovie;
    _assetExport.outputURL =outputFileUrl;
    _assetExport.shouldOptimizeForNetworkUse=YES;
    self.theEndVideoURL=outputFileUrl;
    [_assetExport exportAsynchronouslyWithCompletionHandler:^(void ) {
         NSLog(@"完成！输出路径__%@",outputFileUrl);
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self->loadView removeFromSuperview];
            [self playMovie];
        });
     }];
}
- (void)selectForAlbumButtonClick:(UIButton *)sender{
    [self.movieplay.playerLayer.player pause];
//    ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];
//    ac.configuration.maxSelectCount = 9;
//    ac.configuration.maxPreviewCount = 10;
//    ac.sender = self;
//    [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
//        NSMutableArray *clipImages = [NSMutableArray arrayWithCapacity:[images count]];
//        for (UIImage *image in images) {
//            if (image.size.height>=image.size.width) {
//                CGRect rect =  CGRectMake(0, (image.size.height -image.size.width)/2, image.size.width, image.size.width);
//                CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
//                UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
//                thumbScale =[self imageWithImageSimple:thumbScale scaledToSize:CGSizeMake(320*4, 320*4)];
//                [clipImages addObject:thumbScale];
//                CGImageRelease(imageRef);
//                NSLog(@"剪切后正方形照片%@",thumbScale);
//            }else{
//                CGRect rect =  CGRectMake((image.size.width -image.size.height)/2, 0, image.size.height, image.size.height);
//                CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
//                UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
//                thumbScale =[self imageWithImageSimple:thumbScale scaledToSize:CGSizeMake(320*4, 320*4)];
//                [clipImages addObject:thumbScale];
//                CGImageRelease(imageRef);
//                NSLog(@"剪切后正方形照片%@",thumbScale);
//            }
//        }
//        [self.originalImageArray removeAllObjects];
//        self.originalImageArray =[NSMutableArray arrayWithCapacity:0];
//        self.originalImageArray = clipImages;
//        if (self.originalImageArray.count>0) {
//            for (int i=0; i<self.originalImageArray.count; i++) {
//                UIButton *photoBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//                [photoBtn setBackgroundImage:self.originalImageArray[i] forState:UIControlStateNormal];
//                photoBtn.frame =CGRectMake(i *SCR_WIDTH/5+3, 6, SCR_WIDTH/5-6, SCR_WIDTH/5-6);
//                photoBtn.tag =i;
//                [photoBtn addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
//                [self->scroll addSubview:photoBtn];
//            }
//            self.albumBtn.frame =CGRectMake(self.originalImageArray.count *SCR_WIDTH/5+3, 6, SCR_WIDTH/5-6, SCR_WIDTH/5-6);
//        }
//        self.movieplay.hidden =YES;
//        [self.view addSubview:self.compositionPlay];
//    }];
//    [ac showPreviewAnimated:YES];
}
-(void)selectImage:(UIButton *)btn{
    btnIndex =btn.tag;
    NSLog(@"点击了第___%ld___张图片",(long)btnIndex);
    [self.movieplay.playerLayer.player pause];
    [self.movieplay removeFromSuperview];
    self.movieplay.hidden =YES;
    //self.m_pCameraImage.image =self.imgArray[btn.tag];
    //改变红线坐标
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    selectedLabel.frame =CGRectMake(3+btn.tag*SCR_WIDTH/5, SCR_WIDTH/5+1.5, SCR_WIDTH/5-6, 3);
    [UIView commitAnimations];
    
    //把原始图片给self.imgArray
    [self.imgArray removeAllObjects];
    self.imgArray =[NSMutableArray arrayWithCapacity:0];
    self.imgArray =[self.originalImageArray mutableCopy];//把原始图片给self.imgArray
    //NSLog(@"%@________%@",self.imgArray, self.originalImageArray);
    
    //滤镜
    // [self initCommon];
    //[self initPhotoFilter];
    // [self initTitle];
    //[self initFeSlideFilterView];
    self.m_pCameraImage.image =self.imgArray[btnIndex];
    [self.view bringSubviewToFront:self.compositionPlay];
}
//压缩图片尺寸
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)customMusic{
    UIAlertController *ac =[UIAlertController alertControllerWithTitle:@"提示" message:@"请选择音乐风格" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:cancelAction];
    NSArray *arr =@[@"流行",@"金属",@"思念",@"电子"];
    for (int i=0; i<4; i++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:arr[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CompViewController *composer= [[CompViewController alloc]init];
            composer.musicType =i+1;
            composer.modalPresentationStyle =UIModalPresentationFullScreen;
            [self presentViewController:composer animated:YES completion:nil];
            [self.myPlay stop];
            [self.movieplay.playerLayer.player pause];
        }];
        [ac addAction:action];
    }
    [self presentViewController:ac animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)takePhoto:(id)sender{
    [self.picker takePicture];//他将会自动调用代理方法完成照片的拍摄；
}
//获取DOC路劲
-(NSString *)getDocPath{
    NSArray *tmpPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [tmpPath objectAtIndex:0];
    return docPath;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
//滤镜
#pragma mark - Init
-(void) initCommon{
}
-(void) initPhotoFilter{
    [_arrPhoto removeAllObjects];
    _arrPhoto = [NSMutableArray arrayWithCapacity:5];
    
    for (NSInteger i = 0; i < 5; i++){
        if (i == 0){
            UIImage *image = [self imageDependOnDevice];
            [_arrPhoto addObject:image];
        }else{
            //给一张图片上4种滤镜
            NSString *nameLUT = [NSString stringWithFormat:@"filter_lut_%ld",(long)i];
            // FIlter with LUT
            UIImage *photo = [self imageDependOnDevice];
            // Create filter
            CIFilter *lutFilter = [CIFilter filterWithLUT:nameLUT dimension:64];
            // Set parameter
            CIImage *ciImage = [[CIImage alloc] initWithImage:photo];
            [lutFilter setValue:ciImage forKey:@"inputImage"];
            CIImage *outputImage = [lutFilter outputImage];
            CIContext *context = [CIContext contextWithOptions:[NSDictionary dictionaryWithObject:(__bridge id)(CGColorSpaceCreateDeviceRGB()) forKey:kCIContextWorkingColorSpace]];
            UIImage *newImage = [UIImage imageWithCGImage:[context createCGImage:outputImage fromRect:outputImage.extent]];
            [_arrPhoto addObject:newImage];
        }
    }
}
-(void) initTitle{
    _arrTittleFilter = @[@"Los Angeles",@"Paris",@"London",@"Rio",@"Original"];
}
-(void) initFeSlideFilterView{
    [_slideFilterView removeFromSuperview];
    _slideFilterView = [[FeSlideFilterView alloc] initWithFrame:CGRectMake(0, 64, SCR_WIDTH, SCR_WIDTH)];
    _slideFilterView.dataSource = self;
    _slideFilterView.delegate = self;
    [self.view addSubview:_slideFilterView];
}
#pragma mark - Delegate / Data Source
-(NSInteger) numberOfFilter{
    return 5;
}
-(NSString *) FeSlideFilterView:(FeSlideFilterView *)sender titleFilterAtIndex:(NSInteger)index{
    return _arrTittleFilter[index];
}
-(UIImage *) FeSlideFilterView:(FeSlideFilterView *)sender imageFilterAtIndex:(NSInteger)index{
    return _arrPhoto[index];
}
-(void) FeSlideFilterView:(FeSlideFilterView *)sender didTapDoneButtonAtIndex:(NSInteger)index{
    NSLog(@"did tap at index = %ld",(long)index);
}
-(void)FeSlideFilterView:(FeSlideFilterView *)sender didEndSlideFilterAtIndex:(NSInteger)index{
    NSLog(@"第__%ld__个滤镜",(long)index);
    indexFilter =index;
}
-(NSString *) kCAContentGravityForLayer{
    return kCAGravityResizeAspectFill;
}
#pragma mark - Private
-(UIImage *) imageDependOnDevice{
    NSLog(@"第__%ld__张图",(long)btnIndex);
    UIImage *imageOriginal;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        NSLog(@"%@",self.imgArray[btnIndex]);
        imageOriginal = self.imgArray[btnIndex];
    }else{
        imageOriginal = self.imgArray[btnIndex];
    }
    return imageOriginal;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
