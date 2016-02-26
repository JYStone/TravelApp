//
//  GCZTravelDayCell.h
//  TravelApp
//
//  Created by lanou on 15/12/18.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GCZTravelDayModel;

@interface GCZTravelDayCell : UITableViewCell

- (void)setImageViewTextWithModel:(GCZTravelDayModel *)travelMoel;

+ (CGFloat)getHeightWithModel:(GCZTravelDayModel *)travelModel;

@end
