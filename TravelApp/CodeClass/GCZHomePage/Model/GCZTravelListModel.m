//
//  GCZTravelListModel.m
//  TravelApp
//
//  Created by SZT on 15/12/18.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "GCZTravelListModel.h"

@implementation GCZTravelListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
    if ([key isEqualToString:@"day_count"]) {
        self.day_count = [NSString stringWithFormat:@"%@", value];
    }
    
    if ([key isEqualToString:@"view_count"]) {
        self.view_count = [NSString stringWithFormat:@"%@", value];
    }

    
}
@end
