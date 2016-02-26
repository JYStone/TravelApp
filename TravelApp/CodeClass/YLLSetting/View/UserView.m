//
//  UserView.m
//  TravelApp
//
//  Created by SZT on 15/12/25.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "UserView.h"

@implementation UserView

- (instancetype)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action btnAction:(SEL)btnAction{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        
        self.imageView = [[BlurImageView alloc] initWithFrame:CGRectMake(width * 0.2, width * 0.1, width * 0.5, width * 0.5) imageString:@"beijing1.png"];
        [self getCircleImageView:self.imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self.imageView addGestureRecognizer:tap];
        self.imageView.userInteractionEnabled = YES;
        [self addSubview:self.imageView];
        
        self.img = [[UIImageView alloc] initWithFrame:CGRectMake(width * 0.2 ,width * 0.65, width * 0.09, width * 0.09)];
        self.img.image = [UIImage imageNamed:@"user2"];
        [self addSubview:self.img];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * 0.4, width * 0.645, width * 0.5, 30)];
        self.nameLabel.text = @"user";
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.nameLabel];
        
        self.buttonZ = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.buttonZ.frame = CGRectMake(width * 0.8, height - 60, width * 0.2, 30);
        [self.buttonZ setTitle:@"注销" forState:(UIControlStateNormal)];
        self.buttonZ.tintColor = [UIColor blackColor];
        //[self.buttonZ addTarget:target action:btnAction forControlEvents:UIControlEventTouchUpInside];
       // [self addSubview:self.buttonZ];
        
        self.button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        self.button.frame = CGRectMake(width * 0.8, height - 30, width * 0.2, 30);
        self.button.tintColor = [UIColor blackColor];
        [self.button setTitle:@"登录" forState:(UIControlStateNormal)];
        [self.button addTarget:target action:btnAction forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];
        
    }
    return self;
}

- (void)getCircleImageView:(UIImageView *)imageView {
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderColor = [UIColor clearColor].CGColor;
    imageView.layer.borderWidth = 2;
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
}
@end
