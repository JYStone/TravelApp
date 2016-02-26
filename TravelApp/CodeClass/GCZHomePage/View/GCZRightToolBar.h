//
//  GCZRightToolBar.h
//  TravelApp
//
//  Created by SZT on 15/12/26.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCZRightToolBar : UIToolbar

- (instancetype)initRightToolBarWithFrame:(CGRect)frame Delegate:(id)delegate shareAction:(SEL)shareAction collectAction:(SEL)collectionAction;

@end
