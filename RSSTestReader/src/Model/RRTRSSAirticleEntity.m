//
//  RRTRSSAirticleEntity.m
//  RSSTestReader
//
//  Created by Yuto on 2018/07/31.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import "RRTRSSAirticleEntity.h"

@implementation RRTRSSAirticleGuidEntity
@end

@implementation RRTRSSAirticleEntity

+ (instancetype)airticle:(NSDictionary *)item rssVersion:(NSString *)version {
    return [[[self class] alloc] initWithItem:item rssVersion:version];
}

- (instancetype)initWithItem:(NSDictionary *)item rssVersion:(NSString *)version {
    if ([super init]) {
        _rssVersion = version;
        _title = [self stringFromItem:item forKey:[self titleKey]];
        _link = [self stringFromItem:item forKey:[self linkKey]];
        _descriptionStr = [self stringFromItem:item forKey:[self descriptionKey]];
        _author = [self stringFromItem:item forKey:[self authorKey]];
        _category = [self arrayFromItem:item forKey:[self categoryKey]];
        _comments = [self stringFromItem:item forKey:[self commentsKey]];
        _enclosure = [self stringFromItem:item forKey:[self enclosureKey]];
        _guid = [self guidFromItem:item forKey:[self guidKey]];
        _pubDate = [self pubDateFromString:[self stringFromItem:item forKey:[self pubDateKey]]];
        _source = [self stringFromItem:item forKey:[self sourceKey]];
    }
    return self;
}

- (NSString *)stringFromItem:(NSDictionary *)item forKey:(NSString *)key  {
    if ([item objectForKey:key] == nil || key == nil) {
        return nil;
    }
    return [[item objectForKey:key] objectForKey:@"text"];
}

- (NSArray *)arrayFromItem:(NSDictionary *)item forKey:(NSString *)key  {
    if ([item objectForKey:key] == nil || key == nil) {
        return nil;
    }
    // 1このみはDict
    NSMutableArray *retArray = [NSMutableArray array];
    id obj = [item objectForKey:key];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = obj;
        [retArray addObject:[dict objectForKey:@"text"]];
    } else if ([obj isKindOfClass:[NSArray class]]) {
        NSArray *array = obj;
        for (NSDictionary *dict in array) {
            [retArray addObject:[dict objectForKey:@"text"]];
        }
    }
    return retArray;
}

- (RRTRSSAirticleGuidEntity *)guidFromItem:(NSDictionary *)item forKey:(NSString *)key  {
    if ([item objectForKey:key] == nil || key == nil) {
        return nil;
    }
    RRTRSSAirticleGuidEntity *entity = [[RRTRSSAirticleGuidEntity alloc] init];
    if ([[[item objectForKey:key] objectForKey:@"isPermaLink"] isEqualToString:@"true"]) {
        entity.permaLink = YES;
    }
    entity.text = [[item objectForKey:key] objectForKey:@"text"];
    return entity;
}

- (NSDate *)pubDateFromString:(NSString *)inDate {
    if (inDate == nil) {
        return nil;
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        if ([kRSSVersion1_0 isEqualToString:self.rssVersion]) {
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        } else if ([kRSSVersion2_0 isEqualToString:self.rssVersion]) {
            [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZ"];
        }
        return [dateFormatter dateFromString:inDate];
    }
}

- (NSString *)stringVisibleString {
    if (self.pubDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
        return [dateFormatter stringFromDate:self.pubDate];
    } else {
        return @"----/--/-- --:--:--";
    }
}

- (NSString *)titleKey {
    NSString *ret = nil;
    if ([self.rssVersion isEqualToString:kRSSVersion1_0]
        || [self.rssVersion isEqualToString:kRSSVersion2_0]
        || [self.rssVersion isEqualToString:kRSSVersionAtom]) {
        ret = @"title";
    }
    return ret;
}

- (NSString *)linkKey {
    NSString *ret = nil;
    if ([self.rssVersion isEqualToString:kRSSVersion1_0]
        || [self.rssVersion isEqualToString:kRSSVersion2_0]) {
        ret = @"link";
    } else if ([self.rssVersion isEqualToString:kRSSVersionAtom]) {
        
    }
    return ret;
}

- (NSString *)descriptionKey {
    NSString *ret = nil;
    if ([self.rssVersion isEqualToString:kRSSVersion1_0]
        || [self.rssVersion isEqualToString:kRSSVersion2_0]) {
        ret = @"description";
    } else if ([self.rssVersion isEqualToString:kRSSVersionAtom]) {
        
    }
    return ret;
}

- (NSString *)authorKey {
    NSString *ret = nil;
    if ([self.rssVersion isEqualToString:kRSSVersion1_0]) {
        ret = @"dc:creator";
    } else if ([self.rssVersion isEqualToString:kRSSVersion2_0]) {
        ret = @"author";
    } else if ([self.rssVersion isEqualToString:kRSSVersionAtom]) {
        
    }
    return ret;
}

- (NSString *)categoryKey {
    NSString *ret = nil;
    if ([self.rssVersion isEqualToString:kRSSVersion1_0]) {
        
    } else if ([self.rssVersion isEqualToString:kRSSVersion2_0]) {
        ret = @"category";
    } else if ([self.rssVersion isEqualToString:kRSSVersionAtom]) {
        
    }
    return ret;
}

- (NSString *)commentsKey {
    NSString *ret = nil;
    if ([self.rssVersion isEqualToString:kRSSVersion1_0]) {
        
    } else if ([self.rssVersion isEqualToString:kRSSVersion2_0]) {
        ret = @"comments";
    } else if ([self.rssVersion isEqualToString:kRSSVersionAtom]) {
        
    }
    return ret;
}

- (NSString *)enclosureKey {
    NSString *ret = nil;
    if ([self.rssVersion isEqualToString:kRSSVersion1_0]) {
        
    } else if ([self.rssVersion isEqualToString:kRSSVersion2_0]) {
        ret = @"enclosure";
    } else if ([self.rssVersion isEqualToString:kRSSVersionAtom]) {
        
    }
    return ret;
}

- (NSString *)guidKey {
    NSString *ret = nil;
    if ([self.rssVersion isEqualToString:kRSSVersion1_0]) {
        
    } else if ([self.rssVersion isEqualToString:kRSSVersion2_0]) {
        ret = @"guid";
    } else if ([self.rssVersion isEqualToString:kRSSVersionAtom]) {
        
    }
    return ret;
}

- (NSString *)pubDateKey {
    NSString *ret = nil;
    if ([self.rssVersion isEqualToString:kRSSVersion1_0]) {
        ret = @"dc:date";
    } else if ([self.rssVersion isEqualToString:kRSSVersion2_0]) {
        ret = @"pubData";
    } else if ([self.rssVersion isEqualToString:kRSSVersionAtom]) {
        
    }
    return ret;
}

- (NSString *)sourceKey {
    NSString *ret = nil;
    if ([self.rssVersion isEqualToString:kRSSVersion1_0]) {
        
    } else if ([self.rssVersion isEqualToString:kRSSVersion2_0]) {
        ret = @"source";
    } else if ([self.rssVersion isEqualToString:kRSSVersionAtom]) {
        
    }
    return ret;
}

@end
