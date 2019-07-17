//
//  ViewController.h
//  Composer
//
//  Created by 马 爱林 on 14/10/29.
//  Copyright (c) 2014年 马 爱林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ELCImagePickerHeader.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "FeSlideFilterView.h"
#import "CIFilter+LUT.h"
#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE

@interface ViewController : UIViewController

-(void) initCommon;
-(void) initPhotoFilter;
-(void) initTitle;
-(void) initFeSlideFilterView;

@end



