//
//  RRTLoadingViewController.m
//  RSSTestReader
//
//  Created by Yuto on 2018/07/28.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import "RRTLoadingViewController.h"

@interface RRTLoadingView ()

@property (strong, nonatomic) NSArray *loadingTextArray;
@property (assign, nonatomic) BOOL textAnimating;

@end

@implementation RRTLoadingView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // View 設定
    [[self layer] setCornerRadius:5.0f];
    [[self layer] setBorderWidth:2.0f];
    [[self layer] setBorderColor:[[UIColor grayColor] CGColor]];
    
    self.loadingTextArray = @[
                              @"Loading.  ",
                              @"Loading.. ",
                              @"Loading..."
                              ];
    self.textAnimating = NO;
}

- (void)startAnimation {
    [self.loadingIndicator startAnimating];
    self.textAnimating = YES;
    [self loopAnimetion];
}

- (void)loopAnimetion {
    __weak typeof(self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *now = weakSelf.loadingText.text;
        NSString *next = nil;
        NSUInteger nowIndex = [weakSelf.loadingTextArray indexOfObject:now];
        if (nowIndex + 1 < weakSelf.loadingTextArray.count) {
            next = [weakSelf.loadingTextArray objectAtIndex:nowIndex + 1];
        } else {
            next = [weakSelf.loadingTextArray firstObject];
        }
        [weakSelf.loadingText setText:next];
        
        if (weakSelf.textAnimating) {
            [weakSelf loopAnimetion];
        }
    });
}

- (void)endAnimation {
    [self.loadingIndicator stopAnimating];
    self.textAnimating = NO;
}

@end


@interface RRTLoadingViewController ()

@end

@implementation RRTLoadingViewController

+ (instancetype)loadingViewController:(UIStoryboard *)storyboard {
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.loadingView startAnimation];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.loadingView endAnimation];
}

@end
