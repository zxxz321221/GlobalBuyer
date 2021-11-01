//
//  NewChangePasswordViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/17.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "NewChangePasswordViewController.h"

@interface NewChangePasswordViewController ()
{
    BOOL isNewPass;//默认NO  输入新密码输入框为空
    BOOL isPass;//默认NO  确认新密码输入框为空
}
@property (nonatomic , strong) UIScrollView * topScrollView;
@property (nonatomic , strong) UIScrollView * mainScrollView;
@property (nonatomic , strong) UIView * oneView;
@property (nonatomic , strong) UIView * twoView;
@property (nonatomic , strong) UIView * threeView;
@property (nonatomic , strong) UILabel * topLine;

@property (nonatomic , strong) UILabel * oneTopL;
@property (nonatomic , strong) UILabel * twoTopL;
@property (nonatomic , strong) UILabel * threeTopL;
@property (nonatomic , strong) UIImageView * arrowImg_one;
@property (nonatomic , strong) UIImageView * arrowImg_two;


@property (nonatomic , strong) UITextField * oneView_textField;
@property (nonatomic , strong) UIButton * oneView_eye;
@property (nonatomic , strong) UIButton * oneView_confim;
@property (nonatomic , strong) UIImageView * point;//错误叹号
@property (nonatomic , strong) UILabel * markL;

//twoview UI
@property (nonatomic , strong) UIView * view1;
@property (nonatomic , strong) UIView * view2;
@property (nonatomic , strong) UILabel * label1;
@property (nonatomic , strong) UITextField * twoView_NewPassText;//新密码
@property (nonatomic , strong) UITextField * twoView_PassText;//确认信密码
@property (nonatomic , strong) UIImageView * point1;//错误叹号
@property (nonatomic , strong) UILabel * markL_one;
@property (nonatomic , strong) UILabel * markL_two;
@property (nonatomic , strong) UIImageView * point2;//新密码下方错误叹号
@property (nonatomic , strong) UIButton * twoView_eye1;
@property (nonatomic , strong) UIButton * twoView_eye2;
@property (nonatomic , strong) UIButton * twoView_confim;
@end

@implementation NewChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isNewPass = NO;
    isPass = NO;
    [self createUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"修改登录密码";
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
        _topScrollView.contentSize =  CGSizeMake([Unity countcoordinatesW:130]*3+[Unity countcoordinatesW:5]*2, 0);
        // 没有弹簧效果
        //        _topScrollView.bounces = NO;
        // 隐藏水平滚动条
        _topScrollView.showsHorizontalScrollIndicator = NO;
        
        [_topScrollView addSubview:self.oneTopL];
        [_topScrollView addSubview:self.arrowImg_one];
        [_topScrollView addSubview:self.twoTopL];
        [_topScrollView addSubview:self.arrowImg_two];
        [_topScrollView addSubview:self.threeTopL];
    }
    return _topScrollView;
}
- (UILabel *)topLine{
    if (!_topLine) {
        _topLine = [[UILabel alloc]initWithFrame:CGRectMake(0, _topScrollView.bottom, kScreenW, [Unity countcoordinatesH:1])];
        _topLine.backgroundColor = [Unity getColor:@"#e0e0e0"];
    }
    return _topLine;
}
- (UILabel *)oneTopL{
    if (!_oneTopL) {
        _oneTopL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [Unity countcoordinatesW:130], [Unity countcoordinatesH:40])];
        _oneTopL.text = @"1.身份验证";
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
        _twoTopL.text = @"2.设置新密码";
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
        _threeTopL.text = @"3.修改成功";
        _threeTopL.font = [UIFont systemFontOfSize:12];
        _threeTopL.textAlignment = NSTextAlignmentCenter;
        _threeTopL.textColor = [Unity getColor:@"#999999"];
    }
    return _threeTopL;
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
        [_mainScrollView addSubview:self.twoView];
        [_mainScrollView addSubview:self.threeView];
    }
    return _mainScrollView;
}
- (UIView *)oneView{
    if (!_oneView) {
        _oneView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, _mainScrollView.height)];
//        _oneView.backgroundColor = [UIColor redColor];
        UILabel * label = [Unity lableViewAddsuperview_superView:_oneView _subViewFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:20], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:20]) _string:@"请输入现在的密码验证您的身份" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], label.bottom+[Unity countcoordinatesH:10], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:45])];
        view.backgroundColor = [Unity getColor:@"#e0e0e0"];
        [_oneView addSubview:view];
        [view addSubview:self.oneView_textField];
        [view addSubview:self.oneView_eye];
        
        _point = [Unity imageviewAddsuperview_superView:_oneView _subViewFrame:CGRectMake([Unity countcoordinatesW:10], view.bottom+[Unity countcoordinatesH:3], [Unity countcoordinatesH:14], [Unity countcoordinatesH:14]) _imageName:@"!" _backgroundColor:nil];
        _point.hidden=YES;
        _markL = [Unity lableViewAddsuperview_superView:_oneView _subViewFrame:CGRectMake(_point.right+[Unity countcoordinatesW:5], view.bottom, kScreenW-[Unity countcoordinatesW:25]-[Unity countcoordinatesH:14], [Unity countcoordinatesH:20]) _string:@"密码不正确" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#d00000"] _textAlignment:NSTextAlignmentLeft];
        _markL.hidden=YES;
        
        
        
        [_oneView addSubview:self.oneView_confim];
        
    }
    return _oneView;
}
- (UIView *)twoView{
    if (!_twoView) {
        _twoView = [[UIView alloc]initWithFrame:CGRectMake(_oneView.right, 0, kScreenW, _mainScrollView.height)];
        
        UILabel * label = [Unity lableViewAddsuperview_superView:_twoView _subViewFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:20], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:20]) _string:@"请输入新的登录密码" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
        _view1 = [[UIView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], label.bottom+[Unity countcoordinatesH:10], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:45])];
        _view1.backgroundColor = [Unity getColor:@"#e0e0e0"];
        [_twoView addSubview:_view1];
        [_view1 addSubview:self.twoView_NewPassText];
        [_view1 addSubview:self.twoView_eye1];
        _point1 = [Unity imageviewAddsuperview_superView:_twoView _subViewFrame:CGRectMake([Unity countcoordinatesW:10], _view1.bottom+[Unity countcoordinatesH:3], [Unity countcoordinatesH:14], [Unity countcoordinatesH:14]) _imageName:@"!" _backgroundColor:nil];
        _point1.hidden=YES;
        _markL_one = [Unity lableViewAddsuperview_superView:_twoView _subViewFrame:CGRectMake(_point1.right+[Unity countcoordinatesW:5], _view1.bottom, kScreenW-[Unity countcoordinatesW:25]-[Unity countcoordinatesH:14], [Unity countcoordinatesH:20]) _string:@"密码格式不正确" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#d00000"] _textAlignment:NSTextAlignmentLeft];
        _markL_one.hidden=YES;
        
        _label1 = [Unity lableViewAddsuperview_superView:_twoView _subViewFrame:CGRectMake([Unity countcoordinatesW:10], _view1.bottom+[Unity countcoordinatesH:20], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:20]) _string:@"请再次输入您的新密码" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
        _view2 = [[UIView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], _label1.bottom+[Unity countcoordinatesH:10], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:45])];
        _view2.backgroundColor = [Unity getColor:@"#e0e0e0"];
        [_twoView addSubview:_view2];
        [_view2 addSubview:self.twoView_PassText];
        [_view2 addSubview:self.twoView_eye2];
        _point2 = [Unity imageviewAddsuperview_superView:_twoView _subViewFrame:CGRectMake([Unity countcoordinatesW:10], _view2.bottom+[Unity countcoordinatesH:3], [Unity countcoordinatesH:14], [Unity countcoordinatesH:14]) _imageName:@"!" _backgroundColor:nil];
        _point2.hidden=YES;
        _markL_two = [Unity lableViewAddsuperview_superView:_twoView _subViewFrame:CGRectMake(_point2.right+[Unity countcoordinatesW:5], _view2.bottom, kScreenW-[Unity countcoordinatesW:25]-[Unity countcoordinatesH:14], [Unity countcoordinatesH:20]) _string:@"密码输入不一致哦!" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#d00000"] _textAlignment:NSTextAlignmentLeft];
        _markL_two.hidden=YES;
        
        [_twoView addSubview:self.twoView_confim];
        
        
    }
    return _twoView;
}
- (UIView *)threeView{
    if (!_threeView) {
        _threeView = [[UIView alloc]initWithFrame:CGRectMake(_twoView.right, 0, kScreenW, _mainScrollView.height)];
        UIImageView * imageView = [Unity imageviewAddsuperview_superView:_threeView _subViewFrame:CGRectMake((kScreenW-[Unity countcoordinatesW:80])/2, [Unity countcoordinatesH:80], [Unity countcoordinatesW:80], [Unity countcoordinatesW:80]) _imageName:@"登录密码修改成功" _backgroundColor:nil];
        UILabel * label = [Unity lableViewAddsuperview_superView:_threeView _subViewFrame:CGRectMake([Unity countcoordinatesW:10], imageView.bottom+[Unity countcoordinatesH:40], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:40]) _string:@"恭喜您，您的登录密码修改成功!" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentCenter];
        label.backgroundColor = [UIColor clearColor];
    }
    return _threeView;
}
- (UIButton *)oneView_confim{
    if (!_oneView_confim) {
        _oneView_confim = [[UIButton alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:145], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:40])];
        [_oneView_confim addTarget:self action:@selector(oneView_confimClick) forControlEvents:UIControlEventTouchUpInside];
        [_oneView_confim setTitle:@"确定" forState:UIControlStateNormal];
        [_oneView_confim setTitleColor:[Unity getColor:@"#c478d4"] forState:UIControlStateNormal];
        _oneView_confim.backgroundColor = [Unity getColor:@"#b445c8"];
        _oneView_confim.layer.cornerRadius = [Unity countcoordinatesH:20];
        _oneView_confim.layer.masksToBounds = YES;
        _oneView_confim.userInteractionEnabled=NO;
    }
    return _oneView_confim;
}
- (UITextField *)oneView_textField{
    if (!_oneView_textField) {
        _oneView_textField = [[UITextField alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:10], [Unity countcoordinatesW:250], [Unity countcoordinatesH:25])];
        _oneView_textField.secureTextEntry = YES;
        _oneView_textField.placeholder = @"输入密码";
        _oneView_textField.font = [UIFont systemFontOfSize:14];
        [_oneView_textField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    }
    return _oneView_textField;
}
- (UIButton *)oneView_eye{
    if (!_oneView_eye) {
        _oneView_eye = [[UIButton alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:300]-[Unity countcoordinatesW:25], [Unity countcoordinatesH:16], [Unity countcoordinatesW:15], [Unity countcoordinatesH:13])];
        [_oneView_eye addTarget:self action:@selector(oneView_eyeClick:) forControlEvents:UIControlEventTouchUpInside];
        [_oneView_eye setBackgroundImage:[UIImage imageNamed:@"隐藏"] forState:UIControlStateNormal];
        [_oneView_eye setBackgroundImage:[UIImage imageNamed:@"显示"] forState:UIControlStateSelected];

    }
    return _oneView_eye;
}
- (UIButton *)twoView_confim{
    if (!_twoView_confim) {
        _twoView_confim = [[UIButton alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], _view2.bottom+[Unity countcoordinatesH:50], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:40])];
        [_twoView_confim addTarget:self action:@selector(twoView_confimClick) forControlEvents:UIControlEventTouchUpInside];
        [_twoView_confim setTitle:@"确定" forState:UIControlStateNormal];
        [_twoView_confim setTitleColor:[Unity getColor:@"#c478d4"] forState:UIControlStateNormal];
        _twoView_confim.backgroundColor = [Unity getColor:@"#b445c8"];
        _twoView_confim.layer.cornerRadius = [Unity countcoordinatesH:20];
        _twoView_confim.layer.masksToBounds = YES;
        _twoView_confim.userInteractionEnabled = NO;
    }
    return _twoView_confim;
}
- (UITextField *)twoView_NewPassText{
    if (!_twoView_NewPassText) {
        _twoView_NewPassText = [[UITextField alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:10], [Unity countcoordinatesW:250], [Unity countcoordinatesH:25])];
        _twoView_NewPassText.secureTextEntry = YES;
        _twoView_NewPassText.tag = 1000;
        _twoView_NewPassText.placeholder = @"8-20位数字/字母/字符组合";
        _twoView_NewPassText.font = [UIFont systemFontOfSize:14];
        [_twoView_NewPassText addTarget:self action:@selector(changedPassTextField:) forControlEvents:UIControlEventEditingChanged];
    }
    return _twoView_NewPassText;
}
- (UITextField *)twoView_PassText{
    if (!_twoView_PassText) {
        _twoView_PassText = [[UITextField alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:10], [Unity countcoordinatesW:250], [Unity countcoordinatesH:25])];
        _twoView_PassText.secureTextEntry = YES;
        _twoView_PassText.tag = 1001;
        _twoView_PassText.placeholder = @"确认密码";
        _twoView_PassText.font = [UIFont systemFontOfSize:14];
        [_twoView_PassText addTarget:self action:@selector(changedPassTextField:) forControlEvents:UIControlEventEditingChanged];
    }
    return _twoView_PassText;
}
- (UIButton *)twoView_eye1{
    if (!_twoView_eye1) {
        _twoView_eye1 = [[UIButton alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:300]-[Unity countcoordinatesW:25], [Unity countcoordinatesH:16], [Unity countcoordinatesW:15], [Unity countcoordinatesH:13])];
        [_twoView_eye1 addTarget:self action:@selector(twoView_eye1Click) forControlEvents:UIControlEventTouchUpInside];
        [_twoView_eye1 setBackgroundImage:[UIImage imageNamed:@"隐藏"] forState:UIControlStateNormal];
        [_twoView_eye1 setBackgroundImage:[UIImage imageNamed:@"显示"] forState:UIControlStateSelected];
        
    }
    return _twoView_eye1;
}
- (UIButton *)twoView_eye2{
    if (!_twoView_eye2) {
        _twoView_eye2 = [[UIButton alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:300]-[Unity countcoordinatesW:25], [Unity countcoordinatesH:16], [Unity countcoordinatesW:15], [Unity countcoordinatesH:13])];
        [_twoView_eye2 addTarget:self action:@selector(twoView_eye2Click) forControlEvents:UIControlEventTouchUpInside];
        [_twoView_eye2 setBackgroundImage:[UIImage imageNamed:@"隐藏"] forState:UIControlStateNormal];
        [_twoView_eye2 setBackgroundImage:[UIImage imageNamed:@"显示"] forState:UIControlStateSelected];
        
    }
    return _twoView_eye2;
}



















#pragma mark - 第一页事件处理
- (void)oneView_eyeClick:(UIButton *)btn{
    if (self.oneView_eye.selected) {
        self.oneView_eye.selected = NO;
        self.oneView_textField.secureTextEntry = YES;
    }else{
        self.oneView_eye.selected = YES;
        self.oneView_textField.secureTextEntry = NO;
    }
}

-(void)changedTextField:(UITextField *)textField
{
    if (textField.text.length == 0) {
        [self.oneView_confim setTitleColor:[Unity getColor:@"#c478d4"] forState:UIControlStateNormal];
        self.oneView_confim.userInteractionEnabled=NO;
        if (self.markL.hidden==NO) {
            self.point.hidden=YES;
            self.markL.hidden=YES;
            self.oneView_confim.frame = CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:145], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:40]);
        }
    }else{
        [self.oneView_confim setTitleColor:[Unity getColor:@"#ffffff"] forState:UIControlStateNormal];
        self.oneView_confim.userInteractionEnabled=YES;
    }
}
- (void)oneView_confimClick{
//    self.point.hidden=NO;
//    self.markL.hidden=NO;
//    self.oneView_confim.frame = CGRectMake([Unity countcoordinatesW:10], self.markL.bottom+[Unity countcoordinatesH:50], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:40]);
    if (self.oneView_textField.text.length != 0) {
        [self.mainScrollView setContentOffset:CGPointMake(kScreenW, 0) animated:YES];
        self.mainScrollView.bouncesZoom = NO;
        self.twoTopL.textColor = [Unity getColor:@"#b445c8"];
        self.arrowImg_one.image = [UIImage imageNamed:@"password_go"];
    }
}
#pragma mark - 第二页事件处理
- (void)twoView_confimClick{
//    [self refreshLayout:0];
    [self.mainScrollView setContentOffset:CGPointMake(kScreenW*2, 0) animated:YES];
    self.mainScrollView.bouncesZoom = NO;
    self.threeTopL.textColor = [Unity getColor:@"#b445c8"];
    self.arrowImg_two.image = [UIImage imageNamed:@"password_go"];
    [self.topScrollView setContentOffset:CGPointMake([Unity countcoordinatesW:400]-kScreenW, 0) animated:YES];
    self.topScrollView.bouncesZoom = NO;
    
}
- (void)changedPassTextField:(UITextField *)textField{
    if (textField.tag == 1000) {
        if (textField.text.length == 0) {
            if (self.point1.hidden == NO) {
                self.point1.hidden =YES;
                self.markL_one.hidden=YES;
                self.label1.frame = CGRectMake([Unity countcoordinatesW:10], self.view1.bottom+[Unity countcoordinatesH:20], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:20]);
                self.view2.frame = CGRectMake(self.label1.left, self.label1.bottom+[Unity countcoordinatesH:10], self.label1.width, [Unity countcoordinatesH:45]);
                self.twoView_confim.frame = CGRectMake(self.view2.left, self.view2.bottom+[Unity countcoordinatesH:50], self.view2.width, [Unity countcoordinatesH:40]);
            }
            isNewPass = NO;
        }else{
            isNewPass = YES;
        }
    }else{
        if (textField.text.length == 0) {
            if (self.point2.hidden == NO) {
                self.point2.hidden =YES;
                self.markL_two.hidden=YES;
                self.twoView_confim.frame = CGRectMake(self.view2.left, self.view2.bottom+[Unity countcoordinatesH:50], self.view2.width, [Unity countcoordinatesH:40]);
            }
            isPass = NO;
        }else{
            isPass = YES;
        }
    }
    if (isNewPass && isPass) {
        [self.twoView_confim setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.twoView_confim.userInteractionEnabled = YES;
    }else{
        [self.twoView_confim setTitleColor:[Unity getColor:@"#c478d4"] forState:UIControlStateNormal];
        self.twoView_confim.userInteractionEnabled = NO;
    }
}
- (void)twoView_eye1Click{
    if (self.twoView_eye1.selected) {
        self.twoView_eye1.selected = NO;
        self.twoView_NewPassText.secureTextEntry = YES;
    }else{
        self.twoView_eye1.selected = YES;
        self.twoView_NewPassText.secureTextEntry = NO;
    }
}
- (void)twoView_eye2Click{
    if (self.twoView_eye2.selected) {
        self.twoView_eye2.selected = NO;
        self.twoView_PassText.secureTextEntry = YES;
    }else{
        self.twoView_eye2.selected = YES;
        self.twoView_PassText.secureTextEntry = NO;
    }
}
//密码格式不正确或不一致   刷新ui布局
- (void)refreshLayout:(NSInteger )index{
    if (index == 0) {//新密码格式不正确
        self.point1.hidden=NO;
        self.markL_one.hidden=NO;
        self.label1.frame = CGRectMake([Unity countcoordinatesW:10], self.markL_one.bottom+[Unity countcoordinatesH:20], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:20]);
        self.view2.frame = CGRectMake(self.label1.left, self.label1.bottom+[Unity countcoordinatesH:10], self.label1.width, [Unity countcoordinatesH:45]);
        self.twoView_confim.frame = CGRectMake(self.view2.left, self.view2.bottom+[Unity countcoordinatesH:50], self.view2.width, [Unity countcoordinatesH:40]);
    }else{//密码输入不一致
        self.point2.hidden=NO;
        self.markL_two.hidden=NO;
        self.twoView_confim.frame = CGRectMake(self.view2.left, self.markL_two.bottom+[Unity countcoordinatesH:50], self.view2.width, [Unity countcoordinatesH:40]);
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
