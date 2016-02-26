//
//  WeatherViewController.m
//  TravelApp
//
//  Created by SZT on 15/12/17.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "WeatherViewController.h"
#import "MainScreenBound.h"
#import "FJYHeader.h"
#import <CoreLocation/CoreLocation.h>

@interface WeatherViewController ()<CLLocationManagerDelegate,CityViewControllerDelegate,MBProgressHUDDelegate>

@property (nonatomic, strong) UIScrollView *rootScrollV;
@property (nonatomic, strong) Weather *weather;
@property (nonatomic, strong) UIView *chartView;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) BlurImageView *backView;
@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, assign) BOOL isNight;
@property (nonatomic, strong) NSString *chooseCityName;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSArray *lowTArray;
@property (nonatomic, strong) NSArray *heightTArray;
@property (nonatomic, strong) CLLocationManager *loactionManager;
@property (nonatomic, strong) UIImageView *snow;
@property (nonatomic, strong) UIImageView *cloud;
@property (nonatomic, strong) UIImageView *rain;
@property (nonatomic, strong) UIImageView *lightning;
@property (nonatomic, strong) UIImageView *yin;
@property (nonatomic, strong) UIImageView *sunshine;
@property (nonatomic, strong) UIImageView *fallStar;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSTimer *time;
@property (nonatomic, strong) NSTimer *timer2;
@property (nonatomic,strong ) MBProgressHUD *hud;

@end

@implementation WeatherViewController


- (void)chooseWithCity:(NSString *)cityName {
    for (UIView *view in self.backView.subviews) {
        [view.layer removeAllAnimations];
        [view removeFromSuperview];
    }
    for (UIView *view in self.rootScrollV.subviews) {
        [view removeFromSuperview];
    }
    if (_time) {
        [_time invalidate];
        _time = nil;
    }
    if (_timer2) {
        [self.timer2 invalidate];
        self.timer2 = nil;
    }
    [self refreshData];
    self.chooseCityName = cityName;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:cityName style:(UIBarButtonItemStylePlain) target:self action:@selector(chooseCity:)];
    [self jsonWithWeatherUrlWithCity:cityName];
}

- (void)chooseCity:(UIBarButtonItem *)barButton {
    CityViewController *cityC = [[CityViewController alloc] init];
    cityC.locationCity = self.locationName;
    cityC.delegate = self;
    [self.navigationController pushViewController:cityC animated:YES];
}

#pragma mark -------------- lazy load --------------

- (Weather *)weather {
    if (!_weather) {
        self.weather = [[Weather alloc] init];
    }
    return _weather;
}

- (UIView *)chartView {
    if (!_chartView) {
        self.chartView = [[UIView alloc] init];
    }
    return _chartView;
}

- (NSMutableArray *)dateArray {
    if (!_dateArray) {
        self.dateArray = [[NSMutableArray alloc] init];
    }
    return _dateArray;
}

- (NSMutableArray *)array {
    if (!_array) {
        self.array = [[NSMutableArray alloc] init];
    }
    return _array;
}


#pragma mark -------------- jsonWeather --------------

- (void)jsonWithWeatherUrlWithCity:(NSString *)city {
    if ([_locationName isEqualToString:@""]) {
        city = @"北京";
    }
    [LORequestManger GET:[NSString stringWithFormat:kWeatherUrl,[city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] success:^(id response) {
        NSDictionary *dictionary = (NSDictionary *)response;
        if ([city isEqualToString:self.locationName]) {

        } else {
            self.weather.currentCity = nil;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hud removeFromSuperview];
        });
        [self.weather setValuesForKeysWithDictionary:dictionary];
        if (self.weather.currentCity == nil && self.chooseCityName) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"noSearchResult" object:nil];
            [self presentViewController:[FJYAlertShow noSearchResult] animated:YES completion:^{
                [self jsonWithWeatherUrlWithCity:@"北京"];
            }];
        } else {
            if ([self.weather.pm25 isEqualToString:@""]) {
                self.weather.pm25 = @"暂无";
            }
            if (self.weather.hintIndex.count == 0) {
                
                NSArray *array = @[@"气温",@"洗车",@"旅游",@"感冒",@"运动",@"紫外线强度"];
                for (int i = 0; i < 6; i++) {
                     NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[@"暂无",array[i]] forKeys:@[@"zs",@"title"]];
                    [self.weather.hintIndex addObject:dic];
                }
            }
            
            for (int i = 0; i < self.weather.recentWeather.count; i++) {
                NSDateFormatter *dateFormatterM = [[NSDateFormatter alloc] init];
                [dateFormatterM setDateFormat:@"MM/dd"];
                NSString *weatherDate = [dateFormatterM stringFromDate:[NSDate date]];
                NSDate *nextDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:[[dateFormatterM dateFromString:weatherDate] timeIntervalSinceReferenceDate] + 24*3600 * i];
                [self.dateArray addObject:[dateFormatterM stringFromDate:nextDate]];
            }
            [self setTodayWeatherMessage];
            [self setHint];
            [self setRecentDaysTempChart];
            [self setRecentDaysTempDetail];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
    
    
}



#pragma mark -------------- setBG --------------

- (void)setBgImageViewWithDay:(NSString *)day night:(NSString *)night {
    
    if (_isNight) {
        if (!_backView) {
            _backView = [[BlurImageView alloc] initWithFrame:[UIScreen mainScreen].bounds imageString:night];
            _textColor = [UIColor whiteColor];
            _backView.tag = 1000;
        } else {
            _backView = (BlurImageView *)[self.view viewWithTag:1000];
            _backView.image = [UIImage imageNamed:night];
        }
    } else {
        if (!_backView) {
            _backView = [[BlurImageView alloc] initWithFrame:[UIScreen mainScreen].bounds imageString:day];
            _backView.tag = 1000;
        } else {
            _backView = (BlurImageView *)[self.view viewWithTag:1000];
            _backView.image = [UIImage imageNamed:day];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    if (!self.locationName) {
        [self locationJudge];
    }
}

- (void)locationJudge {
    if ([[SingleTonForTravel shareTravelSingleTon] isLocate]) {
        self.locationName = [SingleTonForTravel shareTravelSingleTon].locationName;
        if (!self.locationName) {
            self.locationName = @"北京";
        }
    } else {
        self.locationName = @"北京";
    }
    [self jsonWithWeatherUrlWithCity:self.locationName];
}


- (void)loadRootScrollView {
    
    _rootScrollV = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _rootScrollV.scrollEnabled = YES;
    _rootScrollV.showsVerticalScrollIndicator = NO;
    _rootScrollV.contentSize = CGSizeMake(kWidth, kHeight * 1.76);
    [self.view addSubview:self.rootScrollV];
    [self refreshData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBarButtonWithImage) name:@"noSearchResult" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FJYWithWifiOrWWAN) name:@"withWifi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FJYWithWifiOrWWAN) name:@"withWWAN" object:nil];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    if ([[dateFormatter stringFromDate:[NSDate date]] intValue] > 6 && [[dateFormatter stringFromDate:[NSDate date]] intValue] < 17) {
        _isNight = NO;
    } else {
        _isNight = YES;
    }
    
    
    
    [self setBgImageViewWithDay:@"bg_daySun" night:@"bg_nightSun"];
    [self.view addSubview:_backView];
    
    self.navigationItem.title = @"天气☀️";
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    
    
    
    self.cloud = [[UIImageView alloc] initWithFrame:CGRectMake(0, kHeight / 20, 150, 75)];
    self.cloud.image = [UIImage imageNamed:@"clound1"];
    
    
    self.lightning = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 350, 350)];
    self.lightning.image = [UIImage imageNamed:@"thunder"];
    
    self.yin = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 250, 100)];
    if (_isNight) {
        self.yin.image = [UIImage imageNamed:@"cloud_ani_night"];
    } else {
        self.yin.image = [UIImage imageNamed:@"cloud_ani_day"];
    }
    
    self.sunshine = [[UIImageView alloc] initWithFrame:CGRectMake(55, -100, 320, 370)];
    self.sunshine.image = [UIImage imageNamed:@"sun"];
    _sunshine.layer.anchorPoint = CGPointMake(1, 0);
    
    self.fallStar = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2, -100, 100, 100)];
    self.fallStar.image = [UIImage imageNamed:@"meteor"];
    
    
    [self changeBarButtonWithImage];
    
    [self loadRootScrollView];
    
    self.hud = [[MBProgressHUD alloc] init];
    self.hud.userInteractionEnabled = NO;
    self.hud.dimBackground = YES;
    [self.view addSubview:self.hud];
    self.hud.delegate = self;
    [self.hud show:YES];
    
    
    
    
    
    
}

- (void)refreshData {
    
    self.rootScrollV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        for (UIView *view in self.rootScrollV.subviews) {
            [view removeFromSuperview];
        }
        [self loadRootScrollView];
        [self.view addSubview:self.hud];
        [self.hud show:YES];
        if (!self.chooseCityName) {
            [self locationJudge];
        } else {
            [self jsonWithWeatherUrlWithCity:self.chooseCityName];
        }
        
    }];
}


- (void)changeBarButtonWithImage {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_search"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:(UIBarButtonItemStyleDone) target:self action:@selector(chooseCity:)];
}


- (void)FJYWithWifiOrWWAN {
    for (UIView *view in self.rootScrollV.subviews) {
        [view removeFromSuperview];
    }
    [self loadRootScrollView];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    if (!self.chooseCityName) {
        [self locationJudge];
    } else {
        [self jsonWithWeatherUrlWithCity:self.chooseCityName];
    }

}


- (void)rainOrSnowShow {
    if (_array.count > 0) {
        UIImageView *imageView = [_array objectAtIndex:0];
        [_array removeObjectAtIndex:0];
        [self rainOrSnow:imageView];
    }
}

- (void)rainOrSnow:(UIImageView *)view {
    float time;
    if ([self.weather.recentWeather[0][@"weather"] containsString:@"雨"]) {
        time = arc4random() % 8;
    } else {
        time = arc4random() % 26;
    }
    [UIView animateWithDuration:time animations:^{
        view.frame = CGRectMake(view.frame.origin.x+15, kHeight, view.frame.size.width, view.frame.size.height);
    } completion:^(BOOL finished) {
        view.frame = CGRectMake(arc4random() % (int)kWidth, -15,view.frame.size.width, view.frame.size.height);
        [_array addObject:view];
    }];
}




#pragma mark -------------- setLabel --------------

- (void)setLabel:(UILabel *)label fontSize:(CGFloat)size text:(NSString *)text view:(UIView *)view{
    label.font = [UIFont systemFontOfSize:size];
    label.text = text;
    label.textColor = self.textColor;
    [view addSubview:label];
}


- (void)setTodayWeatherMessage {
    
    UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 20, kHeight / 42, kWidth, kHeight / 12)];
    [self setLabel:date fontSize:30 text:[self.weather.currentDate stringByAppendingString:[NSString stringWithFormat:@"   %@",[self.weather.recentWeather[0][@"date"] substringToIndex:2]]] view:self.rootScrollV];
    
    UILabel *cityName = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 10, kHeight / 8.9, kWidth, kHeight / 10)];
    [self setLabel:cityName fontSize:40 text:self.weather.currentCity view:self.rootScrollV];
    
    
    UILabel *weather = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 10, kHeight / 5.3, kWidth / 1.5, kHeight / 10)];
    [self setLabel:weather fontSize:35 text:self.weather.recentWeather[0][@"weather"] view:self.rootScrollV];
    
    
    UILabel *pm = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 20, kHeight / 3.7, kWidth, kHeight / 10)];
    [self setLabel:pm fontSize:30 text:[@"PM25 → " stringByAppendingString:self.weather.pm25] view:self.rootScrollV];
    
    UILabel *currentDay = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 20, kHeight / 2.9, kWidth, kHeight / 10)];
    NSArray *array = [self.weather.recentWeather[0][@"date"] componentsSeparatedByString:@"："];
    if (array.count > 1) {
        NSString *string = array[1];
        [self setLabel:currentDay fontSize:30 text:[@"Current temp: " stringByAppendingString:[string substringToIndex:string.length - 1]] view:self.rootScrollV];
    } else {
        [self setLabel:currentDay fontSize:30 text:[@"Current temp: " stringByAppendingString:@"暂无"] view:self.rootScrollV];
    }
    
    
    [self setWeatherImage];
    
    
}

- (void)sunshineShow
{
    [LayerShow sunshineShowWithSunshine:self.sunshine];
}

- (void)fallStarShow {
    [LayerShow fallStarShowWithFallStar:self.fallStar];
}

- (void)cloudMoveShow {
    NSString *currentWeather = self.weather.recentWeather[0][@"weather"];
    NSString *lastTwoWords = [currentWeather substringFromIndex:currentWeather.length - 1];
    if ([lastTwoWords containsString:@"云"]) {
        [LayerShow cloudShowWithCloud:self.cloud];
    } else {
        [LayerShow cloudShowWithCloud:self.yin];
    }
}

- (void)lightingShow {
    [LayerShow lightningShowWithLigtning:self.lightning];
}

- (NSString *)weatherImage:(int)index{
    NSArray *weatherImageStringArray = @[@"qing",@"duoyun",@"leizhenyu",@"xiaoyu@2x",@"xiaoxue",@"yin@2x",@"mai@2x",@"yejianduoyun@2x",@"yejianqing@2x"];
    NSString *imageString;
    NSString *currentWeather = self.weather.recentWeather[index][@"weather"];
    NSString *lastTwoWords = [currentWeather substringFromIndex:currentWeather.length - 1];
    if ([currentWeather containsString:@"雷"] || [currentWeather containsString:@"阵"]) {
        imageString = weatherImageStringArray[2];
        if (index == 0) {
            if (!self.timer2) {
                [self.backView addSubview:self.lightning];
                self.timer2 = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(lightingShow) userInfo:nil repeats:YES];
            }
        }
    }
    if ([lastTwoWords containsString:@"晴"]) {
        if (_isNight) {
            imageString = weatherImageStringArray[8];
        } else {
            imageString = weatherImageStringArray[0];
        }
        if (index == 0) {
            [self setBgImageViewWithDay:@"bg_daySun" night:@"bg_nightSun"];
            if (_isNight) {
                if (!self.timer2) {
                    [self.backView addSubview:self.fallStar];
                    self.timer2 = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(fallStarShow) userInfo:nil repeats:YES];
                }
            } else {
                if (!self.timer2) {
                    [self.backView addSubview:self.sunshine];
                    self.timer2 = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(sunshineShow) userInfo:nil repeats:YES];
                }
            }
        }
    } else if ([lastTwoWords containsString:@"云"]) {
        if (_isNight) {
            imageString = weatherImageStringArray[7];
        } else {
            imageString = weatherImageStringArray[1];
        }
        if (index == 0) {
            [self setBgImageViewWithDay:@"bg_dayDuoyun" night:@"bg_nightDuoyun"];
            if (!self.timer2) {
                [self.backView addSubview:self.cloud];
                self.timer2 = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(cloudMoveShow) userInfo:nil repeats:YES];
            }
        }
    } else if ([lastTwoWords containsString:@"雨"]) {
        imageString = weatherImageStringArray[3];
        if (index == 0) {
            if (self.array.count > 0) {
                [_array removeAllObjects];
                [_time invalidate];
                _time = nil;
            }
            _array = [NSMutableArray array];
            for (int i = 0; i < 100; i++) {
                _rain = [[UIImageView alloc] initWithFrame:CGRectMake(arc4random() % (int)kWidth, arc4random() * 11, 2, 15)];
                _rain.alpha = 0.5;
                _rain.image = [UIImage imageNamed:@"rain_point"];
                [self.backView addSubview:_rain];
                [_array addObject:_rain];
            }
            _time = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(rainOrSnowShow) userInfo:nil repeats:YES];
            [self setBgImageViewWithDay:@"bg_dayYu" night:@"bg_nightYu"];
        }
    } else if ([lastTwoWords containsString:@"阴"]) {
        imageString = weatherImageStringArray[5];
        if (index == 0) {
            [self setBgImageViewWithDay:@"bg_dayYin" night:@"bg_nightYin"];
            if (!self.timer2) {
                [self.backView addSubview:self.yin];
                self.timer2 = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(cloudMoveShow) userInfo:nil repeats:YES];
            }
        }
    } else if ([lastTwoWords containsString:@"雪"]) {
        imageString = weatherImageStringArray[4];
        if (index == 0) {
            if (self.array.count > 0) {
                [_array removeAllObjects];
                [_time invalidate];
                _time = nil;
            }
            _array = [NSMutableArray array];
            for (int i = 0; i < 20; i++) {
                _snow = [[UIImageView alloc] initWithFrame:CGRectMake(arc4random() % (int)kWidth, arc4random() * 11, 15, 15)];
                _snow.image = [UIImage imageNamed:@"snow"];
                _snow.alpha = 0.8;
                [self.backView addSubview:self.snow];
                [_array addObject:self.snow];
            }
            _time = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(rainOrSnowShow) userInfo:nil repeats:YES];
            [self setBgImageViewWithDay:@"bg_daySnow" night:@"bg_nightSnow"];
        }
    } else if ([lastTwoWords containsString:@"雾"] | [lastTwoWords containsString:@"霾"]) {
        imageString = weatherImageStringArray[6];
        if (index == 0) {
            [self setBgImageViewWithDay:@"bg_dayWu" night:@"bg_nightWu"];
        }
    }
   
    return imageString;
}


- (void)setWeatherImage {
    
    UIImageView *weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth * 3.5/5,  kHeight / 8,  kWidth / 5, kHeight / 10)];
    weatherImageView.image = [UIImage imageNamed:[self weatherImage:0]];
    [self.rootScrollV addSubview:weatherImageView];
}




- (void)setLabelOfHint:(UILabel *)label imageString:(NSString *)imageString index:(NSInteger)index fontSize:(CGFloat)size{
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(label.bounds.origin.x, label.bounds.origin.y, label.bounds.size.width, 70)];
    imageView.image = [UIImage imageNamed:imageString];
    imageView.contentMode = UIViewContentModeCenter;
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, label.bounds.origin.y + 80, label.bounds.size.width, 10)];
    title.textColor = _textColor;
    title.font = [UIFont systemFontOfSize:size];
    title.textAlignment = NSTextAlignmentCenter;
    if (index == 0) {
        title.text = [@"气温 " stringByAppendingString:self.weather.hintIndex[index][@"zs"]];
    } else {
        title.text = [self.weather.hintIndex[index][@"title"]  stringByAppendingString:[NSString stringWithFormat:@" %@",self.weather.hintIndex[index][@"zs"]]];
        if ([self.weather.hintIndex[index][@"title"]  stringByAppendingString:[NSString stringWithFormat:@" %@",self.weather.hintIndex[index][@"zs"]]].length > 7) {
            title.font = [UIFont systemFontOfSize:size - 1];
        }
    }
    
    [self.rootScrollV addSubview:label];
    [label addSubview:title];
    [label addSubview:imageView];
    
}

- (void)setHint {
    
    for (NSInteger i = 0; i < self.weather.hintIndex.count; i++) {
        UILabel *hint;
        if (i <= 2) {
            hint = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 20 + i * kWidth * 3/10, kHeight / 2.26, kWidth * 3/10, kHeight / 6)];
        } else {
            hint = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 20 + (i - 3) * kWidth * 3/10, kHeight /1.65, kWidth * 3/10, kHeight / 6)];
        }
        if (_isNight) {
            [self setLabelOfHint:hint imageString:[NSString stringWithFormat:@"icon_hint%ld",i+1] index:i fontSize:14];
        } else {
            [self setLabelOfHint:hint imageString:[NSString stringWithFormat:@"icon_hintDay%ld",i+1] index:i fontSize:14];
        }
        
    }
}



- (void)setLineChart:(NSArray *)lowTempArray hightData:(NSArray *)highTempArray yVMin:(CGFloat)yVMin xLabels:(NSArray *)xls{
    
    PNLineChart *lineChart = [[PNLineChart alloc] initWithFrame:self.chartView.bounds];
    lineChart.chartMarginLeft = 35;
    lineChart.xLabelColor = _textColor;
    lineChart.xLabelFont = [UIFont systemFontOfSize:15];;
    lineChart.showCoordinateAxis =YES;
    lineChart.yValueMin = yVMin;
    
    lineChart.yLabelColor = _textColor;
    lineChart.yLabelFont = [UIFont systemFontOfSize:15];
    [lineChart setXLabels:xls];
    PNLineChartData *dataLow = [PNLineChartData new];
    dataLow.color = PNFreshGreen;
    dataLow.inflexionPointStyle = PNLineChartPointStyleCircle;
    dataLow.itemCount = lineChart.xLabels.count;
    dataLow.getData = ^(NSUInteger index) {
        CGFloat yValue = [lowTempArray[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    PNLineChartData *dataHight = [PNLineChartData new];
    dataHight.color = PNRed;
    dataHight.inflexionPointStyle = PNLineChartPointStyleTriangle;
    dataHight.itemCount = lineChart.xLabels.count;
    dataHight.getData = ^(NSUInteger index) {
        CGFloat yValue = [highTempArray[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    lineChart.chartData = @[dataLow,dataHight];
    lineChart.backgroundColor = [UIColor clearColor];
    [lineChart strokeChart];
    [self.chartView addSubview:lineChart];
}


- (void)setRecentDaysTempChart {
    
    for (UIView *view in self.chartView.subviews) {
        [view removeFromSuperview];
    }
    
    self.chartView.frame = CGRectMake(kWidth / 40, kHeight * 9.5/8, kWidth * 19/20, kHeight / 3);
    self.chartView.backgroundColor = [UIColor clearColor];
    [self.rootScrollV addSubview:self.chartView];
    
    UILabel *chartLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 15 , kHeight * 22.2/20, kWidth / 2, 10)];
    [self setLabel:chartLabel fontSize:20 text:@"气温变化趋势" view:self.rootScrollV];
    
    UILabel *hight = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 2.1 , kHeight * 11/10, kWidth / 8, 10)];
    [self setLabel:hight fontSize:10 text:@"最高温度" view:self.rootScrollV];
    UIImageView *redLine = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 1.65 , kHeight * 11/10, kWidth / 8, 10)];
    redLine.image = [UIImage imageNamed:@"icon_lineChartRed"];
    [self.rootScrollV addSubview:redLine];
    
    UILabel *low = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 2.1 , kHeight * 22.4/20, kWidth / 8, 10)];
    [self setLabel:low fontSize:10 text:@"最低温度" view:self.rootScrollV];
    UIImageView *greenLine = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 1.65 , kHeight * 22.4/20, kWidth / 8, 10)];
    greenLine.image = [UIImage imageNamed:@"icon_lineChartGreen"];
    [self.rootScrollV addSubview:greenLine];
    
    UIButton *chartChangeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    chartChangeButton.frame = CGRectMake(kWidth / 1.3, kHeight * 11/10 , kWidth / 18, kWidth / 18);
    
    
    
    NSArray *array = @[@"今天",@"明天",@"后天",@"大后天"];
    NSMutableArray *Xarray = [NSMutableArray array];
    NSMutableArray *lowTempArray = [NSMutableArray array];
    NSMutableArray *highTempArray = [NSMutableArray array];
    
    CGFloat lowLast = 0.0;
    for (int i = 0; i < self.weather.recentWeather.count; i++) {
        [Xarray addObject:[array[i] stringByAppendingString:self.dateArray[i]]];
        NSArray *tempArray = [self.weather.recentWeather[i][@"temperature"] componentsSeparatedByString:@"~"];
        if ([self.weather.recentWeather[i][@"temperature"] containsString:@"~"]) {
            [highTempArray addObject:tempArray[0]];
            [lowTempArray addObject:[tempArray[1] componentsSeparatedByString:@"℃"][0]];
            if (i == 0) {
                lowLast = [[tempArray[1] componentsSeparatedByString:@"℃"][0] floatValue];
            } else {
                lowLast = lowLast < [[tempArray[1] componentsSeparatedByString:@"℃"][0] floatValue] ? lowLast : [[tempArray[1] componentsSeparatedByString:@"℃"][0] floatValue];
            }

        } else {
            if ([self.weather.recentWeather[i][@"temperature"] isEqualToString:@""]) {
                [highTempArray addObject:@""];
                [lowTempArray addObject:@""];
            } else {
                [highTempArray addObject:self.weather.recentWeather[i][@"temperature"]];
                [lowTempArray addObject:self.weather.recentWeather[i][@"temperature"]];
            }
            
        }
        
        
    }
    _lowTArray = lowTempArray;
    _heightTArray = highTempArray;
    [self setLineChart:lowTempArray hightData:highTempArray yVMin:lowLast xLabels:Xarray];
    
}

- (void)setRecentDetailWeatherMesWithLabel:(UILabel *)label index:(int)index {
    NSString *string;
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.bounds.origin.x, label.bounds.origin.y, label.bounds.size.width, label.bounds.size.height / 4)];
    [self setLabel:dateLabel fontSize:14 text:[[self.weather.recentWeather[index][@"date"] substringToIndex:2] stringByAppendingString:self.dateArray[index]] view:label];
    
    
    UIImageView *weatherIV = [[UIImageView alloc] initWithFrame:CGRectMake((label.bounds.size.width - label.bounds.size.height/4) / 2, label.bounds.size.height / 4 , label.bounds.size.height / 4, label.bounds.size.height / 4)];
    weatherIV.image = [UIImage imageNamed:[self weatherImage:index]];
    [label addSubview:weatherIV];
    
    UILabel *temRang = [[UILabel alloc] initWithFrame:CGRectMake(label.bounds.origin.x, label.bounds.size.height / 2, label.bounds.size.width, label.bounds.size.height / 4)];
    string = [NSString stringWithFormat:@"%@~%@°C",self.lowTArray[index],self.heightTArray[index]];
    if (string.length > 8) {
        [self setLabel:temRang fontSize:14 text:string view:label];
    } else {
        [self setLabel:temRang fontSize:15 text:string view:label];
    }

    
    UILabel *wind = [[UILabel alloc] initWithFrame:CGRectMake(label.bounds.origin.x, label.bounds.size.height * 3/4, label.bounds.size.width, label.bounds.size.height / 4)];
    wind.numberOfLines = 0;
    wind.textAlignment = NSTextAlignmentCenter;
    string = self.weather.recentWeather[index][@"wind"];
    if (string.length >= 5) {
        [self setLabel:wind fontSize:12 text:string view:label];
    } else {
        [self setLabel:wind fontSize:13 text:string view:label];
    }
}


- (void)setRecentDaysTempDetail {
    for (int i = 0; i < self.weather.recentWeather.count; i++) {
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth / 20 + i * kWidth * 9/40, kHeight / 1.225, kWidth * 9/40, kHeight / 4.5)];
        [self setRecentDetailWeatherMesWithLabel:detailLabel index:i];
        [self.rootScrollV addSubview:detailLabel];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
