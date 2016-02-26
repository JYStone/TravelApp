//
//  GCZMoreStoryCell.m
//  TravelApp
//
//  Created by lanou on 15/12/19.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "GCZMoreStoryCell.h"
#import "MainScreenBound.h"
#import "GCZTravelListModel.h"

#define kScale 0.76

@implementation GCZMoreStoryCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    CGFloat Twidth = self.frame.size.width;
    if (self) {
        self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Twidth, Twidth * kScale)];
        self.coverImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.coverImageView.layer.shadowOffset = CGSizeMake(0, 2);
        self.coverImageView.layer.shadowOpacity = 0.8;
        self.coverImageView.layer.shadowRadius = 2;
        [GCZMoreStoryCell setLayerForView:self];
        [self.contentView addSubview:self.coverImageView];
        
        self.coverTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, Twidth * kScale, Twidth - 10, 40)];
        self.coverTextLabel.numberOfLines = 0;
        self.coverTextLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.coverTextLabel];
        
        self.userIconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, Twidth * kScale + 45, 20, 20)];
        self.userIconView.layer.masksToBounds = YES;
        self.userIconView.layer.cornerRadius = 10;
        [self.contentView addSubview:self.userIconView];
        
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, Twidth * kScale + 35, 100, 40)];
        self.userNameLabel.font = [UIFont systemFontOfSize:12];
        self.userNameLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.userNameLabel];
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}



- (void)setStoryModel:(GCZTravelListModel *)storyModel {
    
    if (_storyModel != storyModel) {
        _storyModel = storyModel;
        
        [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:storyModel.index_cover]];
        if ([storyModel.index_title isEqualToString:@""]) {
            self.coverTextLabel.text = storyModel.text;
        } else {
            self.coverTextLabel.text = storyModel.index_title;
        }
        NSDictionary *userDic = storyModel.user;
        [self.userIconView sd_setImageWithURL:[NSURL URLWithString:userDic[@"avatar_m"]]];
        self.userNameLabel.text = userDic[@"name"];
    }
    
}

+ (UIView *)setLayerForView:(UIView *)view {
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    return view;
}


@end
