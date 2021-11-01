//
//  SpecialCollectionViewCell.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/8/1.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SpecialCollectionViewCellDelegate <NSObject>

- (void)clickFirstSpecialNoticeWithBody:(NSMutableArray *)dataBody;
- (void)clickSecondSpecialNoticeWithBody:(NSMutableArray *)dataBody;

- (void)clickFirstDetailWithURL:(NSString *)urlStr nationalityStr:(NSString *)nationalityStr;
- (void)clickSecondDetailWithURL:(NSString *)urlStr nationalityStr:(NSString *)nationalityStr;

@end

@interface SpecialCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong)UIImageView *specialV;
@property (nonatomic, strong)UIView *goodsBackV;
@property (nonatomic, strong)UIScrollView *goodsSv;

@property (nonatomic, strong)UIImageView *specialSecondV;
@property (nonatomic, strong)UIView *goodsBackSecondV;
@property (nonatomic, strong)UIScrollView *goodsSecondSv;

@property (nonatomic, strong)UIView *singleProductV;


@property (nonatomic, strong)NSMutableArray *bodyData;
@property (nonatomic, strong)NSMutableArray *bodySecondData;
- (void)setData;
- (void)setSecondData;

@property (nonatomic, strong)id<SpecialCollectionViewCellDelegate>delegate;

@end
