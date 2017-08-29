//
//  NetResCacheHelper.m
//  HiPandaParent
//
//  Created by MAC20150506A on 15/6/8.
//  Copyright (c) 2015年 com.toycloud. All rights reserved.
//

#import "OurCacheManager.h"
#import "CommonCrypto/CommonDigest.h"

// ------------------------------------
/*
 策略描述：
 1. 先计算出一个几乎唯一的文件名：hash_name = md5(key) + sha1(key);
 2. 数据文件名：hash_name.dat
 3. 配置文件名：hash_name.cfg
 4. 配置文件内容：保存了一个json：
 {
 "key":"xxx",   // key，对比时注意转义。
 "modify_timestamp":123456,    // 更新时间戳
 "expired_timestamp":123456,   // 超时时间戳
 }
 5. 万一遇到 hash_name 文件名重复，但是 "key" != cfg中的"key"，此时就相当于cache失效了。
 */
// ------------------------------------

#define SHAL_LONG (8)
#define MD5_AND_SHAL_LONG (CC_MD5_DIGEST_LENGTH * (2) + SHAL_LONG)
#define MODIFY_TIMESTAMP  @"modify_timestamp"
#define EXPIRED_TIMESTAMP @"expired_timestamp"
#define KEY @"key"
#define CONFIG_FILE (@".cfg")
#define DATA_FILE (@".dat")

@interface OurCacheManager()

@property (strong, nonatomic) NSString *cacheFullPath;

@end

// ------------------------------------

@implementation OurCacheManager

- (instancetype)initWithCachePath:(NSString *)path
{
    self = [super init];
    if (self == nil)
    {
        return nil;
    }
    
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheFullPath = [[cachePaths objectAtIndex:0] stringByAppendingPathComponent:path];
    self.cacheFullPath = cacheFullPath;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cacheFullPath])
    {
         [fileManager createDirectoryAtPath:cacheFullPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [self clearAllExpiredCache];
    return self;
}

- (BOOL)isCached:(NSString *)key expired:(NSTimeInterval)seconds
{
    NSData *data = [self getCacheData:key expired:seconds];
    return (data != nil);
}

- (NSData *)getCacheData:(NSString *)key expired:(NSTimeInterval)seconds
{
    NSString *configFileName = [self getConfigFileNameWithKey:key];
    NSString *dataFileName = [self getDataFileNameWithKey:key];
    NSString *configFilePath = [self.cacheFullPath stringByAppendingPathComponent:configFileName];
    NSString *dataFilePath = [self.cacheFullPath stringByAppendingPathComponent:dataFileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:configFilePath])
    {
        NSData *configData = [fileManager contentsAtPath:configFilePath];
        if (configData)
        {
            NSDictionary *configDictionary = [NSJSONSerialization JSONObjectWithData:configData options:NSJSONReadingAllowFragments error:nil];
            NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
            NSTimeInterval modify_timestamp = [[configDictionary objectForKey:MODIFY_TIMESTAMP] integerValue];
            // 防止系统时间异常
            if (modify_timestamp > nowTime)
            {
                return nil;
            }
            if (modify_timestamp + seconds >= nowTime)
            {
                return [fileManager contentsAtPath:dataFilePath];
            }
        }
    }
    return nil;
}

- (BOOL)setCacheData:(NSString *)key data:(NSData *)data expired:(NSTimeInterval)seconds
{
    NSString *dataFileName = [self getDataFileNameWithKey:key];
    NSString *configFileName = [self getConfigFileNameWithKey:key];
    NSString *configFilePath = [self.cacheFullPath stringByAppendingPathComponent:configFileName];
    NSString *dataFilePath = [self.cacheFullPath stringByAppendingPathComponent:dataFileName];
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    NSMutableDictionary *configDictionary = [[NSMutableDictionary alloc] init];
    [configDictionary setValue:key forKey:KEY];
    [configDictionary setValue:[NSNumber numberWithInteger:nowTime] forKey:MODIFY_TIMESTAMP];
    [configDictionary setValue:[NSNumber numberWithInteger:seconds] forKey:EXPIRED_TIMESTAMP];
    NSError *error = nil;
    NSData *configData = [NSJSONSerialization dataWithJSONObject:configDictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isSuccessOfDataFile= [fileManager createFileAtPath:dataFilePath contents:data attributes:nil];
    BOOL isSuccessOfConfigFile = [fileManager createFileAtPath:configFilePath contents:configData attributes:nil];
    if(isSuccessOfDataFile && isSuccessOfConfigFile)
    {
        return YES;
    }
    return NO;
}

- (void)clearCache:(NSString *)key
{
    NSString *configFileName = [self getConfigFileNameWithKey:key];
    NSString *dataFileName = [self getDataFileNameWithKey:key];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileArray = [fileManager subpathsAtPath:self.cacheFullPath];
    for (NSString *fileName in fileArray)
    {
        if ([fileName isEqualToString:configFileName] || [fileName isEqualToString:dataFileName])
        {
            NSString *filePath = [self.cacheFullPath stringByAppendingPathComponent:fileName];
            NSError *error = nil;
            [fileManager removeItemAtPath:filePath error:&error];
            if (error == nil)
            {
            }
            else
            {
            }

        }
    }
}

- (void)clearAllExpiredCache
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *arrayFilesName = [fileManager subpathsAtPath:self.cacheFullPath];
    NSMutableArray *arrayFilesShouldDelete = [[NSMutableArray alloc] init];
    for (NSString *fileName in arrayFilesName)
    {
        if(fileName.length > MD5_AND_SHAL_LONG)
        {
            if (! [[fileName substringFromIndex:MD5_AND_SHAL_LONG] isEqualToString:CONFIG_FILE])
            {
                continue;
            }
            NSString *configFileFullPath = [self.cacheFullPath stringByAppendingPathComponent:fileName];
            NSData *readData = [fileManager contentsAtPath:configFileFullPath];
            if (readData)
            {
                NSMutableDictionary *configDictionary = [[NSMutableDictionary alloc] init];
                configDictionary = [NSJSONSerialization JSONObjectWithData:readData options:NSJSONReadingAllowFragments error:nil];
                NSTimeInterval modifyTime = [[configDictionary objectForKey:MODIFY_TIMESTAMP] integerValue];
                NSTimeInterval expireTime = [[configDictionary objectForKey:EXPIRED_TIMESTAMP] integerValue];
                
                NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
                if (modifyTime + expireTime >= nowTime)
                {
                    continue;
                }
                else
                {
                    [arrayFilesShouldDelete addObject:fileName];
                    [arrayFilesShouldDelete addObject:[[fileName substringToIndex:MD5_AND_SHAL_LONG] stringByAppendingString:DATA_FILE]];
                }
            }
        }
    }
    for(NSString *fileName in arrayFilesShouldDelete)
    {
        NSString *filePath = [self.cacheFullPath stringByAppendingPathComponent:fileName];
        NSError *error = nil;
        [fileManager removeItemAtPath:filePath error:&error];
        if (error == nil)
        {
           
        }
        else
        {
           
        }
    }
    
}

- (void)clearAllCache
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *allFileNames = [fileManager subpathsAtPath:self.cacheFullPath];
    for (NSString *fileName in allFileNames)
    {
        NSString *path = [self.cacheFullPath stringByAppendingPathComponent:fileName];
        NSError *error = nil;
        [fileManager removeItemAtPath:path error:&error];
        if (error == nil)
        {
           
        }
        else
        {
           
        }

    }
}

#pragma mark private methods
-(NSString *)getDataFileNameWithKey:(NSString *)key
{
    NSString *resultWithMD5 = [self get_md5_string:key];
    NSString *resultWithSHA = [self get_sha1_string:key];
    if(!resultWithMD5 && !resultWithSHA)
    {
        return nil;
    }
    NSString *dataFileName = [NSString stringWithFormat:@"%@%@%@", resultWithMD5, resultWithSHA,DATA_FILE];
    return dataFileName;

}
-(NSString *)getConfigFileNameWithKey:(NSString *)key
{
    NSString *resultWithMD5 = [self get_md5_string:key];
    NSString *resultWithSHA = [self get_sha1_string:key];
    if(!resultWithMD5 && !resultWithSHA)
    {
        return nil;
    }
    NSString *configFileName = [NSString stringWithFormat:@"%@%@%@", resultWithMD5, resultWithSHA,CONFIG_FILE];
    return configFileName;

}
-(NSString *)get_md5_string:(NSString *)string
{
    const char *cStr = [string UTF8String];
    if (cStr == NULL)
    {
        return nil;
    }
    if(!strlen(cStr))
    {
        return nil;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result= [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
 
}
-(NSString *)get_sha1_string:(NSString *)string
{
    const char *cStr = [string UTF8String];
    if (cStr == NULL)
    {
        return nil;
    }
    if(!strlen(cStr))
    {
        return nil;
    }
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}
@end


