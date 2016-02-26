//
//  AppDelegate.m
//  TravelApp
//
//  Created by SZT on 15/12/17.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "AppDelegate.h"
#import "MainScreenBound.h"
#import "BaseTabBarViewController.h"
#import "SettingViewController.h"
#import "AFNetworkReachabilityManager.h"

#import "FJYAlertShow.h"
#import "LayerShow.h"

#import "XGPush.h"
@interface AppDelegate () 

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

   
    
    #pragma mark------------以下为推送配置------------------
    
    [XGPush startApp:2200174145 appKey:@"ID5IL56B34EI"];
    
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 8.0) {
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:setting];
        [application registerForRemoteNotifications];
    }else{
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeBadge)];
    }
    
    
    
    #pragma mark------------以上为推送配置------------------
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedaynight:) name:@"nightORday" object:nil];

//    BaseTabBarViewController *baseTabBarVC = [[BaseTabBarViewController alloc]init];
//    self.window.rootViewController = baseTabBarVC;
   
    SettingViewController *leftViewController =[[SettingViewController alloc]init];
    UINavigationController *leftNA = [[UINavigationController alloc] initWithRootViewController:leftViewController];
    leftNA.navigationBar.hidden = YES;
 
    BaseTabBarViewController *baseTabBarVC = [[BaseTabBarViewController alloc]init];
    
    MMDrawerController *mmdrawerController = [[MMDrawerController alloc]initWithCenterViewController:baseTabBarVC leftDrawerViewController:leftViewController];
    
    [mmdrawerController openDrawerGestureModeMask];
    [mmdrawerController setMaximumLeftDrawerWidth:kWidth * 0.8];
//    [mmdrawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [mmdrawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    self.window.rootViewController = mmdrawerController;
    
    
    
    BOOL isLocate = [[SingleTonForTravel shareTravelSingleTon] isLocate];
    if (isLocate) {
    } else {
        [self.window.rootViewController presentViewController:[FJYAlertShow noLocationService] animated:YES completion:nil];
    }
    
    
    //设置友盟分享秘钥(我的APPKEY)
    [UMSocialData setAppKey:@"567ba24e67e58e0420001b20"];
    
    //新浪微博的SSO授权
//    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3699566697" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    [UMSocialWechatHandler setWXAppId:@"wxd930ea5d5a258f4f" appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" url:@"http://www.umeng.com/social"];
   
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];

    [UMSocialQQHandler setQQWithAppId:@"1105044616" appKey:@"YUwyTS0H5V9NrUdN" url:@"http://www.umeng.com/social"];
    
    
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"noReachable" object:nil];
                [self.window.rootViewController presentViewController:[FJYAlertShow noReachableState] animated:YES completion:nil];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"withWWAN" object:nil];
                [self.window.rootViewController presentViewController:[FJYAlertShow WithWWANState] animated:YES completion:nil];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"withWifi" object:nil];
            }
                break;
            case AFNetworkReachabilityStatusUnknown:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"withUnknow" object:nil];
                [self.window.rootViewController presentViewController:[FJYAlertShow networkUnkownState] animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }];
    
    
    [[TravelFMDataBase shareTravelDataBase] createTabeleForSqliteWithName:@"TravelApp" tableName:@"HotStory"];
    [[TravelFMDataBase shareTravelDataBase] createTabeleForSqliteWithName:@"TravelApp" tableName:@"EveryDayStory"];
    [[TravelFMDataBase shareTravelDataBase] createTabeleForSqliteWithName:@"TravelApp" tableName:@"TouristAttractionDeail"];


    LayerShow *guideShow = [[LayerShow alloc] init];
    [guideShow guideShow];
    

    
    return YES;
  
}


#pragma mark------------打印推送的deviceToken------------------
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //将deviceToken传给我们的XGPush
    [XGPush registerDevice:deviceToken];
//    NSLog(@"deviceToken:%@",[XGPush registerDevice:deviceToken]);
}


//此方法已废弃，但是还是写一下
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    return [UMSocialSnsService handleOpenURL:url];
//}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        
    }
    
    return result;
}


- (void)changedaynight:(NSNotification *)notification {
    if ([notification.object isEqualToString:@"白天模式"]) {
        self.window.alpha = 1;
        
    }else {
        self.window.alpha = 0.5;
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
