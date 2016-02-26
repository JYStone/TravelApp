//
//  AllAttractionsTableViewController.h
//  TravelApp
//
//  Created by SZT on 15/12/25.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TouristAttraction;
@class City;

@interface AllAttractionsTableViewController : UITableViewController

@property(nonatomic,strong)TouristAttraction *touristAttraction;

@property(nonatomic,retain)NSMutableArray  *allAttractions;

@property(nonatomic,retain)City  *city;


@end
