//
//  OurJsonSafeGet.m
//  BabyWatch
//
//  Created by wx1 on 16/6/30.
//  Copyright © 2016年 toycloud. All rights reserved.
//

#import "OurJsonSafeGet.h"

@implementation OurJsonSafeGet

+ (NSString *)safeGetString:(NSDictionary *)jsonObject key:(NSString *)key
{
    id value = [jsonObject valueForKey:key];
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [NSString stringWithFormat:@"%@", value];
    }
    else if ([value isKindOfClass:[NSString class]])
    {
        return value;
    }
    else
    {
        return nil;
    }
}
+ (NSDictionary *)safeGetDictionary:(NSDictionary *)jsonObject key:(NSString *)key
{
    id value = [jsonObject valueForKey:key];
    if ([value isKindOfClass:[NSDictionary class]])
    {
        return value;
    }
    else
    {
        return nil;
    }
}
+ (NSArray *)safeGetArray:(NSDictionary *)jsonObject key:(NSString *)key
{
    id value = [jsonObject valueForKey:key];
    if ([value isKindOfClass:[NSArray class]])
    {
        return value;
    }
    else
    {
        return nil;
    }
}
+ (NSInteger)safeGetInteger:(NSDictionary *)jsonObject key:(NSString *)key
{
    id value = [jsonObject valueForKey:key];
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value integerValue];
    }
    else if ([value isKindOfClass:[NSString class]])
    {
        return [value integerValue];
    }
    else
    {
        return 0;
    }
}
+ (int)safeGetInt:(NSDictionary *)jsonObject key:(NSString *)key
{
    id value = [jsonObject valueForKey:key];
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value intValue];
    }
    else if ([value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    else
    {
        return 0;
    }
}
+ (BOOL)safeGetBOOL:(NSDictionary *)jsonObject key:(NSString *)key
{
    id value = [jsonObject valueForKey:key];
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value boolValue];
    }
    else if ([value isKindOfClass:[NSString class]])
    {
        return [value boolValue];
    }
    else
    {
        return NO;
    }

}
+ (float)safeGetFloat:(NSDictionary *)jsonObject key:(NSString *)key
{
    id value = [jsonObject valueForKey:key];
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value floatValue];
    }
    else if ([value isKindOfClass:[NSString class]])
    {
        return [value floatValue];
    }
    else
    {
        return 0;
    }
}
+ (double)safeGetDouble:(NSDictionary *)jsonObject key:(NSString *)key
{
    id value = [jsonObject valueForKey:key];
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value doubleValue];
    }
    else if ([value isKindOfClass:[NSString class]])
    {
        return [value doubleValue];
    }
    else
    {
        return 0;
    }
}
+ (long)safeGetLong:(NSDictionary *)jsonObject key:(NSString *)key
{
    id value = [jsonObject valueForKey:key];
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value longValue];
    }
    else if ([value isKindOfClass:[NSString class]])
    {
        return [value longLongValue];
    }
    else
    {
        return 0;
    }
}
+ (NSUInteger)safeGetUInterger:(NSDictionary *)jsonObject key:(NSString *)key
{
    id value = [jsonObject valueForKey:key];
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value unsignedIntegerValue];
    }
    else if ([value isKindOfClass:[NSString class]])
    {
        return [value integerValue];
    }
    else
    {
        return 0;
    }
}

@end
