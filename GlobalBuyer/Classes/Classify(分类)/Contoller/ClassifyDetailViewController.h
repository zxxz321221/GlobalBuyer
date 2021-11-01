//
//  ClassifyDetailViewController.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/27.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "RootViewController.h"
#import "CategoryModel.h"
@protocol ClassifyDetailViewControllerDetegate <NSObject>

- (void)selectAtIndexInClassifyDetailViewController:(CategoryModel *)model WithSection:(NSInteger)section;

@end

@interface ClassifyDetailViewController : RootViewController
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSString *signId ;
@property(nonatomic,strong)NSString *countryId;
@property(nonatomic,strong)id<ClassifyDetailViewControllerDetegate>delegate;
@end
