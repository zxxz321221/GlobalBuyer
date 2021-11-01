//
//  AboutViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/6/23.
//  Copyright © 2017年 薛铭. All rights reserved.
//

#import "AboutViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface AboutViewController ()<CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    UILabel *_addLb;
}
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    //[self getAdd];
}

//定位
- (void)getAdd
{
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    [_locationManager startUpdatingLocation];
}

//定位代理
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        [_locationManager stopUpdatingHeading];
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        
        _addLb.text = [NSString stringWithFormat:@"%@%@%@%@%@",placemark.country,placemark.administrativeArea,placemark.locality,placemark.subLocality,placemark.name];
        _addLb.textAlignment = NSTextAlignmentCenter;
        _addLb.numberOfLines = 0;
        NSLog(@"=====%@",placemark.country);
    }];
}

- (void)createUI
{
    _addLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 500, kScreenW, 60)];
    [self.view addSubview:_addLb];
    //导航title 隐藏tabbar
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"GlobalBuyer_My_About_cell", nil);
    self.navigationItem.titleView = titleLabel;
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //Logo
    UIImageView *logoIm = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 90, self.view.bounds.size.height/2 - 150, 180, 180)];
    logoIm.image = [UIImage imageNamed:@"logIcon"];
    [self.view addSubview:logoIm];
    
    //Version
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    UILabel *VersionLb = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 90, self.view.bounds.size.height/2 - 150 +200, 180, 30)];
    VersionLb.textAlignment = NSTextAlignmentCenter;
    VersionLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_About_Version", nil),[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    [self.view addSubview:VersionLb];
    
    //gotoAppStore
    UIButton *gotoAppStoreBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 90, self.view.bounds.size.height/2 - 150 +200 + 40, 180, 40)];
    [gotoAppStoreBtn setTitle:@"Update In AppStore" forState:UIControlStateNormal];
    [gotoAppStoreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    gotoAppStoreBtn.layer.borderColor = Main_Color.CGColor;
    gotoAppStoreBtn.layer.borderWidth = 0.3;
    gotoAppStoreBtn.layer.cornerRadius = 5;
    [self.view addSubview:gotoAppStoreBtn];
    [gotoAppStoreBtn addTarget:self action:@selector(gotoAppStore) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)gotoAppStore
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1232094474"]];
}

//显示tabbar
- (void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
