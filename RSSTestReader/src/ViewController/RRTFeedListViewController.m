//
//  RRTFeedListViewController.m
//  RSSTestReader
//
//  Created by Yuto on 2018/07/28.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import "RRTFeedListViewController.h"
#import "RSSFeedEntity+CoreDataProperties.h"
#import "RRTRSSFeedCellTableViewCell.h"

@interface RRTFeedListViewController ()

@property NSArray <RSSFeedEntity *> *visibleArray;

@end

@implementation RRTFeedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RRTRSSFeedCellTableViewCell"
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"Cell"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.visibleArray = [RSSFeedEntity MR_findAll];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.visibleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RRTRSSFeedCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                                        forIndexPath:indexPath];
    RSSFeedEntity *entity = [self.visibleArray objectAtIndex:indexPath.row];
    cell.titleView.text = entity.title;
    cell.urlView.text = entity.url;
    UIImage *image = nil;
    if (entity.favicon) {
        image = [UIImage imageWithData:entity.favicon];
    }
    [cell.thumbnail setImage:image];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    return @[
             [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                title:@"Delete"
                                              handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                  // own delete action
                                                  [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                                                      RSSFeedEntity *entity = [weakSelf.visibleArray objectAtIndex:indexPath.row];
                                                      [entity MR_deleteEntityInContext:localContext];
                                                  } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
                                                      DDLogDebug(@"Coredata result %@, Error : %@", (contextDidSave ? @"SAVE" : @"D'ONT SAVE"), [error description]);
                                                      weakSelf.visibleArray = [RSSFeedEntity MR_findAll];
                                                      [weakSelf.tableView reloadData];
                                                  }];
                                              }],
             [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                title:@"Action"
                                              handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                  // own action
                                                  // edit
                                              }],
             ];
}

@end
