//
//  CityViewController.m
//  TravelApp
//
//  Created by SZT on 15/12/20.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "CityViewController.h"
#import "MainScreenBound.h"
#import "FJYHeader.h"

@interface CityViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchResultsUpdating>

@property (nonatomic, strong) NSMutableArray *hotCityArray;
@property (nonatomic, strong) NSMutableArray *allCityArray;

@property (nonatomic, strong) UIButton *searchButton;


@property (nonatomic, strong) UISearchController *searchC;
@property (nonatomic, strong) UITableViewController *searchTVC;
@property (nonatomic, strong) NSMutableArray *searchResult;

@property (nonatomic, strong) UILabel *string;

@end

@implementation CityViewController

- (NSMutableArray *)hotCityArray {
    if (!_hotCityArray) {
        self.hotCityArray = [[NSMutableArray alloc] init];
    }
    return _hotCityArray;
}

- (NSMutableArray *)allCityArray {
    if (!_allCityArray) {
        self.allCityArray = [[NSMutableArray alloc] init];
    }
    return _allCityArray;
}

- (NSMutableArray *)searchResult {
    if (!_searchResult) {
        _searchResult = [[NSMutableArray alloc] init];
    }
    return _searchResult;
}


#pragma mark -------------- jsonCity --------------

- (void)jsonWithCityName {
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    for (NSDictionary *dic in rootDic[@"热门城市"]) {
        [self.hotCityArray addObject:dic[@"name"]];
    }
}

- (void)plistWithCityName {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    NSArray *rootArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    for (NSArray *array in rootArray) {
        for (NSString *string in array) {
            [self.allCityArray addObject:string];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self jsonWithCityName];
    [self plistWithCityName];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgImageView.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:bgImageView];
    
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kHeight / 10, kWidth, kHeight * 3/4) collectionViewLayout:[self setCollectionLayout]];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [collectionView registerClass:[CityCollectionViewCell class] forCellWithReuseIdentifier:@"cityCell"];
    
    
    _searchButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _searchButton.frame = CGRectMake(kWidth / 2, kHeight / 10, kWidth /4 , kWidth / 4);
    [_searchButton setImage:[[UIImage imageNamed:@"search"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] forState:(UIControlStateNormal)];
    [_searchButton addTarget:self action:@selector(searchAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_searchButton];
    
    UIImageView *searchHint = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/3.5, kHeight / 20, kWidth /4 , kWidth / 5)];
    searchHint.image = [UIImage imageNamed:@"paopao"];
    [self.view addSubview:searchHint];
    _string = [[UILabel alloc] initWithFrame:CGRectMake(0, searchHint.frame.size.height/3, searchHint.frame.size.width, 20)];
    _string.font = [UIFont systemFontOfSize:12];
    _string.textAlignment = NSTextAlignmentCenter;
    _string.text = @"搜索找我";
    [searchHint addSubview:_string];

    
    
}

- (void)searchAction {
    
    self.searchButton.transform = CGAffineTransformMakeScale(1.5, 1.5);
    _string.text = @"满意吗😋";
    
    self.searchTVC = [[UITableViewController alloc] initWithStyle:(UITableViewStylePlain)];
    self.searchTVC.tableView.dataSource = self;
    self.searchTVC.tableView.delegate = self;
    self.searchTVC.tableView.separatorStyle = NO;
    self.searchTVC.tableView.backgroundColor = [UIColor clearColor];
    self.searchC = [[UISearchController alloc] initWithSearchResultsController:self.searchTVC];
    self.searchC.searchResultsUpdater = self;
    self.searchC.hidesNavigationBarDuringPresentation = NO;
    self.searchC.dimsBackgroundDuringPresentation = NO;
    self.searchC.hidesBottomBarWhenPushed = NO;
    self.searchC.searchBar.delegate = self;
    self.searchC.searchBar.placeholder = @"我想要的城市࿐";
    [self presentViewController:self.searchC animated:YES completion:nil];
}


#pragma mark -------------- set Collectionlayot --------------

- (UICollectionViewFlowLayout *)setCollectionLayout {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 5;
    
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 5, 10);
    CGFloat itemWidth =(kWidth - 12 * 10) / 4.0;
    CGFloat itemHeight = kHeight / 20;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.headerReferenceSize = CGSizeMake(0, 30);
    
    return flowLayout;
}

#pragma mark -------------- section number --------------

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark -------------- cell number --------------

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 1) {
        return self.hotCityArray.count;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResult.count;
}

#pragma mark -------------- cell load --------------

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CityCollectionViewCell *cityCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cityCell" forIndexPath:indexPath];
    if (indexPath.section == 1) {
        cityCell.cityName.text = self.hotCityArray[indexPath.item];
    } else {
        UIImageView *loactionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cityCell.bounds.size.width / 14, cityCell.bounds.origin.y / 2 + 8 , 15, 15)];
        loactionImageView.image = [UIImage imageNamed:@"icon_cityLoaction"];
        [cityCell addSubview:loactionImageView];
        //定位城市
        cityCell.cityName.frame = CGRectMake(cityCell.bounds.size.width / 3, cityCell.bounds.origin.y, kWidth / 2, cityCell.bounds.size.height);
        cityCell.cityName.textAlignment = NSTextAlignmentLeft;
        cityCell.cityName.text = self.locationCity;
    }
    return cityCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"searchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:identifier];
    }
    if (self.searchResult.count != 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld  %@",(long)(indexPath.row + 1),self.searchResult[indexPath.row]];
    }
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 20, kWidth / 20, header.bounds.size.width - kWidth / 20, header.bounds.size.height - kWidth / 20)];
    if (indexPath.section == 1) {
        title.text = @"热门城市";
    } else {
        title.text = @"当前定位";
    }
    
    [header addSubview:title];
    return header;
    
}

#pragma mark -------------- cell select --------------

- (void) setAlertShow:(NSString *)chooseCity {
    
    UIAlertController *cityChooseAlertC = [UIAlertController alertControllerWithTitle:@"城市切换" message:[NSString stringWithFormat:@"亲爱的，真的要选这个 → [%@]吗?",chooseCity] preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"就TA了" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [LayerShow waterDropCATransitionWithView:self.view dration:1];
        [self.searchC dismissViewControllerAnimated:YES completion:nil];
        [self.searchC.searchBar resignFirstResponder];
        [self.delegate chooseWithCity:chooseCity];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [cityChooseAlertC addAction:sureAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不要嘛" style:(UIAlertActionStyleCancel) handler:nil];
    [cityChooseAlertC addAction:cancelAction];
    [self presentViewController:cityChooseAlertC animated:YES completion:nil];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setAlertShow:self.searchResult[indexPath.row]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.locationCity) {
            [self setAlertShow:self.locationCity];
        }
    } else {
        [self setAlertShow:self.hotCityArray[indexPath.row]];
    }
    
}


#pragma mark -------------- search update --------------

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *inputString = [NSString stringWithUTF8String:searchController.searchBar.text.UTF8String];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [c] %@",inputString];
    [self.searchResult removeAllObjects];
    self.searchResult = [NSMutableArray arrayWithArray:[self.allCityArray filteredArrayUsingPredicate:predicate]];
    [self.searchTVC.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [LayerShow waterDropCATransitionWithView:self.view dration:1];
    [self.delegate chooseWithCity:searchBar.text];
    [self.searchC dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchButton.transform = CGAffineTransformMakeScale(1, 1);
    self.string.text = @"搜索找我";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    self.searchC.searchBar.hidden = YES;
    self.searchTVC.tableView.hidden = YES;
    [self.searchC.searchBar resignFirstResponder];
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
