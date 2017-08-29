//
//  UrlUtility.h
//  HiPandaParent
//
//  Created by MAC20150506A on 15/7/9.
//  Copyright (c) 2015年 com.toycloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlUtility : NSObject

+ (NSDictionary *)parseURLParams:(NSString *)query;
+ (NSURL *)generateURL:(NSString *)baseURL params:(NSDictionary *)params;
+ (NSDictionary *)getCurNetworkInfo;

@end
