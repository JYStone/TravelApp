//
//  GCZTravelDayCell.m
//  TravelApp
//
//  Created by lanou on 15/12/18.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "GCZTravelDayCell.h"
#import "GCZTravelDayModel.h"
#import "MainScreenBound.h"


#import "SDWebImageDownloader.h"
#define kTextFontSize 14


@implementation GCZTravelDayCell

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kCellBackGroundColor;

    }
    return self;
}

- (void)setImageViewTextWithModel:(GCZTravelDayModel *)travelMoel {
    
    NSArray *subArray = self.contentView.subviews;
    for (id view in subArray) {
        [view removeFromSuperview];
    }
    
    CGFloat photoWidth = 0;
    CGFloat photoHeight = 0;
    
    if (travelMoel.photo_info) {
        NSDictionary *photoInfoDic = travelMoel.photo_info;
        photoWidth = [photoInfoDic[@"w"] floatValue];
        photoHeight = [photoInfoDic[@"h"] floatValue];
    } else {
        photoWidth = [travelMoel.photo_width floatValue];
        photoHeight = [travelMoel.photo_height floatValue];
    }
    
    if (photoHeight > 0) {
        CGFloat scale = photoWidth / photoHeight;
        photoHeight = (kWidth - 20) / scale;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kWidth - 20, photoHeight)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:travelMoel.photo_1600]];
    CGFloat textHeight = [GCZTravelDayCell getHeightWithString:travelMoel.text];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, photoHeight + 20, kWidth - 40, textHeight)];
    textLabel.font = [UIFont systemFontOfSize:kTextFontSize];
    textLabel.text = travelMoel.text;
    textLabel.numberOfLines = 0;
    
    [self.contentView addSubview:textLabel];
    [self.contentView addSubview:imageView];

}

+ (CGFloat)getHeightWithModel:(GCZTravelDayModel *)travelModel {
    
    CGFloat photoWidth = 0;
    CGFloat photoHeight = 0;
    
    if (travelModel.photo_info) {
        NSDictionary *photoInfoDic = travelModel.photo_info;
        photoWidth = [photoInfoDic[@"w"] floatValue];
        photoHeight = [photoInfoDic[@"h"] floatValue];
    } else {
        photoWidth = [travelModel.photo_width floatValue];
        photoHeight = [travelModel.photo_height floatValue];
    }
    
    
    if (photoHeight > 0) {
        CGFloat scale = photoWidth / photoHeight;
        photoHeight = (kWidth - 20) / scale;
    }
    
    CGFloat textHeight = [GCZTravelDayCell getHeightWithString:travelModel.text];
    
    return textHeight + photoHeight;
}

+ (CGFloat)getHeightWithString:(NSString *)textStr {
    
    NSDictionary *textDic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:kTextFontSize] forKey:NSFontAttributeName];
    
    CGRect bounds = [textStr boundingRectWithSize:CGSizeMake(kWidth - 40, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:textDic context:nil];
    
    return bounds.size.height;
}


@end
