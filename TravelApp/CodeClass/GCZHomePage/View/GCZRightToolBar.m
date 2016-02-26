//
//  GCZRightToolBar.m
//  TravelApp
//
//  Created by SZT on 15/12/26.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "GCZRightToolBar.h"
#import "TravelFMDataBase.h"

@implementation GCZRightToolBar

- (instancetype)initRightToolBarWithFrame:(CGRect)frame Delegate:(id)delegate shareAction:(SEL)shareAction collectAction:(SEL)collectionAction {

    self = [super initWithFrame:frame];
    if (self) {
        //设置右侧barButtonItems
        NSMutableArray *buttons = [[NSMutableArray alloc] init];
        UIButton *button        = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[[UIImage imageNamed:@"share_selected"]
                                    imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]
                          forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        
        [button addTarget:delegate
                   action:shareAction
         forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 25, 25);
        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.backgroundColor = [UIColor clearColor];
        
        UIButton *anotherButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [anotherButton1 setBackgroundImage:[[UIImage imageNamed:@"yw_detail_collecticon"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]
                                  forState:(UIControlStateNormal)];
        anotherButton1.backgroundColor = [UIColor clearColor];
        [anotherButton1 setBackgroundImage:[[UIImage imageNamed:@"yw_detail_collectedicon"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]
                                  forState:(UIControlStateSelected)];
        [anotherButton1 addTarget:delegate
                           action:collectionAction
                 forControlEvents:(UIControlEventTouchUpInside)];
        anotherButton1.frame = CGRectMake(0, 0, 25, 25);
        UIBarButtonItem *rButton = [[UIBarButtonItem alloc] initWithCustomView:anotherButton1];
        rButton.customView.backgroundColor = [UIColor clearColor];
        rightButtonItem.customView.backgroundColor = [UIColor clearColor];
        
        [buttons addObject:rButton];
        [buttons addObject:rightButtonItem];
        
        [self setItems:buttons animated:NO];
        self.clipsToBounds = YES;
    }
    return self;
}

@end
