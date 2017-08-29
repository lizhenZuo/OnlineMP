//
//  ConstError.h
//  Credit
//
//  Created by dfcy on 2017/8/18.
//  Copyright © 2017年 zorro.zuo. All rights reserved.
//

#import <Foundation/Foundation.h>

/* 错误码专区 */
// ------------------------------------------------------------------------
// 自定义错误码
// ------------------------------------------------------------------------
// 默认值
#define ERROR_CUSTOM_DEFALUT (NSIntegerMax)
// 网络请求失败
#define ERROR_CUSTOM_NETWORK (-90000)
// 网络请求超时
#define ERROR_CUSTOM_NETWORK_TIME_OUT (-90001)
// 网络请求返回值解析出错
#define ERROR_CUSTOM_JSON (-90002)
// MSC库错误（除请求失败和超时外的所有错误）
#define ERROR_CUSTOM_MSC (-90003)
// 配置设备WiFi的Socket过程出错或超时
#define ERROR_CUSTOM_WIFI (-90004)
// 喜马拉雅错误
#define ERROR_CUSTOM_XMLY (-90005)

#define ERROR_CUSTOM_NICKNAME_EMPTY (-91000)
#define ERROR_CUSTOM_NICKNAME_FORMAT (-91001)
#define ERROR_CUSTOM_PHONE_EMPTY (-91002)
#define ERROR_CUSTOM_PHONE_FORMAT (-91003)
#define ERROR_CUSTOM_MOBILE_CODE_EMPTY (-91004)
#define ERROR_CUSTOM_MOBILE_CODE_FORMAT (-91005)
#define ERROR_CUSTOM_PASSWORD_EMPTY (-91006)
#define ERROR_CUSTOM_POSTSCRIPT_FORMAT (-91007)
#define ERROR_CUSTOM_DEVICE_ID_EMPTY (-91008)
#define ERROR_CUSTOM_DEVICE_ID_FORMAT (-91009)
#define ERROR_CUSTOM_FEEDBACK_EMPTY (-91010)
#define ERROR_CUSTOM_FEEDBACK_FORMAT (-91011)
#define ERROR_CUSTOM_MEDIA_CONTENT_EMPTY (-91012)
#define ERROR_CUSTOM_MEDIA_CONTENT_FORMAT (-91013)
#define ERROR_CUSTOM_SEND_TEXT_EMPTY (-91014)
#define ERROR_CUSTOM_SEND_TEXT_FORMAT (-91015)
#define ERROR_CUSTOM_CONTENT_EMPTY (-91016)
#define ERROR_CUSTOM_CONTENT_FORMAT (-91017)

@interface ConstError : NSObject

@end
