//
//  CityCollectionViewCell.m
//  Weather
//
//  Created by SZT on 15/12/17.
//  Copyright © 2015年 lanou. All rights reserved.
//

#import "CityCollectionViewCell.h"

@implementation CityCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.cityName = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x -3 , self.bounds.origin.y, self.bounds.size.width+10, self.bounds.size.height)];
        self.cityName.textAlignment = NSTextAlignmentCenter;
        self.cityName.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.cityName];
        
    }
    return self;
}
@end
