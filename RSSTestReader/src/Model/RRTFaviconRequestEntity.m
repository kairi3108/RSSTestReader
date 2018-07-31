//
//  RRTFaviconRequestEntity.m
//  RSSTestReader
//
//  Created by Yuto on 2018/07/30.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import "RRTFaviconRequestEntity.h"
#import <AFNetworking/AFNetworking.h>

@implementation RRTFaviconRequestEntity

+ (instancetype)requestWithDomain:(NSString *)domain {
    return [super request:
            [NSURL URLWithString:
             [NSString stringWithFormat:@"http://www.google.com/s2/favicons?domain=%@", domain]]];
}

- (instancetype)init:(NSURL *)url {
    if (self = [super init:url]) {
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        NSMutableSet *set = [responseSerializer.acceptableContentTypes mutableCopy];
        [set addObject:@"image/jpeg"];
        [set addObject:@"image/png"];
        [set addObject:@"image/gif"];
        [set addObject:@"image/bmp"];
        responseSerializer.acceptableContentTypes = set;
        self.responseSerializer = responseSerializer;
    }
    return self;
}

@end
