//
//  WaterWaveView.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/24.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WaterWaveViewDetegate <NSObject>

- (void) loginClick;
-(void)changeIcon;

@end

@interface WaterWaveView : UIView
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLa;
@property (nonatomic, strong) UIButton *vipView;
@property (nonatomic, strong) id<WaterWaveViewDetegate>delegate;
- (void)setName:(NSString *)name;
- (void)doAnimation;
- (void)readyToBegin;
@end
