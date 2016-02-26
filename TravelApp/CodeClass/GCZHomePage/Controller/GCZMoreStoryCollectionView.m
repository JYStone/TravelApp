//
//  GCZMoreStoryCollectionView.m
//  TravelApp
//
//  Created by SZT on 15/12/19.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "GCZMoreStoryCollectionView.h"
#import "MainScreenBound.h"
#import "GCZTravelListModel.h"
#import "GCZStoryDetailTVC.h"


#define kMoreStoryUrl @"http://api.breadtrip.com/v2/new_trip/spot/hot/list/?start=0"
#define kFootUrl @"http://api.breadtrip.com/v2/new_trip/spot/hot/list/?start=%d"

#import "GCZMoreStoryCell.h"

@interface GCZMoreStoryCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) NSMutableArray *storyArray;

@property (nonatomic,retain) UICollectionView *collectionView;

@end

@implementation GCZMoreStoryCollectionView

#pragma mark-
#pragma marl-----------------------懒加载-----------------------
- (NSMutableArray *)storyArray {
    
    if (!_storyArray) {
        _storyArray = [[NSMutableArray alloc] init];
    }
    return _storyArray;
}

#pragma mark-
#pragma mark-----------------------设置数据-----------------------

- (void)setMoreStoryData {
    [LORequestManger GET:kMoreStoryUrl success:^(id response) {
        NSDictionary *dic = (NSDictionary *)response[@"data"];
        NSArray *hotSpotArray = dic[@"hot_spot_list"];
        NSMutableArray *storyArray = [NSMutableArray array];
        for (NSDictionary *storyDic in hotSpotArray) {
            GCZTravelListModel *storyModel = [[GCZTravelListModel alloc] init];
            [storyModel setValuesForKeysWithDictionary:storyDic];
            [storyArray addObject:storyModel];
        }
        self.storyArray = storyArray;
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}


- (void)setFootRefreshData {
    
    [LORequestManger GET:[NSString stringWithFormat:kFootUrl , self.storyArray.count] success:^(id response) {
        NSDictionary *dic = (NSDictionary *)response[@"data"];
        NSArray *hotSpotArray = dic[@"hot_spot_list"];
        for (NSDictionary *storyDic in hotSpotArray) {
            GCZTravelListModel *storyModel = [[GCZTravelListModel alloc] init];
            [storyModel setValuesForKeysWithDictionary:storyDic];
            [self.storyArray addObject:storyModel];
        }
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMoreStoryData];
    
    UICollectionViewFlowLayout *flowLatout = [[UICollectionViewFlowLayout alloc] init];
    flowLatout.minimumInteritemSpacing = 10;
    flowLatout.minimumLineSpacing = 10;
    
    flowLatout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    CGFloat itemWidth = (kWidth - 30) / 2.0;
    CGFloat itemHeight = itemWidth * 0.76 + 75;
    
    flowLatout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    //竖直滚动
    flowLatout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLatout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[GCZMoreStoryCell class] forCellWithReuseIdentifier:@"cell"];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
    
    // 上拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setMoreStoryData];
    }];
    
    // 下拉刷新
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self setFootRefreshData];
    }];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back@2x.jpg"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]
                                                                   style:(UIBarButtonItemStylePlain)
                                                                  target:self
                                                                  action:@selector(backToRootController)];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void)backToRootController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.storyArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GCZMoreStoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.storyModel = self.storyArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    StoryModel *model = [[StoryModel alloc] init];
    model = self.storyArray[indexPath.row];
    GCZStoryDetailTVC *storyTVC = [[GCZStoryDetailTVC alloc] init];
    storyTVC.urlString = [NSString stringWithFormat:kDetailStoryUrl ,model.spot_id];
    [self.navigationController pushViewController:storyTVC animated:YES];
    
}



@end
