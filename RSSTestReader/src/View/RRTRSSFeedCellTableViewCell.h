//
//  RRTRSSFeedCellTableViewCell.h
//  RSSTestReader
//
//  Created by Yuto on 2018/07/28.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface RRTRSSFeedCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *urlView;
@property (weak, nonatomic) IBOutlet UILabel *rssVersion;

@end
