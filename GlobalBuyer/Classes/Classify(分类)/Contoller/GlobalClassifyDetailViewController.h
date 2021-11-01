//
//  GlobalClassifyDetailViewController.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/7/24.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "RootViewController.h"
#import "ClassifyDetaiCell.h"
#import "CategoryModel.h"
#import "FileArchiver.h"

@protocol GlobalClassifyDetailViewControllerDetegate <NSObject>

-(void)selectAtIndexInClassifyDetailViewController:(CategoryModel *)model;

@end

@interface GlobalClassifyDetailViewController : RootViewController

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSString *signId ;
@property(nonatomic,strong)NSString *countryId;
@property(nonatomic,strong)id<GlobalClassifyDetailViewControllerDetegate>delegate;

@end
