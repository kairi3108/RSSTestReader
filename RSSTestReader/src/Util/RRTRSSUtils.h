//
//  RRTRSSUtils.h
//  RSSTestReader
//
//  Created by Yuto on 2018/08/01.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRTRSSUtils : NSObject

extern NSString *kRSSVersion1_0;
extern NSString *kRSSVersion2_0;
extern NSString *kRSSVersionAtom;

+ (instancetype)shareUtilManager;

+ (NSArray <NSString *>*)supportVersions;

+ (BOOL)hasSupport:(NSDictionary *)xml;

+ (NSString *)rssVersion:(NSDictionary *)xml;

@end
