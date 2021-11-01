//
//  SetViewController.h
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/9.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  SetViewDelegate <NSObject>
//刷新我的页面角标
- (void)loadMyPage;
@end
NS_ASSUME_NONNULL_BEGIN

@interface SetViewController : UIViewController
@property (nonatomic, strong) id<SetViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
