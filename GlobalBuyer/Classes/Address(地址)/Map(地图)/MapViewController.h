//
//  MapViewController.h
//  位置搜索
//
//  Created by 赵阳 && 薛铭 on 2017/5/24.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "RootViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@protocol MapViewControllerDelegate  <NSObject>

-(void)addAddress:(NSString *)addressStr addressDetail:(NSString *)addressDetStr;

@end

@interface MapViewController : RootViewController
@property(nonatomic,strong)id<MapViewControllerDelegate>delegate;
@end
