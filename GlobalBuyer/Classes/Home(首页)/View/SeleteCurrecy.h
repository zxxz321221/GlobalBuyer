//
//  SeleteCurrecy.h
//  GlobalBuyer
//
//  Created by 桂在明 on 2020/3/31.
//  Copyright © 2020 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol  SeleteCurrecyDelegate<NSObject>

- (void)seleteCurrecyDic:(NSDictionary *)dic;

@end
@interface SeleteCurrecy : UIView
@property (nonatomic, strong)id <SeleteCurrecyDelegate>delegate;
+(instancetype)setSeleteCurrecy:(UIView *)view;
- (void)showSeleteCurrecy;
@end

NS_ASSUME_NONNULL_END
