//
//  FJYAlertShow.m
//  TravelApp
//
//  Created by SZT on 15/12/24.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "FJYAlertShow.h"


@implementation FJYAlertShow

+ (UIAlertController *)WithWWANState {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前使用为3G/4G网络，请注意流量消耗" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"设置" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:nil];
    [alertC addAction:sureAction];
    [alertC addAction:cancelAction];
    return alertC;
}

+ (UIAlertController *)noReachableState {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前无网络" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"设置" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alertC addAction:sureAction];
    [alertC addAction:cancelAction];
    return alertC;
    
}

+ (UIAlertController *)networkUnkownState {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前网络未知" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"设置" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alertC addAction:sureAction];
    [alertC addAction:cancelAction];
    return alertC;
}

+ (UIAlertController *)noSearchResult {
    UIAlertController *noResultAlertC = [UIAlertController alertControllerWithTitle:@"TA消失了" message:@"该城市不存在或无法获取" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
    [noResultAlertC addAction:sureAction];
    return noResultAlertC;
}

+ (UIAlertController *)noLocationService {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位未开启,无法进行定位操作，请在设置中开启" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"设置" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alertC addAction:cancelAction];
    [alertC addAction:sureAction];
    return alertC;
}


@end
