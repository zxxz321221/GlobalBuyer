//
//  Unity.h
//  flow
//
//  Created by 桂在明 on 2019/3/26.
//  Copyright © 2019年 桂在明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//状态栏高度
#define STATUS_BAR_HEIGHT 20
//NavBar高度
#define NAVIGATION_BAR_HEIGHT 44
//状态栏 ＋ 导航栏 高度
#define STATUS_AND_NAVIGATION_HEIGHT  ((STATUS_BAR_HEIGHT) + (NAVIGATION_BAR_HEIGHT))

@interface Unity : NSObject
//获取文本颜色
+(UIColor *)getColor:(NSString *) stringToConvert;

//计算坐标比例
+(CGFloat)countcoordinatesX:(CGFloat)numberX;

//计算坐标比例Y
+ (CGFloat)countcoordinatesY:(CGFloat)numberY;

+(CGFloat)countcoordinatesW:(CGFloat)numberW;

+(CGFloat)countcoordinatesH:(CGFloat)numberH;

//image
+ (UIImageView *)imageviewAddsuperview_superView:(UIView *)superview _subViewFrame:(CGRect)rect _imageName:(NSString *)image _backgroundColor:(UIColor *)color;

+(UILabel *)lableViewAddsuperview_superView:(UIView *)superview _subViewFrame:(CGRect)rect _string:(NSString *)string _lableFont:(UIFont *)font _lableTxtColor:(UIColor *)color _textAlignment:(NSTextAlignment)alignment;

+(UITextField *)textFieldAddSuperview_superView:(UIView *)superview
                                  _subViewFrame:(CGRect)rect
                                        _placeT:(NSString *)placeholder
                               _backgroundImage:(UIImage *)background
                                      _delegate:(id)delegate
                                      andSecure:(BOOL)ture
                             andBackGroundColor:(UIColor *)color;

+(UIButton *)buttonAddsuperview_superView:(UIView *)superview _subViewFrame:(CGRect)rect _tag:(id)viewcontroller _action:(SEL)action _string:(NSString *)string _imageName:(NSString *)image;

//校验手机号
+ (BOOL)validateMobile:(NSString *)mobile;

//根据宽度和字体 自动计算文本高度
+(CGFloat) getLabelHeightWithWidth:(CGFloat)labelWidth andDefaultHeight:(CGFloat)labelDefaultHeight andFontSize:(CGFloat)fontSize andText:(NSString *)text;
//根据字符串获取label宽度
+ (CGFloat)widthOfString:(NSString *)string OfFontSize:(CGFloat)font OfHeight:(CGFloat)height;
//货币符号
+ (NSString *)currencySymbol:(NSString *)currency;
+ (UIImage *)imageCompressFitSizeScale:(UIImage *)sourceImage targetSize:(CGSize)size;
//登录密码校验
+ (BOOL)isSafePassword:(NSString *)strPwd;

+ (BOOL)checkPhone:(NSString *)phoneNumber;
+ (BOOL)checkEmail:(NSString *)email;
@end
