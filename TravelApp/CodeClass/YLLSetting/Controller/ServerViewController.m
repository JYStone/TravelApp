//
//  ServerViewController.m
//  TravelApp
//
//  Created by SZT on 16/1/5.
//  Copyright © 2016年 SZT. All rights reserved.
//
#import "MainScreenBound.h"
#import "ServerViewController.h"
#import "ServerItemsView.h"

@interface ServerViewController ()
@property (nonatomic, retain) ServerItemsView *serverView;

@end

@implementation ServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.serverView = [[ServerItemsView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight * 1.8)];
    self.serverView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.serverView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
