//
//  RRTAlertViewControllerManager.m
//  RSSTestReader
//
//  Created by Yuto on 2018/07/28.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import "RRTAlertViewControllerManager.h"
#import "RRTLoadingViewController.h"

@implementation RRTAlertViewControllerManager

+ (instancetype)sharedManager {
    static RRTAlertViewControllerManager *sInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[[self class] alloc] init];
    });
    return sInstance;
}

- (RRTLoadingViewController *)loadingViewController:(UIStoryboard *)storyboard {
    return [storyboard instantiateViewControllerWithIdentifier:
            NSStringFromClass([RRTLoadingViewController class])];
}

- (UIAlertController *)networkErrorAlertController:(void (^)(UIAlertAction *))action {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Error"
                                                                   message:@"Error"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:action]];
    return alert;
}

- (UIAlertController *)networkErrorAlertControllerOnAddFeed:(void (^)(UIAlertAction *))action addAction:(void (^)(UIAlertAction *))addAction {
    UIAlertController *alert = [self networkErrorAlertController:action];
    // add anyway
    [alert addAction:[UIAlertAction actionWithTitle:@"Add Anyway" style:UIAlertActionStyleDefault handler:addAction]];
    return alert;
}

@end
