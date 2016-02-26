//
//  LayerShow.h
//  TravelApp
//
//  Created by SZT on 15/12/25.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LayerShow : NSObject

- (void)guideShow;

+ (void)waterDropCATransitionWithView:(UIView *)view dration:(CGFloat)dration;

+ (void)fallStarShowWithFallStar:(UIImageView *)fallStar;
+ (void)cloudShowWithCloud:(UIImageView *)cloud;
+ (void)lightningShowWithLigtning:(UIImageView *)lightning;
+ (void)sunshineShowWithSunshine:(UIImageView *)sunshine;


@end
