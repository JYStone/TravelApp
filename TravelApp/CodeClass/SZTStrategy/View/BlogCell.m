//
//  BlogCell.m
//  TravelApp
//
//  Created by SZT on 15/12/25.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "BlogCell.h"
#import "MainScreenBound.h"
#import "Blog.h"
#define kIconImageX 15
#define kIconImageY 5
#define kIconImageW  (kWidth-2*kIconImageX)
#define kIconImageH  180

#define kNameX  (kIconImageX+5)
#define kNameY   (kIconImageY+5)
#define kNameW   (kWidth-2*kNameX)
#define kNameH   30

#define kWaypointX    kNameX
#define kWaypointY    (kIconImageY+kIconImageH-20)
#define kWaypointW    30
#define kWaypointH    10

#define kLikeX   (kWaypointX+kWaypointW+30)
#define kLikeY    kWaypointY
#define kLikeW    20
#define kLikeH    10

@interface BlogCell()

@property(nonatomic,strong)UIImageView *iconImage;

@property(nonatomic,strong)UILabel *nameLabel;



@property(nonatomic,strong)UILabel *waypointsLabel;

@property(nonatomic,strong)UILabel *recommendationsLabel;



@end

@implementation BlogCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(kIconImageX, kIconImageY, kIconImageW, kIconImageH)];
        [self.contentView addSubview:_iconImage];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kNameX, kNameY, kNameW, kNameH)];
        _nameLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_nameLabel];
        
        _waypointsLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWaypointX, kWaypointY, kWaypointW, kWaypointH)];
        _waypointsLabel.textColor  = [UIColor whiteColor];
        _waypointsLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_waypointsLabel];
        
        UILabel *zuji = [[UILabel alloc] initWithFrame:CGRectMake(kWaypointX+kWaypointW, kWaypointY, 30, kWaypointH)];
        zuji.text = @"足迹";
        zuji.textColor  = [UIColor whiteColor];
        zuji.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:zuji];
        
        _recommendationsLabel = [[UILabel alloc]initWithFrame:CGRectMake(kLikeX, kLikeY, kLikeW, kLikeH)];
        _recommendationsLabel.font = [UIFont systemFontOfSize:11];
        _recommendationsLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_recommendationsLabel];
        
        
        UILabel *xihuan = [[UILabel alloc]initWithFrame:CGRectMake(kLikeX+kLikeW, kLikeY, 30, 10)];
        xihuan.text = @"喜欢";
        xihuan.font = [UIFont systemFontOfSize:11];
        xihuan.textColor = [UIColor whiteColor];
        [self.contentView addSubview:xihuan];
    }
    return self;
}


-(void)setBlog:(Blog *)blog
{
    if (_blog != blog) {
        _blog = blog;
        [_iconImage sd_setImageWithURL:[NSURL URLWithString:blog.cover_image_default]];
        _nameLabel.text = blog.name;
        _waypointsLabel.text = blog.waypoints;
        _recommendationsLabel.text = blog.recommendations;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
