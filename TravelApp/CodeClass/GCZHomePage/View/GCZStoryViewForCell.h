//
//  GCZStoryViewForCell.h
//  TravelApp
//
//  Created by SZT on 15/12/18.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCZStoryViewForCell : UIView

@property (nonatomic,strong) UIImageView *coverImageView;

@property (nonatomic,strong) UILabel *coverTextLabel;

@property (nonatomic,strong) UILabel *userNameLabel;

@property (nonatomic,strong) UIImageView *userIconView;


- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate action:(SEL)action imageHeightScale:(CGFloat)imageHeightScale;


@end
