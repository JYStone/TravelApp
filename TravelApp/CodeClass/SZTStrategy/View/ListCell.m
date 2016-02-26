//
//  ListCell.m
//  TravelApp
//
//  Created by SZT on 15/12/23.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "ListCell.h"
#import "MainScreenBound.h"

@interface ListCell()

@property(nonatomic,retain)NSArray  *listArray;


@end

@implementation ListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat buttonW = kWidth/4;
        CGFloat buttonH = buttonW;
        for (int i = 0; i < 4; i++) {
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.backgroundColor = [UIColor redColor];
            button.frame = CGRectMake(buttonW*i, 0, buttonW, buttonH);
            [button setTitle:self.listArray[i] forState:(UIControlStateNormal)];
            button.tag = i;
            [self.contentView addSubview:button];
        }
    }
    return self;
}

#pragma mark------------lazy------------------

-(NSArray *)listArray{
    if (!_listArray) {
        _listArray = [NSArray arrayWithObjects:@"不可错过",@"主题榜单",@"精品游记",@"实用须知", nil];
    }
    return _listArray;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
