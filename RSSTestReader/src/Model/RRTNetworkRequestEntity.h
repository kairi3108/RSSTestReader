//
//  RRTNetworkRequestEntity.h
//  RSSTestReader
//
//  Created by Yuto on 2018/07/28.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import "RRTNetworkController.h"

@protocol AFURLRequestSerialization;
@protocol AFURLResponseSerialization;

@interface RRTNetworkRequestEntity : NSObject

@property NSURL *url;
@property id parameters;
@property id<AFURLRequestSerialization> requestSerializer;       // AFHTTPRequestSerializer
@property id<AFURLResponseSerialization> responseSerializer;     // AFJSONResponseSerializer

+ (instancetype)request:(NSURL *)url;

- (instancetype)init:(NSURL *)url;
- (BOOL)canRequest;

- (void)GET:(onSuccessBlock)success failed:(onFailedBlock)failed;

- (id)responseParse:(id)base;

@end
