//
//  AllAttractionCell.m
//  TravelApp
//
//  Created by SZT on 15/12/25.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "AllAttractionCell.h"
#import "MainScreenBound.h"
#import "TouristAttraction.h"


#define kIconImgaeX  10
#define kIconImgaeY  5
#define kIconImgaeW  80
#define kIconImgaeH  80

#define kNamelabelX   (kIconImgaeX+kIconImgaeW+20)
#define kNamelabelY   kIconImgaeY
#define kNamelabelW   100
#define kNamelabelH   30

#define kDescritpX    kNamelabelX
#define kDescritpY    (kNamelabelY+kNamelabelH)
#define kDescritpW    (kWidth-kDescritpX-10)
#define kDescritpH     40

#define kCountX   kNamelabelX
#define kCountY   (kDescritpY+kDescritpH)+5
#define kCountW   25
#define kCountH   15

@interface AllAttractionCell()

@property(nonatomic,strong)UIImageView *iconImage;

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *recommandLabel;

@property(nonatomic,strong)UILabel *countLabel;

@end

@implementation AllAttractionCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *backimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 100)];
        backimage.image = [UIImage imageNamed:@"cellbeijing"];
        [self.contentView addSubview:backimage];
        
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(kIconImgaeX, kIconImgaeY, kIconImgaeW, kIconImgaeH)];
//        _iconImage.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_iconImage];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kNamelabelX, kNamelabelY, kNamelabelW, kNamelabelH)];
        _nameLabel.font = [UIFont fontWithName:[Font shareWithFont].fontName size:15];
//        _nameLabel.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:_nameLabel];
        
        _recommandLabel = [[UILabel alloc]initWithFrame:CGRectMake(kDescritpX, kDescritpY, kDescritpW, kDescritpH)];
        _recommandLabel.numberOfLines = 2;
        _recommandLabel.font = [UIFont fontWithName:[Font shareWithFont].fontName size:11];
//        _recommandLabel.backgroundColor = [UIColor cyanColor];
        [self.contentView addSubview:_recommandLabel];
        
        _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(kCountX, kCountY, kCountW, kCountH)];
//        _countLabel.backgroundColor  = [UIColor grayColor];
        _countLabel.font = [UIFont fontWithName:[Font shareWithFont].fontName size:11];
        [self.contentView addSubview:_countLabel];
        
        UILabel *quguoLabel = [[UILabel alloc]initWithFrame:CGRectMake(kCountX+kCountW+3, kCountY, 45, kCountH)];
        quguoLabel.text = @"去过";
        quguoLabel.font = [UIFont fontWithName:[Font shareWithFont].fontName size:11];
        [self.contentView addSubview:quguoLabel];
    }
    return self;
}


-(void)setTouristAttraction:(TouristAttraction *)touristAttraction
{
    if (_touristAttraction != touristAttraction) {
        
        _touristAttraction = touristAttraction;
        [_iconImage sd_setImageWithURL:[NSURL URLWithString:touristAttraction.cover]];
        _nameLabel.text = touristAttraction.name;
        _recommandLabel.text = touristAttraction.recommended_reason;
        _countLabel.text = touristAttraction.visited_count;
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
