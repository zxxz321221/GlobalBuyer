//
//  HearderView.h
//  首页demo
//
//  Created by 赵阳 && 薛铭 on 2017/6/6.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  HearderViewDelegate <NSObject>

-(void)downLoadSelcetData:(NSInteger )index;

@end

@interface HearderView : UICollectionReusableView

@property(nonatomic,strong)id<HearderViewDelegate>delegate;
-(void)resastBtn;

@end
