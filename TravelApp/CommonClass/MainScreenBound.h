//
//  MainScreenBound.h
//  TravelApp
//
//  Created by SZT on 15/12/17.
//  Copyright © 2015年 SZT. All rights reserved.
//

#ifndef MainScreenBound_h
#define MainScreenBound_h


#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UIImageView+WebCache.h"
#import "LORequestManger.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"


#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "Font.h"
#import "UMSocial.h"
#import "UMSocialSinaHandler.h"

#import <CoreLocation/CoreLocation.h>
#import "GCZHeaderScrollView.h"
#import "LORequestManger.h"
#import "GCZEveryDayStoryCell.h"
#import "StoryModel.h"
#import "GCZTravelListModel.h"
#import "BlurImageView.h"
#import "GCZTravelListModel.h"
#import "GCZTravelListCell.h"
#import "GCZMoreStoryCollectionView.h"
#import "GCZStoryDetailTVC.h"
#import "GCZWebViewController.h"
#import "GCZStoryViewForCell.h"
#import "GCZTravelListTVC.h"
#import "SingleTonForTravel.h"
#import "TravelFMDataBase.h"
#import "MMDrawerController.h"
#import "CollectionTableViewController.h"
#define kCellBackGroundColor [UIColor colorWithRed:245.0 / 255 green:245.0 / 255 blue:245.0 / 255 alpha:1.0]


#define navigationBarBackGroundColor   [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]

#ifdef DEBUG
#define GCZLog(...) NSLog(__VA_ARGS__)
#else
#define GCZLog(...)
#endif

#define kMainUrl @"http://api.breadtrip.com/v2/index/"
#define kEveryStory @"http://api.breadtrip.com/v2/new_trip/spot/hot/list/?start=0"
#define kTravelType12Url @"http://api.breadtrip.com/v2/new_trip/?trip_id=%@"
#define kDetailStoryUrl @"http://api.breadtrip.com/v2/new_trip/spot/?spot_id=%@"
#define kFootUrl1 @"http://api.breadtrip.com/v2/index/?next_start=%@&sign=d6d8ce0ecf227fd30cf3e7b08cd382c1"
#define kTravelListUrl @"http://api.breadtrip.com/trips/%@/waypoints/?gallery_mode=1&sign=1dc7569622ea193bfe182244219ccb1b"

#define kSearchUrl @"http://api.breadtrip.com/v2/search/?key=%@&sign=7d7c7100787a56131dd24fffadfa9110"


#endif /* MainScreenBound_h */
