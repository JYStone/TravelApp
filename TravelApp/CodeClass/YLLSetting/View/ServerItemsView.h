//
//  ServerItemsView.h
//  TravelApp
//
//  Created by SZT on 16/1/5.
//  Copyright © 2016年 SZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServerItemsView : UIView
@property (nonatomic, strong) UILabel *titleLabel;//服务条款
@property (nonatomic, strong) UILabel *editionLabel;//版本信息
@property (nonatomic, strong) UILabel *edition;
@property (nonatomic, strong) UILabel *statementLanel;//声明
@property (nonatomic, strong) UIScrollView *scrollView;
@end
