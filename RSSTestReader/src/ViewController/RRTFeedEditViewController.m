//
//  RRTFeedEditViewController.m
//  RSSTestReader
//
//  Created by Yuto on 2018/07/28.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import "RRTFeedEditViewController.h"
#import "RRTCommonButton.h"
#import "RRTAlertViewControllerManager.h"
#import "RRTNetworkController.h"
#import "RRTNetworkRSSRequestEntity.h"
#import "RSSFeedEntity+CoreDataProperties.h"

#define DUMMY

@interface RRTFeedEditViewController ()

@property (weak, nonatomic) IBOutlet UITextField *urlView;
@property (weak, nonatomic) IBOutlet UITextField *titleView;
@property (weak, nonatomic) IBOutlet RRTCommonButton *addButton;
@property (weak, nonatomic) IBOutlet RRTCommonButton *cancelButton;

@end

@implementation RRTFeedEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)buttonTaped:(id)sender {
    if (self.addButton == sender) {
        // regist
        __weak typeof(self) weakSelf = self;
        RRTAlertViewControllerManager *alertManager = [RRTAlertViewControllerManager sharedManager];
        RRTLoadingViewController *loading = [alertManager loadingViewController:self.storyboard];
        [self presentViewController:loading animated:YES completion:^{
            // 通信
#ifdef DUMMY
            NSString *urlStr = @"http://getnews.jp/feed";
#else
            NSString *urlStr = self.urlView.text;
#endif
            RRTNetworkRequestEntity *request = [RRTNetworkRSSRequestEntity request:[NSURL URLWithString:urlStr]];
            [request GET:^(RRTNetworkResponseEntity *entity) {
                NSDictionary *dict = entity.object;
                
                DDLogDebug(@"request : %@", dict);
                // saveObj
                // タイトル
                NSString *title = [dict objectForKey:kRSSRequestEntityKeyTitle];
                if (title == nil || title.length == 0) {
                    title = @"未設定";
                }
                
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                    // save
                    RSSFeedEntity *feed = [RSSFeedEntity MR_createEntityInContext:localContext];
                    [feed setupNextPrimaryKey];
                    feed.title = title;
                    feed.url = [dict objectForKey:kRSSRequestEntityKeyURL];
                    feed.favicon = [dict objectForKey:kRSSRequestEntityKeyFavicon];
                    
                } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
                    DDLogDebug(@"Coredata result %@, Error : %@", (contextDidSave ? @"SAVE" : @"DON'T SAVE"), [error description]);
                    // dissmiss & back
                    [loading dismissViewControllerAnimated:YES completion:^{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }];
                }];
            } failed:^(RRTNetworkErrorEntity *entity) {
                DDLogError(@"error : %@", entity);
                [loading dismissViewControllerAnimated:YES completion:^{
                    UIAlertController *alert = [alertManager networkErrorAlertControllerOnAddFeed:^(UIAlertAction *alertAction) {
                        // OK
                    } addAction:^(UIAlertAction *alertAction) {
                        // Add Anyway
                        // タイトル
                        NSString *title = weakSelf.titleView.text;
                        if (title == nil || title.length == 0) {
                            title = @"未設定";
                        }
                        
                        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                            // save
                            RSSFeedEntity *feed = [RSSFeedEntity MR_createEntityInContext:localContext];
                            [feed setupNextPrimaryKey];
                            feed.title = title;
                            feed.url = request.url.absoluteString;
                            
                        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
                            DDLogDebug(@"Coredata result %@, Error : %@", (contextDidSave ? @"SAVE" : @"DON'T SAVE"), [error description]);
                            // dissmiss & back
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }];
                    }];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                }];
            }];
        }];
    } else if (self.cancelButton == sender) {
        // back
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
