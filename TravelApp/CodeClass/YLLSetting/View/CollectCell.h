//
//  CollectCell.h
//  TravelApp
//
//  Created by SZT on 15/12/26.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCZTravelListModel;

@interface CollectCell : UITableViewCell

@property(nonatomic,strong)UIImageView *iconImage;

@property(nonatomic,strong)UILabel *titleLabel;


@property(nonatomic,retain)GCZTravelListModel  *model;

@end
