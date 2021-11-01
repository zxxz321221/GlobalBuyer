//
//  ZxzyCell1.h
//  GlobalBuyer
//
//  Created by 桂在明 on 2020/3/30.
//  Copyright © 2020 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol  ZxzyCell1Delegate<NSObject>

- (void)updateIcon;
- (void)addGoods;
- (void)seleteCurrecy;
- (void)addIconUrl:(NSString *)url GoodsName:(NSString *)name GoodsLink:(NSString *)link GoodsParam:(NSString *)param GoodsPrice:(NSString *)price GoodsCurrecy:(NSString *)currecy GoodsNum:(NSString *)num;
- (void)showHud1:(NSString *)msg;
@end
@interface ZxzyCell1 : UITableViewCell
@property (nonatomic, strong)id <ZxzyCell1Delegate>delegate;
@property (nonatomic , strong) UIButton * iconBtn;
@property (nonatomic , strong) UILabel * uploadL;
@property (nonatomic , strong) UIImageView * icon;


- (void)configLink:(NSString *)link WithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
