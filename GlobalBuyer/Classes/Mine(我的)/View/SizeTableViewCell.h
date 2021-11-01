//
//  SizeTableViewCell.h
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/4/8.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^EditBlock) (NSInteger);

@interface SizeTableViewCell : UITableViewCell
- (void)configName:(NSString *)name Sex:(NSString *)sex Height:(NSString *)height Weight:(NSString *)weight Shoulder:(NSString *)shoulder Chest:(NSString *)chest Waistline:(NSString *)waistline Girth:(NSString *)girth FootSize:(NSString *)footSize Bottoms:(NSString *)bottoms Index:(NSInteger)index;

@property(nonatomic, copy) EditBlock editBlock;
@end

NS_ASSUME_NONNULL_END
