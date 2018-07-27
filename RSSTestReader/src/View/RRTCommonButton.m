//
//  RRTCommonButton.m
//  RSSTestReader
//
//  Created by Yuto on 2018/07/28.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import "RRTCommonButton.h"

@implementation RRTCommonButton

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[self layer] setBorderColor:[[UIColor colorWithRed:0
                                                 green:122.f/255.f
                                                  blue:1
                                                 alpha:1] CGColor]];
    [[self layer] setBorderWidth:2.0f];
    [[self layer] setCornerRadius:3.f];
}

@end
