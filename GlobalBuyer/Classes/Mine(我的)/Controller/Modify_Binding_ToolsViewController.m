//
//  Modify_Binding_ToolsViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/20.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "Modify_Binding_ToolsViewController.h"
#import "UserModel.h"
#import "TYAttributedLabel.h"
@interface Modify_Binding_ToolsViewController ()<TYAttributedLabelDelegate>
{
    NSArray * arr;
}
@property (nonatomic , strong) UserModel * model;
@property (nonatomic , strong) UIScrollView * topScrollView;
@property (nonatomic , strong) UIScrollView * mainScrollView;
@property (nonatomic , strong) UILabel * topLine;
//tops
@property (nonatomic , strong) UILabel * oneTopL;
@property (nonatomic , strong) UILabel * twoTopL;
@property (nonatomic , strong) UILabel * threeTopL;
@property (nonatomic , strong) UILabel * fourTopL;
@property (nonatomic , strong) UIImageView * arrowImg_one;
@property (nonatomic , strong) UIImageView * arrowImg_two;
@property (nonatomic , strong) UIImageView * arrowImg_three;

@property (nonatomic , strong) UIView * oneView;
@property (nonatomic , strong) UIView * twoView_mobile;
@property (nonatomic , strong) UIView * twoView_email;
@property (nonatomic , strong) UIView * mobileView1;
@property (nonatomic , strong) UITextField * mobileText;
@property (nonatomic , strong) UIButton * mobile_code;//验证码
@property (nonatomic , strong) UIImageView * mobile_point;
@property (nonatomic , strong) UILabel * mobile_markL;
@property (nonatomic , strong) UILabel * codeLabel;
@property (nonatomic , strong) UIView * mobileView2;
@property (nonatomic , strong) UITextField * codeText;
@property (nonatomic , strong) UIImageView * code_point;
@property (nonatomic , strong) UILabel * code_markL;
@property (nonatomic , strong) UIButton * mobile_confim;
@property (nonatomic , strong) TYAttributedLabel * mobile_label;

@property (nonatomic , strong) UIView * emailView;
@property (nonatomic , strong) UITextField * emailText;
@property (nonatomic , strong) UIImageView * email_point;
@property (nonatomic , strong) UILabel * email_markL;
@property (nonatomic , strong) UIButton * email_confim;
//emial mobile 第三页
@property (nonatomic , strong) UIView * threeView_mobile;
@property (nonatomic , strong) UIView * threeView_email;

@property (nonatomic , strong) UIView * emailView1;
@property (nonatomic , strong) UITextField * emailText1;
@property (nonatomic , strong) UIImageView * email_point1;
@property (nonatomic , strong) UILabel * email_markL1;
@property (nonatomic , strong) UILabel * email_label;
@property (nonatomic , strong) UIView * emailView2;
@property (nonatomic , strong) UITextField * emailText2;
@property (nonatomic , strong) UIImageView * email_point2;
@property (nonatomic , strong) UILabel * email_markL2;
@property (nonatomic , strong) UIButton * three_email_confim;

@property (nonatomic , strong) UIView * mobileView3;
@property (nonatomic , strong) UITextField * mobileText3;
@property (nonatomic , strong) UIButton * mobile_code3;
@property (nonatomic , strong) UIImageView * mobile_point3;
@property (nonatomic , strong) UILabel * mobile_markL3;
@property (nonatomic , strong) UILabel * mobile_label3;
@property (nonatomic , strong) UIView * mobileView4;
@property (nonatomic , strong) UITextField * codeText4;
@property (nonatomic , strong) UIImageView * code_point4;
@property (nonatomic , strong) UILabel * code_markL4;
@property (nonatomic , strong) UIButton * three_mobile_confim;

@end

@implementation Modify_Binding_ToolsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self bindingData];
    [self createUI];
}
- (void)bindingData{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"user.plist"];
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:filename];
    self.model = [[UserModel alloc]initWithDictionary:dict error:nil];
    
    arr = @[@{@"name":@"邮箱",@"content":self.model.email},@{@"name":@"手机",@"content":self.model.mobile_phone}];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"修改绑定工具";
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addLeftBarButtonWithImage:[UIImage imageNamed:@"back"] action:@selector(backClick)];
}
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addLeftBarButtonWithImage:(UIImage *)image action:(SEL)action
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(0, 0, 44, 44);
    [firstButton setImage:image forState:UIControlStateNormal];
    [firstButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 5 * SCREEN_WIDTH / 375.0, 0, 0)];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}
- (void)createUI{
    [self.view addSubview:self.topScrollView];
    [self.view addSubview:self.mainScrollView];
    [self.view addSubview:self.topLine];
    
}
- (UIScrollView *)topScrollView{
    if (!_topScrollView) {
        _topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, [Unity countcoordinatesH:40])];
        _topScrollView.backgroundColor = [UIColor whiteColor];
        _topScrollView.scrollEnabled = NO;
        _topScrollView.userInteractionEnabled = YES;
        _topScrollView.contentSize =  CGSizeMake([Unity countcoordinatesW:130]*4+[Unity countcoordinatesW:5]*3, 0);
        // 没有弹簧效果
        //        _topScrollView.bounces = NO;
        // 隐藏水平滚动条
        _topScrollView.showsHorizontalScrollIndicator = NO;
        
        [_topScrollView addSubview:self.oneTopL];
        [_topScrollView addSubview:self.arrowImg_one];
        [_topScrollView addSubview:self.twoTopL];
        [_topScrollView addSubview:self.arrowImg_two];
        [_topScrollView addSubview:self.threeTopL];
        [_topScrollView addSubview:self.arrowImg_three];
        [_topScrollView addSubview:self.fourTopL];
    }
    return _topScrollView;
}
- (UILabel *)oneTopL{
    if (!_oneTopL) {
        _oneTopL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [Unity countcoordinatesW:130], [Unity countcoordinatesH:40])];
        _oneTopL.text = @"1.选择绑定工具";
        _oneTopL.font = [UIFont systemFontOfSize:12];
        _oneTopL.textAlignment = NSTextAlignmentCenter;
        _oneTopL.textColor = [Unity getColor:@"#b445c8"];
    }
    return _oneTopL;
}
- (UIImageView *)arrowImg_one{
    if (!_arrowImg_one) {
        _arrowImg_one = [[UIImageView alloc]initWithFrame:CGRectMake(_oneTopL.right, [Unity countcoordinatesH:15], [Unity countcoordinatesW:5], [Unity countcoordinatesH:10])];
        _arrowImg_one.image = [UIImage imageNamed:@"password_gray_go"];
    }
    return _arrowImg_one;
}
- (UILabel *)twoTopL{
    if (!_twoTopL) {
        _twoTopL = [[UILabel alloc]initWithFrame:CGRectMake(_arrowImg_one.right, 0, [Unity countcoordinatesW:130], [Unity countcoordinatesH:40])];
        _twoTopL.text = @"2.身份验证";
        _twoTopL.font = [UIFont systemFontOfSize:12];
        _twoTopL.textAlignment = NSTextAlignmentCenter;
        _twoTopL.textColor = [Unity getColor:@"#999999"];
    }
    return _twoTopL;
}
- (UIImageView *)arrowImg_two{
    if (!_arrowImg_two) {
        _arrowImg_two = [[UIImageView alloc]initWithFrame:CGRectMake(_twoTopL.right, [Unity countcoordinatesH:15], [Unity countcoordinatesW:5], [Unity countcoordinatesH:10])];
        _arrowImg_two.image = [UIImage imageNamed:@"password_gray_go"];
    }
    return _arrowImg_two;
}
- (UILabel *)threeTopL{
    if (!_threeTopL) {
        _threeTopL = [[UILabel alloc]initWithFrame:CGRectMake(_arrowImg_two.right, 0, [Unity countcoordinatesW:130], [Unity countcoordinatesH:40])];
        _threeTopL.text = @"3.输入新的绑定工具";
        _threeTopL.font = [UIFont systemFontOfSize:12];
        _threeTopL.textAlignment = NSTextAlignmentCenter;
        _threeTopL.textColor = [Unity getColor:@"#999999"];
    }
    return _threeTopL;
}
- (UIImageView *)arrowImg_three{
    if (!_arrowImg_three) {
        _arrowImg_three = [[UIImageView alloc]initWithFrame:CGRectMake(_threeTopL.right, [Unity countcoordinatesH:15], [Unity countcoordinatesW:5], [Unity countcoordinatesH:10])];
        _arrowImg_three.image = [UIImage imageNamed:@"password_gray_go"];
    }
    return _arrowImg_three;
}
- (UILabel *)fourTopL{
    if (!_fourTopL) {
        _fourTopL = [[UILabel alloc]initWithFrame:CGRectMake(_arrowImg_three.right, 0, [Unity countcoordinatesW:130], [Unity countcoordinatesH:40])];
        _fourTopL.text = @"4.更改完成";
        _fourTopL.font = [UIFont systemFontOfSize:12];
        _fourTopL.textAlignment = NSTextAlignmentCenter;
        _fourTopL.textColor = [Unity getColor:@"#999999"];
    }
    return _fourTopL;
}
- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, [Unity countcoordinatesH:40], kScreenW, kScreenH-[Unity countcoordinatesH:40]-NavBarHeight)];
        _mainScrollView.backgroundColor = [UIColor whiteColor];
        _mainScrollView.scrollEnabled = NO;
        _mainScrollView.userInteractionEnabled = YES;
        _mainScrollView.contentSize =  CGSizeMake(kScreenW*3, 0);
        // 没有弹簧效果
        //        _topScrollView.bounces = NO;
        // 隐藏水平滚动条
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        
        [_mainScrollView addSubview:self.oneView];
        [_mainScrollView addSubview:self.twoView_mobile];
        [_mainScrollView addSubview:self.twoView_email];
        [_mainScrollView addSubview:self.threeView_email];
        [_mainScrollView addSubview:self.threeView_mobile];
    }
    return _mainScrollView;
}
- (UILabel *)topLine{
    if (!_topLine) {
        _topLine = [[UILabel alloc]initWithFrame:CGRectMake(0, _topScrollView.bottom, kScreenW, [Unity countcoordinatesH:1])];
        _topLine.backgroundColor = [Unity getColor:@"#e0e0e0"];
        
    }
    return _topLine;
}
- (UIView *)oneView{
    if (!_oneView) {
        _oneView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, _mainScrollView.height)];
        
        for (int i=0; i<2; i++) {
            UIButton * btn = [Unity buttonAddsuperview_superView:_oneView _subViewFrame:CGRectMake(0, i*[Unity countcoordinatesH:50], kScreenW, [Unity countcoordinatesH:50]) _tag:self _action:@selector(btnClick:) _string:@"" _imageName:@""];
            btn.tag= 1000+i;
            UIImageView * icon = [Unity imageviewAddsuperview_superView:btn _subViewFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:19], [Unity countcoordinatesW:12], [Unity countcoordinatesH:12]) _imageName:arr[i][@"name"] _backgroundColor:nil];
            UILabel * nameL = [Unity lableViewAddsuperview_superView:btn _subViewFrame:CGRectMake(icon.right+[Unity countcoordinatesW:10], [Unity countcoordinatesH:15], [Unity countcoordinatesW:60], [Unity countcoordinatesH:20]) _string:arr[i][@"name"] _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
            nameL.backgroundColor = [UIColor clearColor];
            UIImageView * jianIcon = [Unity imageviewAddsuperview_superView:btn _subViewFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:15], [Unity countcoordinatesH:20], [Unity countcoordinatesW:5], [Unity countcoordinatesH:10]) _imageName:@"password_gray_go" _backgroundColor:nil];
            jianIcon.backgroundColor = [UIColor clearColor];
            UILabel * label = [Unity lableViewAddsuperview_superView:btn _subViewFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:175], [Unity countcoordinatesH:15], [Unity countcoordinatesW:150], [Unity countcoordinatesH:20]) _string:arr[i][@"content"] _lableFont:[UIFont systemFontOfSize:12] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentRight];
            label.backgroundColor = [UIColor clearColor];
            UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, [Unity countcoordinatesH:49], kScreenW, [Unity countcoordinatesH:1])];
            line.backgroundColor = [Unity getColor:@"#e0e0e0"];
            [btn addSubview:line];
        }
    }
    return _oneView;
}
- (UIView *)twoView_email{
    if (!_twoView_email) {
        _twoView_email = [[UIView alloc]initWithFrame:CGRectMake(kScreenW, 0, kScreenW, _mainScrollView.height)];
        UILabel * label = [Unity lableViewAddsuperview_superView:_twoView_email _subViewFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:20], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:20]) _string:@"请输入现有绑定邮箱" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
        _emailView = [[UIView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], label.bottom+[Unity countcoordinatesH:10], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:45])];
        _emailView.backgroundColor = [Unity getColor:@"#e0e0e0"];
        [_twoView_email addSubview:_emailView];
        [_emailView addSubview:self.emailText];
        
        _email_point = [Unity imageviewAddsuperview_superView:_twoView_email _subViewFrame:CGRectMake([Unity countcoordinatesW:10], _emailView.bottom+[Unity countcoordinatesH:3], [Unity countcoordinatesH:14], [Unity countcoordinatesH:14]) _imageName:@"!" _backgroundColor:nil];
        _email_point.hidden=YES;
        _email_markL = [Unity lableViewAddsuperview_superView:_twoView_email _subViewFrame:CGRectMake(_email_point.right+[Unity countcoordinatesW:5], _emailView.bottom, kScreenW-[Unity countcoordinatesW:25]-[Unity countcoordinatesH:14], [Unity countcoordinatesH:20]) _string:@"邮箱输入错误" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#b00000"] _textAlignment:NSTextAlignmentLeft];
        _email_markL.hidden=YES;
        
        [_twoView_email addSubview:self.email_confim];
        
        _twoView_email.hidden=YES;
    }
    return _twoView_email;
}
- (UITextField *)emailText{
    if (!_emailText) {
        _emailText = [[UITextField alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:10], [Unity countcoordinatesW:280], [Unity countcoordinatesH:25])];
        _emailText.keyboardType = UIKeyboardTypeNumberPad;
        _emailText.placeholder = @"请输入邮箱";
        _emailText.font = [UIFont systemFontOfSize:14];
        [_emailText addTarget:self action:@selector(emailTextField:) forControlEvents:UIControlEventEditingChanged];
    }
    return _emailText;
}
- (UIButton *)email_confim{
    if (!_email_confim) {
        _email_confim = [[UIButton alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], _emailView.bottom+[Unity countcoordinatesH:50], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:40])];
        [_email_confim addTarget:self action:@selector(email_confimClick) forControlEvents:UIControlEventTouchUpInside];
        [_email_confim setTitle:@"确定" forState:UIControlStateNormal];
        [_email_confim setTitleColor:[Unity getColor:@"#c478d4"] forState:UIControlStateNormal];
        _email_confim.backgroundColor = [Unity getColor:@"#b445c8"];
        _email_confim.layer.cornerRadius = [Unity countcoordinatesH:20];
        _email_confim.layer.masksToBounds = YES;
        _email_confim.userInteractionEnabled = NO;
    }
    return _email_confim;
}
- (UIView *)twoView_mobile{
    if (!_twoView_mobile) {
        _twoView_mobile = [[UIView alloc]initWithFrame:CGRectMake(kScreenW, 0, kScreenW, _mainScrollView.height)];
        UILabel * label = [Unity lableViewAddsuperview_superView:_twoView_mobile _subViewFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:20], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:20]) _string:@"请输入绑定手机号验证身份" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
        _mobileView1 = [[UIView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], label.bottom+[Unity countcoordinatesH:10], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:45])];
        _mobileView1.backgroundColor = [Unity getColor:@"#e0e0e0"];
        [_twoView_mobile addSubview:_mobileView1];
        [_mobileView1 addSubview:self.mobileText];
        [_mobileView1 addSubview:self.mobile_code];
        _mobile_point = [Unity imageviewAddsuperview_superView:_twoView_mobile _subViewFrame:CGRectMake([Unity countcoordinatesW:10], _mobileView1.bottom+[Unity countcoordinatesH:3], [Unity countcoordinatesH:14], [Unity countcoordinatesH:14]) _imageName:@"!" _backgroundColor:nil];
        _mobile_point.hidden=YES;
        _mobile_markL = [Unity lableViewAddsuperview_superView:_twoView_mobile _subViewFrame:CGRectMake(_mobile_point.right+[Unity countcoordinatesW:5], _mobileView1.bottom, kScreenW-[Unity countcoordinatesW:25]-[Unity countcoordinatesH:14], [Unity countcoordinatesH:20]) _string:@"请输入正确的手机号码" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#b00000"] _textAlignment:NSTextAlignmentLeft];
        _mobile_markL.hidden=YES;
        _codeLabel = [Unity lableViewAddsuperview_superView:_twoView_mobile _subViewFrame:CGRectMake([Unity countcoordinatesW:10], _mobileView1.bottom+[Unity countcoordinatesH:20], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:20]) _string:@"请输入短信验证码" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
        _mobileView2 = [[UIView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], _codeLabel.bottom+[Unity countcoordinatesH:10], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:45])];
        _mobileView2.backgroundColor = [Unity getColor:@"#e0e0e0"];
        [_twoView_mobile addSubview:_mobileView2];
        [_mobileView2 addSubview:self.codeText];
        
        _code_point = [Unity imageviewAddsuperview_superView:_twoView_mobile _subViewFrame:CGRectMake([Unity countcoordinatesW:10], _mobileView2.bottom+[Unity countcoordinatesH:3], [Unity countcoordinatesH:14], [Unity countcoordinatesH:14]) _imageName:@"!" _backgroundColor:nil];
        _code_point.hidden=YES;
        _code_markL = [Unity lableViewAddsuperview_superView:_twoView_mobile _subViewFrame:CGRectMake(_code_point.right+[Unity countcoordinatesW:5], _mobileView2.bottom, kScreenW-[Unity countcoordinatesW:25]-[Unity countcoordinatesH:14], [Unity countcoordinatesH:20]) _string:@"验证码错误" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#b00000"] _textAlignment:NSTextAlignmentLeft];
        _code_markL.hidden=YES;
        
        [_twoView_mobile addSubview:self.mobile_confim];
        [_twoView_mobile addSubview:self.mobile_label];
        // 规则声明
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"如果绑定手机无法收到验证码，请使用"];
        [attributedString addAttributeTextColor:[Unity getColor:@"#999999"]];
        [attributedString addAttributeFont:[UIFont systemFontOfSize:12]];
        [self.mobile_label appendTextAttributedString:attributedString];
        
        // 增加链接 Terms and Conditions
        [self.mobile_label appendLinkWithText:@"邮箱进行身份验证" linkFont:[UIFont systemFontOfSize:12] linkColor:[Unity getColor:@"#b445c8"] linkData:@"1"];
        
        [self.mobile_label sizeToFit];
        
        UILabel * serviceL = [[UILabel alloc]initWithFrame:CGRectMake((kScreenW-[Unity countcoordinatesW:200])/2, _twoView_mobile.height-[Unity countcoordinatesH:40], [Unity countcoordinatesW:200], [Unity countcoordinatesH:20])];
        serviceL.text = @"遇到问题？联系客服";
        serviceL.textColor =[Unity getColor:@"#333333"];
        serviceL.textAlignment = NSTextAlignmentCenter;
        serviceL.font = [UIFont systemFontOfSize:12];
        
        [_twoView_mobile addSubview:serviceL];
        
        _twoView_mobile.hidden=YES;
    }
    return _twoView_mobile;
}
- (UITextField *)mobileText{
    if (!_mobileText) {
        _mobileText = [[UITextField alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:10], [Unity countcoordinatesW:150], [Unity countcoordinatesH:25])];
        _mobileText.keyboardType = UIKeyboardTypeNumberPad;
        _mobileText.placeholder = @"请输入手机号";
        _mobileText.font = [UIFont systemFontOfSize:14];
        [_mobileText addTarget:self action:@selector(mobileTextField:) forControlEvents:UIControlEventEditingChanged];
    }
    return _mobileText;
}
- (UIButton *)mobile_code{
    if (!_mobile_code) {
        _mobile_code = [[UIButton alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:200], [Unity countcoordinatesH:5], [Unity countcoordinatesW:100], [Unity countcoordinatesH:35])];
        [_mobile_code addTarget:self action:@selector(mobile_codeClick) forControlEvents:UIControlEventTouchUpInside];
        [_mobile_code setTitle:@"获取验证码" forState:UIControlStateNormal];
        _mobile_code.layer.borderColor = [[Unity getColor:@"#999999"] CGColor];
        _mobile_code.layer.borderWidth = 1.0f;
        [_mobile_code setTitleColor:[Unity getColor:@"#999999"] forState:UIControlStateNormal];
        _mobile_code.titleLabel.font = [UIFont systemFontOfSize:14];
        _mobile_code.layer.cornerRadius = [Unity countcoordinatesH:17.5];
        _mobile_code.layer.masksToBounds = YES;
        _mobile_code.userInteractionEnabled=NO;
    }
    return _mobile_code;
}
- (UITextField *)codeText{
    if (!_codeText) {
        _codeText = [[UITextField alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:10], [Unity countcoordinatesW:150], [Unity countcoordinatesH:25])];
        _codeText.keyboardType = UIKeyboardTypeNumberPad;
        _codeText.placeholder = @"请输入验证码";
        _codeText.font = [UIFont systemFontOfSize:14];
        [_codeText addTarget:self action:@selector(codeTextField:) forControlEvents:UIControlEventEditingChanged];
    }
    return _codeText;
}
- (UIButton *)mobile_confim{
    if (!_mobile_confim) {
        _mobile_confim = [[UIButton alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], _mobileView2.bottom+[Unity countcoordinatesH:50], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:40])];
        [_mobile_confim addTarget:self action:@selector(mobile_confimClick) forControlEvents:UIControlEventTouchUpInside];
        [_mobile_confim setTitle:@"确定" forState:UIControlStateNormal];
        [_mobile_confim setTitleColor:[Unity getColor:@"#c478d4"] forState:UIControlStateNormal];
        _mobile_confim.backgroundColor = [Unity getColor:@"#b445c8"];
        _mobile_confim.layer.cornerRadius = [Unity countcoordinatesH:20];
        _mobile_confim.layer.masksToBounds = YES;
        _mobile_confim.userInteractionEnabled = NO;
    }
    return _mobile_confim;
}
#pragma mark - Getter
- (TYAttributedLabel *)mobile_label {
    if (!_mobile_label) {
        _mobile_label = [[TYAttributedLabel alloc] initWithFrame:CGRectMake([Unity countcoordinatesW:10], _mobile_confim.bottom+[Unity countcoordinatesH:5], kScreenW-[Unity countcoordinatesW:20], 0)];
        _mobile_label.delegate = self;
    }
    return _mobile_label;
}
#pragma mark ---------邮箱第三部view
- (UIView *)threeView_email{
    if (!_threeView_email) {
        _threeView_email = [[UIView alloc]initWithFrame:CGRectMake(kScreenW*2, 0, kScreenW, _mainScrollView.height)];
        UILabel * label = [Unity lableViewAddsuperview_superView:_threeView_email _subViewFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:20], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:20]) _string:@"请输入新的邮箱地址" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
        _emailView1 = [[UIView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], label.bottom+[Unity countcoordinatesH:10], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:45])];
        _emailView1.backgroundColor = [Unity getColor:@"#e0e0e0"];
        [_threeView_email addSubview:_emailView1];
        [_emailView1 addSubview:self.emailText1];
        _email_point1 = [Unity imageviewAddsuperview_superView:_threeView_email _subViewFrame:CGRectMake([Unity countcoordinatesW:10], _emailView1.bottom+[Unity countcoordinatesH:3], [Unity countcoordinatesH:14], [Unity countcoordinatesH:14]) _imageName:@"!" _backgroundColor:nil];
        _email_point1.hidden=YES;
        _email_markL1 = [Unity lableViewAddsuperview_superView:_threeView_email _subViewFrame:CGRectMake(_email_point1.right+[Unity countcoordinatesW:5], _emailView1.bottom, kScreenW-[Unity countcoordinatesW:25]-[Unity countcoordinatesH:14], [Unity countcoordinatesH:20]) _string:@"邮箱格式不正确" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#b00000"] _textAlignment:NSTextAlignmentLeft];
        _email_markL1.hidden=YES;
        _email_label = [Unity lableViewAddsuperview_superView:_threeView_email _subViewFrame:CGRectMake([Unity countcoordinatesW:10], _emailView1.bottom+[Unity countcoordinatesH:20], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:20]) _string:@"请再次输入您的邮箱地址" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
        _emailView2 = [[UIView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], _email_label.bottom+[Unity countcoordinatesH:10], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:45])];
        _emailView2.backgroundColor = [Unity getColor:@"#e0e0e0"];
        [_threeView_email addSubview:_emailView2];
        [_emailView2 addSubview:self.emailText2];
        
        _email_point2 = [Unity imageviewAddsuperview_superView:_threeView_email _subViewFrame:CGRectMake([Unity countcoordinatesW:10], _emailView2.bottom+[Unity countcoordinatesH:3], [Unity countcoordinatesH:14], [Unity countcoordinatesH:14]) _imageName:@"!" _backgroundColor:nil];
        _email_point2.hidden=YES;
        _email_markL2 = [Unity lableViewAddsuperview_superView:_threeView_email _subViewFrame:CGRectMake(_email_point2.right+[Unity countcoordinatesW:5], _mobileView2.bottom, kScreenW-[Unity countcoordinatesW:25]-[Unity countcoordinatesH:14], [Unity countcoordinatesH:20]) _string:@"邮箱输入不一致" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#b00000"] _textAlignment:NSTextAlignmentLeft];
        _email_markL2.hidden=YES;
        [_threeView_email addSubview:self.three_email_confim];
    }
    return _threeView_email;
}
- (UITextField *)emailText1{
    if (!_emailText1) {
        _emailText1 = [[UITextField alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:10], [Unity countcoordinatesW:150], [Unity countcoordinatesH:25])];
        _emailText1.placeholder = @"请输入邮箱";
        _emailText1.font = [UIFont systemFontOfSize:14];
        [_emailText1 addTarget:self action:@selector(emailTextField1:) forControlEvents:UIControlEventEditingChanged];
    }
    return _emailText1;
}
- (UITextField *)emailText2{
    if (!_emailText2) {
        _emailText2 = [[UITextField alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:10], [Unity countcoordinatesW:150], [Unity countcoordinatesH:25])];
        _emailText2.placeholder = @"请输入邮箱";
        _emailText2.font = [UIFont systemFontOfSize:14];
        [_emailText2 addTarget:self action:@selector(emailTextField2:) forControlEvents:UIControlEventEditingChanged];
    }
    return _emailText2;
}
- (UIButton *)three_email_confim{
    if (!_three_email_confim) {
        _three_email_confim = [[UIButton alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], _emailView2.bottom+[Unity countcoordinatesH:50], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:40])];
        [_three_email_confim addTarget:self action:@selector(threeEmail_confimClick) forControlEvents:UIControlEventTouchUpInside];
        [_three_email_confim setTitle:@"确定" forState:UIControlStateNormal];
        [_three_email_confim setTitleColor:[Unity getColor:@"#c478d4"] forState:UIControlStateNormal];
        _three_email_confim.backgroundColor = [Unity getColor:@"#b445c8"];
        _three_email_confim.layer.cornerRadius = [Unity countcoordinatesH:20];
        _three_email_confim.layer.masksToBounds = YES;
        _three_email_confim.userInteractionEnabled = NO;
    }
    return _three_email_confim;
}
#pragma mark ---------手机第三部view
- (UIView *)threeView_mobile{
    if (!_threeView_mobile) {
        _threeView_mobile = [[UIView alloc]initWithFrame:CGRectMake(kScreenW*2, 0, kScreenW, _mainScrollView.height)];
        UILabel * label = [Unity lableViewAddsuperview_superView:_threeView_mobile _subViewFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:20], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:20]) _string:@"请输入您新的手机号码" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
        _mobileView3 = [[UIView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], label.bottom+[Unity countcoordinatesH:10], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:45])];
        _mobileView3.backgroundColor = [Unity getColor:@"#e0e0e0"];
        [_threeView_mobile addSubview:_mobileView3];
        [_mobileView3 addSubview:self.mobileText3];
        [_mobileView3 addSubview:self.mobile_code3];
        _mobile_point3 = [Unity imageviewAddsuperview_superView:_mobileView3 _subViewFrame:CGRectMake([Unity countcoordinatesW:10], _mobileView1.bottom+[Unity countcoordinatesH:3], [Unity countcoordinatesH:14], [Unity countcoordinatesH:14]) _imageName:@"!" _backgroundColor:nil];
        _mobile_point3.hidden=YES;
        _mobile_markL3 = [Unity lableViewAddsuperview_superView:_mobileView3 _subViewFrame:CGRectMake(_mobile_point3.right+[Unity countcoordinatesW:5], _mobileView3.bottom, kScreenW-[Unity countcoordinatesW:25]-[Unity countcoordinatesH:14], [Unity countcoordinatesH:20]) _string:@"请输入正确的手机号码" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#b00000"] _textAlignment:NSTextAlignmentLeft];
        _mobile_markL3.hidden=YES;
        _mobile_label3 = [Unity lableViewAddsuperview_superView:_threeView_mobile _subViewFrame:CGRectMake([Unity countcoordinatesW:10], _mobileView3.bottom+[Unity countcoordinatesH:20], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:20]) _string:@"请输入短信验证码" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
        _mobileView4 = [[UIView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], _codeLabel.bottom+[Unity countcoordinatesH:10], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:45])];
        _mobileView4.backgroundColor = [Unity getColor:@"#e0e0e0"];
        [_threeView_mobile addSubview:_mobileView4];
//        [_mobileView2 addSubview:self.codeText];
//
        _code_point4 = [Unity imageviewAddsuperview_superView:_threeView_mobile _subViewFrame:CGRectMake([Unity countcoordinatesW:10], _mobileView4.bottom+[Unity countcoordinatesH:3], [Unity countcoordinatesH:14], [Unity countcoordinatesH:14]) _imageName:@"!" _backgroundColor:nil];
        _code_point4.hidden=YES;
        _code_markL4 = [Unity lableViewAddsuperview_superView:_threeView_mobile _subViewFrame:CGRectMake(_code_point4.right+[Unity countcoordinatesW:5], _mobileView4.bottom, kScreenW-[Unity countcoordinatesW:25]-[Unity countcoordinatesH:14], [Unity countcoordinatesH:20]) _string:@"验证码错误" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#b00000"] _textAlignment:NSTextAlignmentLeft];
        _code_markL4.hidden=YES;
//
//        [_twoView_mobile addSubview:self.mobile_confim];
    }
    return _threeView_mobile;
}
- (UITextField *)mobileText3{
    if (!_mobileText3) {
        _mobileText3 = [[UITextField alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:10], [Unity countcoordinatesW:150], [Unity countcoordinatesH:25])];
        _mobileText3.keyboardType = UIKeyboardTypeNumberPad;
        _mobileText3.placeholder = @"请输入手机号";
        _mobileText3.font = [UIFont systemFontOfSize:14];
        [_mobileText3 addTarget:self action:@selector(mobileTextField:) forControlEvents:UIControlEventEditingChanged];
    }
    return _mobileText3;
}
- (UIButton *)mobile_code3{
    if (!_mobile_code3) {
        _mobile_code3 = [[UIButton alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:200], [Unity countcoordinatesH:5], [Unity countcoordinatesW:100], [Unity countcoordinatesH:35])];
        [_mobile_code3 addTarget:self action:@selector(mobile_codeClick) forControlEvents:UIControlEventTouchUpInside];
        [_mobile_code3 setTitle:@"获取验证码" forState:UIControlStateNormal];
        _mobile_code3.layer.borderColor = [[Unity getColor:@"#999999"] CGColor];
        _mobile_code3.layer.borderWidth = 1.0f;
        [_mobile_code3 setTitleColor:[Unity getColor:@"#999999"] forState:UIControlStateNormal];
        _mobile_code3.titleLabel.font = [UIFont systemFontOfSize:14];
        _mobile_code3.layer.cornerRadius = [Unity countcoordinatesH:17.5];
        _mobile_code3.layer.masksToBounds = YES;
        _mobile_code3.userInteractionEnabled=NO;
    }
    return _mobile_code3;
}



- (void)btnClick:(UIButton *)btn{
    self.arrowImg_one.image = [UIImage imageNamed:@"password_go"];
    self.twoTopL.textColor = [Unity getColor:@"#b445c8"];
    [self.mainScrollView setContentOffset:CGPointMake(kScreenW, 0) animated:YES];
    self.mainScrollView.bouncesZoom = NO;
    if (btn.tag == 1000) {
        self.title = @"修改邮箱绑定";
        self.twoView_email.hidden=NO;
    }else{
        self.title = @"修改手机绑定";
        self.twoView_mobile.hidden=NO;
    }
}
-(void)mobileTextField:(UITextField *)textField
{
    if (textField.text.length == 0) {
        //手机号码输入框为空   确定按钮失效文字变暗
        [self.mobile_confim setTitleColor:[Unity getColor:@"#c478d4"] forState:UIControlStateNormal];
        self.mobile_confim.userInteractionEnabled = NO;
        //验证码按钮失效 变暗
        self.mobile_code.userInteractionEnabled = NO;
        self.mobile_code.layer.borderColor = [[Unity getColor:@"#999999"] CGColor];
        self.mobile_code.layer.borderWidth = 1.0f;
        [self.mobile_code setTitleColor:[Unity getColor:@"#999999"] forState:UIControlStateNormal];
        if (self.mobile_markL.hidden==NO) {
            self.mobile_point.hidden=YES;
            self.mobile_markL.hidden=YES;
            self.codeLabel.frame = CGRectMake([Unity countcoordinatesW:10], self.mobileView1.bottom+[Unity countcoordinatesH:20], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:20]);
            self.mobileView2.frame = CGRectMake(self.codeLabel.left, self.codeLabel.bottom+[Unity countcoordinatesH:10], self.codeLabel.width, [Unity countcoordinatesH:45]);
            self.mobile_confim.frame = CGRectMake(self.codeLabel.left, self.mobileView2.bottom+[Unity countcoordinatesH:50], self.codeLabel.width, [Unity countcoordinatesH:40]);
            self.mobile_label.frame = CGRectMake([Unity countcoordinatesW:10], self.mobile_confim.bottom+[Unity countcoordinatesH:5], kScreenW-[Unity countcoordinatesW:20], 0);
            [self.mobile_label sizeToFit];
        }
    }else{
        //手机号码输入框不为空   确定按钮恢复 文字变白色
        [self.mobile_confim setTitleColor:[Unity getColor:@"#ffffff"] forState:UIControlStateNormal];
        self.mobile_confim.userInteractionEnabled = YES;
        self.mobile_code.userInteractionEnabled = YES;
        self.mobile_code.layer.borderColor = [[Unity getColor:@"#b445c8"] CGColor];
        self.mobile_code.layer.borderWidth = 1.0f;
        [self.mobile_code setTitleColor:[Unity getColor:@"#b445c8"] forState:UIControlStateNormal];
    }
}
- (void)mobile_codeClick{
    if ([Unity checkPhone:self.mobileText.text]) {
       //发送短信验证
    }else{
        //手机号格式不正确
        self.mobile_point.hidden=NO;
        self.mobile_markL.hidden=NO;
        self.codeLabel.frame = CGRectMake([Unity countcoordinatesW:10], self.mobile_markL.bottom+[Unity countcoordinatesH:20], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:20]);
        self.mobileView2.frame = CGRectMake(self.codeLabel.left, self.codeLabel.bottom+[Unity countcoordinatesH:10], self.codeLabel.width, [Unity countcoordinatesH:45]);
        self.mobile_confim.frame = CGRectMake(self.codeLabel.left, self.mobileView2.bottom+[Unity countcoordinatesH:50], self.codeLabel.width, [Unity countcoordinatesH:40]);
        self.mobile_label.frame = CGRectMake([Unity countcoordinatesW:10], self.mobile_confim.bottom+[Unity countcoordinatesH:5], kScreenW-[Unity countcoordinatesW:20], 0);
        [self.mobile_label sizeToFit];
    }
}
- (void)mobile_confimClick{
    if (self.mobile_markL.hidden == YES && self.code_markL.hidden==YES) {
        if (self.codeText.text.length == 0) {
            //提示错误
            self.code_markL.hidden=NO;
            self.code_point.hidden=NO;
            self.mobile_confim.frame = CGRectMake(self.codeLabel.left, self.code_markL.bottom+[Unity countcoordinatesH:50], self.codeLabel.width, [Unity countcoordinatesH:40]);
            self.mobile_label.frame = CGRectMake([Unity countcoordinatesW:10], self.mobile_confim.bottom+[Unity countcoordinatesH:5], kScreenW-[Unity countcoordinatesW:20], 0);
            [self.mobile_label sizeToFit];
        }else{
            self.arrowImg_two.image =[UIImage imageNamed:@"password_go"];
            self.threeTopL.textColor = [Unity getColor:@"#b445c8"];
            [self.topScrollView setContentOffset:CGPointMake([Unity countcoordinatesW:535]-kScreenW, 0) animated:YES];
            self.topScrollView.bouncesZoom = NO;
            [self.mainScrollView setContentOffset:CGPointMake(kScreenW*2, 0) animated:YES];
            self.mainScrollView.bouncesZoom = NO;
            //手机进入第三部隐藏   threeview_email
            _threeView_email.hidden=YES;
        }
    }
    
}
#pragma mark - Delegate
//TYAttributedLabelDelegate
- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)TextRun atPoint:(CGPoint)point {
    if ([TextRun isKindOfClass:[TYLinkTextStorage class]]) {
        NSString *linkStr = ((TYLinkTextStorage*)TextRun).linkData;
        NSLog(@"linkStr === %@",linkStr);
    }
}
-(void)codeTextField:(UITextField *)textField
{
    if (textField.text.length == 0) {
        if (self.code_markL.hidden==NO) {
            self.code_markL.hidden=YES;
            self.code_point.hidden=YES;
            self.mobile_confim.frame = CGRectMake(self.codeLabel.left, self.mobileView2.bottom+[Unity countcoordinatesH:50], self.codeLabel.width, [Unity countcoordinatesH:40]);
            self.mobile_label.frame = CGRectMake([Unity countcoordinatesW:10], self.mobile_confim.bottom+[Unity countcoordinatesH:5], kScreenW-[Unity countcoordinatesW:20], 0);
            [self.mobile_label sizeToFit];
        }
    }else{
        
    }
}
-(void)emailTextField:(UITextField *)textField
{
    if (textField.text.length == 0) {
        self.email_confim.userInteractionEnabled = NO;
        [self.email_confim setTitleColor:[Unity getColor:@"#c478d4"] forState:UIControlStateNormal];
        
        if (self.email_markL.hidden==NO) {
            self.email_markL.hidden=YES;
            self.email_point.hidden=YES;
            self.email_confim.frame = CGRectMake([Unity countcoordinatesW:10], self.emailView.bottom+[Unity countcoordinatesH:50], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:40]);
        }
    }else{
        self.email_confim.userInteractionEnabled = YES;
        [self.email_confim setTitleColor:[Unity getColor:@"#ffffff"] forState:UIControlStateNormal];
    }
}
- (void)email_confimClick{
    if ([Unity checkEmail:self.emailText.text]) {
        //通过
        self.arrowImg_two.image =[UIImage imageNamed:@"password_go"];
        self.threeTopL.textColor = [Unity getColor:@"#b445c8"];
        [self.topScrollView setContentOffset:CGPointMake([Unity countcoordinatesW:535]-kScreenW, 0) animated:YES];
        self.topScrollView.bouncesZoom = NO;
        [self.mainScrollView setContentOffset:CGPointMake(kScreenW*2, 0) animated:YES];
        self.mainScrollView.bouncesZoom = NO;
        //手机进入第三部隐藏   threeview_mobile
        _threeView_mobile.hidden=YES;
    }else{
        self.email_markL.hidden=NO;
        self.email_point.hidden=NO;
        self.email_confim.frame = CGRectMake([Unity countcoordinatesW:10], self.email_markL.bottom+[Unity countcoordinatesH:50], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:40]);
    }
}
//emial  第三页事件
-(void)emailTextField1:(UITextField *)textField
{
    if (textField.text.length == 0) {
        self.three_email_confim.userInteractionEnabled = NO;
        [self.three_email_confim setTitleColor:[Unity getColor:@"#c478d4"] forState:UIControlStateNormal];
        if (self.email_point1.hidden == NO) {
            self.email_point1.hidden = YES;
            self.email_markL1.hidden = YES;
            self.email_label.frame = CGRectMake([Unity countcoordinatesW:10], _emailView1.bottom+[Unity countcoordinatesH:20], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:20]);
            self.emailView2.frame = CGRectMake(self.email_label.left, self.email_label.bottom+[Unity countcoordinatesH:10], self.email_label.width, [Unity countcoordinatesH:45]);
            self.three_email_confim.frame = CGRectMake(self.emailView2.left, self.emailView2.bottom+[Unity countcoordinatesH:50], self.emailView2.width, [Unity countcoordinatesH:40]);
        }
    }else{
        self.three_email_confim.userInteractionEnabled = YES;
        [self.three_email_confim setTitleColor:[Unity getColor:@"#ffffff"] forState:UIControlStateNormal];
    }
}
-(void)emailTextField2:(UITextField *)textField
{
    if (textField.text.length == 0) {
        if (self.email_point2.hidden == NO) {
            self.email_point2.hidden = YES;
            self.email_markL2.hidden = YES;
            self.three_email_confim.frame = CGRectMake(self.emailView2.left, self.emailView2.bottom+[Unity countcoordinatesH:50], self.emailView2.width, [Unity countcoordinatesH:40]);
        }
    }
}
- (void)threeEmail_confimClick{
    if ([Unity checkEmail:self.emailText1.text]) {
        if (self.email_point1.hidden == NO) {
            self.email_point1.hidden = YES;
            self.email_markL1.hidden = YES;
            self.email_label.frame = CGRectMake([Unity countcoordinatesW:10], _emailView1.bottom+[Unity countcoordinatesH:20], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:20]);
            self.emailView2.frame = CGRectMake(self.email_label.left, self.email_label.bottom+[Unity countcoordinatesH:10], self.email_label.width, [Unity countcoordinatesH:45]);
            self.three_email_confim.frame = CGRectMake(self.emailView2.left, self.emailView2.bottom+[Unity countcoordinatesH:50], self.emailView2.width, [Unity countcoordinatesH:40]);
        }
        if ([self.emailText1.text isEqualToString:self.emailText2.text]) {
            //通过
            self.email_point2.hidden = YES;
            self.email_markL2.hidden = YES;
            self.three_email_confim.frame = CGRectMake(self.emailView2.left, self.emailView2.bottom+[Unity countcoordinatesH:50], self.emailView2.width, [Unity countcoordinatesH:40]);
            
        }else{
            //邮箱输入不一致
            self.email_point2.hidden = NO;
            self.email_markL2.hidden = NO;
            self.three_email_confim.frame = CGRectMake(self.emailView2.left, self.email_markL2.bottom+[Unity countcoordinatesH:50], self.emailView2.width, [Unity countcoordinatesH:40]);
        }
    }else{
        //格式不对第一段提示
        self.email_point1.hidden = NO;
        self.email_markL1.hidden = NO;
        self.email_label.frame = CGRectMake([Unity countcoordinatesW:10], self.email_markL1.bottom+[Unity countcoordinatesH:20], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:20]);
        self.emailView2.frame = CGRectMake(self.email_label.left, self.email_label.bottom+[Unity countcoordinatesH:10], self.email_label.width, [Unity countcoordinatesH:45]);
        self.three_email_confim.frame = CGRectMake(self.emailView2.left, self.emailView2.bottom+[Unity countcoordinatesH:50], self.emailView2.width, [Unity countcoordinatesH:40]);
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
