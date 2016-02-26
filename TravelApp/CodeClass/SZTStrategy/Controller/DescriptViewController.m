//
//  DescriptViewController.m
//  TravelApp
//
//  Created by SZT on 15/12/25.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "DescriptViewController.h"
#import "MainScreenBound.h"


#define kLabelX  5
#define kLabelY  10
#define kLabelW  (kWidth-2*kLabelX)
#define kLabelH  kHeight-50


@interface DescriptViewController ()

@property(nonatomic,strong)UILabel *descLabel;

@end

@implementation DescriptViewController

- (void)viewDidLoad {
    
    self.navigationController.navigationBarHidden = NO;
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    Font *font = [Font shareWithFont];
    self.descLabel = [[UILabel alloc]initWithFrame:CGRectMake(kLabelX, kLabelY, kLabelW, kLabelH)];
    self.descLabel.font = [UIFont fontWithName:font.fontName size:12];
    self.descLabel.numberOfLines = 0;
    [self.view addSubview:self.descLabel];

    self.descLabel.textAlignment = NSTextAlignmentJustified;
    self.descLabel.text = self.descript;
}


@end
