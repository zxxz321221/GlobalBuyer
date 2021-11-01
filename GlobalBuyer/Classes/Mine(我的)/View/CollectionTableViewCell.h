//
//  CollectionTableViewCell.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/7/24.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *logoIv;
@property (nonatomic,strong) UILabel *logoLb;
@property (nonatomic,strong) UILabel *sourceLb;
@property (nonatomic,strong) UILabel *remakeLb;

@property (nonatomic,strong) UIButton *editBtn;

@end
