//
//  RSSFeedEntity+CoreDataProperties.h
//  RSSTestReader
//
//  Created by Yuto on 2018/07/28.
//  Copyright © 2018年 Yuto. All rights reserved.
//
//

#import "RSSFeedEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface RSSFeedEntity (CoreDataProperties)

+ (NSFetchRequest<RSSFeedEntity *> *)fetchRequest;

@property (nonatomic) int16_t idNumber;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, copy) NSData *favicon;
@property (nullable, nonatomic, copy) NSString *rssVersion;

- (void)setupNextPrimaryKey;

@end

NS_ASSUME_NONNULL_END
