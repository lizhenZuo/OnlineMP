//
//  UIConst.h
//  Credit
//
//  Created by dfcy on 2017/8/18.
//  Copyright © 2017年 zorro.zuo. All rights reserved.
//

#import <Foundation/Foundation.h>

/* 颜色 和 字体大小的设置区 */

#ifdef DEBUG // 调试

#define MYLog(...) NSLog(__VA_ARGS__)

#else // 发布

#define MYLog(...)

#endif
//获取屏幕宽高
#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//获取当前手机的屏幕的几倍分辩率 4-6,6s为2倍，plus为3倍
#define kScale (NSInteger)[UIScreen mainScreen].scale
//获取appDelegate
#define  kwindow ((AppDelegate *)[UIApplication sharedApplication].delegate)
//适配
#define getHeight(y)     y/2
#define getWidth(x)      x/2
//颜色
#define rgb(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
//内边框
#define NborderWidth 0.5
#define NborderColor [[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0] CGColor]
//圆角
#define CirleWidth 2

//外边框
#define WborderColor [[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0] CGColor]
#define WborderWidth 0.5
#define BGColor rgb(243,243,243)

#define  halfBorderWidth 0.25

//屏幕适配
#define iphone5 kSCREEN_WIDTH==320.0f
#define iphone6 kSCREEN_WIDTH==375.0f
#define iphone6p kSCREEN_WIDTH==414.0f

//主要的颜色
#define BlueColor rgb(0,156,237)
#define RedColor rgb(255,89,73)
#define GreenColor rgb(85,193,84)
#define GrayColor rgb(208,208,208)
#define WhiteColor rgb(255,255,255)
#define BoldFont @"Helvetica-Bold"

@interface UIConst : NSObject

@end
