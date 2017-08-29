//
//  NetResCacheHelper.h
//  HiPandaParent
//
//  Created by MAC20150506A on 15/6/8.
//  Copyright (c) 2015年 com.toycloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OurCacheManager : NSObject

// 初始化时会清除全部超时的 cache。
- (instancetype)initWithCachePath:(NSString *)path;

// 是否命中有效期内的 cache？
- (BOOL)isCached:(NSString *)key expired:(NSTimeInterval)seconds;

// 获取有效期内的 cache。
// 如果获取不到，返回 nil。
- (NSData *)getCacheData:(NSString *)key expired:(NSTimeInterval)seconds;

// 设置 cache。
- (BOOL)setCacheData:(NSString *)key data:(NSData *)data expired:(NSTimeInterval)seconds;

// 删除 cache。
- (void)clearCache:(NSString *)key;

// 删除全部失效的 cache。
- (void)clearAllExpiredCache;

// 删除全部 cache。
- (void)clearAllCache;

@end
