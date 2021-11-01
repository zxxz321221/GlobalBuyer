//
//  ZxzyCell4.h
//  GlobalBuyer
//
//  Created by 桂在明 on 2020/3/30.
//  Copyright © 2020 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZxzyCell4;
NS_ASSUME_NONNULL_BEGIN
@protocol  ZxzyCell4Delegate <NSObject>

- (void)goodsDelete:(ZxzyCell4 *)cell;
- (void)updateWithName:(NSString *)name WithParam:(NSString *)param WithPrice:(NSString *)price WithNum:(NSString *)num WithCurrety:(NSString *)currety WithCell:(ZxzyCell4 *)cell;
- (void)updateIcon:(ZxzyCell4 *)cell;
- (void)seleteCurrecy:(ZxzyCell4 *)cell;
- (void)updataIcon:(NSString *)icon Name:(NSString *)name Price:(NSString *)price BZ:(NSString *)bz Param:(NSString *)param Num:(NSString *)num Cell:(ZxzyCell4 *)cell;
@end
@interface ZxzyCell4 : UITableViewCell
@property (nonatomic, strong) id<ZxzyCell4Delegate>delegate;
@property (nonatomic , strong) NSString * currety;
- (void)configWithData:(NSDictionary *)dic xvhao:(NSInteger)hao;

@end

NS_ASSUME_NONNULL_END
