//
//  RRTNetworkController.h
//  RSSTestReader
//
//  Created by Yuto on 2018/07/28.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRTNetworkResponseEntity.h"
#import "RRTNetworkErrorEntity.h"

@interface RRTNetworkController : NSObject

typedef void(^onSuccessBlock)(RRTNetworkResponseEntity *entity);
typedef void(^onFailedBlock)(RRTNetworkErrorEntity *entity);

+ (instancetype)sharedController;

- (void) request:(RRTNetworkRequestEntity *)request
         success:(onSuccessBlock)success
          failed:(onFailedBlock)failed;

@end
