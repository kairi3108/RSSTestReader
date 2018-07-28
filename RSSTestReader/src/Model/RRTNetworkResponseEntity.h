//
//  RRTNetworkResponseEntity.h
//  RSSTestReader
//
//  Created by Yuto on 2018/07/28.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RRTNetworkRequestEntity;

@interface RRTNetworkResponseEntity : NSObject

@property NSURL *url;
@property NSURLResponse *response;
@property (nonatomic) id object;

+ (instancetype)response:(RRTNetworkRequestEntity *)request response:(NSURLResponse *)response object:(id)object;

@end
