//
//  RRTFaviconRequestEntity.h
//  RSSTestReader
//
//  Created by Yuto on 2018/07/30.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import "RRTNetworkRequestEntity.h"

@interface RRTFaviconRequestEntity : RRTNetworkRequestEntity

+ (instancetype)requestWithDomain:(NSString *)domain;

@end
