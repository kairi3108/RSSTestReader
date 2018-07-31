//
//  RRTArticleViewController.m
//  RSSTestReader
//
//  Created by Yuto on 2018/07/28.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import "RRTArticleViewController.h"
#import "RRTRSSAirticleEntity.h"

@interface RRTArticleViewController () <WKNavigationDelegate>

@end

@implementation RRTArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Title
    self.title = self.targetEntity.title;
    
    // View Load
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.baseView addSubview:self.webView];
    
    
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.webView
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.baseView
                                                             attribute:NSLayoutAttributeWidth
                                                            multiplier:1.0
                                                              constant:0],
                                [NSLayoutConstraint constraintWithItem:self.webView
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.baseView
                                                             attribute:NSLayoutAttributeHeight
                                                            multiplier:1.0
                                                              constant:0]
                                ]];
    
    // Load
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.targetEntity.link]];
    [self.webView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Observer
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    [self.webView addObserver:self
                   forKeyPath:@"loading"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"loading"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        float value = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        [self.loadingView setProgress:value animated:YES];
    } else if ([keyPath isEqualToString:@"loading"]) {
        [self.loadingView setHidden:!self.webView.isLoading];
    }
}

- (IBAction)barButtonItemTaped:(id)sender {
    if (sender == self.backButton) {
        [self.webView goBack];
    } else if (sender == self.pushButton) {
        [self.webView goForward];
    } else if (sender == self.reloadButton) {
        [self.webView reload];
    }
}


@end
