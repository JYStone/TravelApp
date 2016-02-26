//
//  GCZWebViewController.m
//  TravelApp
//
//  Created by SZT on 15/12/21.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "GCZWebViewController.h"
#import <WebKit/WebKit.h>

@interface GCZWebViewController ()

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation GCZWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView.allowsBackForwardNavigationGestures =YES;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back@2x.jpg"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)]
                                                                   style:(UIBarButtonItemStylePlain)
                                                                  target:self
                                                                  action:@selector(backToRootController)];
    
    self.navigationItem.leftBarButtonItem = leftButton;
}
- (void)backToRootController {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
