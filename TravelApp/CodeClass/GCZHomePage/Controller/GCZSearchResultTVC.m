//
//  GCZSearchResultTVC.m
//  TravelApp
//
//  Created by SZT on 15/12/24.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "GCZSearchResultTVC.h"
#import "MainScreenBound.h"
#import "GCZPlaceModel.h"
#import "GCZSearchPlaceCell.h"
#import "CountryDetailViewController.h"
#import "City.h"

@interface GCZSearchResultTVC ()
@property (nonatomic,retain) NSMutableArray *placeArray;

@property (nonatomic,retain) NSMutableArray *storyArray;

@end

@implementation GCZSearchResultTVC

#pragma mark-
#pragma mark ----------------懒加载---------------
- (NSMutableArray *)placeArray {
    if (!_placeArray) {
        _placeArray = [[NSMutableArray alloc] init];
    }
    return _placeArray;
}

- (NSMutableArray *)storyArray {
    
    if (!_storyArray) {
        _storyArray = [[NSMutableArray alloc] init];
    }
    return _storyArray;
}

#pragma mark-
#pragma mark--------------------------设置数据---------------------

- (void)setSearchData {
    
    [LORequestManger GET:self.searchUrl success:^(id response) {
        NSDictionary *dataDic = response[@"data"];
        NSArray *placesArray = dataDic[@"places"];
        for (NSDictionary *dic in placesArray) {
            GCZPlaceModel *model = [[GCZPlaceModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.placeArray addObject:model];
        }
        NSArray *tripArray = dataDic[@"trips"];
        for (NSDictionary *dic in tripArray) {
            GCZTravelListModel *tripModel = [[GCZTravelListModel alloc] init];
            [tripModel setValuesForKeysWithDictionary:dic];
            [self.storyArray addObject:tripModel];
        }
        
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSearchData];
    
    [self.tableView registerClass:[GCZSearchPlaceCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerClass:[GCZTravelListCell class] forCellReuseIdentifier:@"travelCell"];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back@2x.jpg"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]
                                                                   style:(UIBarButtonItemStylePlain)
                                                                  target:self
                                                                  action:@selector(backToRootController)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
}

- (void)backToRootController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.placeArray.count;
    } else {
        return self.storyArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44;
    } else {
        return kWidth * 0.7;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:22];
    titleLabel.center = CGPointMake(kWidth / 2, 30);
    if (section == 0) {
        titleLabel.text = @"目的地";
    } else {
        titleLabel.text = @"游记故事";
    }
    [headerView addSubview:titleLabel];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GCZSearchPlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        GCZPlaceModel *model = self.placeArray[indexPath.row];
        cell.placeModel = model;
        return cell;
    } else {
        GCZTravelListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"travelCell" forIndexPath:indexPath];
        GCZTravelListModel *tripModel = self.storyArray[indexPath.row];
        [cell setHotTravelWithImageModel:tripModel];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        CountryDetailViewController *countryVC = [[CountryDetailViewController alloc] init];
        GCZPlaceModel *model = self.placeArray[indexPath.row];
        City *city = [[City alloc] init];
        city.type = model.type;
        city.ID = model.ID;
        countryVC.city = city;
        city.name = model.name;
        [self.navigationController pushViewController:countryVC animated:YES];
    } else {
        
        GCZTravelListTVC *travelTVC = [[GCZTravelListTVC alloc] init];
        GCZTravelListModel *model = self.storyArray[indexPath.row];
        travelTVC.travel_id = [NSString stringWithFormat:kTravelListUrl ,model.ID];
        travelTVC.travel_type = @"4";
        [self.navigationController pushViewController:travelTVC animated:YES];
        
    }
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
