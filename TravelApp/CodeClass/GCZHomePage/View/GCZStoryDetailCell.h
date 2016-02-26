//
//  GCZStoryDetailCell.h
//  TravelApp
//
//  Created by lanou on 15/12/21.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GCZTravelListModel;

@interface GCZStoryDetailCell : UITableViewCell

@property (nonatomic,strong) UIImageView *pictureView;

@property (nonatomic,strong) UILabel *textLabel1;

@property (nonatomic,strong) GCZTravelListModel *storyModel;

+ (CGFloat)heightForImageViewWithModel:(GCZTravelListModel *)model;

+ (CGFloat)HeightForTextWithModel:(GCZTravelListModel *)model fontSize:(NSInteger)fontSize surplusWidth:(CGFloat)surplusWidth;

@end
