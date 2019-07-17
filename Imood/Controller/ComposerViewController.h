//
//  ComposerViewController.h
//  Composer
//
//  Created by 马 爱林 on 14/10/29.
//  Copyright (c) 2014年 马 爱林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridButton.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImage+ImageSize.h"
typedef void(^MyBlock) (NSString *strMusic);
@interface ComposerViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSTimer *time;//时间主轴
@property (strong, nonatomic) NSTimer *gridTime;//每小节已经播放时间
@property (strong, nonatomic) CADisplayLink *gridTime1;
@property (strong, nonatomic) NSTimer *shengyuTime;//每小节剩余播放时间
@property (assign, nonatomic) float xiaojiejishu;
@property (strong, nonatomic) NSTimer *scrollViewTime;//scroll滚动
@property (strong, nonatomic) GridButton *button;
@property (strong, nonatomic) NSMutableArray *musicArray;
@property (strong, nonatomic) NSMutableArray *musicArray1;
@property (strong, nonatomic) NSMutableArray *musicArray2;
@property (strong, nonatomic) NSMutableArray *musicArray3;
@property (strong, nonatomic) NSMutableArray *musicArray4;
@property (strong, nonatomic) NSMutableArray *musicArray5;
@property (strong, nonatomic) NSMutableArray *musicArray6;
@property (strong, nonatomic) NSMutableArray *musicArray7;
@property (strong, nonatomic) NSMutableArray *musicNameArray;//32首歌

@property (strong, nonatomic) UITableView* chooseTab;//下拉菜单
@property (strong, nonatomic) NSMutableArray* chooseItem;//每个按钮下面的5首歌
@property (strong, nonatomic) NSString *musicName;//音乐名字
@property (assign, nonatomic) NSInteger musicCount;//第几个乐器
@property (strong, nonatomic) AVAudioPlayer *play, *play1, *play2, *play3, *play4, *play5, *play6, *play7, *playTry;
@property (strong, nonatomic) AVAudioPlayer *playRcode;
@property (copy,   nonatomic) MyBlock myBlock;
@property (strong, nonatomic) UIButton *playBtn;//播放按钮
@property (assign, nonatomic) NSInteger jiePai;//节拍
@property (strong, nonatomic)UIButton *recoderBtn;//录音
@property (strong, nonatomic)AVAudioRecorder *myRecorder;
@property (strong, nonatomic)NSTimer *myTimer;
@property (strong, nonatomic)UIView *recoderView;
@property (strong, nonatomic)UIImageView *imageView;
@property (strong, nonatomic)NSArray *imageArr;
@property (strong, nonatomic)UISlider *MusicSlider;
@property (strong, nonatomic)UILabel *label, *label1, *label2;
@property (assign, nonatomic)NSInteger rec_play_start_place;//录音起始播放时间

@property (strong, nonatomic)NSTimer *up_rec_timer;//更新录音Label时间间隔
@property (assign, nonatomic)NSInteger rec_lab_num;//录音后label个数
@property (strong, nonatomic)UILabel *Rec_Label_Back;//录音背景Label
@property (strong, nonatomic)UILabel *Rec_Label;//录音Label
@property (strong, nonatomic)UIImageView *recoder_Img;//红色话筒
@property (strong, nonatomic)UIImage *ThumbImagePlay;//slider播放图片
@property (strong, nonatomic)UIImage *NewThumbImagePlay;
@property (strong, nonatomic)UIImage *ThumbImagePause;//slider暂停图片
@property (strong, nonatomic)UIImage *NewThumbImagePause;
@property (strong, nonatomic)NSMutableArray *recoder_label_array;
@property (strong, nonatomic)UIColor *xuanZhong_color;//选中后颜色
@end
