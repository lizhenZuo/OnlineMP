//
//  OurUtilities.m
//  RainbowBook
//
//  Created by x on 12-12-10.
//  Copyright (c) 2012年 x. All rights reserved.
//

#import "OurUtilities.h"

@implementation OurUtilities

+ (NSArray *)iosVersion
{
    NSString *strVersion = [[UIDevice currentDevice] systemVersion];
    NSArray *arrayStrSubVersion = [strVersion componentsSeparatedByString:@"."];
    return arrayStrSubVersion;
}

+ (NSUInteger)iosSubVerion:(NSUInteger)index
{
    NSArray *arrVersions = [OurUtilities iosVersion];
    if (index >= arrVersions.count)
    {
        return 0;
    }
    NSUInteger subVersion = [[arrVersions objectAtIndex:index] integerValue];
    return subVersion;
}

+ (NSString *)resouceDir
{
    return [[NSBundle mainBundle] resourcePath];
}

+ (NSString *)docDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir = [paths objectAtIndex:0];
    return dir;
}

+ (NSString *)cacheDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *dir = [paths objectAtIndex:0];
    return dir;
}

+ (NSString *)libDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *dir = [paths objectAtIndex:0];
    return dir;
}

+ (NSString *)tmpDir
{
    NSString *dir = NSTemporaryDirectory();
    return dir;
}

+ (NSString *)trimString:(NSString *)str
{
    NSString *tStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return tStr;
}

+ (NSString *)safeString:(NSString *)str
{
    if (str == nil) {
        return @"";
    }
    return str;
}

+ (NSString *)currentLanguage
{
    NSString* strLanguage = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    return strLanguage;
}

+ (NSString *)getBundleId
{
    NSString *str = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey];
    return str;
}

+ (NSString *)getBundleName
{
    NSString *str = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
    return str;
}

+ (NSString *)getBundleDisplayName
{
    NSString *strLocal = NSLocalizedStringFromTable(@"CFBundleDisplayName", @"InfoPlist", nil);
    if (strLocal != nil && strLocal.length > 0 && NSOrderedSame != [strLocal compare:@"CFBundleDisplayName"])
    {
        return strLocal;
    }

    NSString *str = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    return str;
}

+ (NSString *)getBundleVersion
{
    NSString *str = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    return str;
}

+ (BOOL)openUrlString:(NSString *)url
{
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (BOOL)openUrl:(NSURL *)url
{
    return [[UIApplication sharedApplication] openURL:url];
}

+ (BOOL)appStoreWithArtistUrl:(NSString *)artistUrl
{
    NSString* urlPath = artistUrl;
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlPath]];
}

+ (BOOL)appStoreWithAppId:(NSString *)appId
{
    NSString* urlPath = [@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=" stringByAppendingString:appId];
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlPath]];
}

+ (void)gotoReviews:(NSString *)appId
{
//    NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appId];
    NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appId];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+ (BOOL)openAppWithAppId:(NSString *)appId urlScheme:(NSString *)urlScheme
{
    NSString *openUrlScheme = [NSString stringWithFormat:@"%@://", urlScheme];
    BOOL myAppInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:openUrlScheme]];
    if (myAppInstalled)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrlScheme]];
    }
    else
    {
        [self appStoreWithAppId:appId];
    }
    return YES;
}

+ (NSInteger)random:(NSInteger)min max:(NSInteger)max
{
    if (min < 0 || max > RAND_MAX || max < min) {
        return -1;
    }
    
    if (min == max) {
        return min;
    }
    
    NSInteger ret = (arc4random() % (max - min + 1)) + min;
    return ret;
}

+ (NSArray *)randomArray:(NSInteger)min max:(NSInteger)max count:(NSUInteger)count
{
    if (min < 0 || max > RAND_MAX || max < min || count > (max - min + 1)) {
        return nil;
    }
    
    NSMutableArray *arrRan = [NSMutableArray array];
    NSUInteger i = 0;
    while (i < count)
    {
        BOOL isValid = YES;
        NSInteger newRan = [self random:min max:max];
        for (NSUInteger j = 0; j < i; j++)
        {
            NSInteger oldRan = [(NSNumber *)[arrRan objectAtIndex:j] integerValue];
            if (newRan == oldRan)
            {
                isValid = NO;
                break;
            }
        }
        
        if (isValid)
        {
            NSNumber *num = [NSNumber numberWithInteger:newRan];
            [arrRan addObject:num];
            i ++;
        }
    }
    
    return arrRan;
}

+ (NSUInteger)randomIndexWithPercent:(NSArray *)arrPercent
{
    if (arrPercent == nil || arrPercent.count <= 1) {
        return 0;
    }
    
    NSUInteger total = 0;
    for (NSNumber *percent in arrPercent) {
        total += [percent integerValue];
    }
    
    NSUInteger ran = [self random:1 max:total];
    NSUInteger index = 0;
    NSUInteger tmpTotal = 0;
    for (NSNumber *percent in arrPercent) {
        tmpTotal += [percent integerValue];
        if (tmpTotal >= ran) {
            return index;
        }
        index ++;
    }
    return 0;
}

+ (BOOL)isDeviceIpad
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

+ (BOOL)isDeviceIpad3
{
    if (! [self isDeviceIpad])
    {
        return NO;
    }
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    return ((screenSize.width == 2048 && screenSize.height == 1536)
            || (screenSize.width == 1536 && screenSize.height == 2048));
}

+ (BOOL)isDeviceIphone
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

+ (BOOL)isDeviceIphone3
{
    if (! [self isDeviceIphone])
    {
        return NO;
    }
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    return (screenScale == 1
            && ((screenSize.width == 480 && screenSize.height == 320) || (screenSize.width == 320 && screenSize.height == 480)));
}

+ (BOOL)isDeviceIphone4
{
    if (! [self isDeviceIphone])
    {
        return NO;
    }
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    return (screenScale == 2
            && ((screenSize.width == 480 && screenSize.height == 320) || (screenSize.width == 320 && screenSize.height == 480)));
}

+ (BOOL)isDeviceIphone5
{
    if (! [self isDeviceIphone])
    {
        return NO;
    }
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    return ((screenSize.width == 568 && screenSize.height == 320) || (screenSize.width == 320 && screenSize.height == 568));
}

+ (BOOL)isDeviceIphone6
{
    if (! [self isDeviceIphone])
    {
        return NO;
    }
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    return ((screenSize.width == 667 && screenSize.height == 375) || (screenSize.width == 375 && screenSize.height == 667));
}

+ (BOOL)isDeviceIphone6Plus
{
    if (! [self isDeviceIphone])
    {
        return NO;
    }
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    return ((screenSize.width == 736 && screenSize.height == 414) || (screenSize.width == 414 && screenSize.height == 736));
}

+ (BOOL)isIosSimulator
{
#if (TARGET_IPHONE_SIMULATOR)
    return YES;
#else
    return NO;
#endif
}

+ (NSString *)changeExtensionWithFilepath:(NSString *)filepath extension:(NSString *)extension
{
    NSString *strExt = [filepath pathExtension];
    if (strExt == nil || strExt.length == 0)
    {
        return nil;
    }
    
    NSMutableString * strNewFilepath = [NSMutableString stringWithString:filepath];
    [strNewFilepath replaceOccurrencesOfString:strExt withString:extension options:NSBackwardsSearch range:NSMakeRange([strNewFilepath length] - [strExt length], [strExt length])];
    return strNewFilepath;
}

+ (CGFloat) safeParseFloat:(NSString *)string
{
   return  (CGFloat)[string floatValue];
}

@end
