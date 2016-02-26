//
//  UserView.h
//  TravelApp
//
//  Created by SZT on 15/12/25.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainScreenBound.h"
@interface UserView : UIView

@property (nonatomic, strong) BlurImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *buttonZ;

@property (nonatomic, strong) UIImageView *img;


- (instancetype)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action btnAction:(SEL)btnAction;
@end
