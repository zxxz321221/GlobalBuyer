//
//  LoadAnimation.h
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/3/20.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadAnimation : UIView
+(instancetype)LoadingViewSetView:(UIView *)view;

-(void)startLoadAnimation;
-(void)stopLoadAnimation;


@property(nonatomic,strong)NSString * imageName;

@end
