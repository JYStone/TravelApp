//
//  GCZEveryDayStoryCell.h
//  TravelApp
//
//  Created by lanou on 15/12/17.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCZEveryDayStoryCell : UITableViewCell

- (void)setPictureViewWith:(NSArray *)imageArray delegate:(id)delegate action:(SEL)action;

+ (CGFloat)heightForRow;

@end
