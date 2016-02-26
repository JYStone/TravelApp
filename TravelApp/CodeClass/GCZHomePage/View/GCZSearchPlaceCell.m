//
//  GCZSearchPlaceCell.m
//  TravelApp
//
//  Created by lanou on 15/12/24.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "GCZSearchPlaceCell.h"
#import "GCZPlaceModel.h"
#import "MainScreenBound.h"

@implementation GCZSearchPlaceCell

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
        self.countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 120, 44)];
        [self.contentView addSubview:self.countryLabel];
        
        self.provinceLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, kWidth - 140, 44)];
        self.provinceLabel.textColor = [UIColor grayColor];
        self.provinceLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.provinceLabel];
    }
    return self;
    
}

- (void)setPlaceModel:(GCZPlaceModel *)placeModel {
    
    if (_placeModel != placeModel) {
        _placeModel = placeModel;
        
        if (placeModel.province[@"name_en"] == NULL && placeModel.province[@"name"] != NULL) {
            self.provinceLabel.text = placeModel.province[@"name"];
        } else if (placeModel.province[@"name_en"] != NULL) {
            self.provinceLabel.text = placeModel.province[@"name_en"];
        } else {
            self.provinceLabel.text = placeModel.name;
        }
        if (placeModel.country[@"name_orig"]  == NULL) {
            self.countryLabel.text = placeModel.name;
        } else {
            self.countryLabel.text = placeModel.country[@"name_orig"];
        }
    }
    
    
}

@end
