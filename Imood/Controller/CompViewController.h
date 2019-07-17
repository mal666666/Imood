//
//  CompViewController.h
//  IMood
//
//  Created by 马 爱林 on 15/4/22.
//  Copyright (c) 2015年 马 爱林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface CompViewController : UIViewController<AVAudioPlayerDelegate ,AVAudioRecorderDelegate,AVAudioSessionDelegate>


@property (nonatomic, assign) NSInteger musicType;//音乐类型
@property (nonatomic ,strong) AVAudioRecorder *myRecorder;//录音
@end
