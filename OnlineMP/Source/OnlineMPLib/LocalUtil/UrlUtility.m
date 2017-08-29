//
//  UrlUtility.m
//  HiPandaParent
//
//  Created by MAC20150506A on 15/7/9.
//  Copyright (c) 2015年 com.toycloud. All rights reserved.
//

#import "UrlUtility.h"
#import <UIKit/UIKit.h>
/// 需要添加 SystemConfiguration.framework
#import <SystemConfiguration/CaptiveNetwork.h>


@implementation UrlUtility

/**
 * 解析URL参数的工具方法。
 */
+ (NSDictionary *)parseURLParams:(NSString *)query
{
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs)
    {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        if (kv.count == 2)
        {
            NSString *val = [[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [params setObject:val forKey:[kv objectAtIndex:0]];
        }
    }
    return params;
}

/*
 * 使用传入的baseURL地址和参数集合构造含参数的请求URL的工具方法。
 */
+ (NSURL *)generateURL:(NSString *)baseURL params:(NSDictionary *)params
{
    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendString:baseURL];

    //拼接字符串
    NSArray *keys = [params allKeys];
    for (int j = 0; j < keys.count; j++)
    {
        NSString *key = keys[j];
        NSString *string;
        NSString *valueString = params[key];
        if (j == 0)
        {
            string = [NSString stringWithFormat:@"?%@=%@", key, valueString];
        }
        else
        {
            string = [NSString stringWithFormat:@"&%@=%@", key, valueString];
        }
        [urlString appendString:string];
    }
    return [[NSURL alloc] initWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

+ (BOOL)isNetworkSupport
{
    return YES;
}

+ (NSDictionary *)getCurNetworkInfo
{
    NSMutableDictionary *result = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces)
    {
        return result;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    for (NSString *interfaceName in interfaces)
    {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        if (dictRef)
        {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
//            NSLog(@"network info -> %@", networkInfo);
            NSString *bssid = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeyBSSID];
            NSString *ssid = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            result = [[NSMutableDictionary alloc] init];
            [result setValue:bssid forKey:@"bssid"];
            [result setValue:ssid forKey:@"ssid"];
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return result;

}


@end
