//
//  ControllerManager.m
//  Credit
//
//  Created by dfcy on 2017/8/18.
//  Copyright © 2017年 zorro.zuo. All rights reserved.
//

#import "ControllerManager.h"

@interface ControllerManager()

@end

@implementation ControllerManager

+ (instancetype)getInstance
{
    static ControllerManager *s_instance = nil;
    if (s_instance == nil)
    {
        s_instance = [[ControllerManager alloc] init];
    }
    return s_instance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

@end
