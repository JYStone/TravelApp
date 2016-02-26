//
//  StrategyViewController.m
//  TravelApp
//
//  Created by SZT on 15/12/17.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "StrategyViewController.h"

#import "StrategyUrl.h"
#import "StrategyCell.h"
#import "Strategy.h"
#import "MainScreenBound.h"
#import "StrategyDetailViewController.h"




//右上角选择器坐标
#define kMyPickerW 100
#define kMyPickerH 180
#define kMyPickerX (kWidth-kMyPickerW)
//#define kMyPickerY (64-kMyPickerH)
#define kMyPickerY  0-kMyPickerH

//选择器每行的宽高
#define kPickerElementW  kMyPickerW
#define kPickerElementH  kMyPickerH/3


//右上角招牌
#define kIconImageW  125
#define kIconImageH  95
#define kIconImageX  (kWidth-kIconImageW)
//#define kIconImageY  60
#define kIconImageY  0

#pragma mark ---------右上角招牌元素的坐标------------

//左边绳子
#define kLeftItemW    3
#define kLeftItemH    30
#define kLeftItemX    35
#define kLeftItemY    0

//右边绳子
#define kRightItemW   3
#define kRightItemH   30
#define kRightItemX   80
#define kRightItemY    0

//木板
#define kWoodX  10
#define kWoodY  (kRightItemY+kRightItemH)-3
#define kWoodW  (kIconImageW-2*kWoodX)
#define kWoodH  50

//木板里的标题
#define kTitleLabelW  kWoodW
#define kTitleLabelH  30
#define kTitleLabelX  0
#define kTitleLabelY  (kWoodH/2-kTitleLabelH/2)


@interface StrategyViewController () <UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)UITableView *strategyTableView;


@property(nonatomic,strong)UITableView *stayAtHomeTableView;

@property(nonatomic,retain)NSArray *titleArray;

@property(nonatomic,strong)UIPickerView   *myPicker;

@property(nonatomic,strong)UIImageView *iconImage;

@property(nonatomic,strong)UILabel *titleLabel;

@property(nonatomic,retain)NSArray *outStrategys;

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)UISegmentedControl *segment;

@property(nonatomic,strong)MBProgressHUD *HUD;

@property(nonatomic,strong)MBProgressHUD *netDontWorkHUD;

@end


@implementation StrategyViewController

#pragma mark ---------ViewDidLoad------------


/**
 页面主要内容：一个scrollView里面包含两个tableView
 */

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectNetAndReloadData) name:@"withWifi" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectNetAndReloadData) name:@"withWWAN" object:nil];
    
    
    self.navigationController.navigationBar.barTintColor = navigationBarBackGroundColor;
    
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self jsonOfAnalysicStrategyWithUrl:kNearPlayUrl];
    });
    dispatch_async(queue, ^{
        [self jsonOfOutStrategyWithUrl];
        
    });
    
    #pragma mark------------xin------------------
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    _scrollView.contentSize = CGSizeMake(kWidth*2, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
    
    
    #pragma mark------------xin------------------
    

    [_scrollView addSubview:self.stayAtHomeTableView];
    [_scrollView addSubview:self.strategyTableView];
    
    self.strategyTableView.dataSource = self;
    self.strategyTableView.delegate = self;
    self.stayAtHomeTableView.delegate = self;
    self.stayAtHomeTableView.dataSource = self;
    
   
    
    //  设置点击事件
    self.titleLabel.text = @"周末逛店";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.iconImage addGestureRecognizer:tap];
    
    [self.view insertSubview:self.iconImage aboveSubview:self.strategyTableView];
    
    [self.view insertSubview:self.myPicker aboveSubview:self.strategyTableView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(returnPickerAndShowTitle) name:@"changeOK" object:nil];//收回选择器放下iconImage

    self.navigationController.navigationBar.translucent = NO;
    
    //给导航栏设置segmengt
    UIView *navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    [navigationView addSubview:self.segment];
    [self.segment addTarget:self action:@selector(segmentAction:) forControlEvents:(UIControlEventValueChanged)];
    self.segment.selectedSegmentIndex = 0;
    self.navigationItem.titleView = navigationView;
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.labelText = @"正在刷新";

    self.HUD.dimBackground = YES;
    
}

#pragma mark ---------按钮点击 ------------


- (void)connectNetAndReloadData
{
    [self jsonOfAnalysicStrategyWithUrl:kNearPlayUrl];
    [self jsonOfOutStrategyWithUrl];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.7 animations:^{
        self.iconImage.frame = CGRectMake(kIconImageX, 0-kIconImageH, kIconImageW, kIconImageH);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.myPicker.frame = CGRectMake(kMyPickerX, 0, kMyPickerW, kMyPickerH);
        }];
    }];
}

- (void)segmentAction:(UISegmentedControl*)segment
{
    if (segment.selectedSegmentIndex == 0) {
        if(self.scrollView.contentOffset.x !=0){
//            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [UIView animateWithDuration:0.4 animations:^{
                [self.scrollView setContentOffset:CGPointMake(0, 0)];
                self.iconImage.frame = CGRectMake(kIconImageX, kIconImageY, kIconImageW, kIconImageH);
                self.myPicker.frame = CGRectMake(kMyPickerX, kMyPickerY, kMyPickerW, kMyPickerH);
            }];
        }
    }else{
        if (self.scrollView.contentOffset.x != kWidth) {
//            [self.scrollView setContentOffset:CGPointMake(kWidth, 0) animated:YES];
            [UIView animateWithDuration:0.4 animations:^{
                [self.scrollView setContentOffset:CGPointMake(kWidth, 0)];
                self.iconImage.frame = CGRectMake(0-kIconImageW, kIconImageY, kIconImageW, kIconImageH);
                self.myPicker.frame = CGRectMake(0-kMyPickerW, kMyPickerY, kMyPickerW, kMyPickerH);
            }];
        }
    }
}


#pragma mark ---------lazy------------

- (UISegmentedControl *)segment
{
    if (!_segment) {
        _segment = [[UISegmentedControl alloc]initWithItems:@[@"出门",@"宅家"]];
        _segment.tintColor = [UIColor clearColor];
        _segment.frame = CGRectMake(0, 0, 80, 20);
        NSDictionary *selectDict = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:14],
                                     NSForegroundColorAttributeName:[UIColor grayColor]
                                     };
        [_segment setTitleTextAttributes:selectDict forState:(UIControlStateNormal)];
        NSDictionary *unSelectDict = @{
                                       NSFontAttributeName:[UIFont systemFontOfSize:14],
                                       NSForegroundColorAttributeName:[UIColor blackColor]
                                       };
        [_segment setTitleTextAttributes:unSelectDict forState:(UIControlStateSelected)];
    }
    return _segment;
}

-(UIImageView *)iconImage
{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(kIconImageX, kIconImageY, kIconImageW, kIconImageH)];
        
        UIImageView *leftItem = [[UIImageView alloc]initWithFrame:CGRectMake(kLeftItemX, kLeftItemY, kLeftItemW, kLeftItemH)];
        leftItem.image = [UIImage imageNamed:@"绳子"];
        [_iconImage addSubview:leftItem];
        
        UIImageView *rightItem = [[UIImageView alloc]initWithFrame:CGRectMake(kRightItemX, kRightItemY, kRightItemW, kRightItemH)];
        rightItem.image = [UIImage imageNamed:@"绳子"];
        [_iconImage addSubview:rightItem];
        
        UIImageView *woodImage = [[UIImageView alloc]initWithFrame:CGRectMake(kWoodX, kWoodY, kWoodW, kWoodH)];
        woodImage.image = [UIImage imageNamed:@"木板"];
        [woodImage addSubview:self.titleLabel];
        [_iconImage addSubview:woodImage];
        
        _iconImage.userInteractionEnabled = YES;
    }
    return _iconImage;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kTitleLabelX, kTitleLabelY, kTitleLabelW, kTitleLabelH)];
        _titleLabel.font = [UIFont fontWithName:@"迷你简黛玉" size:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

-(NSArray *)outStrategys
{
    if (!_outStrategys) {
        _outStrategys = [NSArray arrayWithObjects:kWeekendUrl,kLessonUrl,kNearPlayUrl,kTastFoodUrl,kClubUrl,kLeisureUrl, nil];
    }
    return _outStrategys;
}

-(NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSArray arrayWithObjects:@"周末逛店",@"体验课",@"周边游",@"尝美食",@"酒吧",@"休闲", nil];
    }
    return _titleArray;
}


-(UITableView *)strategyTableView
{
    if (!_strategyTableView) {
        _strategyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:(UITableViewStylePlain)];
        _strategyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _strategyTableView;
}

-(UITableView *)stayAtHomeTableView
{
    if (!_stayAtHomeTableView) {
        _stayAtHomeTableView = [[UITableView alloc]initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight) style:(UITableViewStylePlain)];
        _stayAtHomeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _stayAtHomeTableView;
}


-(UIPickerView *)myPicker
{
    if (!_myPicker) {
        _myPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(kMyPickerX, kMyPickerY, kMyPickerW, kMyPickerH)];
        _myPicker.delegate = self;
        _myPicker.dataSource = self;
    }
    return _myPicker;
}



#pragma mark------------scrollView代理------------------

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    static float X = 0;
    

    if (self.scrollView.contentOffset.x !=X  && self.segment.selectedSegmentIndex == 0) {
        X = self.scrollView.contentOffset.x;
        self.myPicker.frame = CGRectMake(kMyPickerX-X, self.myPicker.frame.origin.y, kMyPickerW, kMyPickerH);
        self.iconImage.frame = CGRectMake(kIconImageX-X, self.iconImage.frame.origin.y, kIconImageW, kIconImageH);
    }

    if ((self.myPicker.frame.origin.y != kMyPickerY)  && (self.iconImage.frame.origin.y != kIconImageY) ) {
        
        if (self.scrollView.contentOffset.x!=0) {//左右滑动
            self.myPicker.frame = CGRectMake(kMyPickerX, kMyPickerY, kMyPickerW, kMyPickerH);
            self.iconImage.frame = CGRectMake(kIconImageX, kIconImageY, kIconImageW, kIconImageH);
        }
        else{//上下滑动
            
            [UIView animateWithDuration:0.7 animations:^{
                self.myPicker.frame = CGRectMake(kMyPickerX, kMyPickerY, kMyPickerW, kMyPickerH);
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:0.4 animations:^{
                        self.iconImage.frame = CGRectMake(kIconImageX, kIconImageY, kIconImageW, kIconImageH);
                        }];
                    }
            }];
            
        }
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.scrollView.contentOffset.x == 0 && self.scrollView.contentOffset.y==0) {
        self.segment.selectedSegmentIndex = 0;
    }
    
    if (self.scrollView.contentOffset.x == kWidth && self.scrollView.contentOffset.y==0){
        self.segment.selectedSegmentIndex = 1;
    }
}


#pragma mark ---------tableView数据源方法------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.strategyTableView) {
        return (self.allStrategys.count +1);
    }else{
        return (self.allHomeStrategys.count +1);
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"cell";
    StrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[StrategyCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    
    if (tableView == self.strategyTableView) {
        if (indexPath.row == self.allStrategys.count) {
            cell.titleLabel.text = nil;
            [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:nil]];
        }else{
            Strategy *strategy = self.allStrategys[indexPath.row];
            cell.titleLabel.text = strategy.title;
            [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:strategy.cover_image_url]];
        }
    }
    if (tableView == self.stayAtHomeTableView) {
        if (indexPath.row == self.allHomeStrategys.count) {
            cell.titleLabel.text = nil;
            [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:nil]];
        }else{
        Strategy *strategy = self.allHomeStrategys[indexPath.row];
        cell.titleLabel.text = strategy.title;
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:strategy.cover_image_url]];
        }
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.allHomeStrategys.count || indexPath.row == self.allStrategys.count) {
        return 113;
    }else{
        
        return 150;
 
    }
    
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Strategy *strategy = [[Strategy alloc]init];
    if (tableView == self.strategyTableView) {
        strategy = self.allStrategys[indexPath.row];
    }else{
        strategy = self.allHomeStrategys[indexPath.row];
    }
    
    StrategyDetailViewController *strategyDetailVC = [[StrategyDetailViewController alloc]init];
    strategyDetailVC.strategyUrl = strategy.content_url;
    strategyDetailVC.imageUrl = strategy.cover_image_url;
    [self.navigationController pushViewController:strategyDetailVC animated:YES];
}

#pragma mark ---------myPickerView数据源------------

//选择器个数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//每个选择器里面总行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 6;
}

//选择器每行高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return kPickerElementH;
}

#pragma mark ---------myPickerView代理------------

//自定义picker每行的视图
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kPickerElementW, kPickerElementH)];
    CGFloat tempW = tempView.frame.size.width;
    CGFloat tempH = tempView.frame.size.height;
    
//    添加木板
    UIImageView *woodImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5,tempW-2*5, tempH)];
    woodImage.image = [UIImage imageNamed:@"木板"];
    [tempView addSubview:woodImage];
    
//    木板上面的标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, woodImage.frame.size.width, woodImage.frame.size.height)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = self.titleArray[row];
    titleLabel.font = [UIFont fontWithName:@"迷你简黛玉" size:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [woodImage addSubview:titleLabel];
    
    return tempView;
}


//picker选中
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *currentTitle = self.titleArray[row];
    if ([currentTitle isEqualToString:self.titleLabel.text]) {
        
    }else{
        self.titleLabel.text = currentTitle;
        NSString *currentStrate = self.outStrategys[row];

        [self jsonOfAnalysicStrategyWithUrl:currentStrate];
    }
}


- (void)returnPickerAndShowTitle
{
    [UIView animateWithDuration:0.7 animations:^{
        self.myPicker.frame = CGRectMake(kMyPickerX, kMyPickerY, kMyPickerW, kMyPickerH);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.4 animations:^{
                self.iconImage.frame = CGRectMake(kIconImageX, kIconImageY, kIconImageW, kIconImageH);
            }];

        }
    }];

}


#pragma mark ---------json数据解析------------



-(void)jsonOfAnalysicStrategyWithUrl:(NSString *)urlString
{
    
    [LORequestManger GET:urlString success:^(id response) {
        self.allStrategys = [[NSMutableArray alloc]init];
        NSDictionary *rootDict = (NSDictionary *)response;
        NSArray *rootArray = rootDict[@"data"][@"items"];
        for (NSDictionary *dict in rootArray) {
            Strategy *strategy = [[Strategy alloc]init];
            [strategy setValuesForKeysWithDictionary:dict];
            [self.allStrategys addObject:strategy];
        }
       dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            [self.strategyTableView reloadData];
        });
        [self.strategyTableView.mj_header endRefreshing];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeOK" object:nil];
        [self.HUD hide:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.netDontWorkHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.netDontWorkHUD.labelText = @"网络不给力";

        self.netDontWorkHUD.dimBackground = YES;
        
        [self.netDontWorkHUD hide:YES afterDelay:1.5];

    }];

}

-(void)jsonOfOutStrategyWithUrl
{
    [LORequestManger GET:kDIYUrl success:^(id response) {
        
        self.allHomeStrategys = [[NSMutableArray alloc]init];
        NSDictionary *rootDict = (NSDictionary *)response;
        NSArray *rootArray = rootDict[@"data"][@"items"];
        for (NSDictionary *dict in rootArray) {
            Strategy *strategy = [[Strategy alloc]init];
            [strategy setValuesForKeysWithDictionary:dict];
            [self.allHomeStrategys addObject:strategy];
        }
        
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            [self.stayAtHomeTableView reloadData];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        self.netDontWorkHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.netDontWorkHUD.labelText = @"网络不给力";
        
        self.netDontWorkHUD.dimBackground = YES;
        
        [self.netDontWorkHUD hide:YES afterDelay:1.5];
        
        
    }];
}



@end
