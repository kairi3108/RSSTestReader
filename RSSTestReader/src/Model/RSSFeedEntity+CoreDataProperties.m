//
//  RSSFeedEntity+CoreDataProperties.m
//  RSSTestReader
//
//  Created by Yuto on 2018/07/28.
//  Copyright © 2018年 Yuto. All rights reserved.
//
//

#import "RSSFeedEntity+CoreDataProperties.h"

@implementation RSSFeedEntity (CoreDataProperties)

+ (NSFetchRequest<RSSFeedEntity *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"RSSFeedEntity"];
}

@dynamic idNumber;
@dynamic title;
@dynamic url;
@dynamic favicon;
@dynamic rssVersion;

- (void)setupNextPrimaryKey {
    if ([RSSFeedEntity MR_countOfEntities] == 0) {
        self.idNumber = 1;
    } else {
        NSArray <RSSFeedEntity *>*obj = [RSSFeedEntity MR_findAll];
        NSInteger nowMax = 0;
        for (RSSFeedEntity *entity in obj) {
            if (nowMax < entity.idNumber) {
                nowMax = entity.idNumber;
            }
        }
        self.idNumber = nowMax + 1;
    }
}

@end
