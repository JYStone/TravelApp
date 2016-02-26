//
//  Blog.m
//  TravelApp
//
//  Created by SZT on 15/12/25.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "Blog.h"

@implementation Blog

-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    } else if ([key isEqualToString:@"waypoints"]){
        _waypoints = [NSString stringWithFormat:@"%@",value];
    }else if ([key isEqualToString:@"recommendations"]){
        _recommendations = [NSString stringWithFormat:@"%@",value];
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{}

@end
