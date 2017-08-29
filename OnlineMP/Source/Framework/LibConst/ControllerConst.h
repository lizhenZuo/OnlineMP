//
//  ControllerConst.h
//  Credit
//
//  Created by dfcy on 2017/8/18.
//  Copyright © 2017年 zorro.zuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXTScope.h"

/* controller 层的各种配置信息 */
// http 超时
#define APP_CONST_NETWORK_TIMEOUT (15.0f)

// http 文件超时
#define APP_CONST_NETWORK_FILE_TIMEOUT (45.0f)

// http cache 超时默认值
#define APP_CONST_NETWORK_CACHE_TIMEOUT_DEFAULT (0.0f)

// 所有的 GET 请求结果最长有效期不超过 cache 一个月。
// 在获取操作时，还会根据业务需求决定要返回多久时间内的 cache。
#define APP_CONST_CACHE_TIMEOUT_MAX (30 * 24 * 60 * 60)

@interface ControllerConst : NSObject

@end
