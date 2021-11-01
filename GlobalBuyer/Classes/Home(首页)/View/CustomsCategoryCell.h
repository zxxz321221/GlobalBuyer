//
//  CustomsCategoryCell.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/10/31.
//  Copyright © 2018年 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  CustomsCategoryCellDelegate<NSObject>

- (void)isSelect:(NSString *)special;

@end

@interface CustomsCategoryCell : UITableViewCell

@property (nonatomic,strong) UILabel *nameLb;
@property (nonatomic,strong) UILabel *contLb;
@property (nonatomic,strong) UIButton *isSelectbtn;
@property (nonatomic, strong)id <CustomsCategoryCellDelegate>delegate;
@property (nonatomic,strong) NSString *specialStr;

@end
