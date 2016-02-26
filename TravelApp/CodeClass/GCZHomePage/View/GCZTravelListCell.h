//
//  GCZTravelListCell.h
//  TravelApp
//
//  Created by lanou on 15/12/18.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GCZTravelListModel;

@interface GCZTravelListCell : UITableViewCell

@property (nonatomic,strong) GCZTravelListModel *travelModel;

- (void)setRecommendProductsWithImageModel:(GCZTravelListModel *)model;

- (void)setHotTravelWithImageModel:(GCZTravelListModel *)model;
@end
