//
//  MapSearchViewController.h
//  位置搜索
//
//  Created by 赵阳 && 薛铭 on 2017/5/24.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "RootViewController.h"
#import "PoisModel.h"
@protocol MapSearchViewControllerDelegate <NSObject>

-(void)showInMap:(PoisModel *)poisModel;

@end

@interface MapSearchViewController : RootViewController
@property(nonatomic,strong)NSString *searchStr;
@property(nonatomic,strong)id<MapSearchViewControllerDelegate>delegate;
@end
