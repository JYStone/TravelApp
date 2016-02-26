//
//  Font.h
//  TravelApp
//
//  Created by SZT on 15/12/22.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Font : NSObject

+ (Font *)shareWithFont;

@property (nonatomic, strong) NSString *fontName;

@end
