//
//  MapKitViewController.m
//  TravelApp
//
//  Created by SZT on 15/12/24.
//  Copyright © 2015年 SZT. All rights reserved.
//

#import "MapKitViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "TouristAttraction.h"
#import "UINavigationBar+Awesome.h"

@interface MapKitViewController ()<CLLocationManagerDelegate>

@property(nonatomic,strong)MKMapView *mapView;

@property(nonatomic,strong)CLLocationManager *locationManager;

@end

@implementation MapKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.alpha = 0.8;
     [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
    self.locationManager = [[CLLocationManager alloc]init];
    
    [self.view addSubview:self.mapView];
    
    self.navigationController.navigationBarHidden =NO;
    
    CLLocationCoordinate2D coordinate;
    coordinate.longitude = [self.touristAttraction.location[@"lng"] floatValue];
    coordinate.latitude = [self.touristAttraction.location[@"lat"] floatValue];
    
    MKCoordinateSpan span;
    span.longitudeDelta = 0.01;
    span.latitudeDelta = 0.01;
    
    MKCoordinateRegion resion;
    resion.center = coordinate;
    resion.span = span;
    
    [self.mapView setRegion:resion animated:YES];
    
    [self.mapView setMapType:(MKMapTypeStandard)];

    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithTitle:@"导航" style:(UIBarButtonItemStylePlain) target:self action:@selector(startToNavigation:)];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    UIBarButtonItem *Backbutton = [[UIBarButtonItem alloc]initWithTitle:@"back" style:(UIBarButtonItemStylePlain) target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = Backbutton;

}

- (void)backAction:(UIBarButtonItem *)button
{
//    self.navigationController.navigationBar.alpha = 0.8;
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.locationManager stopUpdatingLocation];
    [self.navigationController popViewControllerAnimated: YES];
    
}

- (void)startToNavigation:(UIBarButtonItem *)button
{

    self.locationManager.delegate = self;
    
    if([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
    {
               // 主动要求用户对我们的程序授权, 授权状态改变就会通知代理
        [self.locationManager requestAlwaysAuthorization]; // 请求前台和后台定位权限
        [self.locationManager startUpdatingLocation];
    }else
    {

        // 3.开始监听(开始获取位置)
        [self.locationManager startUpdatingLocation];
    }
    

}

-(MKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    }
    return _mapView;
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusNotDetermined) {

    }else if (status == kCLAuthorizationStatusAuthorizedAlways ||
              status == kCLAuthorizationStatusAuthorizedWhenInUse)
        
    {

        // 开始定位
        [self.locationManager startUpdatingLocation];
        
    }else
    {

    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [self.locationManager stopUpdatingLocation];
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D startCoordinate;
    startCoordinate.longitude = location.coordinate.longitude;
    startCoordinate.latitude = location.coordinate.latitude;

    MKPlacemark *startPlacemark = [[MKPlacemark alloc]initWithCoordinate:startCoordinate addressDictionary:nil];
    
    CLLocationCoordinate2D stopCoordinate;
    stopCoordinate.longitude = [self.touristAttraction.location[@"lng"] floatValue];
    stopCoordinate.latitude = [self.touristAttraction.location[@"lat"] floatValue];
    MKPlacemark *stopPlacemark = [[MKPlacemark alloc]initWithCoordinate:stopCoordinate addressDictionary:nil];
    
    MKMapItem *startItem = [[MKMapItem alloc]initWithPlacemark:startPlacemark];
    MKMapItem *stopItem = [[MKMapItem alloc]initWithPlacemark:stopPlacemark];;
    
    NSMutableDictionary *launchDict = [NSMutableDictionary dictionary];
    launchDict[MKLaunchOptionsDirectionsModeKey] = MKLaunchOptionsDirectionsModeDriving;
    [MKMapItem openMapsWithItems:@[startItem,stopItem] launchOptions:launchDict];

}

@end
