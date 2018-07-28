//
//  RRTNetworkResponseEntity.m
//  RSSTestReader
//
//  Created by Yuto on 2018/07/28.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import "RRTNetworkResponseEntity.h"
#import "RRTNetworkRSSRequestEntity.h"

@implementation RRTNetworkResponseEntity

- (NSString *)description {
    return [NSString stringWithFormat:@"%@, url : %@, response : %@, object : %@",
            [super description],
            [self.url description],
            [self.response description],
            [self.object description]];
}

+ (instancetype)response:(RRTNetworkRequestEntity *)request response:(NSURLResponse *)response object:(id)object {
    return [[[self class] alloc]init:request response:response object:object];
}

- (instancetype)init:(RRTNetworkRequestEntity *)request response:(NSURLResponse *)response object:(id)object {
    if (self = [super init]) {
        _url = request.url;
        _response = response;
        _object = [request responseParse:object];
    }
    return self;
}

@end
