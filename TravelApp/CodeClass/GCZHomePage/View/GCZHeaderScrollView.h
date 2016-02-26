//
//  GCZHeaderScrollView.h
//  TravelApp
//
//  Created by SZT on 15/12/17.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCZHeaderScrollView : UIScrollView

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setTimerForRollImage:(NSTimeInterval)timerInterval delegate:(id)delegate action:(SEL)action;

- (void)setRollImageWithImageArray:(NSArray *)imageArray delegate:(id)delegate action:(SEL)action;


@end
