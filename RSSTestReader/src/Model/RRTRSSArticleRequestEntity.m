//
//  RRTRSSArticleRequestEntity.m
//  RSSTestReader
//
//  Created by Yuto on 2018/07/31.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import "RRTRSSArticleRequestEntity.h"
#import <AFNetworking/AFNetworking.h>
#import "XMLReader.h"
#import "RRTRSSAirticleEntity.h"

@implementation RRTRSSArticleRequestEntity

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
        if ([RRTRSSUtils hasSupport:entity.object]) {
            NSString *rssVersion = [RRTRSSUtils rssVersion:entity.object];
            DDLogDebug(@"RSS VERSION : %@", rssVersion);
            NSMutableArray <RRTRSSAirticleEntity *>*itemArray = [NSMutableArray array];
            if ([rssVersion isEqualToString:kRSSVersion2_0]) {
                NSDictionary *rss = [entity.object objectForKey:@"rss"];
                if (rss && [rss isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *channels = [rss objectForKey:@"channel"];
                    if (channels && [channels isKindOfClass:[NSDictionary class]]) {
                        NSArray <NSDictionary *>*itemDic = [channels objectForKey:@"item"];
                        if (itemDic && [itemDic isKindOfClass:[NSArray class]]) {
                            for (NSDictionary *item in itemDic) {
                                RRTRSSAirticleEntity *itemEntity = [RRTRSSAirticleEntity airticle:item rssVersion:rssVersion];
                                [itemArray addObject:itemEntity];
                            }
                        }
                    }
                }
            } else if ([rssVersion isEqualToString:kRSSVersion1_0]) {
                NSDictionary *rdf = [entity.object objectForKey:@"rdf:RDF"];
                if (rdf && [rdf isKindOfClass:[NSDictionary class]]) {
                    NSArray <NSDictionary *>*itemDic = [rdf objectForKey:@"item"];
                    if (itemDic && [itemDic isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *item in itemDic) {
                            RRTRSSAirticleEntity *itemEntity = [RRTRSSAirticleEntity airticle:item rssVersion:rssVersion];
                            [itemArray addObject:itemEntity];
                        }
                    }
                }
            }
            entity.object = itemArray;
            if (success) {
                success(entity);
            }
        } else {
            if (failed) {
                failed([RRTNetworkErrorEntity errorRSSNotSupportVersion:entity.url xml:entity.object]);
            }
        }
        
    } failed:^(RRTNetworkErrorEntity *entity) {
        if (failed) {
            failed(entity);
        }
    }];
}

@end
