//
//  GCZTravelListTVC.m
//  TravelApp
//
//  Created by SZT on 15/12/18.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "GCZTravelListTVC.h"
#import "MainScreenBound.h"
#import "GCZTravelDayModel.h"
#import "GCZTravelDayCell.h"
#import "GCZTravelType12Model.h"
#import "GCZTravelListModel.h"
#import "GCZDayFirstSectionCell.h"
#import "GCZRightToolBar.h"


@interface GCZTravelListTVC () <UMSocialUIDelegate>

@property (nonatomic,strong) GCZTravelListModel *travelModel;

@property (nonatomic,strong) NSMutableArray *travelDayArray;

@property (nonatomic,strong) UIToolbar *toolBar;

@end

@implementation GCZTravelListTVC

#pragma mark -
#pragma mark ----------------------懒加载-------------------

- (NSMutableArray *)travelDayArray {
    
    if (!_travelDayArray) {
        _travelDayArray = [[NSMutableArray alloc] init];
    }
    return _travelDayArray;
    
}


- (void)setTravelDetailData {
    
    if ([self.travel_type isEqualToString:@"4"]) {
    
    [LORequestManger GET:self.travel_id success:^(id response) {
        self.travelModel = [[GCZTravelListModel alloc] init];
        [self.travelModel setValuesForKeysWithDictionary:(NSDictionary *)response];
        self.title = self.travelModel.name;
        //设置setBarButtonItem
        [self setBarButtonItem];
        
        NSArray *daysArray = response[@"days"];
    
        for (NSDictionary *dic in daysArray) {
            GCZTravelDayModel *dayModel = [[GCZTravelDayModel alloc] init];
            [dayModel setValuesForKeysWithDictionary:dic];
            [self.travelDayArray addObject:dayModel];
        }
        //设置headerView背景图片
        UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kWidth * 0.5)];
        [headerView sd_setImageWithURL:[NSURL URLWithString:self.travelModel.trackpoints_thumbnail_image]];
        self.tableView.tableHeaderView = headerView;
        
        //设置用户头像
        if (self.travelModel.user) {
            UIImageView *userIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
            [self setImageViewForLayer:userIconView];
            userIconView.center = CGPointMake(kWidth / 2, kWidth * 0.5);
            
            NSDictionary *userDic = self.travelModel.user;
            [userIconView sd_setImageWithURL:[NSURL URLWithString:userDic[@"avatar_l"]]];
            [self.tableView addSubview:userIconView];
        }
        
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    } else {
        
        [LORequestManger GET:self.travel_id success:^(id response) {
            self.travelModel = [[GCZTravelListModel alloc] init];
            NSDictionary *dataDic = response[@"data"];
            [self.travelModel setValuesForKeysWithDictionary:dataDic];
            self.title = self.travelModel.name;


            NSArray *dayListArray = dataDic[@"day_list"];
            for (NSDictionary *dic in dayListArray) {
                NSArray *spotArray = dic[@"spot_list"];
                NSDictionary *detailDic = spotArray[0];
                GCZTravelType12Model *model = [[GCZTravelType12Model alloc] init];
                [model setValuesForKeysWithDictionary:detailDic];
                [self.travelDayArray addObject:model];
            }
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kWidth * 0.6)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.travelModel.cover_image]];
            self.tableView.tableHeaderView = imageView;
            [self.tableView reloadData];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        
        
        
    }
    
}


- (UIImageView *)setImageViewForLayer:(UIImageView *)imageView {
    
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderColor = [[UIColor whiteColor]CGColor];
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    imageView.layer.borderWidth = 3.5;
    
    return imageView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setTravelDetailData];
    
    //隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back@2x.jpg"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]
                                                                   style:(UIBarButtonItemStylePlain)
                                                                  target:self
                                                                  action:@selector(backToRootController)];
    
    self.navigationItem.leftBarButtonItem = leftButton;
    
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:30.0 / 255 green:144 / 255.0 blue:255.0 / 255 alpha:1.0];
}

- (void)backToRootController {

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setBarButtonItem {
    GCZRightToolBar *rightToolBar = [[GCZRightToolBar alloc] initRightToolBarWithFrame:CGRectMake(0, 0, 85, 25)
                                                                              Delegate:self
                                                                           shareAction:@selector(shareWithBarButtonRight)
                                                                         collectAction:@selector(favouriteButtonItem)];
    
    rightToolBar.barTintColor = self.navigationController.navigationBar.tintColor;
    rightToolBar.backgroundColor = [UIColor clearColor];
    for (UIView *view in [rightToolBar subviews]) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    UIBarButtonItem *collectionButton = rightToolBar.items[0];
    UIButton *button = collectionButton.customView;
    button.selected = [[TravelFMDataBase shareTravelDataBase] selectRowWithTravelName:self.travelModel.name tableName:@"HotStory"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightToolBar];
}

//收藏按钮触发
- (void)favouriteButtonItem {
    
    if ([SingleTonForTravel shareTravelSingleTon].isLogin) {
        UIToolbar *toolBar = self.navigationItem.rightBarButtonItem.customView;
        UIBarButtonItem *button = toolBar.items[0];
        UIButton *rButton = button.customView;
        rButton.selected = !rButton.selected;

        if (rButton.selected) {
            [[TravelFMDataBase shareTravelDataBase] insertRowToTableWithModel:self.travelModel
                                                                    tableName:@"HotStory"];
        } else {
            [[TravelFMDataBase shareTravelDataBase] deleteRowFromTableWithTravelName:self.travelModel.name
                                                                           tableName:@"HotStory"];
        }
    } else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"亲，收藏请先登录喔(*^__^*)" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"好的" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:sureAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];

        
    }
    
   
    
    
}

- (void)shareWithBarButtonRight {
    NSString *shareText = [NSString stringWithFormat:@"我在破费旅游看到了好玩的 小伙伴们快来！ http://web.breadtrip.com/trips/%@", self.share_id];
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                      appKey:@"567ba24e67e58e0420001b20"
                                   shareText:shareText
                                  shareImage:nil
                             shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline, nil]
                                    delegate:self];
    
}


//获取对应下标下的model
- (GCZTravelDayModel *)getTravelDayModelWithIndexPath:(NSIndexPath *)indexPath {
    
    GCZTravelDayModel *dayModel = self.travelDayArray[indexPath.section - 1];
    NSArray *daysArray = dayModel.waypoints;
    [dayModel setValuesForKeysWithDictionary:daysArray[indexPath.row]];
    return dayModel;
}

//获取对应下标下的typeModel
- (GCZTravelDayModel *)getType12ModelWidthIndexPath:(NSIndexPath *)indexPath {
    
    GCZTravelType12Model *type12Model = self.travelDayArray[indexPath.section - 1];
    NSArray *detailArray = type12Model.detail_list;
    GCZTravelDayModel *dayModel = [[GCZTravelDayModel alloc] init];
    [dayModel setValuesForKeysWithDictionary:detailArray[indexPath.row]];
    return dayModel;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return self.travelDayArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    } else {

    if ([self.travel_type isEqualToString:@"4"]) {
        GCZTravelDayModel *dayModel    = self.travelDayArray[section - 1];
        return dayModel.waypoints.count;
    } else {
        GCZTravelType12Model *dayModel = self.travelDayArray[section - 1];
        return dayModel.detail_list.count;
    }
    }
    
}

//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 165;
    } else {
    if ([self.travel_type isEqualToString:@"4"]) {
        return [GCZTravelDayCell getHeightWithModel:[self getTravelDayModelWithIndexPath:indexPath]] + 30;

    } else {
        return [GCZTravelDayCell getHeightWithModel:[self getType12ModelWidthIndexPath:indexPath]] + 30;
    }
    
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        static NSString *identifier = @"cell1";
        GCZDayFirstSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[GCZDayFirstSectionCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                                 reuseIdentifier:identifier];
        }
        cell.travelListModel = self.travelModel;
        return cell;
    } else {
    
    static NSString *identifier = @"cell";
    GCZTravelDayCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[GCZTravelDayCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                       reuseIdentifier:identifier];
    }
    GCZTravelDayModel *dayModel = [[GCZTravelDayModel alloc] init];
    if ([self.travel_type isEqualToString:@"4"]) {
        dayModel = [self getTravelDayModelWithIndexPath:indexPath];
    } else {
        dayModel = [self getType12ModelWidthIndexPath:indexPath];
        
    }
    [cell setImageViewTextWithModel:dayModel];
    
    return cell;
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
