//
//  GCZTravelDayModel.h
//  TravelApp
//
//  Created by SZT on 15/12/18.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCZTravelDayModel : NSObject

@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *text;

@property (nonatomic,strong) NSString *local_time;

@property (nonatomic,strong) NSString *photo_1600;

@property (nonatomic,strong) NSString *photo_height;

@property (nonatomic,strong) NSString *photo_width;


@property (nonatomic,strong) NSString *date;

@property (nonatomic,strong) NSString *day;





@property (nonatomic,copy) NSArray *waypoints;

@property (nonatomic,strong) NSDictionary *photo_info;

@property (nonatomic,strong) NSArray *spot_list;








@end
