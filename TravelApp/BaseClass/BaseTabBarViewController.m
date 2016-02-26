//
//  BaseTabBarViewController.m
//  TravelApp
//
//  Created by SZT on 15/12/17.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "MainScreenBound.h"
#import "BaseTabBarViewController.h"
#import "WeatherViewController.h"
#import "HomePageTableViewController.h"
#import "MainScreenBound.h"

#import "CountryViewController.h"

//攻略出门
#import "StrategyViewController.h"


@interface BaseTabBarViewController ()

#pragma mark --------- 首页模块属性------------

#pragma mark ---------攻略模块属性------------







@property (nonatomic,strong) StrategyViewController *strategyVC;//出门页面

@property(nonatomic,strong)CountryViewController *countryVC;

@property (nonatomic, strong) HomePageTableViewController *homePageTVC;
@property (nonatomic, strong) WeatherViewController *weatherVC;



#pragma mark ---------天气模块属性------------

#pragma mark ---------设置模块属性------------

@end

@implementation BaseTabBarViewController
- (UIStatusBarStyle)preferredStatusBarStyle

{
    
    return UIStatusBarStyleLightContent;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self preferredStatusBarStyle];
//    [self childViewControllerForStatusBarStyle];
//    [self setNeedsStatusBarAppearanceUpdate];
    
    
        

    
    //首页
    self.homePageTVC = [[HomePageTableViewController alloc]initWithStyle:(UITableViewStylePlain)];
    
    //攻略
    self.countryVC = [[CountryViewController alloc]init];
    
    //好玩
    self.strategyVC = [[StrategyViewController alloc]init];
    
    //天气
    self.weatherVC = [[WeatherViewController alloc]init];
    //设置

    #pragma mark ---------------------
    
    self.tabBar.tintColor = [UIColor blackColor];
    [self addChildViewController:self.homePageTVC title:@"首页" image:@"Home@2x.jpg"];
    
    [self addChildViewController:self.countryVC title:@"攻略" image:@"Travel@2x.jpg"];
    
    [self addChildViewController:self.strategyVC title:@"好玩" image:@"Goout@2x.jpg"];
    
    [self addChildViewController:self.weatherVC title:@"天气" image:@"WeatherCare@2x.jpg"];
    self.strategyVC.navigationController.navigationBar.translucent = NO;
    
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"set@2x.jpg"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:(UIBarButtonItemStylePlain) target:self action:@selector(changeFrame)];
    
    self.strategyVC.navigationController.navigationBar.translucent = NO;
    
    self.homePageTVC.navigationItem.leftBarButtonItem = leftBarButton;
//    self.weatherVC.navigationItem.leftBarButtonItem = leftBarButton;

    

}


#pragma mark ---------lazy------------


- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title image:(NSString *)image
{
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:childController];
    
    navc.tabBarItem.title = title;

    navc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];

    [self addChildViewController:navc];
}


- (void)changeFrame {


    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
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
