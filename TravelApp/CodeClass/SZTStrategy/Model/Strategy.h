//
//  Strategy.h
//  TravelApp
//
//  Created by SZT on 15/12/17.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Strategy : NSObject



@property (nonatomic,copy) NSString *content_url;//跳转内容url

@property (nonatomic,copy) NSString *cover_image_url;//图片url

@property (nonatomic,copy) NSString *created_at;//

@property (nonatomic,copy) NSString *likes_count;//点赞的个数

@property (nonatomic,copy) NSString *published_at;

@property (nonatomic,copy) NSString *share_msg;// 详细描述

@property (nonatomic,copy) NSString *short_title;//  短标题

@property (nonatomic,copy) NSString *title;//主标题

@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *updated_at;

@property (nonatomic,copy) NSString *url;




@end
