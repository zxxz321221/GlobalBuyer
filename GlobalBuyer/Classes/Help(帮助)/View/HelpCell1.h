//
//  HelpCell1.h
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/22.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  HelpCell1Delegate <NSObject>
- (void)headerButtonClick:(NSInteger)index;
@end
NS_ASSUME_NONNULL_BEGIN

@interface HelpCell1 : UITableViewCell
@property (nonatomic, strong) id<HelpCell1Delegate>delegate;
@end

NS_ASSUME_NONNULL_END
