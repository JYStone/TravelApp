//
//  GCZTapImageView.m
//  TravelApp
//
//  Created by SZT on 15/12/17.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "GCZTapImageView.h"

@implementation GCZTapImageView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate action:(SEL)action {
    
    self = [super initWithFrame:frame];
    if (self) {
        //打开用户交互 添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:delegate action:action];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled = YES;
    }
    return self;
}


@end
