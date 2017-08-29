//
//  OurJsonSafeGet.h
//  BabyWatch
//
//  Created by wx1 on 16/6/30.
//  Copyright © 2016年 toycloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DICT_GET_NSSTRING(_DICT, _KEY) [OurJsonSafeGet safeGetString:(_DICT) key:(_KEY)]
#define DICT_GET_NSDICTIONARY(_DICT, _KEY) [OurJsonSafeGet safeGetDictionary:(_DICT) key:(_KEY)]
#define DICT_GET_NSARRAY(_DICT, _KEY) [OurJsonSafeGet safeGetArray:(_DICT) key:(_KEY)]
#define DICT_GET_NSINTEGER(_DICT, _KEY) [OurJsonSafeGet safeGetInteger:(_DICT) key:(_KEY)]
#define DICT_GET_INT(_DICT, _KEY) [OurJsonSafeGet safeGetInt:(_DICT) key:(_KEY)]
#define DICT_GET_BOOL(_DICT, _KEY) [OurJsonSafeGet safeGetBOOL:(_DICT) key:(_KEY)]
#define DICT_GET_FLOAT(_DICT, _KEY) [OurJsonSafeGet safeGetFloat:(_DICT) key:(_KEY)]
#define DICT_GET_DOUBLE(_DICT, _KEY) [OurJsonSafeGet safeGetDouble:(_DICT) key:(_KEY)]
#define DICT_GET_LONG(_DICT, _KEY) [OurJsonSafeGet safeGetLong:(_DICT) key:(_KEY)]
#define DICT_GET_NSUINTEGER(_DICT, _KEY) [OurJsonSafeGet safeGetUInterger:(_DICT) key:(_KEY)]

// OurJsonSafeGet
@interface OurJsonSafeGet : NSObject
+ (NSString *)safeGetString:(NSDictionary *)jsonObject key:(NSString *)key;
+ (NSDictionary *)safeGetDictionary:(NSDictionary *)jsonObject key:(NSString *)key;
+ (NSArray *)safeGetArray:(NSDictionary *)jsonObject key:(NSString *)key;
+ (NSInteger)safeGetInteger:(NSDictionary *)jsonObject key:(NSString *)key;
+ (int)safeGetInt:(NSDictionary *)jsonObject key:(NSString *)key;
+ (BOOL)safeGetBOOL:(NSDictionary *)jsonObject key:(NSString *)key;
+ (float)safeGetFloat:(NSDictionary *)jsonObject key:(NSString *)key;
+ (double)safeGetDouble:(NSDictionary *)jsonObject key:(NSString *)key;
+ (long)safeGetLong:(NSDictionary *)jsonObject key:(NSString *)key;
+ (NSUInteger)safeGetUInterger:(NSDictionary *)jsonObject key:(NSString *)key;
@end

