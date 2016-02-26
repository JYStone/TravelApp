//
//  CollectCell.m
//  TravelApp
//
//  Created by SZT on 15/12/26.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "CollectCell.h"
#import "MainScreenBound.h"

#define kIconImageX  10
#define kIconImageY   5
#define kIconImageW   80
#define kIconImageH   80

#define kTitleLabelX  (kIconImageX+kIconImageW)
#define kTitleLabelY   30
#define kTitleLabelW   200
#define kTitleLabelH   30

@implementation CollectCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(kIconImageX, kIconImageY, kIconImageW, kIconImageH)];
        [self.contentView addSubview:self.iconImage];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kTitleLabelX, kTitleLabelY, kTitleLabelW, kTitleLabelH)];
        [self.contentView addSubview:self.titleLabel];
        
    }
    return self;
}


-(void)setModel:(GCZTravelListModel *)model
{
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    self.titleLabel.text = model.name;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
