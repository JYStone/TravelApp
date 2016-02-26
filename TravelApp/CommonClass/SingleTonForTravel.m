//
//  SingleTonForTravel.m
//  TravelApp
//
//  Created by lanou on 15/12/25.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "SingleTonForTravel.h"
#import "MainScreenBound.h"

@implementation SingleTonForTravel

static SingleTonForTravel *travelSingleTon;

+ (SingleTonForTravel *)shareTravelSingleTon {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        travelSingleTon = [[SingleTonForTravel alloc] init];
    });
    return travelSingleTon;
}

- (BOOL)isLocate {
    if ([CLLocationManager locationServicesEnabled]) {
        _loactionManager = [[CLLocationManager alloc] init];
        _loactionManager.delegate = self;
        _loactionManager.desiredAccuracy = kCLLocationAccuracyBest;
        _loactionManager.distanceFilter = 10;
        if ([[UIDevice currentDevice] systemVersion].floatValue >= 8.0) {
            [_loactionManager requestWhenInUseAuthorization];
        }
        [_loactionManager startUpdatingLocation];

        return YES;
    } else {
        return NO;

    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            CLPlacemark *pk = [placemarks lastObject];

            if ([self.locationName isEqualToString:pk.locality]) {
                
            } else {
                self.locationName = pk.locality;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"locationCity" object:nil];
            }
        } else {
           
        }
        [_loactionManager stopUpdatingLocation];
        
    }];
    
}

@end
