//
//  TravelBlog.h
//  TravelApp
//
//  Created by SZT on 15/12/24.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <Foundation/Foundation.h>


//精品游记
@interface TravelBlog : NSObject

@property(nonatomic,copy)NSString *cover_image;
@property(nonatomic,copy)NSString *cover_image_1600;
@property(nonatomic,copy)NSString *cover_image_default;
@property(nonatomic,copy)NSString *cover_image_w640;
@property(nonatomic,copy)NSString *date_added;
@property(nonatomic,copy)NSString *date_complete;
@property(nonatomic,copy)NSString *day_count;

//@property(nonatomic,copy)NSString *default;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *last_modified;
@property(nonatomic,copy)NSString *mileage;
@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *recommendations;
@property(nonatomic,copy)NSString *version;
@property(nonatomic,copy)NSString *waypoints;
@property(nonatomic,copy)NSString *wifi_sync;

@end
