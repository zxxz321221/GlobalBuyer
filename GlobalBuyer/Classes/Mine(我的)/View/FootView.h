//
//  FootView.h
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/7.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  FootViewDelegate <NSObject>

- (void)footCollection;
- (void)footDelete;

@end
NS_ASSUME_NONNULL_BEGIN

@interface FootView : UIView
@property (nonatomic, strong) id<FootViewDelegate>delegate;
- (void)showFootView;
- (void)hiddenFootView;
+(instancetype)setFootView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
