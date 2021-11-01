//
//  FootprintViewController.h
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/6.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  FootprintViewDelegate <NSObject>

- (void)withOfDelete:(BOOL)delere;

@end
NS_ASSUME_NONNULL_BEGIN

@interface FootprintViewController : UIViewController
@property (nonatomic, strong) id<FootprintViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
