//
//  InterestCell.h
//  TakeThings-iOS
//
//  Created by 桂在明 on 2019/4/30.
//  Copyright © 2019 GUIZM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InterestCell : UICollectionViewCell
@property (nonatomic , strong)UIView * maskV;
- (void)configWithOfIcon:(NSString *)icon WithOfName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
