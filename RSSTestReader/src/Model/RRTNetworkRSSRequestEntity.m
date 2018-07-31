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
#import "RSSFeedEntity+CoreDataProperties.h"
#import "RRTFaviconRequestEntity.h"

@implementation RRTNetworkRSSRequestEntity

NSString *kRSSRequestEntityKeyTitle = @"title";
NSString *kRSSRequestEntityKeyURL = @"url";
NSString *kRSSRequestEntityKeyFavicon = @"favicon";

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

- (void)GET:(onSuccessBlock)success failed:(onFailedBlock)failed {
    [super GET:^(RRTNetworkResponseEntity *entity) {
        // RSS FEED → favicon
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        
        // パース
        NSString *title = nil;
        NSDictionary *rss = [entity.object objectForKey:@"rss"];
        if (rss && [rss isKindOfClass:[NSDictionary class]]) {
            NSDictionary *channels = [rss objectForKey:@"channel"];
            if (channels && [channels isKindOfClass:[NSDictionary class]]) {
                NSDictionary *titleDic = [channels objectForKey:@"title"];
                if (titleDic && [titleDic isKindOfClass:[NSDictionary class]]) {
                    title = [titleDic objectForKey:@"text"];
                }
            }
        }
        // SET
        if (title) {
            [dictionary setObject:title forKey:kRSSRequestEntityKeyTitle];
        }
        [dictionary setObject:self.url.absoluteString forKey:kRSSRequestEntityKeyURL];
        
        // favicon
        RRTFaviconRequestEntity *favicon = [RRTFaviconRequestEntity requestWithDomain:self.url.host];
        // Search
        [favicon GET:^(RRTNetworkResponseEntity *favEntity) {
            if (favEntity.object) {
                [dictionary setObject:favEntity.object forKey:kRSSRequestEntityKeyFavicon];
            }
            if (success) {
                entity.object = dictionary;
                success(entity);
            }
        } failed:^(RRTNetworkErrorEntity *favEntity) {
            // 失敗時はnil→成功とする
            if (success) {
                entity.object = dictionary;
                success(entity);
            }
        }];
    } failed:^(RRTNetworkErrorEntity *entity) {
        if (failed) {
            failed(entity);
        }
    }];
}

@end
