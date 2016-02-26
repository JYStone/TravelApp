//
//  StoryModel.h
//  TravelApp
//
//  Created by SZT on 15/12/17.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryModel : NSObject

//故事的id
@property (nonatomic,strong) NSString *trip_id;

//图片
@property (nonatomic,strong) NSString *cover_image_1600;

//封面图片
@property (nonatomic,strong) NSString *index_cover;

//封面图片下方描述文字
@property (nonatomic,strong) NSString *index_title;

@property (nonatomic,strong) NSDictionary *user;

@property (nonatomic,strong) NSString *spot_id;

@property (nonatomic,strong) NSString *text;



@end
