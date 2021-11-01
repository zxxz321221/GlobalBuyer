//
//  AlreadyPayTableViewCell.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/9/15.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlreadyPayTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *iv;
@property (nonatomic,strong)UILabel *lb;
@property (nonatomic,strong)UILabel *numLb;
@property (nonatomic,strong)UILabel *priceLb;
@property (nonatomic,strong)UIButton *btn;

@property (nonatomic,strong)NSString *goodsId;
@property (nonatomic,strong)UIView *pickLimitV;

@end
