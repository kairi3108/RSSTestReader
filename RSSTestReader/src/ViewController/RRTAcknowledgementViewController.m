//
//  RRTAcknowledgementViewController.m
//  RSSTestReader
//
//  Created by Yuto on 2018/08/02.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import "RRTAcknowledgementViewController.h"
#import <WebKit/WebKit.h>

@interface RRTAcknowledgementViewController ()

@end

@implementation RRTAcknowledgementViewController

- (void)loadView {
    WKWebView *webview = [[WKWebView alloc] init];
    self.view = webview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *str = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Acknowledgement"
                                                                                             ofType:@"html"]
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    
    WKWebView *view = (WKWebView *)self.view;
    [view loadHTMLString:str baseURL:nil];
}
@end
