//
//  RRTNetworkErrorEntity.h
//  RSSTestReader
//
//  Created by Yuto on 2018/07/28.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RRTNetworkRequestEntity;

@interface RRTNetworkErrorEntity : NSObject

@property NSURL *url;
@property NSURLResponse *response;
@property NSError *error;

+ (instancetype)errorCannotExecuteRequest:(NSURL *)url;
+ (instancetype) error:(RRTNetworkRequestEntity *)request response:(NSURLResponse *)response error:(NSError *)error;

@end
