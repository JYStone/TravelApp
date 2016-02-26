//
//  ServerItemsView.m
//  TravelApp
//
//  Created by SZT on 16/1/5.
//  Copyright © 2016年 SZT. All rights reserved.
//
#import "MainScreenBound.h"
#import "ServerItemsView.h"

@implementation ServerItemsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        self.scrollView.contentSize = CGSizeMake(kWidth, kHeight * 1.8);
        [self addSubview:self.scrollView];
        
        CGFloat width = self.scrollView.frame.size.width;
        CGFloat height = self.scrollView.frame.size.height;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, width * 0.08, kWidth, 50)];
        self.titleLabel.text = @"服务条款";
        self.titleLabel.font = [UIFont systemFontOfSize:20];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.scrollView addSubview:self.titleLabel];
        
        self.editionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, width * 0.08 + 50, kWidth, 30)];
        self.editionLabel.numberOfLines = 0;
        self.editionLabel.text = @"版本信息";
        self.editionLabel.font = [UIFont systemFontOfSize:14];
        self.editionLabel.textAlignment = NSTextAlignmentCenter;
        [self.scrollView addSubview:self.editionLabel];
        
        self.edition = [[UILabel alloc] initWithFrame:CGRectMake(0, width * 0.08 + 50 + 30, kWidth, 30)];
        self.edition.text = @"Perfect Travelling 1.0 适用于iOS8.0以上系统的设备";
        self.edition.textAlignment = NSTextAlignmentCenter;
        self.edition.font = [UIFont systemFontOfSize:12];
        [self.scrollView addSubview:self.edition];
        
        self.statementLanel = [[UILabel alloc] initWithFrame:CGRectMake(30, width * 0.08 + 110, kWidth - 60, height * 1.7 - (width * 0.08 + 110))];
        self.statementLanel.numberOfLines = 0;
        self.statementLanel.font = [UIFont systemFontOfSize:12];
        self.statementLanel.text = @"    1.一切移动客户端用户在下载并使用本软件时均被视为已经仔细阅读本条款并完全同意。凡以任何方式登陆本软件，或直接、间接使用本APP资料者，均被视为自愿接受本声明和用户服务协议的约束。\n\n    2.本软件使用完全免费，手机由于上网而产生的GPRS流量费用由运营商收取。\n\n    3.本软件转载的内容并不代表本软件之意见及观点，也不意味着软件作者赞同其观点或证实其内容的真实性。\n\n    4.本软件所转载的文字、图片、音视频等内容均由互联网收集，对其真实性、准确性和合法性本软件不提供任何保证，也不承担任何法律责任。如有真实性、准确性和合法性存在问题的内容，请联系开发者及时删除相关内容。\n\n     5.本软件所转载的文字、图片、音视频等内容均由互联网自动收集，如侵犯了第三方的知识产权或其他权利，请联系开发者删除相关内容，本软件对此不承担任何法律责任。\n\n   6.本软件不保证为向用户提供便利而设置的外部链接的准确性和完整性，同时，对于该外部链接指向的不由本软件实际控制的任何网页上的内容，本软件不承担任何责任。\n\n     7.用户明确并同意其使用本软件网络服务所存在的风险将完全由其本人承担；因其使用本软件网络服务而产生的一切后果也由其本人承担，本软件对此不承担任何责任。\n\n   8.除本软件注明之服务条款外，其它因不当使用本APP而导致的任何意外、疏忽、合约毁坏、诽谤、版权或其他知识产权侵犯及其所造成的任何损失，本软件概不负责，亦不承担任何法律责任。\n\n   9.对于因不可抗力或因黑客攻击、通讯线路中断等本软件不能控制的原因造成的网络服务中断或其他缺陷，导致用户不能正常使用本软件，本软件不承担任何责任，但将尽力减少因此给用户造成的损失或影响。\n\n   10.本声明未涉及的问题请参见国家有关法律法规，当本声明与国家有关法律法规冲突时，以国家法律法规为准。\n\n   11.本软件版权及其修改权、更新权和最终解释权均属本软件开发者所有。\n\n如有疑问，请联系1248300875@qq.com";
        [self.scrollView addSubview:self.statementLanel];
        
    }
    return self;
}

@end
