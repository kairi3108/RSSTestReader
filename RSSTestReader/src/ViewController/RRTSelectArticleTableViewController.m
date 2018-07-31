//
//  RRTSelectArticleTableViewController.m
//  RSSTestReader
//
//  Created by Yuto on 2018/07/28.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import "RRTSelectArticleTableViewController.h"
#import "RRTFeedArticleTableViewCell.h"
#import "RRTRSSArticleRequestEntity.h"
#import "RSSFeedEntity+CoreDataProperties.h"
#import "RRTRSSAirticleEntity.h"
#import "RRTArticleViewController.h"
#import "RRTAlertViewControllerManager.h"

@interface RRTSelectArticleTableViewController ()

@property NSArray *visibleCell;

@end

@implementation RRTSelectArticleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RRTFeedArticleTableViewCell"
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"Cell"];
    
    // とりあえず空を入れておく
    self.visibleCell = @[];
    // タイトルセット
    self.title = self.targetEntity.title;
    
    // ひっぱる
    UIRefreshControl *control = [[UIRefreshControl alloc] init];
    [control addTarget:self action:@selector(refreshContolPulled:) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = control;

    // だしておく
    DDLogDebug(@"Selected : %@", self.targetEntity);
    [self reloadRSSFeeds];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"WebViewSegue"]) {
        RRTArticleViewController *next = segue.destinationViewController;
        next.targetEntity = sender;
    }
}

- (void)refreshContolPulled:(id)sender {
    [self reloadRSSFeeds];
}

- (void)reloadRSSFeeds {
    // 読み込み中
    __weak typeof(self) weakSelf = self;
    RRTLoadingViewController *loadingView = [[RRTAlertViewControllerManager sharedManager] loadingViewController:self.storyboard];
    [self presentViewController:loadingView animated:YES completion:^{
        // 取りに行く
        RRTRSSArticleRequestEntity *request = [RRTRSSArticleRequestEntity request:[NSURL URLWithString:self.targetEntity.url]];
        [request GET:^(RRTNetworkResponseEntity *entity) {
            
            // close
            [loadingView dismissViewControllerAnimated:YES completion:^{
                DDLogDebug(@"Get Success : %ld airticles", (NSUInteger)((NSArray *)entity.object).count);
                // Pull close
                [weakSelf.tableView.refreshControl endRefreshing];
                // View Reload
                weakSelf.visibleCell = [entity object];
                [weakSelf.tableView reloadData];
            }];
        } failed:^(RRTNetworkErrorEntity *entity) {
            // close
            [loadingView dismissViewControllerAnimated:YES completion:^{
                DDLogDebug(@"Error : %@", entity);
                // 通信えらー
                UIAlertController *alert = [[RRTAlertViewControllerManager sharedManager] networkErrorAlertController:nil];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }];
        }];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.visibleCell count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RRTFeedArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                                        forIndexPath:indexPath];
    RRTRSSAirticleEntity *airticle = [self.visibleCell objectAtIndex:indexPath.row];
    [cell.descriptionView setText:airticle.title];
    [cell.dateView setText:[airticle stringVisibleString]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // View
    [self performSegueWithIdentifier:@"WebViewSegue" sender:[self.visibleCell objectAtIndex:indexPath.row]];
}

@end
