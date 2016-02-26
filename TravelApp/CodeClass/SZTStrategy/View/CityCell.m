//
//  CityCell.m
//  TravelApp
//
//  Created by SZT on 15/12/23.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "CityCell.h"
#import "MainScreenBound.h"

#define kCellWidth  kWidth
#define kCellHeight  200

#define kIconImageW  kWidth
#define kIconImageH  kCellHeight
#define kIconImageX 0
#define kIconImageY 0

#define kCityNameW  80
#define kCityNameH  30
#define kCityNameX  15
#define kCityNameY  kCellHeight- kCityNameH


@implementation CityCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(kIconImageX, kIconImageY, kIconImageW, kIconImageH)];
        [self.contentView addSubview:self.iconImage];
        
        self.cityName = [[UILabel alloc]initWithFrame:CGRectMake(kCityNameX, kCityNameY, kCityNameW, kCityNameH)];
        self.cityName.textColor = [UIColor whiteColor];
        self.cityName.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:self.cityName];
    }
    return self;
}


-(void)setCity:(City *)city
{
    if (_city != city) {
        _city = city;
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:city.cover]];
        self.cityName.text = city.name_zh;
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
