//
//  OurResourceManager.m
//  BabyWatch
//
//  Created by MAC20151009A on 16/8/9.
//  Copyright © 2016年 toycloud. All rights reserved.
//
//
//  ResManager
//

#import "OurRequestManager.h"
#import "AFNetworking.h"
#import "OurCacheManager.h"
#import "EXTScope.h"

#define APP_CONST_CACHE_DIR (@"url_cache")
#define ERROR_REQUESET_TIMEOUT (14)
#define ERROR_NETWORK       (12)
// ------------------------------------
@interface OurResRequest()
@property (strong, nonatomic) NSMutableArray *arrayHandleBlocks;
@end

@implementation OurResRequest

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.arrayHandleBlocks = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (NSString *)resquestKey
{
    if (self.userRequestKeyFunction != nil)
    {
        return self.userRequestKeyFunction();
    }
    // use default key.
    NSString *url = self.requestUrl.absoluteString;
    NSString *jsonString = @"";
    if (self.requestParams != nil)
    {
        jsonString = [self dicToJsonString:self.requestParams];
    }
    return [url stringByAppendingString:jsonString];
}

- (BOOL) isGettingFinished
{
    BOOL isFinished = YES;
    if (self.state == ResRequestState_Fail || self.state == ResRequestState_TimeOut || self.state == ResRequestState_Success)
    {
        isFinished = YES;
    }
    else if (self.state == ResRequestState_Ready || self.state == ResRequestState_Getting)
    {

        isFinished = NO;
    }
    return isFinished;
}
- (void)pushStateChangedBlock:(OurResRequestHandleBlock)block
{
    [self.arrayHandleBlocks insertObject:block atIndex:0];
}

- (NSMutableArray *)getStateChangedBlockList
{
    return self.arrayHandleBlocks;
}

#pragma mark private methods

-(NSString*)dicToJsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (!jsonData)
    {
        jsonString = @"";
    }
    else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}



@end

// ------------------------------------

@interface OurRequestManager()

@property (strong, nonatomic) OurCacheManager *cacheManager;
@property (strong, nonatomic) NSMutableArray *arrayResRequest;

@end

@implementation OurRequestManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.cacheManager = [[OurCacheManager alloc] initWithCachePath:APP_CONST_CACHE_DIR];
        self.arrayResRequest = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)request:(OurResRequest *)rr
{
    [rr resquestKey];
    [self.arrayResRequest addObject:rr];
    
    rr.state = ResRequestState_Getting;
    [self handleBlocks:rr];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if (rr.requetMethod == ResRequestMethod_PostByJson)
    {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    manager.requestSerializer.timeoutInterval = rr.requetTimeout;
    
    for (NSString *key in rr.requestHeaders)
    {
        NSString *value = [rr.requestHeaders objectForKey:key];
        [manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
    NSLog(@"%@%@",rr.requestUrl.absoluteString,rr.requestParams);
    
    @weakify(self);
    id handleSuccess = ^(AFHTTPRequestOperation *operation, id responseObject)
    {
        @strongify(self);
        if (responseObject == nil)
        {
            rr.state = ResRequestState_Fail;
            [self handleSameRequest:rr];
            return;
        }
        
        NSData *respData = operation.responseData;
        NSString *cacheKey = [rr resquestKey];
        NSTimeInterval timeout = rr.requestCacheExpiredTimeout;
        [self.cacheManager setCacheData:cacheKey data:respData expired:timeout];
        
        rr.state = ResRequestState_Success;
        rr.respData = respData;
        [self handleSameRequest:rr];
        NSLog(@"response:%@",responseObject);
    };
    
    id handleFail = ^(AFHTTPRequestOperation *operation, NSError *error)
    {
        @strongify(self);
      
        if (error.code == NSURLErrorTimedOut)
        {
            rr.state = ResRequestState_TimeOut;
        }
        else
        {
            rr.state = ResRequestState_Fail;

        }
        [self handleSameRequest:rr];
        NSLog(@"error:%@",error);
    };
    
    NSString *cacheKey = [rr resquestKey];
    NSData *cacheData = [self.cacheManager getCacheData:cacheKey expired:rr.requestCacheTimeout];
    if (cacheData != nil)
    {
        rr.isRespDataFromCache = YES;
        rr.respData = cacheData;
        rr.state = ResRequestState_Success;
        [self handleSameRequest:rr];
    }
    else if (rr.requetMethod == ResRequestMethod_Get)
    {
        if (![self isAlreadyResquesting:rr])
        {
           [manager GET:rr.requestUrl.absoluteString parameters:rr.requestParams success:handleSuccess failure:handleFail];
        }
    }
    else if (rr.requetMethod == ResRequestMethod_Post || rr.requetMethod == ResRequestMethod_PostByJson)
    {
        if (![self isAlreadyResquesting:rr])
        {
             [manager POST:rr.requestUrl.absoluteString parameters:rr.requestParams success:handleSuccess failure:handleFail];
        }
    }
}

// 清除某个请求的缓存
- (void)clearCacheForRequest:(OurResRequest *)rr
{
    NSString *requestKey = [rr resquestKey];
    [self.cacheManager clearCache:requestKey];
}

// 判断是否有相同的请求已发出
- (BOOL)isAlreadyResquesting:(OurResRequest *)rr
{
    NSInteger count = 0;
    for (int i = 0; i < self.arrayResRequest.count; i++)
    {
        OurResRequest *ourRR = [self.arrayResRequest objectAtIndex:i];
        if ([[rr resquestKey] isEqualToString:[ourRR resquestKey]])
        {
            count ++;
            if (count > 1)
            {
                return YES;
            }
        }
    }
    return NO;
}

// 把返回的请求的数据赋值给队列中所有相同的请求
- (void)handleSameRequest:(OurResRequest *)rr
{
    NSMutableArray *arrayResquestShouldRemove = [[NSMutableArray alloc] init];
    for (OurResRequest *ourRR in self.arrayResRequest)
    {
        if ([[ourRR resquestKey] isEqualToString:[rr resquestKey]])
        {
            ourRR.respData = rr.respData;
            ourRR.state = rr.state;
            ourRR.isRespDataFromCache = rr.isRespDataFromCache;
            ourRR.finishCode = rr.finishCode;
            //handleSameRequest 函数执行完毕再执行handleBlocks， 先移除相同的请求，在执行block
            [self performSelector:@selector(handleBlocks:) withObject:ourRR afterDelay:0];
            [arrayResquestShouldRemove addObject:ourRR];
        }
    }
    for (OurResRequest *ourRR in arrayResquestShouldRemove)
    {
        [self.arrayResRequest removeObject:ourRR];
    }
}

// 执行block数组
- (void)handleBlocks:(OurResRequest *)rr
{
    for (OurResRequestHandleBlock handleBlock in rr.arrayHandleBlocks)
    {
        handleBlock();
    }
}
@end

