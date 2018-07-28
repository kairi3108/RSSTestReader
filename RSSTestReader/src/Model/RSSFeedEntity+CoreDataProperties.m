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

- (void)setupNextPrimaryKey {
    NSArray <RSSFeedEntity *>*obj = [RSSFeedEntity MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"SELF.idNumber == %@.@max.idNumber"]];
    self.idNumber = [[obj firstObject] idNumber] + 1;
}

@end
