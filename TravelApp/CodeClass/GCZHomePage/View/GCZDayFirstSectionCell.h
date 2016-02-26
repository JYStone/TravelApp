//
//  GCZDayFirstSectionCell.h
//  TravelApp
//
//  Created by lanou on 15/12/18.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GCZTwoLabelView;
@class GCZTravelListModel;

@interface GCZDayFirstSectionCell : UITableViewCell

@property (nonatomic,strong) UILabel *userNameLabel;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) GCZTwoLabelView *timeView;

@property (nonatomic,strong) GCZTwoLabelView *mileageView;

@property (nonatomic,strong) GCZTwoLabelView *likeView;

@property (nonatomic,strong) GCZTravelListModel *travelListModel;




@end
