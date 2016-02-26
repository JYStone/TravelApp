//
//  GCZStoryDetailCell.m
//  TravelApp
//
//  Created by lanou on 15/12/21.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "GCZStoryDetailCell.h"
#import "MainScreenBound.h"
#import "GCZTravelListModel.h"

@implementation GCZStoryDetailCell

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
        _pictureView = [[UIImageView alloc] init];
        _textLabel1 = [[UILabel alloc] init];
        _textLabel1.font = [UIFont systemFontOfSize:14];
        _textLabel1.numberOfLines = 0;
    
        [self.contentView addSubview:_pictureView];
        [self.contentView addSubview:_textLabel1];
    }
    return self;
}

- (void)setStoryModel:(GCZTravelListModel *)storyModel {
    if (_storyModel != storyModel) {
        _storyModel = storyModel;
                
        CGFloat pictureHeight = [GCZStoryDetailCell heightForImageViewWithModel:storyModel];
        CGFloat textHeight = [GCZStoryDetailCell HeightForTextWithModel:storyModel fontSize:14 surplusWidth:20];
        
        _pictureView.frame = CGRectMake(20, 10, kWidth - 40, pictureHeight);
        [_pictureView sd_setImageWithURL:[NSURL URLWithString:storyModel.photo_1600]];
        
        _textLabel1.frame = CGRectMake(20, _pictureView.frame.size.height + 15, kWidth - 40, textHeight);
        _textLabel1.text = storyModel.text;
        
    }
    
    
}


+ (CGFloat)HeightForTextWithModel:(GCZTravelListModel *)model fontSize:(NSInteger)fontSize surplusWidth:(CGFloat)surplusWidth {
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontSize] forKey:NSFontAttributeName];
    
    CGRect bounds = [model.text boundingRectWithSize:CGSizeMake(kWidth - 2 * surplusWidth, 1111111) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    return bounds.size.height;
}

+ (CGFloat)heightForImageViewWithModel:(GCZTravelListModel *)model {
    
    CGFloat pictureHeight = [model.photo_height floatValue];
    CGFloat pictureWidth = [model.photo_width floatValue];
    CGFloat scale = 0;
    if (pictureHeight > 0) {
     scale = pictureWidth / pictureHeight;
    }
    
    CGFloat height = (kWidth - 40) / scale;
    return height;
}


@end
