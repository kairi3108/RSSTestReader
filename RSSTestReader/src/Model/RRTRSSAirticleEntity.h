//
//  RRTRSSAirticleEntity.h
//  RSSTestReader
//
//  Created by Yuto on 2018/07/31.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRTRSSAirticleGuidEntity : NSObject
@property BOOL permaLink;
@property NSString *text;
@end

@interface RRTRSSAirticleEntity : NSObject

@property NSString *rssVersion;

@property NSString *title; // コンテンツのタイトル。ページタイトルや記事タイトル。

@property NSString *link; // コンテンツのURL。

@property NSString *descriptionStr; // コンテンツの概要。

@property NSString *author; // コンテンツを書いた人のメールアドレス。

@property NSArray<NSString *> *category; // コンテンツのカテゴリ。

@property NSString *comments; // コンテンツに対するコメントがあるページのURL。

@property NSString *enclosure; // コンテンツに添付されるメディアオブジェクト。

@property RRTRSSAirticleGuidEntity *guid; // コンテンツのユニークな永続的なURL。

@property NSDate *pubDate; // コンテンツの公開日。

@property NSString *source; // 記事で引用しているRSSのチャンネル。引用元のURLを指定するurl属性は必須属性。

+ (instancetype)airticle:(NSDictionary *)item rssVersion:(NSString *)version;

- (NSString *)stringVisibleString;

@end
