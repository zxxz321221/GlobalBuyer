//
//  MapView.m
//  位置搜索
//
//  Created by 赵阳 && 薛铭 on 2017/5/25.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "MapView.h"
#import <MAMapKit/MAMapKit.h>


@interface MapView ()<MAMapViewDelegate,AMapSearchDelegate,AMapLocationManagerDelegate>

@property (nonatomic ,strong) AMapSearchAPI * mapSearchAPI;
@property (nonatomic ,strong) MAUserLocation * currentLocation;
@property (nonatomic ,strong) NSMutableDictionary * userLocationDict;
@property (nonatomic, assign) BOOL locatingWithReGeocode;
@property (nonatomic, strong) UIButton *locationBtn;
@property (nonatomic, strong)MAMapView *mapView;
@property (nonatomic, strong)UIImageView *pointImgView;
@property (nonatomic, strong)AMapSearchAPI *search;
@property (nonatomic, strong)AMapGeoPoint *piont;

@end

@implementation MapView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self addSubviews];
    }
    return self;
}

#pragma mark 添加视图
- (void)addSubviews {
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setLocatingWithReGeocode:YES];
    [self.locationManager startUpdatingLocation];
    [self addSubview:self.mapView];
    [self.mapView addSubview:_pointImgView];
    
    //地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    //初始化地图
    [AMapServices sharedServices].enableHTTPS = YES;
    [self.mapView addSubview:self.pointImgView];
    [self.mapView addSubview:self.locationBtn];
}

- (MAMapView *)mapView {
    if (_mapView == nil) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        ///把地图添加至view
        _mapView.zoomLevel = 17;
        _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x, 22);
        _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x, 22);
        ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        _mapView.delegate = self;
    }
    return _mapView;
}

- (UIImageView *)pointImgView {
    if (_pointImgView == nil) {
        _pointImgView = [[UIImageView alloc]init];
        _pointImgView.frame = CGRectMake(self.mapView.bounds.size.width/2 - 22, self.mapView.bounds.size.height/2 - 36, 44, 72);
        _pointImgView.image = [UIImage imageNamed:@"Pin.png"];
    }
    return _pointImgView;
}

- (UIButton *)locationBtn {
    if (_locationBtn == nil) {
        _locationBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.bounds.size.width - 40, self.bounds.size.height - 40, 30, 30)];
        [_locationBtn setImage:[UIImage imageNamed:@"gpsStat1.png"] forState:UIControlStateNormal];
        [_locationBtn addTarget:self action:@selector(LocationClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _locationBtn;
}

#pragma  mark 布局
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect pointImgViewFrame = self.pointImgView.frame;
    pointImgViewFrame.origin.y = self.mapView.bounds.size.height/2 - 36;
    
    self.pointImgView.frame = pointImgViewFrame;
    CGRect locationBtnFrame = self.locationBtn.frame;
    
    locationBtnFrame.origin.y =self.bounds.size.height - 40;
    self.locationBtn.frame = locationBtnFrame;
    
}

#pragma mark 定位事件
- (void)LocationClick {
    [self.locationManager startUpdatingLocation];
}

#pragma mark 定位返回地址
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    if (reGeocode) {
        [self.locationManager stopUpdatingLocation];
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        regeo.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        regeo.requireExtension =YES;
        [self.search AMapReGoecodeSearch:regeo];
        self.piont.latitude =location.coordinate.latitude;
        self.piont.longitude = location.coordinate.longitude;
        self.mapView.centerCoordinate = CLLocationCoordinate2DMake( location.coordinate.latitude, location.coordinate.longitude);
    }
}

#pragma mark 初始化
- (AMapGeoPoint *)piont {
    if (_piont == nil) {
        _piont = [AMapGeoPoint new];
    }
    return _piont;
}

#pragma mark MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    if (wasUserAction) {
        NSLog(@"用户");
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        regeo.location = [AMapGeoPoint locationWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
        regeo.requireExtension =YES;
        [self.search AMapReGoecodeSearch:regeo];
        self.piont.latitude = mapView.centerCoordinate.latitude;
        self.piont.longitude = mapView.centerCoordinate.longitude;
    }
}

#pragma mark AMapLocationManagerDelegate
- (void)mapViewWillStartLocatingUser:(MAMapView *)mapView {
    if(![CLLocationManager locationServicesEnabled]) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Map_Seekfailed", nil) message:NSLocalizedString(@"GlobalBuyer_Map_Seekfailed_Message", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil, nil];
        [alertView show];
        _mapView = nil;
        _mapView.delegate = nil;
        return;
    } else {
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Map_Seekfailed", nil) message:NSLocalizedString(@"GlobalBuyer_Map_Seekfailed_Message", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles:nil, nil];
            [alertView show];
            _mapView = nil;
            _mapView.delegate = nil;
            return;
        }
    }
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    
    if (response.regeocode !=nil ) {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        NSLog(@"adcode反向地理编码回调:%@",response.regeocode.addressComponent.neighborhood);
        NSLog(@"反向地理编码回调:%@",response.regeocode.addressComponent.adcode);
        NSLog(@"township反向地理编码回调:%@",response.regeocode.addressComponent.township);
        NSLog(@"towncode反向地理编码回调:%@",response.regeocode.addressComponent.towncode);
        NSLog(@"district反向地理编码回调:%@",response.regeocode.addressComponent.district);
        [arr addObject:response.regeocode.addressComponent];
        NSArray * addressArr = response.regeocode.pois;
        if (addressArr && addressArr.count >0) {
            AMapPOI *poiTemp = addressArr[0];
            NSLog(@"反向地理编码回调:%@",poiTemp.name);
            
        }
        [arr addObjectsFromArray: response.regeocode.pois];
        [self.delegate addressArr:arr];
    }
}


- (void)moveMap:(AMapGeoPoint *)point {
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake( point.latitude, point.longitude);
}

- (void)moveMap {
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake( self.piont.latitude, self.piont.longitude);
}

- (void)showInSearch:(AMapGeoPoint *)point {
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake( point.latitude, point.longitude);
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:point.latitude longitude:point.longitude];
    regeo.requireExtension =YES;
    [self.search AMapReGoecodeSearch:regeo];
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (response.pois.count == 0){
        return;
    }
}


@end
