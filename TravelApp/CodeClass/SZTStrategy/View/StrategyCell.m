//
//  StrategyCell.m
//  TravelApp
//
//  Created by SZT on 15/12/17.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "StrategyCell.h"
#import "MainScreenBound.h"

#define kIconImageX  0
#define kIconImageY  0
#define kIconImageW  (kWidth-2*kIconImageX)
#define kIconImageH  (150-2*kIconImageY)


#define kTitleLabelX  (kIconImageX+3)
#define kTitleLabelY  (kIconImageY+kIconImageH-30)
#define kTitleLabelW   (kWidth-2*kTitleLabelX)
#define kTitleLabelH   30


@implementation StrategyCell




-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(kIconImageX, kIconImageY, kIconImageW, kIconImageH)];
//        self.iconImage.layer.masksToBounds = YES;
//        self.iconImage.layer.cornerRadius = 10;
        [self.contentView addSubview:self.iconImage];
        
        
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kTitleLabelX, kTitleLabelY, kTitleLabelW, kTitleLabelH)];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLabel];
        
        
    }
    return self;
}



@end
