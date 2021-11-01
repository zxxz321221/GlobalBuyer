//
//  Keyboard.h
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/4/9.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol  keyboardDelegate <NSObject>

- (void)keyboardKeys:(NSString *)keys;

@end
@interface Keyboard : UIView
@property (nonatomic, strong) id<keyboardDelegate>delegate;
+ (instancetype)setKeyboard:(UIView *)view;

- (void)showKeyboard;
- (void)hiddenKeyboard;
@end

NS_ASSUME_NONNULL_END
