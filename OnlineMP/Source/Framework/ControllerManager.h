//
//  ControllerManager.h
//  Credit
//
//  Created by dfcy on 2017/8/18.
//  Copyright © 2017年 zorro.zuo. All rights reserved.
//

#import <Foundation/Foundation.h>

/* ControllerManager 是唯一的实例对象，其他的controller的对象都通过ControllerManager的实例来获取 */

@interface ControllerManager : NSObject

+ (instancetype)getInstance;


@end
