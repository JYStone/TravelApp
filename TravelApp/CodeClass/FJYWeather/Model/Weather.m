//
//  Weather.m
//  TravelApp
//
//  Created by SZT on 15/12/17.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "Weather.h"

@implementation Weather

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"results"]) {
        self.currentCity = value[0][@"currentCity"];
        self.hintIndex = [value[0][@"index"] mutableCopy];
        self.recentWeather = value[0][@"weather_data"];
        self.pm25 = value[0][@"pm25"];
    }
    
    if ([key isEqualToString:@"date"]) {
        self.currentDate = value;
    }
    
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


@end
