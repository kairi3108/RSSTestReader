//
//  RRTLoadingViewController.h
//  RSSTestReader
//
//  Created by Yuto on 2018/07/28.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface RRTLoadingView : UIView

@property (weak, nonatomic) IBOutlet UILabel *loadingText;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

IB_DESIGNABLE
@interface RRTLoadingViewController : UIViewController

@property (weak, nonatomic) IBOutlet RRTLoadingView *loadingView;

+ (instancetype)loadingViewController:(UIStoryboard *)storyboard;

@end
