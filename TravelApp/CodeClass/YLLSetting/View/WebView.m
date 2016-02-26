//
//  WebView.m
//  TravelApp
//
//  Created by SZT on 15/12/29.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "WebView.h"

@implementation WebView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.backButton.frame = CGRectMake(0, 20, 60, 30);
        self.backButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.backButton.tintColor = [UIColor blackColor];
        [self.backButton setTitle:@"back" forState:normal];
        [self addSubview:self.backButton];
    }
    return self;
}

@end
