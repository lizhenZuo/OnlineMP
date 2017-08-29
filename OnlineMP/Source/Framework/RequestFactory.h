//
//  Resquest.h
//  HiPandaParent
//
//  Created by MAC20151009A on 16/8/10.
//  Copyright © 2016年 HiPandaParent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OurRequestManager.h"

@interface RequestFactory : NSObject

+ (OurResRequest *)createRequest;

@end
