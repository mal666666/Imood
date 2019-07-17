//
//  ComposerViewController.m
//  Composer
//
//  Created by 马 爱林 on 14/10/29.
//  Copyright (c) 2014年 马 爱林. All rights reserved.
//

#import "ComposerViewController.h"
#import "ViewController.h"
//#define K_SIZE  [UIScreen mainScreen].applicationFrame.size
#define K_SIZE  [UIScreen mainScreen].bounds.size

@interface ComposerViewController ()
{
    dispatch_queue_t queue;
    int a, b , c, d, e, f, g, h;
}

@end

@implementation ComposerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    queue  =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    a=0;b=0;c=0;d=0;e=0;f=0;g=0;h=0;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.929412F green:0.929412F blue:0.929412F alpha:1.0F];
//    [self.view addSubview:self.recodeWave];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(K_SIZE.height/35+K_SIZE.width*3/20, K_SIZE.width/4-3, K_SIZE.height*0.7, K_SIZE.width*3/4)];//乐器的起点加大小
    self.scrollView.delegate = self;
    [self.scrollView  setContentSize:CGSizeMake(K_SIZE.height*0.75*2, K_SIZE.width*3/4)];
    self.scrollView.backgroundColor = [UIColor colorWithRed:0.815686F green:0.815686F blue:0.815686F alpha:1.0F];
    [self.view addSubview:self.scrollView];
    
    self.playBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.playBtn.frame = CGRectMake(70, 5, 44, 44);
    //[self.playBtn setBackgroundImage:[UIImage imageNamed:@"123.png" ] forState:UIControlStateNormal];
    self.playBtn.tag = 0;
    [self.playBtn addTarget:self action:@selector(playMusic) forControlEvents:UIControlEventTouchDown];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];//重新开始
    btn1.frame = CGRectMake(20, 20, 40, 40);
    [btn1 setBackgroundImage:[UIImage imageNamed:@"restart_1.png"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(restart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeCustom];//发布
    btn2.frame = CGRectMake(K_SIZE.height-70, 22, 36, 36);
    [btn2 setBackgroundImage:[UIImage imageNamed:@"fabu.png"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(MixMusic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    UIButton* btn3 = [UIButton buttonWithType:UIButtonTypeCustom];//返回
    btn3.frame = CGRectMake(66, 22, 36, 36);
    [btn3 setBackgroundImage:[UIImage imageNamed:@"closed"] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(backViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    //音乐播放时间轴
//    self.time = [NSTimer timerWithTimeInterval:4.98f target:self selector:@selector(nextMusic:) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop]addTimer:self.time forMode:NSDefaultRunLoopMode];
    self.time = [NSTimer scheduledTimerWithTimeInterval:25.01f target:self selector:@selector(nextMusic:) userInfo:nil repeats:YES];
    [self.time setFireDate:[NSDate distantFuture]];
//        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(nextMusic:)];
//        displayLink.frameInterval = 300;
//        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    self.xiaojiejishu = 5;
    self.musicName = @"取消";
    self.musicArray  = [NSMutableArray arrayWithCapacity:0];
    self.musicArray1 = [NSMutableArray arrayWithCapacity:0];
    self.musicArray2 = [NSMutableArray arrayWithCapacity:0];
    self.musicArray3 = [NSMutableArray arrayWithCapacity:0];
    self.musicArray4 = [NSMutableArray arrayWithCapacity:0];
    self.musicArray5 = [NSMutableArray arrayWithCapacity:0];
    self.musicArray6 = [NSMutableArray arrayWithCapacity:0];
    self.musicArray7 = [NSMutableArray arrayWithCapacity:0];
    self.musicNameArray = [NSMutableArray arrayWithCapacity:0];
    
    for (int j = 0; j<8; j++) {
        for (int i = 0; i<4; i++) {
            GridButton* btn = [GridButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((self.scrollView.contentSize.width/8)*j+5, (self.scrollView.contentSize.height/5)*(i+1), self.scrollView.contentSize.width/8-5, self.scrollView.contentSize.height/5-5);
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self action:@selector(addMusic:) forControlEvents:UIControlEventTouchUpInside];
            btn.buttonCount = 4*j+i+1;
            [self initMusicData:btn];
            [self.scrollView addSubview:btn];
            
            self.label = [[UILabel alloc]initWithFrame:CGRectMake((self.scrollView.contentSize.width/8-5)/5, 0, self.scrollView.contentSize.height/5-5, self.scrollView.contentSize.height/5-5)];
            self.label.layer.cornerRadius = (self.scrollView.contentSize.height/5-5)/2;
            self.label.layer.masksToBounds= YES;
            self.label.textColor = [UIColor whiteColor];
            self.label.textAlignment = NSTextAlignmentCenter;
            self.label.font = [UIFont systemFontOfSize:30];
            self.label.backgroundColor = [UIColor whiteColor];
            [btn addSubview:self.label];
            
            self.label1 = [[UILabel alloc]initWithFrame:CGRectMake((self.scrollView.contentSize.width/8-5)/1.18, self.scrollView.contentSize.height/13, self.scrollView.contentSize.height/30, self.scrollView.contentSize.height/30)];
            self.label1.layer.cornerRadius = (self.scrollView.contentSize.height/30)/2;
            self.label1.layer.masksToBounds= YES;
            self.label1.backgroundColor = [UIColor colorWithRed:0.666667F green:0.666667F blue:0.666667F alpha:1.0F];
            [btn addSubview:self.label1];
            
            self.label2 = [[UILabel alloc]initWithFrame:CGRectMake((self.scrollView.contentSize.width/8-5)/0.93, self.scrollView.contentSize.height/13, self.scrollView.contentSize.height/30, self.scrollView.contentSize.height/30)];
            self.label2.layer.cornerRadius = (self.scrollView.contentSize.height/30)/2;
            self.label2.layer.masksToBounds= YES;
            self.label2.backgroundColor = [UIColor colorWithRed:0.666667F green:0.666667F blue:0.666667F alpha:1.0F];
            [btn addSubview:self.label2];
        }
    }
  
    [self addChooseTable];//添加下拉菜单re
    [self startScrollView];//添加滚动
    self.jiePai = 1;//计数，第几列
    [self yueqi];
    [self recoder];
    [self rotation];
    self.rec_lab_num =0;
    [self recoderBackLabel];//录音背景label
    self.recoder_label_array = [NSMutableArray arrayWithCapacity:0];
    //[self recoderLabel];
    self.play  = self.musicArray[0];
    self.play1 = self.musicArray1[0];
    self.play2 = self.musicArray2[0];
    self.play3 = self.musicArray3[0];
    
    self.MusicSlider = [[UISlider alloc]initWithFrame:CGRectMake(115, 25, K_SIZE.height-200, 30)];
    self.MusicSlider.maximumValue = self.scrollView.contentSize.width-1 ;
    self.MusicSlider.minimumValue = 0;
    self.MusicSlider.continuous = YES;
    //[self.MusicSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.MusicSlider addTarget:self action:@selector(sliderTouch) forControlEvents:UIControlEventTouchUpInside];
    self.ThumbImagePlay = [UIImage imageNamed:@"play1.png"];
    self.NewThumbImagePlay = [self.ThumbImagePlay TransformtoSize:CGSizeMake(40, 40)];
    self.ThumbImagePause = [UIImage imageNamed:@"pause.png"];
    self.NewThumbImagePause = [self.ThumbImagePause TransformtoSize:CGSizeMake(40, 40)];
    [self.MusicSlider setThumbImage:self.NewThumbImagePlay forState:UIControlStateNormal];
    self.MusicSlider.minimumTrackTintColor = [UIColor greenColor];
    self.MusicSlider.maximumTrackTintColor = [UIColor grayColor];
    [self.view addSubview: self.MusicSlider];
    NSLog(@"ttttt%lu",(unsigned long)self.scrollView.subviews.count);

}
- (void)sliderTouch
{
    NSLog(@"播放暂停");
    [self playMusic];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    float scrollViewWidth = self.scrollView.contentSize.width;//scrollView宽度
    float scrollViewPoint = self.scrollView.contentOffset.x;//已走宽度
    NSInteger jiePai = scrollViewPoint/scrollViewWidth*8;//第几节拍
    float time = scrollViewPoint*40/scrollViewWidth;//已经播放了的时间
    float currentTime = fmodf(time, 5);//当前节奏剩余时间
    NSInteger dece = decelerate? 1:0;//是否到头了，减速
    if (jiePai <0) {
        jiePai =0;
    }
    if (jiePai>4) {
        jiePai =4;
    }
    self.jiePai = jiePai+1;//节拍
    if (dece && scrollViewPoint <0) {
        jiePai = 0;
        currentTime =0;}
    if (dece && scrollViewPoint >0) {
        jiePai = 4;
        currentTime =0;}
    self.xiaojiejishu = currentTime;//小节计数
    [self.play stop];[self.play1 stop];[self.play2 stop];[self.play3 stop];
    [self.play4 stop];[self.play5 stop];[self.play6 stop];[self.play7 stop];
    [self.time setFireDate:[NSDate distantFuture]];
    if (self.jiePai%2 ==1) {
        self.play  = self.musicArray[jiePai];
        self.play1 = self.musicArray1[jiePai];
        self.play2 = self.musicArray2[jiePai];
        self.play3 = self.musicArray3[jiePai];
        self.play .currentTime = currentTime;
        self.play1.currentTime = currentTime;
        self.play2.currentTime = currentTime;
        self.play3.currentTime = currentTime;
    }
    if (self.jiePai%2 ==0) {
        self.play4 = self.musicArray4[jiePai];
        self.play5 = self.musicArray5[jiePai];
        self.play6 = self.musicArray6[jiePai];
        self.play7 = self.musicArray7[jiePai];
        self.play4.currentTime = currentTime;
        self.play5.currentTime = currentTime;
        self.play6.currentTime = currentTime;
        self.play7.currentTime = currentTime;
    }
    self.playBtn.tag = 1;
    [self playMusic];
    NSLog(@"节拍%ld--------------%f",(long)self.jiePai, currentTime);
}
- (void)sliderValueChanged:(id)sender
{
    UISlider* control = (UISlider*)sender;
    if(control == self.MusicSlider){
        float value = control.value;
        float scrollViewWidth = self.scrollView.contentSize.width;//scrollView宽度
        NSInteger jiePai = value*8/scrollViewWidth;//第几节拍
        float time = value*40/scrollViewWidth;//已经播放了的时间
        float currentTime = fmodf(time, 5);//当前节奏剩余时间
        [self.scrollView setContentOffset:CGPointMake(value, 0)];
        self.jiePai = jiePai;
        self.xiaojiejishu = currentTime;
        [self.play stop];[self.play1 stop];[self.play2 stop];[self.play3 stop];
        [self.scrollViewTime setFireDate:[NSDate distantFuture]];
        self.play  = self.musicArray[0+4*self.jiePai];
        self.play1 = self.musicArray[1+4*self.jiePai];
        self.play2 = self.musicArray[2+4*self.jiePai];
        self.play3 = self.musicArray[3+4*self.jiePai];
        self.play .currentTime = currentTime;
        self.play1.currentTime = currentTime;
        self.play2.currentTime = currentTime;
        self.play3.currentTime = currentTime;
        //[self.play play];[self.play1 play];[self.play2 play];[self.play3 play];
    
        NSLog(@"--------%ld+++++++++%f",(long)self.jiePai, currentTime);
        //[self playMusic];
//        [self.shengyuTime invalidate];
//        self.shengyuTime = [NSTimer timerWithTimeInterval:4.95f-self.xiaojiejishu target:self selector:@selector(shengyuMusic) userInfo:nil repeats:NO];
//        [[NSRunLoop currentRunLoop]addTimer:self.shengyuTime forMode:NSDefaultRunLoopMode];
//        [self.time invalidate];
//        self.time = [NSTimer timerWithTimeInterval:5.0f target:self selector:@selector(nextMusic:) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop]addTimer:self.time forMode:NSDefaultRunLoopMode];
//        [self.time setFireDate:[NSDate distantFuture]];
    }
}
- (void)backViewController
{
    [self restart];
    ViewController * VC = [[ViewController alloc]init];
    [self presentViewController:VC animated:YES completion:nil];
}
#pragma mark ========== 重新开始 ===============
- (void)restart
{
    [self.playTry stop];
    self.playTry.currentTime = 0;
    self.playTry = nil;
    self.jiePai = 0;
    
    //小节时间记时
    [self.gridTime invalidate];
    self.gridTime = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(xiaojieTime) userInfo:nil repeats:YES];
    [self.gridTime setFireDate:[NSDate distantFuture]];
    self.xiaojiejishu =5;
    //音乐播放时间轴
    [self.time invalidate];
    self.time = [NSTimer scheduledTimerWithTimeInterval:25.01f target:self selector:@selector(nextMusic:) userInfo:nil repeats:YES];
    [self.time setFireDate:[NSDate distantFuture]];

    [self.scrollViewTime setFireDate:[NSDate distantFuture]];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.scrollView setScrollEnabled:YES];
    self.playBtn.tag = 0;
    [self.play stop];[self.play1 stop];[self.play2 stop];[self.play3 stop];
    [self.play4 stop];[self.play5 stop];[self.play6 stop];[self.play7 stop];
   
    self.play  = self.musicArray [0];
    self.play1 = self.musicArray1[0];
    self.play2 = self.musicArray2[0];
    self.play3 = self.musicArray3[0];
    self.play4 = self.musicArray4[1];
    self.play5 = self.musicArray5[1];
    self.play6 = self.musicArray6[1];
    self.play7 = self.musicArray7[1];
    self.play .currentTime = 0;
    self.play1.currentTime = 0;
    self.play2.currentTime = 0;
    self.play3.currentTime = 0;
    self.play4.currentTime = 0;
    self.play5.currentTime = 0;
    self.play6.currentTime = 0;
    self.play7.currentTime = 0;
    
    self.MusicSlider.value =0;
    [self.MusicSlider setThumbImage:self.NewThumbImagePlay forState:UIControlStateNormal];
}
- (void)MixMusic
{
    //混合音乐
    AVMutableComposition * mixComposition = [AVMutableComposition composition];
    for (int i=0; i<self.musicNameArray.count; i++) {
        NSString *Path = [[NSBundle mainBundle] pathForResource:self.musicNameArray[i] ofType:@"wav"];
        NSURL *audioUrl = [NSURL fileURLWithPath:Path];
        AVURLAsset * audioAsset = [AVURLAsset URLAssetWithURL:audioUrl options:nil];
        AVMutableCompositionTrack *compositionCommentaryTrack =[mixComposition
                                                    addMutableTrackWithMediaType:AVMediaTypeAudio
                                                    preferredTrackID: kCMPersistentTrackID_Invalid];
        [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)
                                            ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                             atTime:CMTimeMake(i/4*5.042, 1) error:nil];
    }
    AVAssetExportSession * _assetExport = [[AVAssetExportSession alloc]initWithAsset:mixComposition
                                                                         presetName:AVAssetExportPresetAppleM4A];
//    NSString* videoName = @"exportMusic.m4a";
//    NSString *exportPath = [NSTemporaryDirectory() stringByAppendingPathComponent:videoName];
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *exportPath =[[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"exportMusic.m4a"]];
    NSURL    *exportUrl = [NSURL fileURLWithPath:exportPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:exportPath]){
        [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
    }
    _assetExport.outputFileType = AVFileTypeAppleM4A;
    _assetExport.outputURL = exportUrl;
    _assetExport.shouldOptimizeForNetworkUse = YES;
    [_assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) {
         NSLog(@"%@混合音乐完成",exportPath);
         dispatch_sync(dispatch_get_main_queue(), ^{
             [self backViewController];
         });
     }];
}
- (void)xiaojieTime
{
    self.xiaojiejishu +=0.1f;
    NSInteger xiaojie = self.xiaojiejishu *10;
    if (xiaojie == 30 ) {
        NSLog(@"========预加载第%ld节拍=======", (long)self.jiePai+1);
        [self DownloadMusic];
    }
}
#pragma mark==============下一首音乐===============
- (void)nextMusic:(GridButton *)nextMusic
{
    if (self.jiePai ==1) {
        [self.time invalidate];
        self.time = [NSTimer scheduledTimerWithTimeInterval:25.042f target:self selector:@selector(nextMusic:) userInfo:nil repeats:YES];
        NSLog(@"第一次播放更新为5.042");
    }
        if (self.jiePai %2 ==1){
            [self.play stop];[self.play1 stop];[self.play2 stop];[self.play3 stop];
           
            self.play4.volume = 1;
            self.play5.volume = 1;
            self.play6.volume = 1;
            self.play7.volume = 1;
            dispatch_async(queue, ^{
                [self.play4 play];
                [NSTimer  scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(test4) userInfo:nil repeats:YES];
            });
            dispatch_async(queue, ^{
                [self.play5 play];
                [NSTimer  scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(test5) userInfo:nil repeats:YES];
            });
            dispatch_async(queue, ^{
                [self.play6 play];
                [NSTimer  scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(test6) userInfo:nil repeats:YES];
            });
            dispatch_async(queue, ^{
                [self.play7 play];
                [NSTimer  scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(test7) userInfo:nil repeats:YES];
            });
        }
        if (self.jiePai%2 ==0){
            [self.play4 stop];[self.play5 stop];[self.play6 stop];[self.play7 stop];
            dispatch_async(queue, ^{
                [self.play play];
                [NSTimer  scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(test) userInfo:nil repeats:YES];
            });
            dispatch_async(queue, ^{
                [self.play1 play];
                [NSTimer  scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(test1) userInfo:nil repeats:YES];
            });
            dispatch_async(queue, ^{
                [self.play2 play];
                [NSTimer  scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(test2) userInfo:nil repeats:YES];
            });
            dispatch_async(queue, ^{
                [self.play3 play];
                [NSTimer  scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(test3) userInfo:nil repeats:YES];
            });
//            [self.play  play];
//            [self.play1 play];
//            [self.play2 play];
//            [self.play3 play];
        }
    [self.gridTime invalidate];
    self.xiaojiejishu =0;
    self.gridTime = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(xiaojieTime) userInfo:nil repeats:YES];//小节时间记时
    self.jiePai +=1;
    NSLog(@"--------开始播放第%ld节拍----",(long)self.jiePai);
}
-(void)test{
    a +=1;
    NSLog(@"a=%d",a);
}
-(void)test1{
    b +=1;
    NSLog(@"b=%d",b);
}
-(void)test2{
    c +=1;
    NSLog(@"c=%d",c);
}
-(void)test3{
    d +=1;
    NSLog(@"d=%d",d);
}
-(void)test4{
    e +=1;
    NSLog(@"e=%d",e);
}
-(void)test5{
    f +=1;
    NSLog(@"f=%d",f);
}
-(void)test6{
    g +=1;
    NSLog(@"g=%d",g);
}
-(void)test7{
    h +=1;
    NSLog(@"h=%d",h);
}
- (void)DownloadMusic
{
    NSInteger i = 0;
    if (self.jiePai == 1) {i = 0;}
    if (self.jiePai == 2) {i = 1;}
    if (self.jiePai == 3) {i = 2;}
    if (self.jiePai == 4) {i = 3;}
    if (self.jiePai == 5) {i = 4;}
    if (self.jiePai == 6) {i = 5;}
    if (self.jiePai == 7) {i = 6;}
    if (self.jiePai == 8) {self.jiePai = 0;[self.time invalidate];[self.gridTime invalidate];}
    //NSLog(@"当前播放节拍%ld",(long)self.jiePai);
    if (self.jiePai%2 ==0) {
        self.play  = self.musicArray [i+1];
        self.play1 = self.musicArray1[i+1];
        self.play2 = self.musicArray2[i+1];
        self.play3 = self.musicArray3[i+1];
        self.play .currentTime =0;
        self.play1.currentTime =0;
        self.play2.currentTime =0;
        self.play3.currentTime =0;
        NSLog(@"=======预加载播放器0、1、2、3=======");
    }
    if (self.jiePai%2 ==1) {
        self.play4 = self.musicArray4[i+1];
        self.play5 = self.musicArray5[i+1];
        self.play6 = self.musicArray6[i+1];
        self.play7 = self.musicArray7[i+1];
        self.play4.currentTime =0;
        self.play5.currentTime =0;
        self.play6.currentTime =0;
        self.play7.currentTime =0;
        NSLog(@"======预加载播放器4、5、6、7======");
    }
}
#pragma mark==============播放音乐===============
- (void)playMusic
{
    [self.playTry stop];
    self.playTry.currentTime = 0;
    self.playTry = nil;
    
    self.playBtn.tag +=1;
    NSLog(@"xiaojiejishu%f",self.xiaojiejishu);
    if (self.playBtn.tag ==1) {
         self.scrollView.frame = CGRectMake(K_SIZE.height/35+K_SIZE.width*3/20, K_SIZE.width/4-3, K_SIZE.height*0.85, K_SIZE.width*3/4);
        [self.time setFireDate:[NSDate date]];
        [self.gridTime setFireDate:[NSDate date]];
        [self.scrollViewTime setFireDate:[NSDate date]];
        self.chooseTab.hidden = YES;
        [self.MusicSlider setThumbImage:self.NewThumbImagePause forState:UIControlStateNormal];
    }else{
    if (self.playBtn.tag %2 ==0) {
        self.scrollView.frame = CGRectMake(K_SIZE.height/35+K_SIZE.width*3/20, K_SIZE.width/4-3, K_SIZE.height*0.7, K_SIZE.width*3/4);
        [self.gridTime setFireDate:[NSDate distantFuture]];
        [self.scrollViewTime setFireDate:[NSDate distantFuture]];
        [self.time setFireDate:[NSDate distantFuture]];
        if (self.jiePai%2 ==1) {
            [self.play pause]; [self.play1 pause]; [self.play2 pause]; [self.play3 pause];
        }
        if (self.jiePai%2 ==0) {
            [self.play4 pause]; [self.play5 pause]; [self.play6 pause]; [self.play7 pause];
        }
        [self.shengyuTime invalidate];
        self.chooseTab.hidden = NO;
        [self.MusicSlider setThumbImage:self.NewThumbImagePlay forState:UIControlStateNormal];
   }else{
           self.scrollView.frame = CGRectMake(K_SIZE.height/35+K_SIZE.width*3/20, K_SIZE.width/4-3, K_SIZE.height*0.85, K_SIZE.width*3/4);
           self.shengyuTime = [NSTimer timerWithTimeInterval:25.042f-self.xiaojiejishu target:self selector:@selector(shengyuMusic) userInfo:nil repeats:NO];
           [[NSRunLoop currentRunLoop]addTimer:self.shengyuTime forMode:NSDefaultRunLoopMode];
           [self.gridTime setFireDate:[NSDate date]];
           [self.scrollViewTime setFireDate:[NSDate date]];
           if (self.jiePai%2 ==1) {
            //self.play.volume =0.5;self.play1.volume =0.5;self.play2.volume =0.5;self.play3.volume =0.5;
           [self.play play];[self.play1 play];[self.play2 play];[self.play3 play];
           }
           if (self.jiePai%2 ==0) {
            //self.play4.volume =0.5;self.play5.volume =0.5;self.play6.volume =0.5;self.play7.volume =0.5;
           [self.play4 play];[self.play5 play];[self.play6 play];[self.play7 play];
           }
           self.chooseTab.hidden = YES;
           [self.MusicSlider setThumbImage:self.NewThumbImagePause forState:UIControlStateNormal];
        }
    }
}
- (void)shengyuMusic
{
    [self.time setFireDate:[NSDate date]];
}
#pragma maek ==============添加音乐================
- (void)addMusic: (GridButton *)button
{
    __weak typeof(self) safeSelf = self;
    self.musicName = nil;
    self.chooseTab.hidden  = NO;
    self.chooseItem = button.musicArr;
    [self.chooseTab reloadData];
   
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((safeSelf.scrollView.contentSize.width/8-5)/5, 0, safeSelf.scrollView.contentSize.height/5-5, safeSelf.scrollView.contentSize.height/5-5)];
    label.layer.cornerRadius = (safeSelf.scrollView.contentSize.height/5-5)/2;
    label.layer.masksToBounds= YES;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:30];
    label.backgroundColor =[UIColor colorWithRed:0.894118F green:0.831373F blue:0.623529F alpha:1.0F];
    //[UIColor colorWithRed:1.000000F green:0.000000F blue:1.000000F alpha:1.0F];
    [button addSubview:label];
  
    self.myBlock = ^(NSString *strMusic){
        button.ButtonMusic = strMusic;
        if (safeSelf.playTry.isPlaying)
        {
            [safeSelf.playTry stop];
            safeSelf.playTry.currentTime = 0;
            safeSelf.playTry = nil;
//            //
//            AVAudioSession *session = [AVAudioSession sharedInstance];
//            [session setCategory:AVAudioSessionCategoryPlayback error:nil];
//            [session setActive:YES error:nil];
//            //
            NSString *str =[[NSBundle mainBundle] pathForResource:button.ButtonMusic ofType:@"mp3"];
            NSURL *url = [NSURL fileURLWithPath:str];
            safeSelf.playTry = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
            safeSelf.playTry.delegate = safeSelf;
            safeSelf.playTry.volume =1;
            [safeSelf.playTry prepareToPlay];
            [safeSelf.playTry play];
        }else{
//            //
//            AVAudioSession *session = [AVAudioSession sharedInstance];
//            [session setCategory:AVAudioSessionCategoryPlayback error:nil];
//            [session setActive:YES error:nil];
//            //
            NSString *str =[[NSBundle mainBundle] pathForResource:button.ButtonMusic ofType:@"mp3"];
            NSURL *url = [NSURL fileURLWithPath:str];
            safeSelf.playTry = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
            safeSelf.playTry.delegate = safeSelf;
            safeSelf.playTry.volume =1;
            [safeSelf.playTry prepareToPlay];
            [safeSelf.playTry play];
        }
        if (button.buttonCount%4 ==1) {
            safeSelf.playTry.currentTime = 0;
            [safeSelf.musicArray  replaceObjectAtIndex:button.buttonCount/4 withObject:safeSelf.playTry];
            [safeSelf.musicArray4  replaceObjectAtIndex:button.buttonCount/4 withObject:safeSelf.playTry];
        }
        if (button.buttonCount%4 ==2) {
            safeSelf.playTry.currentTime = 0;
            [safeSelf.musicArray1  replaceObjectAtIndex:button.buttonCount/4 withObject:safeSelf.playTry];
            [safeSelf.musicArray5  replaceObjectAtIndex:button.buttonCount/4 withObject:safeSelf.playTry];
        }
        if (button.buttonCount%4 ==3) {
            safeSelf.playTry.currentTime = 0;
            [safeSelf.musicArray2  replaceObjectAtIndex:button.buttonCount/4 withObject:safeSelf.playTry];
            [safeSelf.musicArray6  replaceObjectAtIndex:button.buttonCount/4 withObject:safeSelf.playTry];
        }
        if (button.buttonCount%4 ==0) {
            safeSelf.playTry.currentTime = 0;
            [safeSelf.musicArray3  replaceObjectAtIndex:button.buttonCount/4-1 withObject:safeSelf.playTry];
            [safeSelf.musicArray7  replaceObjectAtIndex:button.buttonCount/4-1 withObject:safeSelf.playTry];
        }
        [safeSelf.musicNameArray replaceObjectAtIndex:button.buttonCount-1 withObject:button.ButtonMusic];//更新歌曲名称
        
        if (![button.ButtonMusic  isEqual: @"取消"]) {
            if (button.buttonCount%4 ==1) {
                label.backgroundColor = [UIColor colorWithRed:0.278431F green:0.639216F blue:0.972549F alpha:1.0F];
            }
            if (button.buttonCount%4 ==2) {
                label.backgroundColor = [UIColor colorWithRed:0.145098F green:0.705882F blue:0.258824F alpha:1.0F];
            }
            if (button.buttonCount%4 ==3) {
                label.backgroundColor = [UIColor colorWithRed:1.000000F green:0.623529F blue:0.274510F alpha:1.0F];
            }
            if (button.buttonCount%4 ==0) {
                label.backgroundColor = [UIColor colorWithRed:0.560784F green:0.607843F blue:0.972549F alpha:1.0F];
            }
            label.text = [NSString stringWithFormat: @"%ld",(long)safeSelf.musicCount];
            //[button setTitle:button.ButtonMusic forState:UIControlStateNormal];
            //[button setBackgroundColor:[UIColor colorWithRed:1.000000F green:0.388235F blue:0.450980F alpha:1.0F]];
        }else{
            label.backgroundColor = [UIColor whiteColor];
            label.text = nil;
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitle:nil forState:UIControlStateNormal];
        }
    };
    if (button.buttonCount%4 ==1) {
        self.xuanZhong_color = [UIColor colorWithRed:0.278431F green:0.639216F blue:0.972549F alpha:1.0F];
    }
    if (button.buttonCount%4 ==2) {
        self.xuanZhong_color =[UIColor colorWithRed:0.145098F green:0.705882F blue:0.258824F alpha:1.0F];
    }
    if (button.buttonCount%4 ==3) {
        self.xuanZhong_color =[UIColor colorWithRed:1.000000F green:0.623529F blue:0.274510F alpha:1.0F];
    }
    if (button.buttonCount%4 ==0) {
        self.xuanZhong_color =[UIColor colorWithRed:0.560784F green:0.607843F blue:0.972549F alpha:1.0F];
    }
    self.playBtn.tag = 1;
    [self playMusic];
    [self sliderValueChanged:nil];
    NSLog(@"点击第%li个按钮",(long)button.buttonCount);
}
-(void)initMusicData:(GridButton *)button
{
    //NSString *str = [[NSBundle mainBundle] pathForResource:@"取消" ofType:@"wav"];
    NSString *str = [[NSBundle mainBundle] pathForResource:@"01" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:str];
    AVAudioPlayer *play = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    play.delegate = self;
    play.volume =1;
    [play prepareToPlay];

    if (button.buttonCount%4 == 1) {
//        button.musicArr = [[NSMutableArray alloc]
//                           initWithObjects:@"取消",@"鼓01",@"鼓02",@"鼓03",@"鼓04",@"鼓05", nil];
        button.musicArr = [[NSMutableArray alloc]
                           initWithObjects:@"取消",@"鼓1",@"鼓2",@"鼓3",@"鼓4",@"鼓5", nil];
        [self.musicArray addObject:play];
        [self.musicArray4 addObject:play];
    }
    if (button.buttonCount%4 == 2) {
//         button.musicArr = [[NSMutableArray alloc]
//                            initWithObjects:@"取消",@"贝斯01",@"贝斯02",@"贝斯03",@"贝斯04",@"贝斯05", nil];
        button.musicArr = [[NSMutableArray alloc]
                           initWithObjects:@"取消",@"贝斯1",@"贝斯2",@"贝斯3",@"贝斯4",@"贝斯5", nil];
        [self.musicArray1 addObject:play];
        [self.musicArray5 addObject:play];
    }
    if (button.buttonCount%4 == 3) {
//         button.musicArr = [[NSMutableArray alloc]
//                            initWithObjects:@"取消",@"吉他01",@"吉他02",@"吉他03",@"吉他04",@"吉他05", nil];
        button.musicArr = [[NSMutableArray alloc]
                           initWithObjects:@"取消",@"键盘1",@"键盘2",@"键盘3",@"键盘4",@"键盘5", nil];
        [self.musicArray2 addObject:play];
        [self.musicArray6 addObject:play];
    }
    if (button.buttonCount%4 == 0) {
//         button.musicArr = [[NSMutableArray alloc]
//                            initWithObjects:@"取消",@"键盘01",@"键盘02",@"键盘03",@"键盘04",@"键盘05", nil];
        button.musicArr = [[NSMutableArray alloc]
                           initWithObjects:@"取消",@"DJ1",@"DJ2",@"DJ3",@"DJ4",@"DJ5", nil];
        [self.musicArray3 addObject:play];
        [self.musicArray7 addObject:play];
    }
    [self.musicNameArray addObject:@"取消"];
}
-(void)addChooseTable
{
    self.chooseTab = [[UITableView alloc]initWithFrame:CGRectMake(K_SIZE.height*0.82, K_SIZE.width/4-3, K_SIZE.height/5, K_SIZE.width*3/4) style:UITableViewStylePlain];
    self.chooseTab.delegate = self;
    self.chooseTab.dataSource = self;
    self.chooseTab.hidden  =NO;
    [self.view addSubview:self.chooseTab];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return K_SIZE.width*3/24;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellName = @"airin";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.textLabel.text = [self.chooseItem objectAtIndex:indexPath.row];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
    cell.backgroundColor =[UIColor colorWithRed:0.815686F green:0.815686F blue:0.815686F alpha:1.0F];
    cell.selectedBackgroundView.backgroundColor =self.xuanZhong_color;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, K_SIZE.width*3/24)];
    label.backgroundColor = [UIColor clearColor];
    label.layer.cornerRadius = 1;
    label.layer.borderColor = [UIColor colorWithRed:0.666667F green:0.666667F blue:0.666667F alpha:1.0F].CGColor;
    label.layer.borderWidth = 1;
    [cell addSubview:label];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.chooseTab.hidden = NO;
    self.musicName = [self.chooseItem objectAtIndex:indexPath.row];
    self.musicCount = indexPath.row;
    if (self.musicName) {
        self.myBlock(self.musicName);
    }
    NSLog(@"选择乐器%@",[self.chooseItem objectAtIndex:indexPath.row]);
}
- (void)startScrollView
{
    CGPoint bottomOffset = CGPointMake(self.scrollView.contentSize.width , self.scrollView.contentOffset.y);
    //设置延迟时间
    float scrollDurationInSeconds = 40.0f;
    //计算timer间隔
    float totalScrollAmount = bottomOffset.x;
    float timerInterval = scrollDurationInSeconds / totalScrollAmount;
    self.scrollViewTime = [NSTimer scheduledTimerWithTimeInterval:timerInterval*2 target:self selector:@selector(scrollScrollView:) userInfo:nil repeats:YES];
    [self.scrollViewTime setFireDate:[NSDate distantFuture]];
    NSLog(@"mei miao diao %f",timerInterval);
}
- (void)scrollScrollView:(NSTimer *)timer
{
    CGPoint newScrollViewContentOffset = self.scrollView.contentOffset;
    //向左移动 1px
    newScrollViewContentOffset.x += 2;
    newScrollViewContentOffset.x = MAX(0, newScrollViewContentOffset.x);
    //如果到顶了，timer中止
    // if (newScrollViewContentOffset.x == self.scrollView.contentSize.width - self.scrollView.bounds.size.width)
    if (newScrollViewContentOffset.x == self.scrollView.contentSize.width)
    {
        //[timer invalidate];
        [self.scrollViewTime setFireDate:[NSDate distantFuture]];
        //newScrollViewContentOffset.x = 0;
    }
    //最后设置scollView's contentOffset
    [self.scrollView setScrollEnabled:YES];
    self.scrollView.contentOffset = newScrollViewContentOffset;
    self.MusicSlider.value = newScrollViewContentOffset.x;
    if (self.rec_play_start_place == newScrollViewContentOffset.x)
    {
        NSString *str =[self fullPathAtCache];//播放录音
        NSLog(@" 录音开始播放-------%ld======%f",(long)self.rec_play_start_place, newScrollViewContentOffset.x);
    }
}
- (void)recoder
{
    self.recoderBtn = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [self.recoderBtn setFrame:CGRectMake(K_SIZE.height/35, (self.scrollView.contentSize.height/1.93)-(self.scrollView.contentSize.height/5), K_SIZE.width*3/20, K_SIZE.width*3/20 )];
    [self.recoderBtn setBackgroundImage:[UIImage imageNamed:@"luyin"] forState:UIControlStateNormal];;
    [self.recoderBtn addTarget:self action:@selector(recoderBegin:) forControlEvents:(UIControlEventTouchDown)];
    [self.recoderBtn addTarget:self action:@selector(recoderStop:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.recoderBtn];
        self.recoderView = [[UIView alloc]initWithFrame:(CGRectMake(K_SIZE.height/2-65, K_SIZE.width/2+20, 100, 100))];
        [self.recoderView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Exam_ta_zongjie@2x"]]];
        self.recoderView.hidden = YES;
        [self.view addSubview:self.recoderView];
    self.imageArr = [[NSArray alloc]initWithObjects:
                     @"record_animate_01",
                     @"record_animate_02",
                     @"record_animate_03",
                     @"record_animate_04",
                     @"record_animate_05",
                     @"record_animate_06",
                     @"record_animate_07",
                     @"record_animate_08",
                     @"record_animate_09",
                     @"record_animate_10",
                     @"record_animate_11",
                     @"record_animate_12",
                     @"record_animate_13",
                     @"record_animate_14",nil];
    self.imageView = [[UIImageView alloc]initWithFrame:(CGRectMake(25, 25, 50, 74))];
    [self.imageView setImage:[UIImage imageNamed:[self.imageArr objectAtIndex:0]]];
    [self.recoderView addSubview:self.imageView];
    //初始化录音
    [self prepareRecode];
}
- (NSString *)fullPathAtCache
{
    //创建目录
    NSString *appDocDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *m_pFilePath = [[NSString alloc]initWithString:[appDocDir stringByAppendingPathComponent:@"bao.wav"]];
    return m_pFilePath;
}
- (void)prepareRecode
{
    NSURL *url = [[NSURL alloc]initFileURLWithPath:[self fullPathAtCache]];
    NSError *error;
    NSLog(@"录音路劲%@",url);
    //创建音频会议
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    [audioSession setActive:YES error:&err];
    err = nil;
    NSData *existedData = [NSData dataWithContentsOfFile:[url path] options:NSDataReadingMapped error:&err];
    if (existedData) {
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:[url path] error:&err];
    }
    //初始化
    //@{AVFormatIDKey : @(kAudioFormatLinearPCM), AVEncoderBitRateKey:@(16),AVEncoderAudioQualityKey : @(AVAudioQualityMax), AVSampleRateKey : @(8000.0), AVNumberOfChannelsKey : @(1)}
    self.myRecorder = [[AVAudioRecorder alloc]initWithURL:url settings:nil error:&error];
    self.myRecorder.meteringEnabled = YES;
    self.myRecorder.delegate = self;
}
- (void)recoderBegin:(UIButton *)btn
{
    [self.myRecorder record];
    [self.recoder_Img removeFromSuperview];
    //[self.recoder_label_array removeAllObjects];
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(updateRecoderImage) userInfo:nil repeats:YES];
    [self.recoderView setHidden:NO];
    [self recoderBackLabel];
    float scrollViewWidth = self.scrollView.contentSize.width;//scrollView宽度
    float scrollViewPoint = self.scrollView.contentOffset.x;//已走宽度
    self.rec_lab_num = scrollViewPoint*24/scrollViewWidth;//开始录音起始位置
    self.rec_play_start_place = scrollViewPoint;
    NSLog(@"录音开始时间%ld",(long)self.rec_play_start_place);
    [self.up_rec_timer invalidate];
    self.up_rec_timer =[NSTimer scheduledTimerWithTimeInterval:40.0/24.0 target:self selector:@selector(updateRecodelab) userInfo:nil repeats:YES];
}
- (void)recoderStop:(UIButton *)btn
{
    //屏幕话筒位置自适应
    float lab_kaishi_weizhi = ((self.scrollView.contentSize.width/24)*self.rec_lab_num+30 );
    float lab_daxiao = self.scrollView.contentSize.height/15;
    float huaton_daxiao = self.scrollView.contentSize.height/8;
    float huaton_weizhi = lab_kaishi_weizhi + lab_daxiao/2 - huaton_daxiao/2;
    
    [self.myRecorder stop];
    [self.myTimer invalidate];
    [self.recoderView setHidden:YES];
    [self.up_rec_timer invalidate];
    self.recoder_Img =[[UIImageView alloc]init];
    self.recoder_Img.image = [UIImage imageNamed:@"recoder_end1"];
     self.recoder_Img.frame = CGRectMake(huaton_weizhi, self.scrollView.contentSize.height/18, self.scrollView.contentSize.height/8, self.scrollView.contentSize.height/8);
    // self.recoder_Img.frame = CGRectMake((self.scrollView.contentSize.width/24)*self.rec_lab_num +self.scrollView.contentSize.width/24*0.72, self.scrollView.contentSize.height/18, self.scrollView.contentSize.height/8, self.scrollView.contentSize.height/8);
    [self.scrollView addSubview: self.recoder_Img];
    self.rec_lab_num =0;
}
- (void)updateRecodelab
{
    self.rec_lab_num +=1;
    if (self.rec_lab_num<25) {
        self.Rec_Label = [[UILabel alloc]initWithFrame:CGRectMake((self.scrollView.contentSize.width/24)*(self.rec_lab_num-1)+30, self.scrollView.contentSize.height/15, self.scrollView.contentSize.height/15, self.scrollView.contentSize.height/15)];
        _Rec_Label.backgroundColor = [UIColor colorWithRed:0.984314F green:0.360784F blue:0.439216F alpha:1.0F];
        _Rec_Label.layer.cornerRadius =self.scrollView.contentSize.height/30;
        _Rec_Label.layer.masksToBounds = YES;
        [self.recoder_label_array addObject:self.Rec_Label];
        [self.scrollView addSubview:_Rec_Label];
    }
}
- (void)updateRecoderImage
{
    [self.myRecorder updateMeters];//刷新音量数据
    //获取音量平均值
    double lowPassResults = pow(10, (0.05 * [self.myRecorder peakPowerForChannel:0]));
    //图片小 到大
    if (0<lowPassResults<=0.03){
        [self.imageView setImage:[UIImage imageNamed:[self.imageArr objectAtIndex:0]]];
    }else if (0.03<lowPassResults<=0.06){
        [self.imageView setImage:[UIImage imageNamed:[self.imageArr objectAtIndex:1]]];
    }else if (0.06<lowPassResults<=0.13){
        [self.imageView setImage:[UIImage imageNamed:[self.imageArr objectAtIndex:2]]];
    }else if (0.13<lowPassResults<=0.19){
        [self.imageView setImage:[UIImage imageNamed:[self.imageArr objectAtIndex:3]]];
    }else if (0.19<lowPassResults<=0.26){
        [self.imageView setImage:[UIImage imageNamed:[self.imageArr objectAtIndex:4]]];
    }else if (0.26<lowPassResults<=0.32){
        [self.imageView setImage:[UIImage imageNamed:[self.imageArr objectAtIndex:5]]];
    }else if (0.32<lowPassResults<=0.38){
        [self.imageView setImage:[UIImage imageNamed:[self.imageArr objectAtIndex:6]]];
    }else if (0.38<lowPassResults<=0.44){
        [self.imageView setImage:[UIImage imageNamed:[self.imageArr objectAtIndex:7]]];
    }else if (0.44<lowPassResults<=0.51){
        [self.imageView setImage:[UIImage imageNamed:[self.imageArr objectAtIndex:8]]];
    }else if (0.51<lowPassResults<=0.58){
        [self.imageView setImage:[UIImage imageNamed:[self.imageArr objectAtIndex:9]]];
    }else if (0.58<lowPassResults<=0.65){
        [self.imageView setImage:[UIImage imageNamed:[self.imageArr objectAtIndex:10]]];
    }else if (0.65<lowPassResults<=0.72){
        [self.imageView setImage:[UIImage imageNamed:[self.imageArr objectAtIndex:11]]];
    }else if (0.72<lowPassResults<=0.79){
        [self.imageView setImage:[UIImage imageNamed:[self.imageArr objectAtIndex:12]]];
    }else {
        [self.imageView setImage:[UIImage imageNamed:[self.imageArr objectAtIndex:13]]];
    }
    //NSLog(@"lowpass%f",[self.myRecorder peakPowerForChannel:0]);
}
- (void)yueqi
{
    for (int i=0; i <4; i++) {
        UIButton *yueqi_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        yueqi_btn.frame = CGRectMake(K_SIZE.height/35, (self.scrollView.contentSize.height/1.93)+(self.scrollView.contentSize.height/5)*i, K_SIZE.width*3/20, K_SIZE.width*3/20);
        if (i ==0) {
            [yueqi_btn setImage:[UIImage imageNamed:@"gu.png"] forState:UIControlStateNormal];
        }
        if (i ==1) {
            [yueqi_btn setImage:[UIImage imageNamed:@"beisi.png"] forState:UIControlStateNormal];
        }
        if (i ==2) {
            [yueqi_btn setImage:[UIImage imageNamed:@"jita.png"] forState:UIControlStateNormal];
        }
        if (i ==3) {
            [yueqi_btn setImage:[UIImage imageNamed:@"jianpan.png"] forState:UIControlStateNormal];
        }
        [yueqi_btn addTarget:self action:@selector(yueqiUp:) forControlEvents:UIControlEventTouchUpInside];
        [yueqi_btn addTarget:self action:@selector(yueqiDown:) forControlEvents:UIControlEventTouchDown];
        yueqi_btn.tag = i;
        [self.view addSubview:yueqi_btn];
    }
}
- (void)yueqiUp:(UIButton *)button
{
   
}
- (void)yueqiDown:(UIButton *)button
{
    if (button.tag == 0) {
        [button setImage:[UIImage imageNamed:@"gu_down"] forState:UIControlStateHighlighted];
    }
    if (button.tag == 1) {
        [button setImage:[UIImage imageNamed:@"jita_down"] forState:UIControlStateHighlighted];
    }
    if (button.tag == 2) {
        [button setImage:[UIImage imageNamed:@"beisi_down"] forState:UIControlStateHighlighted];
    }
    if (button.tag == 3) {
        [button setImage:[UIImage imageNamed:@"jianpan_down"] forState:UIControlStateHighlighted];
    }
}
- (void)recoderBackLabel{
    for (int k =0; k <24; k++) {
        self.Rec_Label_Back = [[UILabel alloc]initWithFrame:CGRectMake((self.scrollView.contentSize.width/24)*k+30, self.scrollView.contentSize.height/15, self.scrollView.contentSize.height/15, self.scrollView.contentSize.height/15)];
        self.Rec_Label_Back.backgroundColor = [UIColor colorWithRed:0.666667F green:0.666667F blue:0.666667F alpha:1.0F];
        self.Rec_Label_Back.layer.cornerRadius =self.scrollView.contentSize.height/30;
        self.Rec_Label_Back.layer.masksToBounds = YES;
        [self.scrollView addSubview:self.Rec_Label_Back];
    }
}
- (void)rotation
{
    [[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationLandscapeLeft animated: NO];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0];
    self.view.transform = CGAffineTransformIdentity;
    self.view.transform = CGAffineTransformMakeRotation(M_PI*(90)/180.0);
    self.view.bounds = CGRectMake(-10, 0, 480, 320);
    [UIView commitAnimations];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
