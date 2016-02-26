//
//  AllBlogTableViewController.m
//  TravelApp
//
//  Created by SZT on 15/12/25.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "AllBlogTableViewController.h"
#import "TouristAttraction.h"
#import "MainScreenBound.h"
#import "StrategyUrl.h"
#import "Blog.h"
#import "BlogCell.h"
#import "City.h"
#import "GCZTravelListTVC.h"
#import "UINavigationBar+Awesome.h"

@interface AllBlogTableViewController ()

@property(nonatomic,retain)NSMutableArray  *allBlogs;

@end

@implementation AllBlogTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self jsonOfAllBlogs];
    
    [self.tableView registerClass:[BlogCell class] forCellReuseIdentifier:@"cell"];
    
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.allBlogs.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BlogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Blog *blog = self.allBlogs[indexPath.row];
    cell.blog = blog;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GCZTravelListTVC *travelListTVC = [[GCZTravelListTVC alloc]initWithStyle:(UITableViewStylePlain)];
    Blog *blog = self.allBlogs[indexPath.row];
    travelListTVC.travel_id = [NSString stringWithFormat:kTravelListUrl ,blog.ID];
    travelListTVC.travel_type = @"4";
    
    [self.navigationController pushViewController:travelListTVC animated:YES];
    
}

#pragma mark------------json------------------

- (void)jsonOfAllBlogs
{
    self.allBlogs = [NSMutableArray array];
    NSString *urlString = [NSString stringWithFormat:kGoodBlogUrl,self.city.type,self.city.ID] ;

    [LORequestManger GET:[NSString stringWithFormat:kGoodBlogUrl,self.city.type,self.city.ID] success:^(id response) {
        NSDictionary *rootDict = (NSDictionary *)response;
        NSArray *rootArray = rootDict[@"items"];
        for (NSDictionary *dic in rootArray) {
            Blog *blog  = [[Blog alloc]init];
            [blog setValuesForKeysWithDictionary:dic];
            [self.allBlogs addObject:blog];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}




@end
