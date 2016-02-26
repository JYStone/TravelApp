//
//  CategrayViewController.m
//  TravelApp
//
//  Created by SZT on 15/12/23.
//  Copyright © 2015年 SZT. All rights reserved.
//



//不可错过，主题榜单，实用须知
#import "CategrayViewController.h"
#import "MainScreenBound.h"
#import "UINavigationBar+Awesome.h"


#define kWebViewX  0
#define kWebViewY  20
#define kWebViewW  kWidth
#define kWebViewH  kHeight-20

#define kButtonX   0
#define kButtonY   20
#define kButtonW   45
#define kButtonH   45

@interface CategrayViewController ()

@property(nonatomic,strong)UIWebView *webView;

@end

@implementation CategrayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(kWebViewX, kWebViewY, kWebViewW, kWebViewH)];
    
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
    
     UIButton *backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    backButton.frame = CGRectMake(kButtonX, kButtonY, kButtonW, kButtonH);

    [backButton addTarget:self action:@selector(dismissAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:backButton];
    
    
}

-(void)dismissAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
