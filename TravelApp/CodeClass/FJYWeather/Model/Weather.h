//
//  Weather.h
//  TravelApp
//
//  Created by SZT on 15/12/17.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject

@property (nonatomic, strong) NSString *currentDate;
@property (nonatomic, strong) NSString *error;
@property (nonatomic, strong) NSString *currentCity;
@property (nonatomic, strong) NSMutableArray *hintIndex;
@property (nonatomic, strong) NSString *pm25;
@property (nonatomic, strong) NSArray *recentWeather;
@property (nonatomic, strong) NSString *status;


@end
