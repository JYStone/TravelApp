//
//  BlurImageView.m
//  WXMusic
//
//  Created by 漫步人生路 on 15/8/31.
//  Copyright (c) 2015年 漫步人生路. All rights reserved.
//

#import "BlurImageView.h"

@implementation BlurImageView

- (instancetype)initWithFrame:(CGRect)frame imageString:(NSString *)imageString
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        //设置图片
    
        self.image = [UIImage imageNamed:imageString];
        UIVisualEffectView *backVisual = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        backVisual.frame = self.bounds;
        backVisual.alpha = 0;
        [self addSubview:backVisual];

    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
