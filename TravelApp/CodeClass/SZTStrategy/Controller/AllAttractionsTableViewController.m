//
//  AllAttractionsTableViewController.m
//  TravelApp
//
//  Created by SZT on 15/12/25.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "AllAttractionsTableViewController.h"
#import "AttractionDetailViewController.h"
#import "AllAttractionCell.h"
#import "TouristAttraction.h"
#import "MainScreenBound.h"
#import "City.h"

@interface AllAttractionsTableViewController ()

@property(nonatomic,assign)NSInteger  currentCount;

@property(nonatomic,copy)NSString   *next;

@property(nonatomic,strong)MBProgressHUD *hud;

@end

@implementation AllAttractionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.next = @"0";
    
    [self jsonOfTouristAttraction];
    [self.tableView registerClass:[AllAttractionCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
       
        [self jsonOfTouristAttraction];
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentCount = 0;
        [self jsonOfTouristAttraction];
    }];
    
}

#pragma mark------------lazy------------------

-(NSMutableArray *)allAttractions{
    if (!_allAttractions) {
        _allAttractions = [[NSMutableArray alloc]init];
    }
    return _allAttractions;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.allAttractions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AllAttractionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    TouristAttraction *touristAttraction = self.allAttractions[indexPath.row];
    cell.touristAttraction = touristAttraction;
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttractionDetailViewController *attractionDetailVC = [[AttractionDetailViewController alloc]init];
    attractionDetailVC.touristAttraction = self.allAttractions[indexPath.row];
    
    [self.navigationController pushViewController:attractionDetailVC animated:YES];
}


- (void)AlertDismiss:(UIAlertController *)alert
{
    [alert dismissViewControllerAnimated:YES completion:nil];
}

//上拉下拉刷新加载数据
- (void)jsonOfTouristAttraction
{

    if (self.next == nil) {
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"已无更多数据" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        [self presentViewController:alertController animated:YES completion:nil];
        
        [self performSelector:@selector(AlertDismiss:) withObject:alertController afterDelay:2];

        
    }else{
        [LORequestManger GET:[NSString stringWithFormat:@"http://api.breadtrip.com/destination/place/%@/%@/pois/all/?sort=default&start=%ld",self.city.type,self.city.ID,(long)self.currentCount] success:^(id response) {
            
               NSDictionary *rootDicts = (NSDictionary *)response;

        if ([rootDicts[@"next_start"] isKindOfClass:[NSNull class] ]) {
            self.next = nil;
            
            
        }else{
            self.currentCount = [rootDicts[@"next_start"] integerValue];
            
        }

        
        NSArray *rootArray = rootDicts[@"items"];
        for (NSDictionary *dict in rootArray) {
            TouristAttraction *touristAttraction = [[TouristAttraction alloc]init];
            [touristAttraction setValuesForKeysWithDictionary:dict];
            [self.allAttractions addObject:touristAttraction];
        }
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        }];
        
    }
}




@end
