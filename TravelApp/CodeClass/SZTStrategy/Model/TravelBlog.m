//
//  TravelBlog.m
//  TravelApp
//
//  Created by SZT on 15/12/24.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "TravelBlog.h"

@implementation TravelBlog

-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{}

@end
