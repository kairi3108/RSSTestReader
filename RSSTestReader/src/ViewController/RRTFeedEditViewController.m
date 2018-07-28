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
            RRTNetworkController *controller = [RRTNetworkController sharedController];
            RRTNetworkRequestEntity *request = [RRTNetworkRSSRequestEntity request:[NSURL URLWithString:@"http://getnews.jp/feed"]];
            [controller request:request
                        success:^(RRTNetworkResponseEntity *entity) {
                            DDLogDebug(@"request : %@", entity);
                            // saveObj
                            
                            // dissmiss & back
                            [loading dismissViewControllerAnimated:YES completion:^{
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                            }];
                        } failed:^(RRTNetworkErrorEntity *entity) {
                            DDLogError(@"error : %@", entity);
                            [loading dismissViewControllerAnimated:YES completion:^{
                                UIAlertController *alert = [alertManager networkErrorAlertControllerOnAddFeed:^(UIAlertAction *alertAction) {
                                    // OK
                                    [weakSelf presentViewController:alert
                                                           animated:YES
                                                         completion:nil];
                                } addAction:^(UIAlertAction *alertAction) {
                                    // Add Anyway
                                    [weakSelf presentViewController:alert
                                                           animated:YES
                                                         completion:nil];
                                }];
                            }];
                        }];
        }];
    } else if (self.cancelButton == sender) {
        // back
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
