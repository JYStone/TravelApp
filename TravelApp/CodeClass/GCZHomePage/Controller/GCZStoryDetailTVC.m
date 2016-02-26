//
//  GCZStoryDetailTVC.m
//  TravelApp
//
//  Created by SZT on 15/12/21.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "GCZStoryDetailTVC.h"
#import "MainScreenBound.h"
#import "GCZTravelListModel.h"
#import "GCZStoryDetailCell.h"
#import "GCZRightToolBar.h"

@interface GCZStoryDetailTVC () <UMSocialUIDelegate>

@property (nonatomic,strong) GCZTravelListModel *storyModel;

@property (nonatomic,retain) NSMutableArray *storyArray;

@end

@implementation GCZStoryDetailTVC

#pragma mark-
#pragma mark----------------------懒加载--------------------

- (NSMutableArray *)storyArray {
    if (!_storyArray) {
        _storyArray = [[NSMutableArray alloc] init];
    }
    return _storyArray;
}

- (void)setHeaderViewData {
    
    [LORequestManger GET:self.urlString success:^(id response) {
        NSDictionary *dataDic = response[@"data"];
        NSDictionary *spotDic = dataDic[@"spot"];
        NSDictionary *tripDic = dataDic[@"trip"];
        NSDictionary *userDic = tripDic[@"user"];
        
        self.storyModel = [[GCZTravelListModel alloc] init];
        [self.storyModel setValuesForKeysWithDictionary:spotDic];
        self.storyModel.user = userDic;

        NSArray *detailArray = spotDic[@"detail_list"];
        NSMutableArray *storyDetailArray = [NSMutableArray array];
        for (NSDictionary *dic in detailArray) {
            GCZTravelListModel *model = [[GCZTravelListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [storyDetailArray addObject:model];
        }
        self.storyArray = storyDetailArray;
        
        [self setBarButtonItem];
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 120 + [self heightForHeader])];
        
        UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, 50, 50)];
        userImageView.layer.masksToBounds = YES;
        userImageView.layer.cornerRadius = 25;
        [userImageView sd_setImageWithURL:[NSURL URLWithString:self.storyModel.user[@"avatar_l"]]];
        UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 30, kWidth - 150, 30)];
        userNameLabel.text = self.storyModel.user[@"name"];
        userNameLabel.font = [UIFont systemFontOfSize:22];
        
        UILabel *placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 50, 200, 30)];
        if ([self.storyModel.poi isKindOfClass:[NSDictionary class]]) {
            if (self.storyModel.poi[@"name"] != NULL) {
                placeLabel.text = [NSString stringWithFormat:@"故事发生在%@", self.storyModel.poi[@"name"]];

            }
        } else {
        }

        placeLabel.font = [UIFont systemFontOfSize:14];
        placeLabel.textColor = [UIColor grayColor];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(30, 100, kWidth - 60, 1)];
        lineView.backgroundColor = [UIColor grayColor];
        
        UILabel *textLabel  = [[UILabel alloc] initWithFrame:CGRectMake(30, 110, kWidth - 60, [GCZStoryDetailCell HeightForTextWithModel:self.storyModel fontSize:18 surplusWidth:30])];
        textLabel.text = self.storyModel.text;
        textLabel.numberOfLines = 0;
        headerView.backgroundColor = kCellBackGroundColor;
        [headerView addSubview:lineView];
        [headerView addSubview:textLabel];
        [headerView addSubview:placeLabel];
        [headerView addSubview:userNameLabel];
        [headerView addSubview:userImageView];
        
        self.tableView.tableHeaderView = headerView;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (void)setBarButtonItem {
    UIToolbar *rightToolBar = [[GCZRightToolBar alloc] initRightToolBarWithFrame:CGRectMake(0, 0, 85, 25) Delegate:self shareAction:@selector(shareWithBarButtonRight) collectAction:@selector(favouriteButtonItem)];
    UIBarButtonItem *collectionButton = rightToolBar.items[0];
    UIButton *button = collectionButton.customView;
    
    rightToolBar.barTintColor = self.navigationController.navigationBar.tintColor;
    rightToolBar.backgroundColor = [UIColor clearColor];
    for (UIView *view in [rightToolBar subviews]) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }

    StoryModel *model = [[StoryModel alloc] init];
    model.text = self.storyModel.text;
    model.spot_id = self.storyModel.spot_id;
    model.cover_image_1600 = self.storyModel.cover;
    button.selected = [[TravelFMDataBase shareTravelDataBase] selectRowWithTravelName:model.text tableName:@"EveryDayStory"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightToolBar];
}

- (void)favouriteButtonItem {
    
    UIToolbar *toolBar = self.navigationItem.rightBarButtonItem.customView;
    UIBarButtonItem *button = toolBar.items[0];
    UIButton *rButton = button.customView;
    StoryModel *model = [[StoryModel alloc] init];
    model.text = self.storyModel.text;
    model.spot_id = self.storyModel.spot_id;
    model.cover_image_1600 = self.storyModel.cover_image;

    
    if ([SingleTonForTravel shareTravelSingleTon].isLogin) {
        rButton.selected = !rButton.selected;

        if (rButton.selected) {
            [[TravelFMDataBase shareTravelDataBase] insertRowToTableWithModel:model tableName:@"EveryDayStory"];
        } else {
            [[TravelFMDataBase shareTravelDataBase] deleteRowFromTableWithTravelName:model.text tableName:@"EveryDayStory"];
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

//自适应高度的方法
- (CGFloat)heightForHeader {
    NSDictionary *textDic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:18] forKey:NSFontAttributeName];
    CGRect bounds = [self.storyModel.text boundingRectWithSize:CGSizeMake(kWidth - 60, 100000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:textDic context:nil];
    return bounds.size.height;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setHeaderViewData];
    
    [self.tableView registerClass:[GCZStoryDetailCell class] forCellReuseIdentifier:@"cell"];
    
    //隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //设置右侧barButtonItem
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[[UIImage imageNamed:@"share_selected"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]
                      forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareWithBarButtonRight)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 25, 25);
    
    UIBarButtonItem *rightBtutton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBtutton;
    
    //返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back@2x.jpg"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]
                                                                   style:(UIBarButtonItemStylePlain)
                                                                  target:self
                                                                  action:@selector(backToRootController)];
    self.navigationItem.leftBarButtonItem = leftButton;

}

- (void)backToRootController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)shareWithBarButtonRight {
    NSString *shareText = [NSString stringWithFormat:@"#破费Travel# http://web.breadtrip.com/btrip/spot/%@/?btid=2384118526", self.trip_id];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"567ba24e67e58e0420001b20"
                                      shareText:shareText
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline, nil]
                                       delegate:self];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.storyArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   CGFloat textHeight = [GCZStoryDetailCell HeightForTextWithModel:self.storyArray[indexPath.row] fontSize:14 surplusWidth:20];
    CGFloat pictureHeight = [GCZStoryDetailCell heightForImageViewWithModel:self.storyArray[indexPath.row]];
    
    return textHeight + pictureHeight + 25;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GCZStoryDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.storyModel = self.storyArray[indexPath.row];
    
    // Configure the cell...
    
    return cell;
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
