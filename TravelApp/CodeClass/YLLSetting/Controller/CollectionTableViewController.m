//
//  CollectionTableViewController.m
//  TravelApp
//
//  Created by SZT on 15/12/26.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "CollectionTableViewController.h"
#import "MainScreenBound.h"
#import "CollectCell.h"
//#import "City.h"
#import "TouristAttraction.h"
#import "AttractionDetailViewController.h"

@interface CollectionTableViewController ()

@property(nonatomic,retain)NSArray  *collectBlogs;

@property(nonatomic,retain)NSArray  *collectAttractions;

@property(nonatomic,retain)NSArray  *collectStorys;

@property(nonatomic,retain)NSArray  *titleArray;

@end

@implementation CollectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectBlogs = [[TravelFMDataBase shareTravelDataBase] selectAllDataWithTable:@"HotStory"];
    self.collectStorys = [[TravelFMDataBase shareTravelDataBase] selectAllDataWithTable:@"EveryDayStory"];
    self.collectAttractions = [[TravelFMDataBase shareTravelDataBase] selectAllDataWithTable:@"TouristAttractionDeail"];

    
    self.tableView.separatorStyle = NO;
}


#pragma mark - Table view data source

-(NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSArray arrayWithObjects:@"精品游记",@"景点",@"每日故事", nil];
    }
    return _titleArray;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return self.collectBlogs.count;
    }else if (section == 1){
        return self.collectAttractions.count;
    }else{
        return self.collectStorys.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"cell";
    CollectCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
    
    if (cell == nil) {
        cell = [[CollectCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    
    GCZTravelListModel *model = nil;
    if (indexPath.section == 0) {
        model = self.collectBlogs[indexPath.row];
    }else if (indexPath.section == 1){
        model = self.collectAttractions[indexPath.row];
    }else if (indexPath.section == 2){
        model = self.collectStorys[indexPath.row];
    }
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        GCZTravelListModel *model = [[GCZTravelListModel alloc] init];
        GCZTravelListTVC *travelTVC = [[GCZTravelListTVC alloc] init];
        model = self.collectBlogs[indexPath.row];
        travelTVC.travel_id = [NSString stringWithFormat:kTravelListUrl ,model.url];
        travelTVC.travel_type = @"4";
        [self.navigationController pushViewController:travelTVC animated:YES];
        
    }else if (indexPath.section == 1){
        
        AttractionDetailViewController *attractionDVC = [[AttractionDetailViewController alloc]init];
        GCZTravelListModel *model = self.collectAttractions[indexPath.row];
        TouristAttraction *touristAttractoin = [[TouristAttraction alloc]init];
        touristAttractoin.type = model.type;
        touristAttractoin.ID = model.url;
        touristAttractoin.cover = model.cover;
        touristAttractoin.name = model.title;
        touristAttractoin.recommended_reason = model.recommended;
        
        attractionDVC.touristAttraction = touristAttractoin;
        [self.navigationController pushViewController:attractionDVC animated:YES];
        
    }else if (indexPath.section == 2){
        
        GCZTravelListModel *model = [[GCZTravelListModel alloc] init];
        model = self.collectStorys[indexPath.row];
        GCZStoryDetailTVC *storyTVC = [[GCZStoryDetailTVC alloc] init];
        storyTVC.urlString = [NSString stringWithFormat:kDetailStoryUrl ,model.url];
        [self.navigationController pushViewController:storyTVC animated:YES];
        
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.titleArray[section];
}





@end
