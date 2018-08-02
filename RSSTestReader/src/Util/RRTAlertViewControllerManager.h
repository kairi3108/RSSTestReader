//
//  RRTAlertViewControllerManager.h
//  RSSTestReader
//
//  Created by Yuto on 2018/07/28.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRTLoadingViewController.h"

@interface RRTAlertViewControllerManager : NSObject

+ (instancetype)sharedManager;

- (RRTLoadingViewController *)loadingViewController:(UIStoryboard *)storyboard;

- (UIAlertController *)commonErrorAlertController:(NSString *)title message:(NSString *)message action:(void (^)(UIAlertAction *))action;

- (UIAlertController *)commonErrorAlertController:(NSString *)message action:(void (^)(UIAlertAction *))action;

- (UIAlertController *)networkErrorAlertController:(void (^)(UIAlertAction *))action;

- (UIAlertController *)networkErrorAlertControllerOnAddFeed:(void (^)(UIAlertAction *))action addAction:(void (^)(UIAlertAction *))addAction;

- (UIAlertController *)rssFeedResetAlertController:(void (^)(UIAlertAction *))resetAction;

@end
