//
//  GCZStoryViewForCell.m
//  TravelApp
//
//  Created by SZT on 15/12/18.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "GCZStoryViewForCell.h"
#import "MainScreenBound.h"
#define kScale 0.75

@implementation GCZStoryViewForCell

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate action:(SEL)action imageHeightScale:(CGFloat)imageHeightScale {
    
    self = [super initWithFrame:frame];
    CGFloat Twidth = self.frame.size.width;
    
    if (self) {
        self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Twidth, Twidth * imageHeightScale)];
        [GCZStoryViewForCell setLayerForView:self];
        [self addSubview:self.coverImageView];
        
        self.coverTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, Twidth * imageHeightScale, Twidth - 10, 40)];
        self.coverTextLabel.numberOfLines = 0;
        self.coverTextLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.coverTextLabel];
        
        self.userIconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, Twidth * imageHeightScale + 45, 20, 20)];
        self.userIconView.layer.masksToBounds = YES;
        self.userIconView.layer.cornerRadius = 10;
        [self addSubview:self.userIconView];
        
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, Twidth * imageHeightScale + 35, 100, 40)];
        self.userNameLabel.font = [UIFont systemFontOfSize:12];
        self.userNameLabel.textColor = [UIColor grayColor];
        [self addSubview:self.userNameLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:delegate action:action];
        [self addGestureRecognizer:tap];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

+ (UIView *)setLayerForView:(UIView *)view {
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    return view;
}

@end
