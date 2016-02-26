//
//  SettingTableViewCell.m
//  TravelApp
//
//  Created by SZT on 15/12/18.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "SettingTableViewCell.h"
#import "MainScreenBound.h"
@implementation SettingTableViewCell

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
        //去掉选中时的背景色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth * 0.07, 10, 25, 25)];
        [self addSubview:self.imageV];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth * 0.2, 10, kWidth * 0.4, 30)];
//        self.nameLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.nameLabel];
        
        self.swithDN = [[UISwitch alloc] initWithFrame:CGRectMake(kWidth * 0.65, 8, 0, 0)];
        self.swithDN.transform = CGAffineTransformMakeScale(0.7, 0.7);
        self.swithDN.alpha = 0;
        self.swithDN.onTintColor = [UIColor grayColor];
        self.swithDN.tintColor = [UIColor blackColor];
        self.swithDN.thumbTintColor = [UIColor blackColor];
        [self addSubview:self.swithDN];
        
//        self.switchDN = [[SwitchDN alloc] initWithFrame:CGRectMake(kWidth * 0.65, 10, 0, 0)];
//        self.switchDN.alpha = 0;
//        self.switchDN.onTintColor = [UIColor grayColor];
//        self.switchDN.tintColor = [UIColor blackColor];
//        self.switchDN.thumbTintColor = [UIColor blackColor];
//        [self addSubview:self.switchDN];
        
        self.pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth * 0.7, 10, 15, 22)];
        self.pictureView.image = [UIImage imageNamed:@"sapi_profile_arrow@2x"];
        [self addSubview:self.pictureView];
    }
    return self;
}

@end
