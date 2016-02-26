//
//  FJYAlertShow.h
//  TravelApp
//
//  Created by SZT on 15/12/24.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FJYAlertShow : NSObject

+ (UIAlertController *)noReachableState;
+ (UIAlertController *)noLocationService;
+ (UIAlertController *)WithWWANState;
+ (UIAlertController *)networkUnkownState;
+ (UIAlertController *)noSearchResult;
@end
