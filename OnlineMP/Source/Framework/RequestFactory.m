//
//  Resquest.m
//  HiPandaParent
//
//  Created by MAC20151009A on 16/8/10.
//  Copyright © 2016年 HiPandaParent. All rights reserved.
//

#import "RequestFactory.h"
#import "ControllerConst.h"
#import "ConstError.h"
#import "OurUtilities.h"
#import "LocalUtilties.h"
#import "ControllerManager.h"
#define USER_TOKEN_SEED (@"fvKs2s93SA0di1AaK")

@implementation RequestFactory

+ (OurResRequest *)createRequest
{
    OurResRequest *request = [[OurResRequest alloc] init];
    request.state = ResRequestState_Ready;
    request.requetMethod = ResRequestMethod_Get;
    request.requetTimeout = APP_CONST_NETWORK_TIMEOUT;
    request.requestCacheExpiredTimeout = APP_CONST_CACHE_TIMEOUT_MAX;
    request.requestCacheTimeout = APP_CONST_NETWORK_CACHE_TIMEOUT_DEFAULT;
    request.requestParams = [[NSDictionary alloc] init];
    request.finishCode = ERROR_CUSTOM_DEFALUT;
    request.respMap = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    {
//        NSString *deviceType = [[[ControllerManager getInstance] getShareController] getDeviceType];
//        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
//        NSString *productType = [[[ControllerManager getInstance] getShareController] getProductType];
//        NSString *hashToken = @"";
//        NSString *token = [[ControllerManager getInstance] getUserController].userInfo.token;
        
//        if (token != nil && ![token isEqualToString:@""])
//        {
//             hashToken = [LocalUtilties sha1CodeWith:token passwordSeed:USER_TOKEN_SEED];
//        }
//        [headers setValue:productType forKey:APP_CONST_HEADER_KEY_OF_PRODUCT_TYPE];
//        [headers setValue:deviceType forKey:APP_CONST_HEADER_KEY_OF_DEVICE_TYPE];
//        [headers setValue:version forKey:APP_CONST_HEADER_KEY_OF_VERSION];
//        [headers setValue:hashToken forKey:APP_CONST_HEADER_KEY_OF_HASH_TOKEN];
    }
    request.requestHeaders = headers;
    @weakify(request);
    request.userRequestKeyFunction = ^(){
        @strongify(request);
//        NSString *userId = [[ControllerManager getInstance] getUserController].userInfo.uid;
        NSString *url = [request.requestUrl absoluteString];
        NSString *jsonString = [LocalUtilties dicToJsonString:request.requestParams];
        NSString *key = [url stringByAppendingString:(jsonString == nil) ? @"" : jsonString];
        return key;
    };
    return request;
}

@end
