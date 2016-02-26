//
//  GCZTwoLabelView.m
//  TravelApp
//
//  Created by SZT on 15/12/18.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "GCZTwoLabelView.h"

@implementation GCZTwoLabelView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat totalWidth = self.frame.size.width;
        CGFloat totalHeight = self.frame.size.height;
        self.firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, totalWidth, 0.5 * totalHeight)];
        self.secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.5 * totalHeight, totalWidth, 0.5 * totalHeight)];
        
        self.firstLabel.textAlignment = NSTextAlignmentCenter;
        self.secondLabel.textAlignment = NSTextAlignmentCenter;
        
        self.firstLabel.font = [UIFont systemFontOfSize:12];
        self.secondLabel.font = [UIFont systemFontOfSize:12];
        self.secondLabel.textColor = [UIColor grayColor];
        
        [self addSubview:self.firstLabel];
        [self addSubview:self.secondLabel];
    }
    return self;
}

@end
