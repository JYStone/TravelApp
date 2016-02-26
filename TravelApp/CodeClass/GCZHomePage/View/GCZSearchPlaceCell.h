//
//  GCZSearchPlaceCell.h
//  TravelApp
//
//  Created by lanou on 15/12/24.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GCZPlaceModel;


@interface GCZSearchPlaceCell : UITableViewCell

@property (nonatomic,strong) GCZPlaceModel *placeModel;

@property (nonatomic,strong) UILabel *countryLabel;

@property (nonatomic,strong) UILabel *provinceLabel;



@end
