//
//  CityViewController.h
//  TravelApp
//
//  Created by SZT on 15/12/20.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CityViewControllerDelegate <NSObject>

- (void)chooseWithCity:(NSString *)cityName;

@end

@interface CityViewController : UIViewController

@property (nonatomic, strong) NSString *locationCity;
@property (nonatomic, assign) id<CityViewControllerDelegate> delegate;

@end
