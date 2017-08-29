//
//  LocalUtilties.h
//  HiPandaParentLib
//
//  Created by MAC20151009A on 16/9/14.
//  Copyright © 2016年 HiPandaParent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalUtilties : NSObject

+ (NSString *)dicToJsonString:(id)object;
+ (NSDictionary *)jsonStringToDict:(NSString *)jsonString;

+ (NSString *)arrayToJsonString:(NSArray *)array;
+ (NSArray *)jsonStringToArray:(NSString *)jsonString;

+ (NSString *)stringFromDate:(NSDate *)date;

+ (NSDate *)dateFromString:(NSString *)string;

+ (NSString *)stringFromTime:(NSDate *)date;

+ (NSDate *)timeFromString:(NSString *)string;

+ (NSString *)base64EncodeWithString:(NSString *)originStr;
+ (NSString *)base64DecodeWithString:(NSString *)encodeStr;

// password_1 = lower(sha1(password_seed1 + password))
+ (NSString *)sha1CodeWith:(NSString *)password passwordSeed:(NSString *)passwordSeed;

+ (NSString *)encodeUseDES3:(NSString *)plainText key:(NSString *)key;

+ (NSString *)getDeviceOpenUDID;

// 日期获取星期
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

+ (NSData *)uncompressGZippedData:(NSData *)compressedData;

@end
