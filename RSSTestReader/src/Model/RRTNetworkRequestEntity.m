//
//  RRTNetworkRequestEntity.m
//  RSSTestReader
//
//  Created by Yuto on 2018/07/28.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import "RRTNetworkRequestEntity.h"
#import <AFNetworking/AFNetworking.h>

@implementation RRTNetworkRequestEntity

- (NSString *)description {
    return [NSString stringWithFormat:@"%@, url : %@, parameter : %@, requestSerializer : %@, responseSerializer : %@",
            [super description],
            [self.url description],
            [self.parameters description],
            [self.requestSerializer description],
            [self.responseSerializer description]];
}

+ (instancetype)request:(NSURL *)url {
    return [[[self class] alloc] init:url];
}

- (instancetype)init:(NSURL *)url {
    if (self = [super init]) {
        _url = url;
        _requestSerializer = [AFHTTPRequestSerializer serializer];
        _responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

- (BOOL)canRequest {
    BOOL ret = NO;
    if (self.url && [self.url.absoluteString hasPrefix:@"http"]) {
        ret = YES;
    }
    return ret;
}

- (void)GET:(onSuccessBlock)success failed:(onFailedBlock)failed {
    RRTNetworkController *controller = [RRTNetworkController sharedController];
    [controller request:self
                success:^(RRTNetworkResponseEntity *entity) {
                    if (success) {
                        success(entity);
                    }
                } failed:^(RRTNetworkErrorEntity *entity) {
                    if (failed) {
                        failed(entity);
                    }
                }];
}

- (id)responseParse:(id)base {
    return base;
}

@end
