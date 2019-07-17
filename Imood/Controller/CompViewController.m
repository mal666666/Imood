//
//  CompViewController.m
//  IMood
//
//  Created by 马 爱林 on 15/4/22.
//  Copyright (c) 2015年 马 爱林. All rights reserved.
//

#import "CompViewController.h"

@interface CompViewController (){
    UIButton *select_music_btn;//音乐选择
    UIButton *music_element_btn;//音乐元素
    NSMutableArray *colorArr;//4种按钮颜色
    UIButton *btn1,*btn2,*btn3,*btn4,*btn5;
    NSArray *music_arr;//20个音乐元素
    NSArray *music_DRUM_arr;//5个鼓
    NSArray *music_BASS_arr;//5个贝斯
    NSArray *music_GUITAR_arr;//5个吉他
    NSArray *music_MIDI_arr;//5个键盘
    NSMutableArray *music_mix_arr;//合成音乐
    NSInteger music_index;//识别乐器
    AVAudioPlayer *playTry;//试听
    UIButton *playBtn;//播放按钮
    UISlider *slider;//进度条
    NSTimer *music_timer;//播放进度
    
    UIButton* record_btn;//录音
    UILabel *record_timer_lab;//录音倒计时
    NSString *music_path;//合成音乐路径
    NSString *recoder_path;//录音路径
    int64_t recoder_start_time;//开始录音时间
    
}
@end

@implementation CompViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    //背景
//    UIImageView *backIV =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCR_WIDTH, SCR_HEIGHT+20)];
//    backIV.image =[UIImage imageNamed:@"home_bg2x"];
//    [self.view addSubview:backIV];
    self.view.backgroundColor =[UIColor colorWithRed:0.200000F green:0.423529F blue:0.549020F alpha:1.0F];
    colorArr =[NSMutableArray arrayWithObjects:[UIColor colorWithRed:0.964706F green:0.419608F blue:0.388235F alpha:1.0F],[UIColor colorWithRed:1.000000F green:0.627451F blue:0.219608F alpha:1.0F], [UIColor colorWithRed:0.325490F green:0.709804F blue:0.839216F alpha:1.0F],[UIColor colorWithRed:0.364706F green:0.800000F blue:0.796078F alpha:1.0F],nil];
    [self initInstrumentBtn];//加载音乐创作仪器
    [self initElementBtn];//加载音乐元素
    //加载音乐数据
    if (self.musicType ==1) {
        music_DRUM_arr =[NSArray arrayWithObjects:@"LX-鼓1",@"LX-鼓2",@"LX-鼓3",@"LX-鼓4",@"LX-鼓5", nil];
        music_BASS_arr =[NSArray arrayWithObjects:@"LX-贝斯1",@"LX-贝斯2",@"LX-贝斯3",@"LX-贝斯4",@"LX-贝斯5", nil];
        music_GUITAR_arr=[NSArray arrayWithObjects:@"LX-主音吉他1",@"LX-主音吉他2",@"LX-主音吉他3",@"LX-主音吉他4",@"LX-主音吉他5", nil];
        music_MIDI_arr =[NSArray arrayWithObjects:@"LX-节奏吉他1",@"LX-节奏吉他2",@"LX-节奏吉他3",@"LX-节奏吉他4",@"LX-节奏吉他5", nil];
    }else if (self.musicType ==2){
        music_DRUM_arr =[NSArray arrayWithObjects:@"JS-鼓1",@"JS-鼓2",@"JS-鼓3",@"JS-鼓4",@"JS-鼓5", nil];
        music_BASS_arr =[NSArray arrayWithObjects:@"JS-贝斯1",@"JS-贝斯2",@"JS-贝斯3",@"JS-贝斯4",@"JS-贝斯5", nil];
        music_GUITAR_arr=[NSArray arrayWithObjects:@"JS-主音吉他1",@"JS-主音吉他2",@"JS-主音吉他3",@"JS-主音吉他4",@"JS-主音吉他5", nil];
        music_MIDI_arr =[NSArray arrayWithObjects:@"JS-节奏吉他1",@"JS-节奏吉他2",@"JS-节奏吉他3",@"JS-节奏吉他4",@"JS-节奏吉他5", nil];
    }else if (self.musicType ==3){
        music_DRUM_arr =[NSArray arrayWithObjects:@"SN-鼓1",@"SN-鼓2",@"SN-鼓3",@"SN-鼓4",@"SN-鼓5", nil];
        music_BASS_arr =[NSArray arrayWithObjects:@"SN-贝斯1",@"SN-贝斯2",@"SN-贝斯3",@"SN-贝斯4",@"SN-贝斯5", nil];
        music_GUITAR_arr=[NSArray arrayWithObjects:@"SN-吉他1",@"SN-吉他2",@"SN-吉他3",@"SN-吉他4",@"SN-吉他5", nil];
        music_MIDI_arr =[NSArray arrayWithObjects:@"SN-键盘1",@"SN-键盘2",@"SN-键盘3",@"SN-键盘4",@"SN-键盘5", nil];
    }else {
        music_DRUM_arr =[NSArray arrayWithObjects:@"DZ-鼓1",@"DZ-鼓2",@"DZ-鼓3",@"DZ-鼓4",@"DZ-鼓5", nil];
        music_BASS_arr =[NSArray arrayWithObjects:@"DZ-贝斯1",@"DZ-贝斯2",@"DZ-贝斯3",@"DZ-贝斯4",@"DZ-贝斯5", nil];
        music_GUITAR_arr=[NSArray arrayWithObjects:@"DZ-DJ1",@"DZ-DJ2",@"DZ-DJ3",@"DZ-DJ4",@"DZ-DJ5", nil];
        music_MIDI_arr =[NSArray arrayWithObjects:@"DZ-键盘1",@"DZ-键盘2",@"DZ-键盘3",@"DZ-键盘4",@"DZ-键盘5", nil];
    }
    music_arr =[NSArray arrayWithObjects:music_DRUM_arr,music_BASS_arr,music_GUITAR_arr,music_MIDI_arr, nil];
    //合成音乐数组
    music_mix_arr =[NSMutableArray arrayWithCapacity:4];
    music_mix_arr.array =@[@"无",@"无",@"无",@"无",];
    //播放按钮
    playBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame =CGRectMake(SCR_WIDTH*3/9, kStatusBarH+SCR_WIDTH*3/9, SCR_WIDTH/3, SCR_WIDTH/3);
    if (IS_4INCH_DEVICE || iPadAir ||iPad2) {
        playBtn.frame =CGRectMake(SCR_WIDTH*3/9, kStatusBarH+SCR_WIDTH*3/9/2, SCR_WIDTH/3, SCR_WIDTH/3);
    }
    [playBtn setImage:[UIImage imageNamed: @"play"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(MixMusicPlay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
    //
    [self initFootView];
    music_path =nil;//合成音乐路径
    recoder_path =nil;//录音路径
    recoder_start_time =0;//开始录音时间
}
- (void)drawRect:(CGRect)rect{
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);//填充色设置成灰色
    CGContextFillRect(context,self.view.bounds);//把整个空间用刚设置的颜色填充
}
-(void)initInstrumentBtn{
    for (int i =0; i<2; i++) {
        for (int j=0; j<2; j++) {
            select_music_btn =[UIButton buttonWithType:UIButtonTypeCustom];
            select_music_btn.frame =CGRectMake(j*SCR_WIDTH/2+5,kStatusBarH+ i*SCR_WIDTH/2+5, SCR_WIDTH/2-10, SCR_WIDTH/2-10);
            if (IS_4INCH_DEVICE || iPadAir ||iPad2) {
                select_music_btn.frame =CGRectMake(j*SCR_WIDTH/2+5,kStatusBarH+ i*SCR_WIDTH/2/1.5+5, SCR_WIDTH/2-10, SCR_WIDTH/2/1.5-10);
            }
            select_music_btn.layer.cornerRadius =5;
            select_music_btn.layer.masksToBounds =YES;
            [select_music_btn addTarget:self action:@selector(selectorMusic:) forControlEvents:UIControlEventTouchUpInside];
            //显示乐器
            UILabel *instrument_lab =[[UILabel alloc]initWithFrame:CGRectMake(j*SCR_WIDTH/2+5,kStatusBarH+ i*SCR_WIDTH/2+5, SCR_WIDTH/2-10, SCR_WIDTH/2-10)];
            if (IS_4INCH_DEVICE || iPadAir ||iPad2) {
                instrument_lab.frame =CGRectMake(j*SCR_WIDTH/2+5,kStatusBarH+ i*SCR_WIDTH/2/1.5+5, SCR_WIDTH/2-10, SCR_WIDTH/2/1.5-10);
            }
            instrument_lab.textColor =[UIColor whiteColor];
            instrument_lab.textAlignment =NSTextAlignmentCenter;
            instrument_lab.font =[UIFont systemFontOfSize:30];
            if (i==0&&j==0) {
                select_music_btn.tag =0;
                select_music_btn.backgroundColor =colorArr[0];
                instrument_lab.text =@"DRUM";
            }
            if (i==0&&j==1) {
                select_music_btn.tag =1;
                select_music_btn.backgroundColor =colorArr[1];
                instrument_lab.text =@"BASS";
            }
            if (i==1&&j==0) {
                select_music_btn.tag =2;
                select_music_btn.backgroundColor =colorArr[2];
                instrument_lab.text =@"GUITAR";
            }
            if (i==1&&j==1) {
                select_music_btn.tag =3;
                select_music_btn.backgroundColor =colorArr[3];
                instrument_lab.text =@"MIDI";
            }
            [self.view addSubview:select_music_btn];
            [self.view addSubview:instrument_lab];
            
        }
    }
}
-(void)initElementBtn{
    btn1 =[UIButton buttonWithType:UIButtonTypeCustom];
    btn2 =[UIButton buttonWithType:UIButtonTypeCustom];
    btn3 =[UIButton buttonWithType:UIButtonTypeCustom];
    btn4 =[UIButton buttonWithType:UIButtonTypeCustom];
    btn5 =[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame =CGRectMake(5, kStatusBarH+ SCR_WIDTH+ 5, SCR_WIDTH/5-10, SCR_HEIGHT/6-10);
    btn2.frame =CGRectMake(SCR_WIDTH/5+5, kStatusBarH+ SCR_WIDTH+5, SCR_WIDTH/5-10, SCR_HEIGHT/6-10);
    btn3.frame =CGRectMake(2*SCR_WIDTH/5+5, kStatusBarH+ SCR_WIDTH+5, SCR_WIDTH/5-10, SCR_HEIGHT/6-10);
    btn4.frame =CGRectMake(3*SCR_WIDTH/5+5, kStatusBarH+ SCR_WIDTH+5, SCR_WIDTH/5-10, SCR_HEIGHT/6-10);
    btn5.frame =CGRectMake(4*SCR_WIDTH/5+5, kStatusBarH+ SCR_WIDTH+5, SCR_WIDTH/5-10, SCR_HEIGHT/6-10);
    if (IS_4INCH_DEVICE || iPadAir ||iPad2) {
        btn1.frame =CGRectMake(5, kStatusBarH+ SCR_WIDTH+ 5-SCR_WIDTH/3, SCR_WIDTH/5-10, SCR_HEIGHT/6-10);
        btn2.frame =CGRectMake(SCR_WIDTH/5+5, kStatusBarH+ SCR_WIDTH+5-SCR_WIDTH/3, SCR_WIDTH/5-10, SCR_HEIGHT/6-10);
        btn3.frame =CGRectMake(2*SCR_WIDTH/5+5, kStatusBarH+ SCR_WIDTH+5-SCR_WIDTH/3, SCR_WIDTH/5-10, SCR_HEIGHT/6-10);
        btn4.frame =CGRectMake(3*SCR_WIDTH/5+5, kStatusBarH+ SCR_WIDTH+5-SCR_WIDTH/3, SCR_WIDTH/5-10, SCR_HEIGHT/6-10);
        btn5.frame =CGRectMake(4*SCR_WIDTH/5+5, kStatusBarH+ SCR_WIDTH+5-SCR_WIDTH/3, SCR_WIDTH/5-10, SCR_HEIGHT/6-10);
    }
    btn1.layer.cornerRadius =5;
    btn2.layer.cornerRadius =5;
    btn3.layer.cornerRadius =5;
    btn4.layer.cornerRadius =5;
    btn5.layer.cornerRadius =5;
    btn1.layer.masksToBounds =YES;
    btn2.layer.masksToBounds =YES;
    btn3.layer.masksToBounds =YES;
    btn4.layer.masksToBounds =YES;
    btn5.layer.masksToBounds =YES;
    btn1.backgroundColor =colorArr[0];
    btn2.backgroundColor =colorArr[0];
    btn3.backgroundColor =colorArr[0];
    btn4.backgroundColor =colorArr[0];
    btn5.backgroundColor =colorArr[0];
    btn1.tag =0;
    btn2.tag =1;
    btn3.tag =2;
    btn4.tag =3;
    btn5.tag =4;
    [btn1 setTitle:@"1" forState:UIControlStateNormal];
    [btn2 setTitle:@"2" forState:UIControlStateNormal];
    [btn3 setTitle:@"3" forState:UIControlStateNormal];
    [btn4 setTitle:@"4" forState:UIControlStateNormal];
    [btn5 setTitle:@"5" forState:UIControlStateNormal];
    btn1.titleLabel.font =[UIFont systemFontOfSize:50];
    btn2.titleLabel.font =[UIFont systemFontOfSize:50];
    btn3.titleLabel.font =[UIFont systemFontOfSize:50];
    btn4.titleLabel.font =[UIFont systemFontOfSize:50];
    btn5.titleLabel.font =[UIFont systemFontOfSize:50];
    btn1.titleLabel.adjustsFontSizeToFitWidth =YES;
    btn2.titleLabel.adjustsFontSizeToFitWidth =YES;
    btn3.titleLabel.adjustsFontSizeToFitWidth =YES;
    btn4.titleLabel.adjustsFontSizeToFitWidth =YES;
    btn5.titleLabel.adjustsFontSizeToFitWidth =YES;
    [btn1 addTarget:self action:@selector(selectorMusicElement:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(selectorMusicElement:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 addTarget:self action:@selector(selectorMusicElement:) forControlEvents:UIControlEventTouchUpInside];
    [btn4 addTarget:self action:@selector(selectorMusicElement:) forControlEvents:UIControlEventTouchUpInside];
    [btn5 addTarget:self action:@selector(selectorMusicElement:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    [self.view addSubview:btn2];
    [self.view addSubview:btn3];
    [self.view addSubview:btn4];
    [self.view addSubview:btn5];
}
-(void)selectorMusic:(UIButton*)btn{
    NSLog(@"乐器%ld",(long)btn.tag);
    btn1.backgroundColor =colorArr[btn.tag];
    btn2.backgroundColor =colorArr[btn.tag];
    btn3.backgroundColor =colorArr[btn.tag];
    btn4.backgroundColor =colorArr[btn.tag];
    btn5.backgroundColor =colorArr[btn.tag];
    //
    [btn1 setTitle:music_arr[btn.tag][0] forState:UIControlStateHighlighted];
    [btn2 setTitle:music_arr[btn.tag][1] forState:UIControlStateHighlighted];
    [btn3 setTitle:music_arr[btn.tag][2] forState:UIControlStateHighlighted];
    [btn4 setTitle:music_arr[btn.tag][3] forState:UIControlStateHighlighted];
    [btn5 setTitle:music_arr[btn.tag][4] forState:UIControlStateHighlighted];
    //
    music_index =btn.tag;
}
-(void)selectorMusicElement:(UIButton*)btn{
    NSLog(@"音乐元素%ld",(long)btn.tag);
    if ([btn.titleLabel.text isEqual:@"1"]||[btn.titleLabel.text isEqual:@"2"]||[btn.titleLabel.text isEqual:@"3"]||[btn.titleLabel.text isEqual:@"4"]||[btn.titleLabel.text isEqual:@"5"]) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@" 提示" message:@"请选择乐器" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [music_mix_arr replaceObjectAtIndex:music_index withObject:btn.titleLabel.text];
        for (int i=0; i<music_mix_arr.count; i++) {
            NSLog(@"要合成的音乐元素%@",music_mix_arr[i]);
        }
        [self playMusic:btn.titleLabel.text];
    }
}
-(void)playMusic:(NSString *)musicStr{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [playTry stop];
    NSString *str =[[NSBundle mainBundle] pathForResource:musicStr ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:str];
    playTry = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    playTry.volume =1;
    playTry.delegate =self;
    [playTry prepareToPlay];
    [playTry play];
}
- (void)MixMusicPlay{
    //混合音乐
    [playTry stop];
    if ([music_mix_arr[0] isEqual:@"无"] &&[music_mix_arr[1] isEqual:@"无"] &&[music_mix_arr[2] isEqual:@"无"] &&[music_mix_arr[3] isEqual:@"无"] ) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@" 提示" message:@"请添加音乐" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        AVMutableComposition * mixComposition = [AVMutableComposition composition];
        for (int i=0; i<music_mix_arr.count; i++) {
            if (![music_mix_arr[i] isEqual:@"无"]) {
                NSString *Path = [[NSBundle mainBundle] pathForResource:music_mix_arr[i] ofType:@"mp3"];
                NSURL *audioUrl = [NSURL fileURLWithPath:Path];
                AVURLAsset * audioAsset = [AVURLAsset URLAssetWithURL:audioUrl options:nil];
                AVMutableCompositionTrack *compositionCommentaryTrack =[mixComposition
                                                                        addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                        preferredTrackID: kCMPersistentTrackID_Invalid];
                [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)
                                                    ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                                     atTime:CMTimeMake(0, 1) error:nil];
            }
            
        }
        AVAssetExportSession * _assetExport = [[AVAssetExportSession alloc]initWithAsset:mixComposition
                                                                              presetName:AVAssetExportPresetAppleM4A];
        
        NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *exportPath =[[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"exportMusic.m4a"]];
        NSURL    *exportUrl = [NSURL fileURLWithPath:exportPath];
        music_path =exportPath;
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
                 AVAudioSession *session = [AVAudioSession sharedInstance];
                 [session setActive:YES error:nil];
                 [session setCategory:AVAudioSessionCategoryPlayback error:nil];
                 
                 playTry = [[AVAudioPlayer alloc]initWithContentsOfURL:exportUrl error:nil];
                 [playTry prepareToPlay];
                 playTry.delegate =self;
                 [playTry play];
                 [music_timer invalidate];
                 music_timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(updateSliderValue) userInfo:nil repeats:YES];
             });
         }];
    }
}
-(void)updateSliderValue{
    NSLog(@"%f___%f",playTry.currentTime,playTry.duration);
    slider.value =playTry.currentTime/playTry.duration;
    int x =(int)playTry.duration-(int)playTry.currentTime;
    if (x<10) {
        record_timer_lab.text =[NSString stringWithFormat:@"录音倒计时--0%d", x];
    }else{
        record_timer_lab.text =[NSString stringWithFormat:@"录音倒计时--%d", x];
    }
}
-(void)initFootView{
    UIButton* back_btn = [UIButton buttonWithType:UIButtonTypeCustom];//返回
    back_btn.frame = CGRectMake(SCR_WIDTH/7, SCR_HEIGHT-66, 36, 36);
    [back_btn setBackgroundImage:[UIImage imageNamed:@"closed"] forState:UIControlStateNormal];
    [back_btn addTarget:self action:@selector(backViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back_btn];
    UIButton* mix_btn = [UIButton buttonWithType:UIButtonTypeCustom];//发布
    mix_btn.frame = CGRectMake(SCR_WIDTH-36-SCR_WIDTH/7, SCR_HEIGHT-66, 36, 36);
    [mix_btn setBackgroundImage:[UIImage imageNamed:@"fabu"] forState:UIControlStateNormal];
    [mix_btn addTarget:self action:@selector(MixMusic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mix_btn];
    //播放进度指示
    slider = [[UISlider alloc]initWithFrame:CGRectMake(20, SCR_HEIGHT-46-20-SCR_HEIGHT/20, SCR_WIDTH-40, 0)];
    if (IS_4INCH_DEVICE || iPadAir ||iPad2) {
        slider.frame =CGRectMake(20, SCR_HEIGHT-36-20-SCR_HEIGHT/20-20, SCR_WIDTH-40, 0);
    }
    slider.minimumTrackTintColor =[UIColor greenColor];
    slider.maximumTrackTintColor =[UIColor grayColor];
    slider.thumbTintColor =[UIColor colorWithRed:0.847059F green:0.666667F blue:0.650980F alpha:1.0F];
    slider.maximumValue = 1;
    slider.minimumValue = 0;
    slider.value =0;
    // slider.continuous = YES;
    [self.view addSubview:slider];
    //录音
    record_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    record_btn.frame = CGRectMake(0, 0, 60, 60);
    record_btn.center =CGPointMake(SCR_WIDTH/2, back_btn.center.y);
    [record_btn setBackgroundImage:[UIImage imageNamed:@"luyin"] forState:UIControlStateNormal];
    [record_btn addTarget:self action:@selector(addRecord:) forControlEvents:UIControlEventTouchUpInside];
    record_btn.layer.borderColor =[UIColor redColor].CGColor;
    record_btn.layer.borderWidth =0;
    record_btn.layer.cornerRadius =30;
    record_btn.layer.masksToBounds =YES;
    record_btn.tag =101;
    [self.view addSubview:record_btn];
    //录音倒计时
    record_timer_lab =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCR_WIDTH/2, 30)];
    record_timer_lab.center =CGPointMake(SCR_WIDTH/2, record_btn.center.y-50);
    record_timer_lab.textAlignment =NSTextAlignmentCenter;
    record_timer_lab.hidden =YES;
    [self.view addSubview:record_timer_lab];
}
-(void)addRecord:(UIButton *)btn{
    if (btn.tag ==101) {
        record_btn.layer.borderWidth =4;
        record_btn.tag =102;
        record_timer_lab.hidden =NO;
        //预备录音
        [self prepareRecode];
        [self.myRecorder record];
        recoder_start_time =playTry.currentTime;//开始录音时间
    }else{
        record_btn.layer.borderWidth =0;
        record_btn.tag =101;
        record_timer_lab.hidden =YES;
        [self.myRecorder stop];
        recoder_path =[self fullPathAtCache];//
        [self recoderEndAudioSession];
    }
}
-(void)recoderEndAudioSession{
    //录音结束，切换音频会议
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategorySoloAmbient error:&err];
    [audioSession setActive:YES error:&err];
}
- (void)prepareRecode{
    NSURL *url = [[NSURL alloc]initFileURLWithPath:[self fullPathAtCache]];
    NSError *error;
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
    //@{AVFormatIDKey : @(kAudioFormatMPEG4AAC), AVEncoderBitRateKey:@(16),AVEncoderAudioQualityKey : @(AVAudioQualityMax), AVSampleRateKey : @(44100.0), AVNumberOfChannelsKey : @(2)}
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    self.myRecorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    self.myRecorder.meteringEnabled = YES;
    self.myRecorder.delegate = self;
    [self.myRecorder prepareToRecord];
}
- (NSString *)fullPathAtCache{
    //创建目录
    NSString *appDocDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *m_pFilePath = [[NSString alloc]initWithString:[appDocDir stringByAppendingPathComponent:@"bao.m4a"]];
    NSLog(@"录音路劲_____%@",m_pFilePath);
    return m_pFilePath;
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    record_btn.layer.borderWidth =0;
    record_btn.tag =101;
    record_timer_lab.text =@"";
    [music_timer invalidate];
    [self.myRecorder stop];
    recoder_path =[self fullPathAtCache];
    [self recoderEndAudioSession];
}
-(void)backViewController{
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)MixMusic{
    if (music_path ==nil) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择节奏，并点击播放，合成音乐" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [self.myRecorder stop];
        [playTry stop];
        recoder_path =[self fullPathAtCache];
        [self recoderEndAudioSession];
        AVMutableComposition * mixComposition = [AVMutableComposition composition];
        if (music_path !=nil ) {
            NSURL *music_audioUrl = [NSURL fileURLWithPath:music_path];
            AVURLAsset * audioAsset = [AVURLAsset URLAssetWithURL:music_audioUrl options:nil];
            AVMutableCompositionTrack *compositionCommentaryTrack =[mixComposition
                                                                    addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                    preferredTrackID: kCMPersistentTrackID_Invalid];
            [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)
                                                ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                                 atTime:CMTimeMake(0, 1) error:nil];
        }
        
        if (recoder_path !=nil &&recoder_start_time>0) {
            NSURL *recoder_audioUrl =[NSURL fileURLWithPath:recoder_path];
            AVURLAsset * audioAsset_1 = [AVURLAsset URLAssetWithURL:recoder_audioUrl options:nil];
            AVMutableCompositionTrack *compositionCommentaryTrack_1 =[mixComposition
                                                                      addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                      preferredTrackID: kCMPersistentTrackID_Invalid];
            [compositionCommentaryTrack_1 insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset_1.duration)
                                                  ofTrack:[[audioAsset_1 tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                                   atTime:CMTimeMake(recoder_start_time, 1) error:nil];
        }
        
        AVAssetExportSession * _assetExport = [[AVAssetExportSession alloc]initWithAsset:mixComposition
                                                                              presetName:AVAssetExportPresetAppleM4A];
        
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
             NSLog(@"加录音混合完成___%@",exportPath);
             dispatch_sync(dispatch_get_main_queue(), ^{
                 [self backViewController];
             });
         }];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [music_timer invalidate];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
