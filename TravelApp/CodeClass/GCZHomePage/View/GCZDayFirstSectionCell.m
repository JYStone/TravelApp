//
//  GCZDayFirstSectionCell.m
//  TravelApp
//
//  Created by lanou on 15/12/18.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "GCZDayFirstSectionCell.h"
#import "GCZTravelListModel.h"
#import "MainScreenBound.h"
#import "GCZTwoLabelView.h"
#import <QuartzCore/QuartzCore.h>


@implementation GCZDayFirstSectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kCellBackGroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        self.userNameLabel.center = CGPointMake(kWidth / 2, 70 / 2 + 10);
        self.userNameLabel.font = [UIFont systemFontOfSize:12];
        self.userNameLabel.textColor = [UIColor grayColor];
        self.userNameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.userNameLabel];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth - 50, 50)];
        self.titleLabel.center = CGPointMake(kWidth / 2, 40 + 70 / 2);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleLabel];
        
        //设置里程，时间，喜欢控件的宽度
        CGFloat smallLabelWidth = (kWidth - 60) / 3;
    
        self.timeView = [[GCZTwoLabelView alloc] initWithFrame:CGRectMake(30, self.titleLabel.center.y + 35, smallLabelWidth, 50)];
        [self.contentView addSubview:self.timeView];
        
        self.mileageView = [[GCZTwoLabelView alloc] initWithFrame:CGRectMake(30 + smallLabelWidth, self.titleLabel.center.y + 35, smallLabelWidth, 50)];
        [self.contentView addSubview:self.mileageView];
        
        self.likeView = [[GCZTwoLabelView alloc] initWithFrame:CGRectMake(30 + 2 * smallLabelWidth, self.titleLabel.center.y + 35, smallLabelWidth, 50)];
        [self.contentView addSubview:self.likeView];
      }
    return self;
}



- (void)setTravelListModel:(GCZTravelListModel *)travelListModel {
    
    if (_travelListModel != travelListModel) {
        
        CGFloat smallLabelWidth = (kWidth - 60) / 3;
        
        UIView *longLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth - 60, 0.5)];
        longLineView.center = CGPointMake(kWidth / 2, self.titleLabel.center.y + 30);
        longLineView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:longLineView];
        
        UIView *firstVirtualLine = [[UIView alloc] initWithFrame:CGRectMake(30 + smallLabelWidth, self.titleLabel.center.y + 35, 0.5, 50)];
        firstVirtualLine.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:firstVirtualLine];
        
        UIView *secondVirtualLie = [[UIView alloc] initWithFrame:CGRectMake(30 + 2 * smallLabelWidth, longLineView.frame.origin.y + 5, 0.5, 50)];
        secondVirtualLie.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:secondVirtualLie];
        
        self.titleLabel.text = travelListModel.name;
        NSDictionary *userDic = travelListModel.user;
        self.userNameLabel.text = [NSString stringWithFormat:@"by:%@", userDic[@"name"]];
        
        self.mileageView.firstLabel.text = @"里程";
        self.mileageView.secondLabel.text = [NSString stringWithFormat:@"%dmileage", [travelListModel.mileage integerValue]];
        
        self.timeView.firstLabel.text = travelListModel.first_day;
        self.timeView.secondLabel.text = [NSString stringWithFormat:@"%@days", travelListModel.day_count];
        
        self.likeView.firstLabel.text = @"喜欢";
        self.likeView.secondLabel.text = [NSString stringWithFormat:@"%@", travelListModel.recommendations];
        
    }
    
    
}



@end
