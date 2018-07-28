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

@end
