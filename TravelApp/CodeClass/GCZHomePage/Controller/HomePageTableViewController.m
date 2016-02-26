//
//  HomePageTableViewController.m
//  TravelApp
//
//  Created by SZT on 15/12/17.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "HomePageTableViewController.h"
#import "MainScreenBound.h"
#import "GCZSearchCollectionCell.h"
#import "GCZSearchResultTVC.h"
#import "FJYAlertShow.h"
#import "ServerViewController.h"
@interface HomePageTableViewController () <UIScrollViewDelegate, MBProgressHUDDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate>

@property (nonatomic,strong ) GCZHeaderScrollView *rollPictureScrollView;

@property (nonatomic,strong ) NSMutableArray      *scrollPictureArray;

@property (nonatomic,strong ) NSMutableArray      *storyArray;

@property (nonatomic,strong ) NSMutableArray      *travelListArray;

@property (nonatomic,strong ) UIPageControl       *pageControl;

@property (nonatomic,strong ) MBProgressHUD       *hud;

//searBar
@property (nonatomic,strong ) UISearchBar         *barSearch;

@property (nonatomic,strong ) UICollectionView    *searchCV;

@property (nonatomic, retain) NSArray             *foreignArray;

@property (nonatomic, retain) NSArray             *inlandArray;

@end

@implementation HomePageTableViewController

#pragma mark-
#pragma mark-----------------懒加载-----------------
- (UICollectionView *)searchCV {
    
    if (!_searchCV) {
        
        self.foreignArray = @[@"奈良市",@"札幌市",@"鹿儿岛县",@"小樽市",@"青森县",@"横滨市",@"镰仓市",@"广岛县",@"箱根町",@"泰国",@"韩国",@"美国",@"意大利",@"马来西亚",@"新加坡"];
        
        self.inlandArray = @[@"台湾",@"香港",@"厦门",@"北京",@"丽江",@"成都",@"上海",@"拉萨",@"西安",@"大理",@"三亚"];
        
        UICollectionViewFlowLayout *flowOut = [[UICollectionViewFlowLayout alloc] init];
        
        flowOut.minimumLineSpacing = kWidth * 0.05;
        flowOut.minimumInteritemSpacing = kWidth * 0.05;
        
        flowOut.sectionInset = UIEdgeInsetsMake(kWidth * 0.1, 10, kWidth * 0.1, 10);//分区内边距
        
        //itemSize 一行三列
        CGFloat itemWidth = (kWidth - kWidth * 0.2 - 20) / 3.0;
        CGFloat itemHeight = itemWidth / 2.5;
        
        flowOut.itemSize = CGSizeMake(itemWidth, itemHeight);
        
        flowOut.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        flowOut.headerReferenceSize = CGSizeMake(kWidth, kWidth * 0.08);
        
        _searchCV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, - kHeight, kWidth, kHeight) collectionViewLayout:flowOut];
        
        //设置数据源和代理
        _searchCV.dataSource = self;
        _searchCV.delegate = self;
        
        //注册
        [_searchCV registerClass:[GCZSearchCollectionCell class] forCellWithReuseIdentifier:@"top"];
        
        [_searchCV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
        
        
        _searchCV.backgroundColor = [UIColor colorWithRed:0.0 / 255 green:190.9 / 255 blue:245.0 / 255 alpha:1.0];
        
    }
    return _searchCV;
}

- (NSMutableArray *)scrollPictureArray {
    if (!_scrollPictureArray) {
        _scrollPictureArray = [[NSMutableArray alloc] init];
    }
    return _scrollPictureArray;
}

- (NSMutableArray *)storyArray {
    if (!_storyArray) {
        _storyArray = [[NSMutableArray alloc] init];
    }
    return _storyArray;
}

- (NSMutableArray *)travelListArray {
    if (!_travelListArray) {
        _travelListArray = [[NSMutableArray alloc] init];
    }
    return _travelListArray;
}
#pragma mark-
#pragma mark------------------设置数据------------------

//轮播图数据
- (void)setRollImageData {
    
    [LORequestManger GET:kMainUrl success:^(id response) {
        NSDictionary *rootDic  = response[@"data"];
        NSArray *elementsArray = rootDic[@"elements"];
        NSDictionary *zeroDic  = elementsArray[0];
        NSArray *dataArray     = zeroDic[@"data"];
        NSArray *rollArray     = dataArray[0];
        
        NSMutableArray *imageArray = [NSMutableArray array];
        NSMutableArray *urlArray = [NSMutableArray array];
        for (NSDictionary *modelDic in rollArray) {
            [imageArray addObject:modelDic[@"image_url"]];
            [urlArray addObject:modelDic[@"html_url"]];
        }
        self.scrollPictureArray = urlArray;
        NSArray *picArray = [imageArray copy];
        
        _pageControl.numberOfPages = self.scrollPictureArray.count;

        [self.tableView addSubview:self.pageControl];
        
        [self.rollPictureScrollView setRollImageWithImageArray:picArray
                                                      delegate:self
                                                        action:@selector(tapImage)];
        
        self.tableView.tableHeaderView = self.rollPictureScrollView;

        [self setEveryStory];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

//设置故事精选数据
- (void)setEveryStory {
    
    [LORequestManger GET:kEveryStory success:^(id response) {
        
        NSDictionary *rootDic    = response[@"data"];
        NSArray *storyArray      = rootDic[@"hot_spot_list"];
        NSMutableArray *storyArr = [[NSMutableArray alloc] init];
        for (NSDictionary *storyDic in storyArray) {
        StoryModel *storyModel   = [[StoryModel alloc] init];
            [storyModel setValuesForKeysWithDictionary:storyDic];
            [storyArr addObject:storyModel];
        }
        self.storyArray = storyArr;
        [self setTravilNotesData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}

//设置精彩游记数据
- (void)setTravilNotesData {
    
    [LORequestManger GET:kMainUrl success:^(id response) {
        NSDictionary *rootDic = response[@"data"];
        NSArray *elementsArray = rootDic[@"elements"];
        NSMutableArray *travelListArray = [NSMutableArray array];
        for (int i = 7; i < elementsArray.count; i ++) {
            GCZTravelListModel *model = [[GCZTravelListModel alloc] init];
            NSDictionary *dic = elementsArray[i];
            model.desc = dic[@"desc"];
            model.type = [NSString stringWithFormat:@"%@",dic[@"type"]];
            NSDictionary *travelDic = dic[@"data"][0];
            [model setValuesForKeysWithDictionary:travelDic];
            [travelListArray addObject:model];
        }
        self.travelListArray = travelListArray;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hudWasHidden:self.hud];
        });
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//下拉刷新数据
- (void)setFootRefreshData {
    
    GCZTravelListModel *model = self.travelListArray.lastObject;
//    NSLog(@"%@", [NSString stringWithFormat:kFootUrl1, model.ID]);
    [LORequestManger GET:[NSString stringWithFormat:kFootUrl1, model.ID] success:^(id response) {
        NSDictionary *rootDic = response[@"data"];
        NSArray *elementsArray = rootDic[@"elements"];
        for (int i = 0; i < elementsArray.count; i ++) {
            GCZTravelListModel *model = [[GCZTravelListModel alloc] init];
            NSDictionary *dic = elementsArray[i];
            model.desc = dic[@"desc"];
            model.type = [NSString stringWithFormat:@"%@",dic[@"type"]];
            NSDictionary *travelDic = dic[@"data"][0];
            [model setValuesForKeysWithDictionary:travelDic];
            [self.travelListArray addObject:model];
        }
    
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (void)push {
    CollectionTableViewController *collectTVC = [[CollectionTableViewController alloc]initWithStyle:(UITableViewStylePlain)];
    [self.navigationController pushViewController:collectTVC animated:YES];
}

- (void)pushServerVC {
    ServerViewController *serverVC = [[ServerViewController alloc] init];
    [self.navigationController pushViewController:serverVC animated:YES];
}

- (void)reloadDataWithNetWork {
    
    if (self.scrollPictureArray.count > 0) {
        
    } else {
        [self setRollImageData];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataWithNetWork) name:@"withWWAN" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataWithNetWork) name:@"withWifi" object:nil];
    
    [UIApplication sharedApplication].statusBarStyle = [self preferredStatusBarStyle];
    self.view.backgroundColor = kCellBackGroundColor;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(push) name:@"push" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushServerVC) name:@"pushServerVC" object:nil];

    //下拉刷新设置
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        self.hud.labelText = @"正在刷新";
        self.hud.dimBackground = YES;

        [self setRollImageData];
    }];
    
    //上拉刷新设置
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self setFootRefreshData];
    }];
    
    //设置轮播图
    [self createRollPictureScrollview];
    self.tableView.tableHeaderView = self.rollPictureScrollView;
    [self setRollImageData];
    
    //MBProgress
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.hud.labelText = @"正在刷新";
    self.hud.dimBackground = YES;
    self.hud.delegate = self;

    //创建searchBar
    [self creataSearchBar];
    
    //隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //设置右导航栏按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"附近" style:(UIBarButtonItemStylePlain) target:self action:@selector(nearbyStoryWithRightButton)];
//    [rightButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
}



#pragma mark-
#pragma mark --------------------- 创建轮播图及其事件 ------------------------

//创建轮播图滚动视图 pageControl
- (void)createRollPictureScrollview {
    
    GCZHeaderScrollView *scrollView = [[GCZHeaderScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kWidth * 0.5)];
    
    
   
    [scrollView setTimerForRollImage:3.5 delegate:self action:@selector(timerRoll)];
        
    
    self.rollPictureScrollView      = scrollView;

    self.pageControl                = [[UIPageControl alloc] initWithFrame:CGRectMake(120, self.rollPictureScrollView.frame.size.height - 30, kWidth - 240, 20)];
    [_pageControl addTarget:self action:@selector(pageForRoll:) forControlEvents:(UIControlEventValueChanged)];

}

- (void)creataSearchBar {
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, kWidth - 120, 25)];
    self.barSearch = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kWidth - 120, 25)];
    self.barSearch.delegate = self;
    self.barSearch.layer.cornerRadius = 10;
    self.barSearch.placeholder = @"目的地 游记";
    self.barSearch.layer.masksToBounds = YES;
    self.barSearch.layer.borderWidth = 2;
    self.barSearch.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [titleView addSubview:self.barSearch];
    self.navigationItem.titleView = titleView;

    
}

//轮播图边界滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat contentSet = self.rollPictureScrollView.contentOffset.x;
    
    if (contentSet >= self.rollPictureScrollView.contentSize.width - kWidth) {
        self.rollPictureScrollView.contentOffset = CGPointMake(kWidth, 0);
    } else if (contentSet <= 0)
    {
        self.rollPictureScrollView.contentOffset = CGPointMake(self.rollPictureScrollView.contentSize.width - 2 * kWidth, 0);
    }
    
    if (scrollView == self.searchCV) {
        [self.barSearch resignFirstResponder];
    }
    
    
}

//手动pageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat contentSet = self.rollPictureScrollView.contentOffset.x;
    CGFloat index = contentSet / kWidth;
    if (index == self.scrollPictureArray.count + 1) {
        self.pageControl.currentPage = 0;
    } else if (index == 0) {
        self.pageControl.currentPage = self.scrollPictureArray.count - 1;
    } else {
        self.pageControl.currentPage = index - 1;
    }
}

//定时pageControl
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    CGFloat contentSet = self.rollPictureScrollView.contentOffset.x;
    NSInteger index = contentSet / kWidth;
    if (index == self.scrollPictureArray.count + 1) {
        self.pageControl.currentPage = 0;
    } else if (index == 0) {
        self.pageControl.currentPage = self.scrollPictureArray.count - 1;
    } else {
        self.pageControl.currentPage = index - 1;
    }
    

}

//轮播图定时滚动
- (void)timerRoll {

    [self.rollPictureScrollView setContentOffset:CGPointMake(self.rollPictureScrollView.contentOffset.x + kWidth, 0) animated:YES];
}

#pragma mark-
#pragma mark ------------------------触发方法-----------------------------------

//每日精彩故事触发方法
- (void)storyImageTapped:(id)sender {
    if (self.storyArray.count > 0) {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    StoryModel *model = [[StoryModel alloc] init];
    model = self.storyArray[tap.view.tag - 1000];
    GCZStoryDetailTVC *storyTVC = [[GCZStoryDetailTVC alloc] init];
    storyTVC.trip_id = model.spot_id;
    storyTVC.urlString = [NSString stringWithFormat:kDetailStoryUrl ,model.spot_id];
    [self.navigationController pushViewController:storyTVC animated:YES];
    
    }
    
}

//更多故事按钮触发方法
- (void)goMoreStory {
    
    GCZMoreStoryCollectionView *moreCollectView = [[GCZMoreStoryCollectionView alloc] init];
    [self.navigationController pushViewController:moreCollectView animated:YES];
}

//轮播图触发方法
- (void)tapImage {
    
    NSInteger index = self.rollPictureScrollView.contentOffset.x / kWidth;
    NSString *url = self.scrollPictureArray[index - 1];
    
    GCZWebViewController *webView = [[GCZWebViewController alloc] init];
    webView.url = url;
    [self.navigationController pushViewController:webView animated:YES];
    
}

//pageControl值变化 触发方法
- (void)pageForRoll:(UIPageControl *)pageControl {
    
    NSInteger currentPage = pageControl.currentPage;
    [self.rollPictureScrollView setContentOffset:CGPointMake(kWidth * (currentPage + 1), 0) animated:YES];
    
}

//MBProgress 关闭
- (void)hudWasHidden:(MBProgressHUD *)hud {
    [hud removeFromSuperview];
}

//右边barButton 附近触发方法
- (void)nearbyStoryWithRightButton {
    
    NSString *searchText = [SingleTonForTravel shareTravelSingleTon].locationName;
    
    NSString *encodeSearchText = [searchText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    GCZSearchResultTVC *searResTVC = [[GCZSearchResultTVC alloc] init];
    searResTVC.searchUrl = [NSString stringWithFormat:kSearchUrl, encodeSearchText];
    [self.navigationController pushViewController:searResTVC animated:YES];
    
}

#pragma mark-
#pragma mark --------------------SearchBar代理设置--------------

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(resignFirstResponderForSearchBar)];
//    [rightButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.tableView.scrollEnabled = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.searchCV.frame =  CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height, kWidth, kHeight - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height);
        [self.view.window addSubview:self.searchCV];
    }];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    self.tableView.scrollEnabled = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.searchCV.frame =  CGRectMake(0, - kHeight - 100, kWidth, kHeight - self.tabBarController.tabBar.frame.size.height);
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"附近"
                                                                              style:(UIBarButtonItemStylePlain)
                                                                             target:self
                                                                             action:@selector(nearbyStoryWithRightButton)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.barSearch resignFirstResponder];
    
    NSString *searchText = self.barSearch.text;
    
    NSString *encodeSearchText = [searchText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    GCZSearchResultTVC *searResTVC = [[GCZSearchResultTVC alloc] init];
    searResTVC.searchUrl = [NSString stringWithFormat:kSearchUrl, encodeSearchText];
    [self.navigationController pushViewController:searResTVC animated:YES];
    self.barSearch.text = nil;
    self.navigationItem.leftBarButtonItem.enabled = YES;

    
}



- (void)resignFirstResponderForSearchBar {
    self.tableView.scrollEnabled = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.searchCV.frame =  CGRectMake(0, - kHeight - 100, kWidth, kHeight - self.tabBarController.tabBar.frame.size.height);
    }];
    self.barSearch.text = nil;
    [self.barSearch resignFirstResponder];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"附近" style:(UIBarButtonItemStylePlain) target:self action:@selector(nearbyStoryWithRightButton)];
    self.navigationItem.leftBarButtonItem.enabled = YES;

}


#pragma mark - Table view data source
#pragma mark--------------------设置单元格-------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.travelListArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.0;
}

//设置表头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    [self.barSearch resignFirstResponder];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = kCellBackGroundColor;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 30)];
    if (section == 0) {
        titleLabel.text = @"热门故事";
        UIButton *moreButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        moreButton.frame = CGRectMake(kWidth -  70, 10, 69, 30);
        [moreButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [moreButton setTitle:@"更多故事" forState:(UIControlStateNormal)];
        [moreButton addTarget:self action:@selector(goMoreStory) forControlEvents:(UIControlEventTouchUpInside)];
        [headerView addSubview:moreButton];
        
    } else {
        titleLabel.text = @"精选游记";
    }
    [headerView addSubview:titleLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [GCZEveryDayStoryCell heightForRow] + 10;
    } else {
        return kWidth * 0.6 + 10;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *identififer = @"cell";
        
        GCZEveryDayStoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identififer];
        
        if (nil == cell) {
            cell = [[GCZEveryDayStoryCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identififer];
        }
        
        [cell setPictureViewWith:self.storyArray delegate:self action:@selector(storyImageTapped:)];
        
        return cell;
    } else {
        static NSString *identififer = @"cell1";
        
        GCZTravelListCell *cell = [tableView dequeueReusableCellWithIdentifier:identififer];
        
        if (nil == cell) {
            cell = [[GCZTravelListCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identififer];
        }
        GCZTravelListModel *model = self.travelListArray[indexPath.row];
        
        
        if ([model.desc isEqualToString:@"热门游记"]) {
            [cell setHotTravelWithImageModel:model];
            return cell;
        } else {
            [cell setRecommendProductsWithImageModel:model];
            return cell;
        }
    }
    
}

//单元格点击方法实现
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.travelListArray.count > 0) {
        
    GCZTravelListModel *model = self.travelListArray[indexPath.row];
    GCZTravelListTVC *travelTVC = [[GCZTravelListTVC alloc] init];
    travelTVC.share_id = model.ID;

    if ([model.type isEqualToString:@"4"]) {
        travelTVC.travel_id = [NSString stringWithFormat:kTravelListUrl ,model.ID];
        travelTVC.travel_type = model.type;

        [self.navigationController pushViewController:travelTVC animated:YES];
    } else if ([model.type isEqualToString:@"12"]) {
        travelTVC.travel_id = [NSString stringWithFormat:kTravelType12Url ,model.ID];
        travelTVC.travel_type = model.type;
        [self.navigationController pushViewController:travelTVC animated:YES];
    } else {
        GCZWebViewController *webView = [[GCZWebViewController alloc] init];
        webView.url = model.url;
        [self.navigationController pushViewController:webView animated:YES];
    }
    }
}

#pragma mark-
#pragma mark--------------------CollectionView代理数据源---------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.foreignArray.count;
    }
    return self.inlandArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GCZSearchCollectionCell *top = [collectionView dequeueReusableCellWithReuseIdentifier:@"top" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        top.itemLabel.text = self.foreignArray[indexPath.item];
    }else {
        top.itemLabel.text = self.inlandArray[indexPath.item];
    }
    return top;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kWidth * 0.33, kWidth * 0.1 - 10, kWidth * 0.53, kWidth * 0.1)];
    label.textColor = [UIColor whiteColor];
    
    if (indexPath.section == 0) {
        label.text = @"国外热门目的地";
        [headView addSubview:label];
    }else {
        label.text = @"国内热门目的地";
        [headView addSubview:label];
    }
    
    //        headView.backgroundColor = [UIColor blackColor];
    return headView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"附近" style:(UIBarButtonItemStylePlain) target:self action:@selector(nearbyStoryWithRightButton)];
    self.tableView.scrollEnabled = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.searchCV.frame =  CGRectMake(0, - kHeight - 100, kWidth, kHeight - self.tabBarController.tabBar.frame.size.height);
    }];
    self.barSearch.text = nil;
    [self.barSearch resignFirstResponder];
    self.navigationItem.leftBarButtonItem.enabled = YES;

    NSString *searStr = NULL;
    if (indexPath.section == 0) {
        searStr = self.foreignArray[indexPath.row];
    } else {
        searStr = self.inlandArray[indexPath.row];
    }
    NSString *encodeSearStr = [searStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    GCZSearchResultTVC *searResTVC = [[GCZSearchResultTVC alloc] init];
    searResTVC.searchUrl = [NSString stringWithFormat:kSearchUrl, encodeSearStr];
    GCZLog(@"%@", searResTVC.searchUrl);
    [self.navigationController pushViewController:searResTVC animated:YES];
    
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
