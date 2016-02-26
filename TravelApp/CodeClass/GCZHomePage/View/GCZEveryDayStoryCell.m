//
//  GCZEveryDayStoryCell.m
//  TravelApp
//
//  Created by lanou on 15/12/17.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "GCZEveryDayStoryCell.h"
#import "GCZTapImageView.h"
#import "MainScreenBound.h"
#import "StoryModel.h"

#import "GCZStoryViewForCell.h"
#define kScale 0.75

@implementation GCZEveryDayStoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = kCellBackGroundColor;
    }
    return self;
}

- (void)setPictureViewWith:(NSArray *)imageArray delegate:(id)delegate action:(SEL)action {
    
    StoryModel *storyModel = [[StoryModel alloc] init];
    
    if ([self.contentView viewWithTag:1003]) {
        NSArray *subArray = self.contentView.subviews;
        for (id view in subArray) {
            [view removeFromSuperview];
        }
    }
    if (imageArray.count > 0) {
        for (int i = 0; i < 4; i ++) {
            
            storyModel = imageArray[i];
            
            NSInteger col = i % 2;
            NSInteger row = i / 2;
            CGFloat TapWidth = (kWidth - 30) / 2;
            CGFloat TapHeight = TapWidth * kScale + 75;
            
            GCZStoryViewForCell *smallView = [[GCZStoryViewForCell alloc] initWithFrame:CGRectMake(10 + col * (10 + TapWidth), 10 + row * (5 + TapHeight), TapWidth, TapHeight) delegate:delegate action:action imageHeightScale:kScale];
            
            
            [smallView.coverImageView sd_setImageWithURL:[NSURL URLWithString:storyModel.index_cover]];
            if ([storyModel.index_title isEqualToString:@""]) {
                smallView.coverTextLabel.text = storyModel.text;
            } else {
                smallView.coverTextLabel.text = storyModel.index_title;
            }
            NSDictionary *userDic = storyModel.user;
            [smallView.userIconView sd_setImageWithURL:[NSURL URLWithString:userDic[@"avatar_m"]]];
            smallView.userNameLabel.text = userDic[@"name"];
            smallView.tag = 1000 + i;
            [self.contentView addSubview:smallView];
        }
    }
    
}


+ (CGFloat)heightForRow {
    CGFloat height = 2 * ((kWidth - 30) / 2 * kScale + 75) + 10;
    return height;
}
@end
