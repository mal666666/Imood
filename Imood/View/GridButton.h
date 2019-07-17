//
//  GridButton.h
//  Composer
//
//  Created by 马 爱林 on 14/10/29.
//  Copyright (c) 2014年 马 爱林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridButton : UIButton
@property (strong, nonatomic) NSString *ButtonMusic;//每个button下面都有一首歌
@property (assign, nonatomic) NSInteger buttonCount;
@property (strong, nonatomic) NSMutableArray* musicArr;
@end
