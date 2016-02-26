//
//  Font.m
//  TravelApp
//
//  Created by SZT on 15/12/22.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "Font.h"


static Font *font = nil;

@implementation Font

+ (Font *)shareWithFont {
    static dispatch_once_t onceTon;
    dispatch_once(&onceTon, ^{
        font = [[Font alloc] init];
    });
    return font;
}


@end
