//
//  OurUtilities.h
//  RainbowBook
//
//  Created by x on 12-12-10.
//  Copyright (c) 2012年 x. All rights reserved.
//

// ------------------------------------

#import "OurUIUtilities.h"

// ------------------------------------
//
// Micro
//

#if __has_feature(objc_arc)
#define OurSafeRelease(x)  do {if(x) {x=nil;}} while(0)
#else
#define OurSafeRelease(x)  do {if(x) {[x release]; x=nil;}} while(0)
#endif

#define OurSafeReleaseTimer(x)  do {if(x) {[x invalidate]; OurSafeRelease(x);}} while(0)
#define OurSafeReleaseDelegate(x)  do {if(x) {x.delegate=nil; OurSafeRelease(x);}} while(0)
#define OurSafeReleaseCancel(x)  do {if(x) {[x invalidate]; OurSafeRelease(x);}} while(0)

#define OurSafeString(s) (((s)==nil)?(@""):(s))

#ifdef DEBUG
#define OurLog(...) NSLog(__VA_ARGS__)
#else
#define OurLog(...) do {} while (0)
#endif

#define OurAbs(n) ((n)>=0? (n): -(n))
#define OurFloatEquals(f1,f2) (OurAbs((f1)-(f2))<=0.0001)

// ------------------------------------
//
// Struct
//
// ------------------------------------

#import <Foundation/Foundation.h>

@interface OurUtilities : NSObject

// ios version. "4.3.5"
+ (NSArray *)iosVersion;
+ (NSUInteger)iosSubVerion:(NSUInteger)index;

// no "/".
+ (NSString *)resouceDir;

// no "/".
+ (NSString *)docDir;

// no "/".
+ (NSString *)cacheDir;

// no "/".
+ (NSString *)libDir;

// includes "/".
+ (NSString *)tmpDir;

+ (NSString *)trimString:(NSString *)str;
+ (NSString *)safeString:(NSString *)str;

+ (NSString *)currentLanguage;

+ (NSString *)getBundleId;
+ (NSString *)getBundleName;
+ (NSString *)getBundleDisplayName;
+ (NSString *)getBundleVersion;

+ (BOOL)openUrlString:(NSString *)url;
+ (BOOL)openUrl:(NSURL *)url;
+ (BOOL)appStoreWithArtistUrl:(NSString *)artistUrl;
+ (BOOL)appStoreWithAppId:(NSString *)appId;
+ (void)gotoReviews:(NSString *)appId;
+ (BOOL)openAppWithAppId:(NSString *)appId urlScheme:(NSString *)urlScheme;

+ (NSInteger)random:(NSInteger)min max:(NSInteger)max;
+ (NSArray *)randomArray:(NSInteger)min max:(NSInteger)max count:(NSUInteger)count;
+ (NSUInteger)randomIndexWithPercent:(NSArray *)arrPercent;

+ (BOOL)isDeviceIpad;
+ (BOOL)isDeviceIpad3;
+ (BOOL)isDeviceIphone;
+ (BOOL)isDeviceIphone3;
+ (BOOL)isDeviceIphone4;
+ (BOOL)isDeviceIphone5;
+ (BOOL)isDeviceIphone6;
+ (BOOL)isDeviceIphone6Plus;
+ (BOOL)isIosSimulator;

+ (NSString *)changeExtensionWithFilepath:(NSString *)filepath extension:(NSString *)extension;
+ (CGFloat) safeParseFloat:(NSString *)string;
@end
