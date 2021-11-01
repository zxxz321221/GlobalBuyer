//
//  NewYearCell.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2019/1/26.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  NewYearCellDelegate <NSObject>

- (void)clickNewYearWithLink:(NSString *)link;

@end

@interface NewYearCell : UITableViewCell

@property (nonatomic,strong)UIImageView *titleIv;
@property (nonatomic,strong)UILabel *titleLb;
@property (nonatomic,strong)UILabel *gotoLb;
@property (nonatomic,strong)NSString *titleLink;

@property (nonatomic,strong)UIImageView *goodsIvOne;
@property (nonatomic,strong)UILabel *goodsTitleOne;
@property (nonatomic,strong)UILabel *goodsPriceOne;
@property (nonatomic,strong)NSString *goodsOneLink;

@property (nonatomic,strong)UIImageView *goodsIvTwo;
@property (nonatomic,strong)UILabel *goodsTitleTwo;
@property (nonatomic,strong)UILabel *goodsPriceTwo;
@property (nonatomic,strong)NSString *goodsTwoLink;

@property (nonatomic,strong)UIImageView *goodsIvThree;
@property (nonatomic,strong)UILabel *goodsTitleThree;
@property (nonatomic,strong)UILabel *goodsPriceThree;
@property (nonatomic,strong)NSString *goodsThreeLink;

@property (nonatomic, strong) id<NewYearCellDelegate>delegate;

@end
