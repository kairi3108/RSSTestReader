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

- (UIAlertController *)commonErrorAlertController:(NSString *)title message:(NSString *)message action:(void (^)(UIAlertAction *))action {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:action]];
    return alert;
}

- (UIAlertController *)commonErrorAlertController:(NSString *)message action:(void (^)(UIAlertAction *))action {
    return [self commonErrorAlertController:@"Error"
                                    message:message
                                     action:action];
}

- (UIAlertController *)networkErrorAlertController:(void (^)(UIAlertAction *))action {
    UIAlertController *alert = [self commonErrorAlertController:@"Network Error"
                                                        message:@"Error"
                                                         action:action];
    return alert;
}

- (UIAlertController *)networkErrorAlertControllerOnAddFeed:(void (^)(UIAlertAction *))action addAction:(void (^)(UIAlertAction *))addAction {
    UIAlertController *alert = [self networkErrorAlertController:action];
    // add anyway
    [alert addAction:[UIAlertAction actionWithTitle:@"Add Anyway" style:UIAlertActionStyleDefault handler:addAction]];
    return alert;
}

- (UIAlertController *)rssFeedResetAlertController:(void (^)(UIAlertAction *))resetAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Feed Reset"
                                                                   message:@"Preset JSON URL"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"!!!RESET!!!" style:UIAlertActionStyleDestructive handler:resetAction]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    return alert;
}

@end
