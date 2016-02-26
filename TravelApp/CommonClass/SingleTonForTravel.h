//
//  SingleTonForTravel.h
//  TravelApp
//
//  Created by lanou on 15/12/25.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SingleTonForTravel : NSObject <CLLocationManagerDelegate>


+ (SingleTonForTravel *)shareTravelSingleTon;

- (BOOL)isLocate;

@property (nonatomic, strong) CLLocationManager *loactionManager;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, assign) BOOL isLogin;

@end
