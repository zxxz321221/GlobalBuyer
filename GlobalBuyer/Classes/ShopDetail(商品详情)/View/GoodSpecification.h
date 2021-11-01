//
//  GoodSpecification.h
//  GlobalBuyer
//
//  Created by 澜与轩 on 2020/10/15.
//  Copyright © 2020 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GoodSpecificationDelegate <NSObject>
- (void)selectedSpecification:(NSString *_Nullable)specification selectedNumber:(NSString *_Nullable)number;
@end
NS_ASSUME_NONNULL_BEGIN

@interface GoodSpecification : UIView<UITextFieldDelegate>
@property (nonatomic,strong) NSDictionary *detail;
@property (nonatomic, weak) id<GoodSpecificationDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
