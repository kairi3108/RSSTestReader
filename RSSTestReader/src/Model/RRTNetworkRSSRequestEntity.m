//
//  RRTNetworkRSSRequestEntity.m
//  RSSTestReader
//
//  Created by Yuto on 2018/07/28.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import "RRTNetworkRSSRequestEntity.h"
#import <AFNetworking/AFNetworking.h>
#import "XMLReader.h"

@implementation RRTNetworkRSSRequestEntity

- (instancetype)init:(NSURL *)url {
    if (self = [super init:url]) {
        AFXMLParserResponseSerializer *responseSerializer = [AFXMLParserResponseSerializer serializer];
        NSMutableSet *acceptable = [[responseSerializer acceptableContentTypes] mutableCopy];
        [acceptable addObject:@"application/rss+xml"];
        responseSerializer.acceptableContentTypes = acceptable;
        self.responseSerializer = responseSerializer;
    }
    return self;
}

-(id)responseParse:(id)base {
    return [XMLReader dictionaryForXMLParser:base error:nil];
}

@end
