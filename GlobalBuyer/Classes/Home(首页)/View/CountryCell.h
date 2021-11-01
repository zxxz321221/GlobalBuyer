//
//  CountryCell.h
//  首页demo
//
//  Created by 赵阳 && 薛铭 on 2017/6/5.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  CountryCellDelegate <NSObject>

-(void)cellImgClick:(NSInteger)index;

@end
@interface CountryCell : UICollectionViewCell
@property (nonatomic, strong) NSMutableArray *noticeArr;
@property (nonatomic, strong) NSMutableArray *activityArr;
@property (nonatomic, strong) id <CountryCellDelegate>delegate;

- (void)setNoticeMessage;
- (void)setActivityImg;
- (void)deleteActivityImg;
@end
