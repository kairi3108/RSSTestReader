//
//  RRTArticleViewController.h
//  RSSTestReader
//
//  Created by Yuto on 2018/07/28.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class RRTRSSAirticleEntity;

@interface RRTArticleViewController : UIViewController

@property RRTRSSAirticleEntity *targetEntity;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (strong, nonatomic) WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIProgressView *loadingView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *pushButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *reloadButton;

@end
