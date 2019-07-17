//
//  PSystemMacro.h
//  PPL
//
//  Created by jxgg on 17/11/17.
//  Copyright © 2017年 PPL. All rights reserved.
//

#ifndef PSystemMacro_h
#define PSystemMacro_h

//单例声名
#define SIGLEDEF(__class) \
+(__class*)shareInstance;
//单例实现
#define SIGLEIMP(__class) \
+(__class *)shareInstance{\
static __class *sigleObj = nil;\
static dispatch_once_t predicate;\
dispatch_once(&predicate, ^{\
sigleObj = [[self alloc] init];\
});\
return sigleObj;\
}
// - 状态栏、顶部导航栏、底部导航栏的高度 --
#define kStatusBarH [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarH 44.0f
#define kTabBarH ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49.0f)
#define kTopTotalH (kStatusBarH + kNavBarH)
#define kNavBarButtonItemRect CGRectMake(0, kStatusBarH, 60, kNavBarH)
#define kBottomTouchBarH kTabBarH-49

#pragma mark - 屏幕的宽高 --
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kControllerTabH (kScreenH - kTabBarH - kTopTotalH)
#define kControllerNavH (kScreenH - kTopTotalH)

#pragma mark - 当前系统设备名字 --
#define IOS_DeviceName [[UIDevice currentDevice] systemName]

#pragma mark - 当前系统的版本号 --
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOS_VERSIONSTR [NSString stringWithFormat:@"%.2f",IOS_VERSION]

// OS
#define IOS8 [[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0
#define IOS7 [[[UIDevice currentDevice]systemVersion] floatValue] == 7.0
#define IOS10Later [[[UIDevice currentDevice]systemVersion] floatValue] >= 10.0
#define IOS11 @available(iOS 11.0, *)

#pragma mark - 屏幕宽占比(5/5s) --
#define FLEXIBLE_WIDTH_35INCH(x) ((x) / 320.0 * SCREEN_WIDTH)
#pragma mark - 屏幕宽占比(6/6s) --
#define FLEXIBLE_WIDTH_55INCH(x) ((x) / 375.0 * SCREEN_WIDTH)
#define FLEXIBLE_WIDTH_47INCH(x) ((x) / 375.0)

//#define kCalculateHeight(h) ((h) * kScreenW / 375.0)
#define kCalculateWidth(w) ((w) * kScreenW / 375.0)
#define kCalculateHeight(h) ((h) * kScreenH / 667.0)

#pragma mark - 判断设备 --
/** 判断是否是iPhone4、iPhone4s设备 */
#define IS_35INCH_DEVICE    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
/** 判断设备是否是iPhone5、iPhone5s */
#define IS_4INCH_DEVICE     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
/** 判断设备是否是iPhone6 */
#define IS_47INCH_DEVICE    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
/** 判断设备是否是iPhone6Plus */
#define IS_55INCH_DEVICE    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
/** 判断设备是否是iPhoneX  iPhone Xs*/
#define IS_58INCH_DEVICE    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
/** 判断设备是否是iPhone Xr */
#define IS_61INCH_DEVICE    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
/** 判断设备是否是iPhone Xs Max */
#define IS_65INCH_DEVICE    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPadMini1 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(768, 1024), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPad2 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(768, 1024), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPadAir ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(2048, 1536), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPadAir2 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1536, 2048), [[UIScreen mainScreen] currentMode].size) : NO)

#pragma mark - 获取window --
#define GetWindow [[[UIApplication sharedApplication] delegate] window]
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#pragma mark - 打印日志 --
#ifdef DEBUG
#define PLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#else
#define PLog(...)
#endif

#endif /* DISystemMacro_h */
