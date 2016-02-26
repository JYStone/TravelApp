//
//  GCZMoreStoryCell.h
//  TravelApp
//
//  Created by lanou on 15/12/19.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GCZTravelListModel;
@class GCZStoryViewForCell;

@interface GCZMoreStoryCell : UICollectionViewCell

@property (nonatomic,strong) GCZTravelListModel *storyModel;

@property (nonatomic,strong) UIImageView *coverImageView;

@property (nonatomic,strong) UILabel *coverTextLabel;

@property (nonatomic,strong) UILabel *userNameLabel;

@property (nonatomic,strong) UIImageView *userIconView;


@end
