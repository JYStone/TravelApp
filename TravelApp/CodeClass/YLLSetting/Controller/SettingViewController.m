//
//  SettingViewController.m
//  TravelApp
//
//  Created by SZT on 15/12/21.
//  Copyright © 2015年 SZT. All rights reserved.
//
#import "MainScreenBound.h"
#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "UserView.h"
#import "WebView.h"
#import "CollectionTableViewController.h"
#import "ServerViewController.h"
@interface SettingViewController ()
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, strong) NSArray *settingArray;
@property (nonatomic, strong) NSArray *tableViewArray;
@property (nonatomic, strong) NSArray *smallTableViewArray;
@property (nonatomic, retain) SettingTableViewCell *setCell;
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) UserView *userView;
@property (nonatomic, strong) NSString *stringUrl;
@property (nonatomic, retain) WebView *webView;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, retain) ServerViewController *serverVC;
@end

@implementation SettingViewController

- (WebView *)webView
{
    if (!_webView) {
        _webView = [[WebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * 0.8, kHeight)];
    }
    return _webView;
}


- (NSArray *)settingArray {
    if (!_settingArray) {
        _settingArray = [[NSArray alloc] init];
    }
    return _settingArray;
}

- (NSArray *)tableViewArray {
    if (!_tableViewArray) {
        _tableViewArray = [[NSArray alloc] init];
    }
    return _tableViewArray;
}


#pragma mark
#pragma mark ----tableView 一
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLogin = NO;
    [SingleTonForTravel shareTravelSingleTon].isLogin = NO;
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundView.image = [UIImage imageNamed:@"beijing5.jpg"];
    [self.view addSubview:backgroundView];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kHeight - 355, kWidth * 0.8, kHeight * 0.27)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[SettingTableViewCell class] forCellReuseIdentifier:@"d"];
    [self.view addSubview:self.tableView];
    self.settingArray = @[@"收藏",@"夜间模式",@"清除缓存",@"服务条款"];
    UIImage *image1 = [UIImage imageNamed:@"collect"];
    UIImage *image2 = [UIImage imageNamed:@"nightMode"];
    UIImage *image3 = [UIImage imageNamed:@"cache"];
    UIImage *image4 = [UIImage imageNamed:@"font"];
    self.tableViewArray = @[image1,image2,image3,image4];
    
    
    self.userView = [[UserView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * 0.8, self.view.frame.size.width * 0.7) target:self action:@selector(goToMy) btnAction:@selector(login:)];
    [self.view addSubview:self.userView];
    
    [self.webView.backButton addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
    
}

#pragma mark
#pragma mark ----登录

- (void)login:(UIButton *)button {
    
    if (self.isLogin == YES) {
        [self goToMy];
    }else {
        
        
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
        
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            
            if (response.responseCode == UMSResponseCodeSuccess) {
                
                [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){

                }];
                
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                self.isLogin = YES;
                [SingleTonForTravel shareTravelSingleTon].isLogin = YES;
                //用户微博的url

                self.stringUrl = snsAccount.profileURL;
                self.userView.nameLabel.text = snsAccount.userName;
                [self.userView.imageView sd_setImageWithURL:[NSURL URLWithString:snsAccount.iconURL]];
            }});
    }
    
    
}

- (void)goToMy {
    if(self.isLogin == YES) {
        NSURL *url = [NSURL URLWithString:self.stringUrl];

        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
        [self.view addSubview:self.webView];
    }
}

- (void)back {
    [self.webView removeFromSuperview];
}

#pragma mark
#pragma mark ----tableView 二

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return self.settingArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

        self.setCell = [tableView dequeueReusableCellWithIdentifier:@"d"];
        self.setCell.nameLabel.text = self.settingArray[indexPath.row];
        self.setCell.imageV.image = self.tableViewArray[indexPath.row];
        self.setCell.nameLabel.font = [UIFont fontWithName:[Font shareWithFont].fontName size:17];
        switch (indexPath.row) {
            case 0:
            
                break;
            case 1:
            {
                self.setCell.pictureView.alpha = 0;
                self.setCell.swithDN.alpha = 1;
                [self.setCell.swithDN addTarget:self action:@selector(changeDN:) forControlEvents:(UIControlEventValueChanged)];
            }
                break;
            case 2:
            {
                self.setCell.nameLabel.text = [NSString stringWithFormat:@"清除缓存(%@)", [self getFileSize]];

            }
                break;
            case 3:
            {
                self.setCell.tag = 6000;
            }
                break;
            default:
                break;
        }
        return self.setCell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MMDrawerController *controller = (MMDrawerController *)[UIApplication sharedApplication].keyWindow.rootViewController;
   
        switch (indexPath.row) {
            case 0:
            {
            }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"push" object:nil];
                [controller closeDrawerAnimated:YES completion:nil];
                break;
            case 1:
                
                break;
            case 2:
            {
                [[SDImageCache sharedImageCache] clearDisk];
                [self showHUD];
                [self.tableView reloadData];
            }
                break;
            case 3:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"pushServerVC" object:nil];
                [controller closeDrawerAnimated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    
}

#pragma mark
#pragma mark ----黑夜白天模式

- (void)changeDN:(UISwitch *)switchButton {
    
    if (switchButton.isOn == YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nightORday" object:@"黑夜模式"];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nightORday" object:@"白天模式"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark ----清除缓存

//获取缓存的大小
- (NSString *)getFileSize {
    NSUInteger size = [[SDImageCache sharedImageCache] getSize];
    //
    NSString * sizeString = [NSString stringWithFormat:@"%@",[self fileSizeWithInterge:size]];
    return sizeString;
}

//计算出大小
- (NSString *)fileSizeWithInterge:(NSInteger)size{
    // 1k = 1024, 1m = 1024k
    if (size < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%ldB",(long)size];
    }else if (size < 1024 * 1024){// 小于1m
        CGFloat aFloat = size/1024;
        return [NSString stringWithFormat:@"%.0fK",aFloat];
    }else if (size < 1024 * 1024 * 1024){// 小于1G
        CGFloat aFloat = size/(1024 * 1024);
        return [NSString stringWithFormat:@"%.1fM",aFloat];
    }else{
        CGFloat aFloat = size/(1024*1024*1024);
        return [NSString stringWithFormat:@"%.1fG",aFloat];
    }
}

- (void)showHUD {
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.HUD];
    self.HUD.dimBackground = YES;//将当前的view置于后台
    self.HUD.labelText = @"稍等";
    [self.HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }];
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
