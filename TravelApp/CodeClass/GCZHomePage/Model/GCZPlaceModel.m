//
//  GCZPlaceModel.m
//  TravelApp
//
//  Created by SZT on 15/12/24.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "GCZPlaceModel.h"

@implementation GCZPlaceModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setValue:(id)value forKey:(nonnull NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}
@end
