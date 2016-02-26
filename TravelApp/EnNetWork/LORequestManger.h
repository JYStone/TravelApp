//
//  LORequestManger.h
//  PlanB
//
//  Created by young on 15/5/6.
//  Copyright (c) 2015年 young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
/**
 *  base网络请求
 */

@interface LORequestManger : NSObject

// JSON Post请求
+ (void)POST:(NSString *)URL params:(NSDictionary * )params success:(void (^)(id response))success
     failure:(void (^)(AFHTTPRequestOperation *operation,NSError *error))Error;

// JSON Get请求
+ (void)GET:(NSString *)URL
    success:(void (^)(id response))success
    failure:(void (^)(AFHTTPRequestOperation *operation,NSError *error))Error;

// 上传图片(post方法)
+ (void)UPLOADIMAGE:(NSString *)URL
             params:(NSDictionary *)params
        uploadImage:(UIImage *)image
            success:(void (^)(id response))success
            failure:(void (^)(AFHTTPRequestOperation *operation,NSError *error))Error;
@end
