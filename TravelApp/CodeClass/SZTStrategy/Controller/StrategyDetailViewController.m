//
//  StrategyDetailViewController.m
//  TravelApp
//
//  Created by SZT on 15/12/17.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "StrategyDetailViewController.h"
#import "MainScreenBound.h"
#import <WebKit/WebKit.h>

#define kIconImageX  0
#define kIconImageY  0
#define kIconImageW  kWidth
#define kIconImageH  kHeight/3

#define kScrollViewX  0
#define kScrollViewY  0
#define kScrollViewW  kWidth
#define kScrollViewH  kHeight


#define kWebViewX    0
#define kWebViewY    kHeight/3
#define kWebViewW    kWidth-2*kWebViewX
#define kWebViewH    kHeight

@interface StrategyDetailViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)UIWebView *webView;

@property(nonatomic,strong)UIImageView *iconimage;

@property(nonatomic,strong)UIScrollView *scrollView;


@end

@implementation StrategyDetailViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.iconimage = [[UIImageView alloc]initWithFrame:CGRectMake(kIconImageX, kIconImageY, kIconImageW, kIconImageH)];
    [self.iconimage sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]];
    [self.view addSubview:self.iconimage];
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(kScrollViewX, kScrollViewY, kScrollViewW, kScrollViewH)];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.delegate = self;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kIconImageX, kIconImageY, kIconImageW, kIconImageH)];
    label.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:label];
    

    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, kWebViewY, kWebViewW, kWebViewH)];
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.strategyUrl]]];
    self.webView.userInteractionEnabled = NO;
    
    [self.scrollView addSubview:self.webView];
    
    [self.view addSubview:self.scrollView];

//    [self.view addSubview:self.iconimage];


}

#pragma mark------------scrollView的代理------------------

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<kIconImageH-20 && scrollView.contentOffset.y>0) {
        CGFloat scaleH = scrollView.contentOffset.y/8;
        self.iconimage.frame = CGRectMake(kIconImageX, kIconImageY-scaleH, kIconImageW, kIconImageH);
    }

    if (scrollView.contentOffset.y<0) {
        self.iconimage.transform =
        CGAffineTransformMakeScale(1-(scrollView.contentOffset.y)/100, 1-(scrollView.contentOffset.y)/100);
    }
    if (scrollView.contentOffset.y>=kIconImageH-10) {
        self.webView.userInteractionEnabled = YES;
    }else{
        self.webView.userInteractionEnabled = NO;
    }
}


#pragma mark------------webView代理------------------

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{

}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];

    self.scrollView.contentSize = CGSizeMake(0, kIconImageH+kWebViewH+100);
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
   
}


@end
