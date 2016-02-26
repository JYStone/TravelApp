//
//  GCZPlaceModel.h
//  TravelApp
//
//  Created by SZT on 15/12/24.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCZPlaceModel : NSObject

@property (nonatomic,strong) NSString *ID;

@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSString *icon;

@property (nonatomic,strong) NSString *type;

@property (nonatomic,strong) NSDictionary *province;

@property (nonatomic,strong) NSDictionary *country;





@end
