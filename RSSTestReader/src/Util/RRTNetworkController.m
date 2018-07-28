//
//  RRTNetworkController.m
//  RSSTestReader
//
//  Created by Yuto on 2018/07/28.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import "RRTNetworkController.h"
#import <AFNetworking/AFNetworking.h>

@implementation RRTNetworkController

+ (instancetype)sharedController {
    static RRTNetworkController *sInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[RRTNetworkController alloc] init];
    });
    return sInstance;
}

- (void)request:(RRTNetworkRequestEntity *)request
        success:(onSuccessBlock)success
         failed:(onFailedBlock)failed {
    if (!request.canRequest) {
        if (failed != nil) {
            failed([RRTNetworkErrorEntity errorCannotExecuteRequest:request.url]);
        }
        return;
    }
    AFHTTPSessionManager *sessinManager = [AFHTTPSessionManager manager];
    sessinManager.requestSerializer = request.requestSerializer;
    sessinManager.responseSerializer = request.responseSerializer;
    [sessinManager GET:request.url.absoluteString
            parameters:request.parameters
              progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSURLResponse *urlResponse = task.response;
                   RRTNetworkResponseEntity *response = [RRTNetworkResponseEntity response:request
                                                                                  response:urlResponse
                                                                                    object:responseObject];
                   if (success) {
                       success(response);
                   }
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   NSURLResponse *urlResponse = task.response;
                   RRTNetworkErrorEntity *errorObj = [RRTNetworkErrorEntity error:request
                                                                         response:urlResponse
                                                                            error:error];
                   if (failed) {
                       failed(errorObj);
                   }
               }];
}

@end
