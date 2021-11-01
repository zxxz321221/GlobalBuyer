//
//  LoadingView.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/23.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView
+(instancetype)LoadingViewSetView:(UIView *)view;
-(void)startLoading;
-(void)stopLoading;


@property(nonatomic,strong)UILabel *messageLb;
@end
