//
//  PhotoView.h
//  GlobalBuyer
//
//  Created by 桂在明 on 2020/3/30.
//  Copyright © 2020 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol  PhotoViewDelegate<NSObject>

- (void)seleteBtn:(NSInteger)tag;

@end
@interface PhotoView : UIView
@property (nonatomic, strong)id <PhotoViewDelegate>delegate;
+(instancetype)setPhotoView:(UIView *)view;
- (void)showPhotoView;
- (void)hiddenCashWay;
@end

NS_ASSUME_NONNULL_END
