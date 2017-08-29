//
//  OurUIUtilities.m
//  RainbowBook
//
//  Created by x on 12-12-11.
//  Copyright (c) 2012年 x. All rights reserved.
//

#import "OurUIUtilities.h"
#import "OurUtilities.h"

// ------------------------------------

CGRect OurUIRectOffset(CGFloat x, CGFloat y, CGFloat w, CGFloat h, CGRect rectOffset)
{
    return CGRectMake(x + rectOffset.origin.x, y + rectOffset.origin.y, w, h);
}

CGFloat OurUIRectXRight(CGRect rect)
{
    return rect.origin.x + rect.size.width;
}

CGFloat OurUIRectYBottom(CGRect rect)
{
    return rect.origin.y + rect.size.height;
}

// ------------------------------------

@implementation OurUIUtilities


+ (UIStoryboard *)getCurrentStoryboard
{
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"HealthScale_Iphone4" bundle:nil];
//    if ([OurUtilities isDeviceIphone5])
//    {
//        storyboard = [UIStoryboard storyboardWithName:@"HealthScale_Iphone5" bundle:nil];
//    }
    return storyboard;
}

+ (NSString *)resourcePath:(NSString *)path
{
    NSString *suffix_iphone = @"iphone";
    NSString *suffix_iphone5 = @"iphone5";
    NSString *suffix_ipad = @"ipad";
    
    // prepare new path
    NSString *pathExt = [path pathExtension];
    if (pathExt == nil || pathExt.length == 0)
    {
        return path;
    }
    NSString *pathWithoutExt = [path stringByDeletingPathExtension];

    // device array
    NSMutableArray *arrayDevice = [NSMutableArray array];
    if ([OurUtilities isDeviceIpad])
    {
        // ipad
        [arrayDevice addObject:suffix_ipad];
    }
    else
    {
        // iphone
        if ([OurUtilities isDeviceIphone5])
        {
            [arrayDevice addObject:suffix_iphone5];
        }
        [arrayDevice addObject:suffix_iphone];
    }
    
    // lang
    NSString *curLang = [OurUtilities currentLanguage];
    
    // "path + device + lang"
    // iphone3 = path-iphone-lang, path-iphone-lang@2x
    // iphone4 = path-iphone-lang@2x, path-iphone-lang
    // iphone5 = path-iphone5-lang@2x, path-iphone-lang@2x, path-iphone-lang
    // ipad = path-ipad-lang, path-ipad-lang@2x
    // ipad3 = path-ipad-lang@2x, path-ipad-lang
    for (NSString *device in arrayDevice)
    {
        NSString *newPath = [NSString stringWithFormat:@"%@-%@-%@.%@", pathWithoutExt, device, curLang, pathExt];
        NSString *newPath2x = [NSString stringWithFormat:@"%@-%@-%@@2x.%@", pathWithoutExt, device, curLang, pathExt];
        NSString *newFullPath = [NSString stringWithFormat:@"%@/%@", [OurUtilities resouceDir], newPath];
        NSString *newFullPath2x = [NSString stringWithFormat:@"%@/%@", [OurUtilities resouceDir], newPath2x];
        if ([[NSFileManager defaultManager] fileExistsAtPath:newFullPath] || [[NSFileManager defaultManager] fileExistsAtPath:newFullPath2x])
        {
            return newPath;
        }
    }
    
    // "path + device"
    // iphone3 = path-iphone, path-iphone@2x
    // iphone4 = path-iphone@2x, path-iphone
    // iphone5 = path-iphone5@2x, path-iphone@2x, path-iphone
    // ipad = path-ipad, path-ipad@2x
    // ipad3 = path-ipad@2x, path-ipad
    for (NSString *device in arrayDevice)
    {
        NSString *newPath = [NSString stringWithFormat:@"%@-%@.%@", pathWithoutExt, device, pathExt];
        NSString *newPath2x = [NSString stringWithFormat:@"%@-%@@2x.%@", pathWithoutExt, device, pathExt];
        NSString *newFullPath = [NSString stringWithFormat:@"%@/%@", [OurUtilities resouceDir], newPath];
        NSString *newFullPath2x = [NSString stringWithFormat:@"%@/%@", [OurUtilities resouceDir], newPath2x];
        if ([[NSFileManager defaultManager] fileExistsAtPath:newFullPath] || [[NSFileManager defaultManager] fileExistsAtPath:newFullPath2x])
        {
            return newPath;
        }
    }
    
    // "path + lang"
    // iphone3 = path-lang, path-lang@2x
    // iphone4 = path-lang@2x, path-lang
    // iphone5 = path-lang@2x, path-lang
    // ipad = path-lang@2x
    // ipad3 = path-lang@2x
    {
        NSString *newPath = [NSString stringWithFormat:@"%@-%@.%@", pathWithoutExt, curLang, pathExt];
        NSString *newPath2x = [NSString stringWithFormat:@"%@-%@@2x.%@", pathWithoutExt, curLang, pathExt];
        NSString *newFullPath = [NSString stringWithFormat:@"%@/%@", [OurUtilities resouceDir], newPath];
        NSString *newFullPath2x = [NSString stringWithFormat:@"%@/%@", [OurUtilities resouceDir], newPath2x];
        
        if ([OurUtilities isDeviceIpad] && [[NSFileManager defaultManager] fileExistsAtPath:newFullPath2x])
        {
            return newPath2x;
        }

        if ([[NSFileManager defaultManager] fileExistsAtPath:newFullPath] || [[NSFileManager defaultManager] fileExistsAtPath:newFullPath2x])
        {
            return newPath;
        }
    }

    // "path"
    // iphone3 = path, path@2x
    // iphone4 = path@2x, path
    // iphone5 = path@2x, path
    // ipad = path@2x
    // ipad3 = path@2x
    {
        NSString *newPath = [NSString stringWithFormat:@"%@.%@", pathWithoutExt, pathExt];
        NSString *newPath2x = [NSString stringWithFormat:@"%@@2x.%@", pathWithoutExt, pathExt];
        NSString *newFullPath = [NSString stringWithFormat:@"%@/%@", [OurUtilities resouceDir], newPath];
        NSString *newFullPath2x = [NSString stringWithFormat:@"%@/%@", [OurUtilities resouceDir], newPath2x];

        if ([OurUtilities isDeviceIpad] && [[NSFileManager defaultManager] fileExistsAtPath:newFullPath2x])
        {
            return newPath2x;
        }
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:newFullPath] || [[NSFileManager defaultManager] fileExistsAtPath:newFullPath2x])
        {
            return newPath;
        }
    }
    
    // all others = path
    return path;
}

+ (CGFloat)resourceValue:(CGFloat)value;
{
    return ([OurUtilities isDeviceIpad])? value * 2.0: value;
}

+ (UIColor *)color:(NSUInteger)rgb alpha:(CGFloat)a
{
    if (rgb > 0xffffff || a < 0 || a > 1)
    {
        return [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }
    
    return [UIColor colorWithRed:((CGFloat)((rgb & 0xff0000) >> 16) / 256.0) green:((CGFloat)((rgb & 0xff00) >> 8) / 256.0) blue:((CGFloat)(rgb & 0xff) / 256.0) alpha:a];
}

+ (UIImage *)imageWithColor:(UIColor *)color Size:(CGSize)size
{
    CGSize imageSize = size;
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return pressedColorImg;
}

+ (UIImage *)resourceImage:(NSString *)image
{
    return [UIImage imageNamed:[OurUIUtilities resourcePath:image]];
}

+ (UIImage *)getLaunchImage
{
    NSString *launchImageName = nil;
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = @"Portrait";
    NSArray *imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dic in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dic[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dic[@"UILaunchImageOrientation"]])
        {
            launchImageName = dic[@"UILaunchImageName"];
            break;
        }
    }
    return [UIImage imageNamed:launchImageName];
}

@end
