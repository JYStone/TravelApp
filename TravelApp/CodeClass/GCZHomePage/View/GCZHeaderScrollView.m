//
//  GCZHeaderScrollView.m
//  TravelApp
//
//  Created by SZT on 15/12/17.
//  Copyright © 2015年 SZT. All rights reserved.
//

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

#import "GCZHeaderScrollView.h"
#import "UIImageView+WebCache.h"
#import "GCZTapImageView.h"


@implementation GCZHeaderScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.bounces = NO;
        self.pagingEnabled = YES;
        self.contentOffset = CGPointMake(kWidth, 0);
        self.showsHorizontalScrollIndicator = NO;
        
    }
    
    return self;
}

//设置滚动图以及触发的代理
- (void)setRollImageWithImageArray:(NSArray *)imageArray delegate:(id)delegate action:(SEL)action {
    NSArray *subsView = self.subviews;
    for (UIView *view in subsView) {
        [view removeFromSuperview];
    }
    NSMutableArray *pictureArray = [NSMutableArray arrayWithArray:imageArray];
    [pictureArray insertObject:imageArray.firstObject atIndex:pictureArray.count];
    [pictureArray insertObject:imageArray.lastObject atIndex:0];
    
    
    self.contentSize = CGSizeMake(pictureArray.count * kWidth, 0);
    self.delegate = delegate;
    for (int i = 0; i < pictureArray.count; i ++) {
        
        GCZTapImageView *imageView = [[GCZTapImageView alloc] initWithFrame:CGRectMake(i * kWidth, 0, kWidth, kWidth * 0.5) delegate:delegate action:action];
        [imageView sd_setImageWithURL:[NSURL URLWithString:pictureArray[i]]];

        [self addSubview:imageView];
    
    }
}

//设置定时器的数据
- (void)setTimerForRollImage:(NSTimeInterval)timerInterval delegate:(id)delegate action:(SEL)action {
    
   NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:delegate selector:action userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}



@end
