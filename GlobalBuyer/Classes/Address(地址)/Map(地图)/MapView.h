//
//  MapView.h
//  位置搜索
//
//  Created by 赵阳 && 薛铭 on 2017/5/25.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
@protocol MapViewDelegate <NSObject>

-(void)addressArr:(NSMutableArray *)array;

@end

@interface MapView : UIView
@property(nonatomic,strong)id<MapViewDelegate>delegate;
@property (nonatomic ,strong) AMapLocationManager * locationManager;
-(void)moveMap:(AMapGeoPoint *)point;
-(void)moveMap;
-(void)showInSearch:(AMapGeoPoint *)point;
@end
