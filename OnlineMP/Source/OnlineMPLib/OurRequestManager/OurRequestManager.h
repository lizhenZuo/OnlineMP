//
//  ResManager
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
    ResRequestState_Ready = 0,
    ResRequestState_Getting,
    ResRequestState_Success,
    ResRequestState_Fail,
    ResRequestState_TimeOut,
}ResRequestState;

typedef enum
{
    ResRequestMethod_Get = 0,
    ResRequestMethod_Post,
    ResRequestMethod_PostByJson,
}ResRequestMethod;

typedef void (^OurResRequestHandleBlock)(void);
typedef NSString* (^OurResRequestKeyFunction)(void);

// ------------------------------------

@interface OurResRequest : NSObject

- (BOOL)isGettingFinished;

// 请求的状态
@property (assign, nonatomic) ResRequestState state;

// 完成码
@property (assign, nonatomic) NSInteger finishCode;

// 请求URL
@property (strong, nonatomic) NSURL *requestUrl;

// 请求 header
@property (strong, nonatomic) NSDictionary *requestHeaders;

// 请求参数
@property (strong, nonatomic) NSDictionary *requestParams;

// 请求方法
@property (assign, nonatomic) ResRequestMethod requetMethod;

// 请求超时时间，单位秒，默认值:35秒。
@property (assign, nonatomic) CGFloat requetTimeout;

// 多少时间缓存失效，单位秒。
@property (assign, nonatomic) CGFloat requestCacheExpiredTimeout;

// 可接受多少时间内的缓存，单位秒。<=0，表示需要重新获取。默认值:0秒。
@property (assign, nonatomic) CGFloat requestCacheTimeout;

// 获取到的原始数据。
@property (strong, nonatomic) NSData *respData;

// 不需要在controller层保存的临时数据
@property (strong, nonatomic) NSDictionary *respMap;

// respData是否是从缓存中获取的
@property (assign, nonatomic) BOOL isRespDataFromCache;

// 这个回调用来生成请求的key和缓存数据的key，根据不同的项目可以用不同的方法来生成
// 写一个子类来继承这个类，在子类中生成这个key
@property (strong, nonatomic) OurResRequestKeyFunction userRequestKeyFunction;


// 每次请求的状态改变时调
- (void)pushStateChangedBlock:(OurResRequestHandleBlock)block;
- (NSMutableArray *)getStateChangedBlockList;
- (NSString *)resquestKey;

@end


@interface OurRequestManager : NSObject
- (void)request:(OurResRequest *)rr;
// 清除某个请求的缓存
- (void)clearCacheForRequest:(OurResRequest *)rr;
@end

