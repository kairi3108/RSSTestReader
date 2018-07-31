//
//  RRTRSSUtils.m
//  RSSTestReader
//
//  Created by Yuto on 2018/08/01.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import "RRTRSSUtils.h"

@implementation RRTRSSUtils

NSString *kRSSVersion1_0 = @"1.0";
NSString *kRSSVersion2_0 = @"2.0";
NSString *kRSSVersionAtom = @"Atom";

+ (instancetype)shareUtilManager {
    static RRTRSSUtils *sInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[self alloc] init];
    });
    return sInstance;
}

+ (NSArray<NSString *> *)supportVersions {
#ifdef ENABLE_ATOM
    return @[kRSSVersion1_0, kRSSVersion2_0, kRSSVersionAtom];
#else
    return @[kRSSVersion1_0, kRSSVersion2_0];
#endif
}

+ (BOOL)hasSupport:(NSDictionary *)xml {
    return [[[self class] supportVersions] containsObject:[[self class] rssVersion:xml]];
}

+ (NSString *)rssVersion:(NSDictionary *)xml {
    if ([xml objectForKey:@"rdf:RDF"]) {
        return kRSSVersion1_0;
    } else if ([xml objectForKey:@"rss"]) {
        return kRSSVersion2_0;
    } else if ([xml objectForKey:@"feed"]) {
        return kRSSVersionAtom;
    } else {
        return nil;
    }
}

@end
