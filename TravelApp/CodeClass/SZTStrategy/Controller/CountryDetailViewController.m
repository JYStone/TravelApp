//
//  CountryDetailViewController.m
//  TravelApp
//
//  Created by SZT on 15/12/23.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "CountryDetailViewController.h"
#import "CategrayViewController.h"
#import "MainScreenBound.h"

#import "ListCell.h"
#import "City.h"
#import "Attractions.h"//景点
#import "TouristAttraction.h"//推荐地点moxing
#import "AttractionDetailViewController.h"

#import "TravelBlog.h"

#import "AllAttractionsTableViewController.h"

#import "AllBlogTableViewController.h"

#import "UINavigationBar+Awesome.h"

#define NAVBAR_CHANGE_POINT 50

#define marginY 64

#define kIconImageX  0
#define kIconImageY  0-marginY
#define kIconImageW  kWidth
#define kIconImageH  200+marginY

#define kButtonX    0
#define kButtonY   (kIconImageH-15)
#define kButtonW   kWidth/4
#define kBUttonH   kButtonW

#define kScrollViewW  kWidth
#define kScrollViewH  kHeight+marginY
#define kScrollViewX  0
#define kScrollViewY  0-marginY

#define kMargin 10

#define kaddressImageX  10
#define kaddressImgaeY  (kButtonY+kBUttonH+30)
#define kaddressImageW  (kWidth-kaddressImageX*3)/2
#define kaddressImageH  kaddressImageW

#define kMoreButtonX   20
#define kMoreButtonY   (kaddressImgaeY+kMargin*2+kaddressImageH*3+10)
#define kMoreButtonW   (kWidth-2*kMoreButtonX)
#define kMoreButtonH   30

//图片上面的城市名字
#define kNamelabelX   15
#define kNamelabelY   (kIconImageH-60)
#define kNamelabelW   150
#define kNamelabelH   30

//去过的label
#define kVisitedX kNamelabelX
#define kVisitedY  (kNamelabelY+kNamelabelH)
#define kVisitedW  70
#define kVisitedH   10

//喜欢的label
#define kLikeX   (kNamelabelX+kVisitedW)
#define kLikeY   kVisitedY
#define kLikeW   90
#define kLikeH   10




#define kContenSizeH  kaddressImgaeY+kMargin*2+kaddressImageH*3+10+50+20



@interface CountryDetailViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIImageView *iconImage;

@property(nonatomic,strong)UIButton *backButton;

//@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,retain)NSMutableArray  *allAttractions;

@property(nonatomic,assign)NSInteger rowCount;

@property(nonatomic,strong)UIScrollView *scrollview;

@property(nonatomic,retain)NSArray  *typearray;

@property(nonatomic,strong)UIButton *backButton0;

//@property(nonatomic,retain)NSMutableArray  *allTouristAttraction;

@end

@implementation CountryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rowCount = 0;
    self.view.backgroundColor = [UIColor whiteColor];

    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];

    self.tabBarController.tabBar.hidden = YES;
    
    [self.view addSubview:self.iconImage];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:self.city.cover]];

//    透明的label
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kIconImageX, kIconImageY, kWidth, kIconImageH)];
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.scrollview addSubview:titleLabel];
    
//    添加城市名字，去过lable，喜欢label
    
    [self addNameAndTwoLabel];

    //添加米色背景
    UIImageView *miseBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"米色.jpg"]];
    miseBG.frame = CGRectMake(0, kIconImageH-15, kWidth, kContenSizeH-kIconImageH);
    miseBG.layer.masksToBounds = YES;
    miseBG.layer.cornerRadius = 15;
    [self.scrollview addSubview:miseBG];
    
    
  #pragma mark------------添加4个按钮啊------------------
    
    [self addButtonsWithTarget:self action:@selector(buttonAction:)];
    #pragma mark------------添加图片------------------
    [self addImageViews];
    
    #pragma mark------------6张图片json解析------------------
    [self jsonOfTouristAttraction];
    
    self.scrollview.contentSize = CGSizeMake(kWidth, kContenSizeH);
    [self.view addSubview:self.scrollview];
    


    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"leftArrow@2x.jpg"]imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)] style:(UIBarButtonItemStylePlain) target:self action:@selector(backAction:)];
    

    self.navigationItem.leftBarButtonItem = backButton;
    
    #pragma mark------------添加“”更多按钮“”添加target和action------------------
    
    [self addMoreAttractionButton];
    
    #pragma mark------------在米色的背景添加@“推荐地点”和两条线条------------------
    
    [self addAbstractAttraction:miseBG];


}


//返回按钮
- (void)backAction:(UIBarButtonItem *)button
{
    self.tabBarController.tabBar.hidden = NO;

    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//更多旅游推荐地点的按钮
- (void)moreAttractionsAction:(UIButton *)button
{
    AllAttractionsTableViewController *allAttractionTVC = [[AllAttractionsTableViewController alloc]initWithStyle:(UITableViewStylePlain)];
    
    allAttractionTVC.city = self.city;
    
    [self.navigationController pushViewController:allAttractionTVC animated:YES];
}

#pragma mark------------添加4个按钮------------------

- (void)addButtonsWithTarget:(id)target  action:(SEL)action
{
    NSArray *array = [NSArray arrayWithObjects:@"不可错过",@"实用须知",@"主题榜单",@"精品游记", nil];
    for (int i = 0; i < 4; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i*kButtonW, kButtonY, kButtonW, kBUttonH)];
        button.tag = 100+i;

        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, button.frame.size.width-2*20, button.frame.size.width-2*20)];
        iconImage.image =  [UIImage imageNamed:array[i]];
        [button addSubview:iconImage];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10+button.frame.size.width-2*20, button.frame.size.width-2*10, 10)];
        label.font = [UIFont systemFontOfSize:11];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = array[i];
        [button addSubview:label];
        
        [button addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
        [self.scrollview addSubview:button];
    }
}

#pragma mark------------添加城市名字，去过lable，喜欢label------------------
- (void)addNameAndTwoLabel
{
    //添加城市名字，去过，喜欢
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kNamelabelX, kNamelabelY, kNamelabelW, kNamelabelH)];
    nameLabel.text = self.city.name_zh;
    nameLabel.textColor = [UIColor whiteColor];
    
    [self.scrollview addSubview:nameLabel];
    
    UILabel *visitedLabel = [[UILabel alloc]initWithFrame:CGRectMake(kVisitedX, kVisitedY, kVisitedW, kVisitedH)];
    visitedLabel.text = [NSString stringWithFormat:@"%@ 去过 /",self.city.visited_count];
    visitedLabel.font = [UIFont systemFontOfSize:11];
    visitedLabel.textColor = [UIColor whiteColor];

    [self.scrollview addSubview:visitedLabel];
    
    
    UILabel *likeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kLikeX, kLikeY, kLikeW, kLikeH)];
    likeLabel.text = [NSString stringWithFormat:@"%@ 喜欢",self.city.wish_to_go_count];
    likeLabel.font = [UIFont systemFontOfSize:11];
    likeLabel.textColor = [UIColor whiteColor];

    [self.scrollview addSubview:likeLabel];
}

#pragma mark------------添加“更多按钮”------------------
- (void)addMoreAttractionButton{
    UIButton *moreButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    moreButton.layer.masksToBounds = YES;
    moreButton.layer.cornerRadius = kMoreButtonH/2;
    moreButton.backgroundColor = [UIColor redColor];
    moreButton.frame = CGRectMake(kMoreButtonX, kMoreButtonY, kMoreButtonW, kMoreButtonH);
    [moreButton addTarget:self action:@selector(moreAttractionsAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [moreButton setTitle:@"更多 " forState:(UIControlStateNormal)];
    [self.scrollview addSubview:moreButton];
}

#pragma mark------------米色背景添加“推荐地点”------------------
- (void)addAbstractAttraction:(UIImageView *)miseBG
{
    UILabel  *recommandLabel = [[UILabel alloc]initWithFrame:CGRectMake((kWidth-60)/2, kBUttonH+10, 60, 10)];
    recommandLabel.font = [UIFont systemFontOfSize:11];
    recommandLabel.text = @"推荐地点";
    //    recommandLabel.backgroundColor = [UIColor cyanColor];
    recommandLabel.textAlignment = NSTextAlignmentCenter;
    [miseBG addSubview:recommandLabel];
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(recommandLabel.frame.origin.x-90, kBUttonH+10+4, 80, 1)];
    leftView.backgroundColor = [UIColor grayColor];
    [miseBG addSubview:leftView];
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(recommandLabel.frame.origin.x+recommandLabel.frame.size.width+10, kBUttonH+10+4, 80, 1)];
    rightView.backgroundColor = [UIColor grayColor];
    [miseBG addSubview:rightView];

}

- (void)addImageViews
{
    //收到通知后加载6张图片
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadImage) name:@"loadImage" object:nil];
    for (int i= 0; i < 6; i ++) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, kaddressImageH-50, kaddressImageW, 20)];
        label.textColor = [UIColor whiteColor];
        label.tag = 300+i;
        
        NSInteger row = i%2;
        NSInteger col = i/2;
        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(kaddressImageX+row*(kMargin+kaddressImageW), kaddressImgaeY+col*(kaddressImageH+kMargin), kaddressImageW, kaddressImageH)];
        iconImage.tag = 200+i;
        iconImage.userInteractionEnabled = YES;
        [iconImage addSubview:label];
        
        iconImage.layer.masksToBounds = YES;
        iconImage.layer.cornerRadius = 10;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapAction:)];
        
        [iconImage addGestureRecognizer:tap];
        iconImage.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:0.8];
        [self.scrollview addSubview:iconImage];
    }
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    UIColor * color = [UIColor whiteColor];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        self.iconImage.transform = CGAffineTransformMakeScale(1-offsetY/100, 1-offsetY/100);
    } else if (offsetY>0 && offsetY < self.iconImage.frame.size.height) {
        self.iconImage.frame = CGRectMake(kIconImageX, kIconImageY-offsetY/10, kIconImageW, kIconImageH);
    }
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        
        CGFloat Y  = self.scrollview.contentOffset.y;
        if (Y < 0) {
            
            self.iconImage.transform = CGAffineTransformMakeScale(1-Y/100, 1-Y/100);
        }else if (Y>0 && Y < 180){
            
            self.iconImage.frame = CGRectMake(kIconImageX, kIconImageY-Y/10, kIconImageW, kIconImageH);
            if (Y > 120  && Y < 180) {
                
//                self.navigationController.navigationBar.alpha = (scrollView.contentOffset.y-120)/60*1.0;
                self.backButton0.alpha = 1 - scrollView.contentOffset.y/kIconImageH*1.0;
            }
        }
    }
}




#pragma mark------------button点击和图片点击------------------


- (void)buttonAction:(UIButton *)button
{
    NSInteger flag = button.tag-100;
    if (flag<3) {
        NSString *webUrl = [NSString stringWithFormat:@"http://web.breadtrip.com/mobile/destination/%@/%@/%@/",self.city.type,self.city.ID,self.typearray[flag]];
        CategrayViewController *categrayVC = [[CategrayViewController alloc]init];
        categrayVC.url = webUrl;
        
        [self presentViewController:categrayVC animated:YES completion:nil];
        
//        [self.navigationController pushViewController:categrayVC animated:YES];
    }else{
        //        精品游记需要进行数据解析
        AllBlogTableViewController *allBlogTVC = [[AllBlogTableViewController alloc]init];

        allBlogTVC.city = self.city;
        
        [self.navigationController pushViewController:allBlogTVC animated:YES];
    }
}

//加载6张图片
- (void)loadImage
{
    if (self.allAttractions.count > 0) {
        
        for (int i = 0; i < 6; i ++) {
            UIImageView *iconImage = [self.scrollview viewWithTag:200+i];
            TouristAttraction *touristAttraction = self.allAttractions[i];
            
            [iconImage sd_setImageWithURL:[NSURL URLWithString:touristAttraction.cover]];
            UILabel *label = [self.scrollview viewWithTag:300+i];
            label.text = touristAttraction.name;
        }
    }
    
}

//图片点击事件跳转到景点详情
- (void)imageTapAction:(UITapGestureRecognizer *)tap
{
    
    UIImageView *iconImage = (UIImageView *)tap.view;
    if (iconImage.image == nil) {
        
    }else{
        
        NSInteger flag = iconImage.tag-200;
        TouristAttraction *attractions = self.allAttractions[flag];
        AttractionDetailViewController *attractionDetailVC = [[AttractionDetailViewController alloc]init];
        attractionDetailVC.touristAttraction = attractions;
        [self.navigationController pushViewController:attractionDetailVC animated:YES];
    }

}

#pragma mark------------lazy------------------

-(UIScrollView *)scrollview
{
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(kScrollViewX, kScrollViewY, kScrollViewW, kScrollViewH)];

        _scrollview.delegate = self;
    }
    return _scrollview;
}


-(UIImageView *)iconImage{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(kIconImageX, kIconImageY, kIconImageW, kIconImageH)];
    }
    return _iconImage;
}

-(void)setCity:(City *)city{
    if (_city!= city) {
        _city = city;
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:_city.cover]];
    }
}


-(NSArray *)typearray{
    
    if (!_typearray) {
        _typearray = [NSArray arrayWithObjects:@"intro",@"overview",@"top10_list",@"trips", nil];
    }
    return _typearray;
}



#pragma mark------------精品游记------------------
- (void)jsonOfAnalysicTravalBlob
{

    [LORequestManger GET:[NSString stringWithFormat:@"http://api.breadtrip.com/destination/place/%@/%@/trips/",self.city.ID,self.city.type] success:^(id response) {
        NSDictionary *rootDict = (NSDictionary *)response;
        NSArray *rootArray = rootDict[@"items"];
        for (NSDictionary *dict in rootArray) {
            TravelBlog *travelBlog = [[TravelBlog alloc]init];
            [travelBlog setValuesForKeysWithDictionary:dict];

        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"loadImage" object:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}



#pragma mark------------旅行地点数据解析(包含6张图片)------------------

- (void)jsonOfTouristAttraction
{
    
    self.allAttractions = [NSMutableArray array];
    [LORequestManger GET:[NSString stringWithFormat:@"http://api.breadtrip.com/destination/place/%@/%@/pois/all/",self.city.type,self.city.ID] success:^(id response) {
       
        NSDictionary *rootDicts = (NSDictionary *)response;
        NSArray *rootArray = rootDicts[@"items"];
        for (NSDictionary *dict in rootArray) {
            TouristAttraction *touristAttraction = [[TouristAttraction alloc]init];
            [touristAttraction setValuesForKeysWithDictionary:dict];
            [self.allAttractions addObject:touristAttraction];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"loadImage" object:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


@end
