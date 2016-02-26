//
//  CountryViewController.m
//  TravelApp
//
//  Created by SZT on 15/12/23.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "CountryViewController.h"
#import "CountryDetailViewController.h"
#import "MainScreenBound.h"
#import "CityCell.h"
#import "City.h"

#define kTableViewX 0
#define kTableViewY 0
#define kTableViewW  kWidth
#define kTableViewH  kHeight

@interface CountryViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,retain)NSMutableArray  *allModelsArray;

@property(nonatomic,strong)MBProgressHUD *HUD;

@property(nonatomic,assign)BOOL isNetWorking;

@end

@implementation CountryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectNetAndReloadData) name:@"withWifi" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectNetAndReloadData) name:@"withWWAN" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NONetWorkAlert) name:@"noReachable" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NONetWorkAlert) name:@"withUnknow" object:nil];
    
    self.navigationController.navigationBar.barTintColor = navigationBarBackGroundColor;
    self.navigationController.navigationBar.alpha = 0.8;
    
    self.navigationItem.title = @"攻略";
    
    [self jsonAnalysic];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
    
    self.tabBarController.tabBar.hidden = NO;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self jsonAnalysic];
    }];

}

- (void)connectNetAndReloadData
{
    [self jsonAnalysic];
}



- (void)NONetWorkAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil   message:@"网络不给力" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
       
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];

}


#pragma mark------------lazy------------------

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(kTableViewX, kTableViewY, kTableViewW, kTableViewH) style:(UITableViewStylePlain)];
    }
    return _tableView;
}




#pragma mark------------tableView数据源------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allModelsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idetifier = @"cell";
    CityCell *cityCell = [tableView dequeueReusableCellWithIdentifier:idetifier];
    if (cityCell == nil) {
        cityCell = [[CityCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:idetifier];
    }
    City *city = self.allModelsArray[indexPath.row];
    cityCell.city = city;
    return cityCell;
}

#pragma mark------------tableView代理------------------

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    
    City *city = self.allModelsArray[indexPath.row];
    CountryDetailViewController *countryDetailVC = [[CountryDetailViewController alloc]init];
    countryDetailVC.city = city;
    
    [self.navigationController pushViewController:countryDetailVC animated:YES];

    UIImage *image = cell.iconImage.image;

}




#pragma mark------------json 解析------------------

- (void)jsonAnalysic
{
    [LORequestManger GET:@"http://api.breadtrip.com/destination/index_places/8/" success:^(id response) {
        
        self.allModelsArray = [NSMutableArray array];
        
        NSDictionary *rootDict = (NSDictionary *)response;
        NSArray *rootArray = rootDict[@"data"];
        for (NSDictionary *dict in rootArray) {
            City *city = [[City alloc]init];
            [city setValuesForKeysWithDictionary:dict];
            [self.allModelsArray addObject:city];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil   message:@"网络不给力" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];

        
    }];
}




@end
