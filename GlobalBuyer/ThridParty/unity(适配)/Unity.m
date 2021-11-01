//
//  Unity.m
//  flow
//
//  Created by 桂在明 on 2019/3/26.
//  Copyright © 2019年 桂在明. All rights reserved.
//

#import "Unity.h"

@implementation Unity
+(UIColor *)getColor:(NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
//计算坐标比例
+(CGFloat)countcoordinatesX:(CGFloat)numberX
{
    CGFloat percentage = numberX / 320;  //百分比
    return [UIScreen mainScreen].bounds.size.width * percentage;
}

//计算坐标比例Y
+(CGFloat)countcoordinatesY:(CGFloat)numberY
{
    //    CGFloat percentage = numberY / 558;
    CGFloat percentage = numberY / 568;  //百分比
    return [UIScreen mainScreen].bounds.size.height * percentage;
}

+(CGFloat)countcoordinatesW:(CGFloat)numberW
{
    CGFloat percentage = [UIScreen mainScreen].bounds.size.width / 320;  //百分比
    return numberW * percentage;
}
+(CGFloat)countcoordinatesH:(CGFloat)numberH
{
//    CGFloat percentage = [UIScreen mainScreen].bounds.size.height / 568;  //百分比
//    return numberH * percentage;
    CGFloat H = 0.0;
    if ([UIScreen mainScreen].bounds.size.height == 812) {
        H = 667;
    }else if ([UIScreen mainScreen].bounds.size.height == 896){
        H= 736;
    }else{
        H = [UIScreen mainScreen].bounds.size.height;
    }
    CGFloat percentage = H / 568;  //百分比
    return numberH * percentage;
}

+ (UIImageView *)imageviewAddsuperview_superView:(UIView *)superview _subViewFrame:(CGRect)rect _imageName:(NSString *)image _backgroundColor:(UIColor *)color
{
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:rect];
    if(image != nil && image.length>0)
        imageview.image = [UIImage imageNamed:image];
    else if(color != nil)
        imageview.backgroundColor = color;
    [superview addSubview:imageview];
    
    return imageview;
}

+(UILabel *)lableViewAddsuperview_superView:(UIView *)superview _subViewFrame:(CGRect)rect _string:(NSString *)string _lableFont:(UIFont *)font _lableTxtColor:(UIColor *)color _textAlignment:(NSTextAlignment)alignment
{
    UILabel *lable = [[UILabel alloc]initWithFrame:rect];
    lable.backgroundColor = [UIColor clearColor];
    lable.text = string;
    lable.font = font;
    lable.textColor = color;
    lable.textAlignment = alignment;
    [superview addSubview:lable];
    
    return lable;
}
+(UITextField *)textFieldAddSuperview_superView:(UIView *)superview
                                  _subViewFrame:(CGRect)rect
                                        _placeT:(NSString *)placeholder
                               _backgroundImage:(UIImage *)background
                                      _delegate:(id)delegate
                                      andSecure:(BOOL)ture
                             andBackGroundColor:(UIColor *)color
{
    UITextField * textfield = [[UITextField alloc] initWithFrame:rect];
    if (placeholder != nil){
        textfield.placeholder = placeholder;
        
    }
    if (background != nil){
        textfield.background = background;
    }
    textfield.delegate = delegate;
    textfield.secureTextEntry = ture;
    textfield.backgroundColor = color;
    [superview addSubview:textfield];
    return textfield;
}

+(UIButton *)buttonAddsuperview_superView:(UIView *)superview _subViewFrame:(CGRect)rect _tag:(id)viewcontroller _action:(SEL)action _string:(NSString *)string _imageName:(NSString *)image
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setTitle:string forState:UIControlStateNormal];
    if(viewcontroller != nil)
        [button addTarget:viewcontroller action:action forControlEvents:UIControlEventTouchUpInside];
    [superview addSubview:button];
    
    return button;
}
//验证手机号
+ (BOOL)validateMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@"" withString:@""];
    
    if (mobile.length !=11) {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))|(198)\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))|(166)\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString * CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))|(199)\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}


+(CGFloat) getLabelHeightWithWidth:(CGFloat)labelWidth andDefaultHeight:(CGFloat)labelDefaultHeight andFontSize:(CGFloat)fontSize andText:(NSString *)text
{
    CGSize constraint = CGSizeMake(labelWidth, 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat labelHeight = MAX(size.height, labelDefaultHeight);
    
    return labelHeight;
}
+ (CGFloat)widthOfString:(NSString *)string OfFontSize:(CGFloat)font OfHeight:(CGFloat)height{
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:font]};     //字体属性，设置字体的font
    
    CGSize maxSize = CGSizeMake(MAXFLOAT, height);     //设置字符串的宽高  MAXFLOAT为最大宽度极限值  JPSlideBarHeight为固定高度
    
    CGSize size = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return ceil(size.width);     //此方法结合  预编译字符串  字体font  字符串宽高  三个参数计算文本  返回字符串宽度
}
+ (NSString *)currencySymbol:(NSString *)currency{
    if ([currency isEqualToString:@"TWD"]) {//台币
        return @"NT$";
    }else if ([currency isEqualToString:@"CNY"]){//人民币
        return @"¥";
    }else if ([currency isEqualToString:@"USD"]){//美元（美国，澳大利亚，香港）
        return @"$";
    }else if ([currency isEqualToString:@"JPY"]){//日币
        return @"¥";
    }else if ([currency isEqualToString:@"GBP"]){//英镑
        return @"£";
    }else if ([currency isEqualToString:@"EUR"]){//欧元（德国 法国）
        return @"€";
    }else if ([currency isEqualToString:@"KRW"]){//韩币
        return @"₩";
    }
    return @"";
}
//按比例缩放,size 是你要把图显示到 多大区域
+ (UIImage *)imageCompressFitSizeScale:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
            
        }
        else{
            
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}
//登录密码校验  字母 数字 特殊符号 必须同时存在 大小写字母其中一种
+ (BOOL)isSafePassword:(NSString *)strPwd{
    NSString *passWordRegex = @"^(?=.*?[a-zA-Z])(?=.*?[0-9])(?=.*?[~!@#$%^&*()_+-=?/])[a-zA-Z0-9~!@#$%^&*()_+-=?/]{8,20}$";
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passWordRegex];
    
    if ([regextestcm evaluateWithObject:strPwd] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}
#pragma mark --判断手机号合法性

+ (BOOL)checkPhone:(NSString *)phoneNumber

{
    
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9])|(17[0-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    
    if (!isMatch)
        
    {
        
        return NO;
        
    }
    
    return YES;
    
    
    
}
#pragma mark 判断邮箱

+ (BOOL)checkEmail:(NSString *)email{
    
    //^(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w{2,3}){1,3})$
    
    NSString *regex = @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [emailTest evaluateWithObject:email];
    
}
@end
