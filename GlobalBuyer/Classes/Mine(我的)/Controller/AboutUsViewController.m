//
//  AboutUsViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/16.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "AboutUsViewController.h"
#import "PolicyWebViewController.h"
#import "About_usViewController.h"
@interface AboutUsViewController ()
@property (nonatomic , strong) UIImageView * backImage;
@property (nonatomic , strong) UIImageView * logoImage;
@property (nonatomic , strong) UILabel * versionL;
@property (nonatomic , strong) UIButton * aboutBtn;
@property (nonatomic , strong) UIButton * evaluateBtn;
@property (nonatomic , strong) UIButton * privacyProofBtn;
@property (nonatomic , strong) UILabel * copyrightL;
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.backImage];
    [self.view addSubview:self.logoImage];
    [self.view addSubview:self.versionL];
    [self.view addSubview:self.aboutBtn];
    [self.view addSubview:self.evaluateBtn];
    [self.view addSubview:self.privacyProofBtn];
    [self.view addSubview:self.copyrightL];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self addLeftBarButtonWithImage:[UIImage imageNamed:@"back"] action:@selector(backClick)];
    self.title = @"关于我们";
}
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIImageView *)backImage{
    if (!_backImage) {
        _backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-NavBarHeight)];
        _backImage.image = [UIImage imageNamed:@"关于我们背景"];
        _backImage.userInteractionEnabled = YES;
    }
    return _backImage;
}
- (UIImageView *)logoImage{
    if (!_logoImage) {
        _logoImage  = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenW-[Unity countcoordinatesW:80])/2, [Unity countcoordinatesH:100], [Unity countcoordinatesW:80], [Unity countcoordinatesH:80])];
        _logoImage.image = [UIImage imageNamed:@"关于我们LOGO"];
    }
    return _logoImage;
}
- (UILabel *)versionL{
    if (!_versionL) {
        _versionL = [[UILabel alloc]initWithFrame:CGRectMake(0,_logoImage.bottom+[Unity countcoordinatesH:10], kScreenW, [Unity countcoordinatesH:20])];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        _versionL.text = [NSString stringWithFormat:@"版本号: %@",app_Version];
        _versionL.textColor = [Unity getColor:@"#333333"];
        _versionL.textAlignment = NSTextAlignmentCenter;
        _versionL.font = [UIFont systemFontOfSize:14];
    }
    return _versionL;
}
- (UIButton *)aboutBtn{
    if (!_aboutBtn) {
        _aboutBtn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenW-[Unity countcoordinatesW:110])/2, kScreenH-NavBarHeight-[Unity countcoordinatesH:160], [Unity countcoordinatesW:110], [Unity countcoordinatesH:30])];
        [_aboutBtn addTarget:self action:@selector(aboutClick) forControlEvents:UIControlEventTouchUpInside];
        [_aboutBtn setTitle:@"关于我们" forState:UIControlStateNormal];
        _aboutBtn.layer.borderColor = [[Unity getColor:@"#999999"] CGColor];
        _aboutBtn.layer.borderWidth = 1.0f;
        _aboutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_aboutBtn setTitleColor:[Unity getColor:@"#333333"] forState:UIControlStateNormal];
        _aboutBtn.layer.cornerRadius = 10;
    }
    return _aboutBtn;
}
- (UIButton *)evaluateBtn{
    if (!_evaluateBtn) {
        _evaluateBtn = [[UIButton alloc]initWithFrame:CGRectMake(_aboutBtn.left, _aboutBtn.bottom+[Unity countcoordinatesH:10], [Unity countcoordinatesW:110], [Unity countcoordinatesH:30])];
        [_evaluateBtn addTarget:self action:@selector(evaluateClick) forControlEvents:UIControlEventTouchUpInside];
        [_evaluateBtn setTitle:@"评价我们" forState:UIControlStateNormal];
        _evaluateBtn.layer.borderColor = [[Unity getColor:@"#999999"] CGColor];
        _evaluateBtn.layer.borderWidth = 1.0f;
        _evaluateBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_evaluateBtn setTitleColor:[Unity getColor:@"#333333"] forState:UIControlStateNormal];
        _evaluateBtn.layer.cornerRadius = 10;
    }
    return _evaluateBtn;
}
- (UIButton *)privacyProofBtn{
    if (!_privacyProofBtn) {
        _privacyProofBtn = [[UIButton alloc]initWithFrame:CGRectMake(_evaluateBtn.left, _evaluateBtn.bottom+[Unity countcoordinatesH:10], [Unity countcoordinatesW:110], [Unity countcoordinatesH:30])];
        [_privacyProofBtn addTarget:self action:@selector(privacyProofClick) forControlEvents:UIControlEventTouchUpInside];
        [_privacyProofBtn setTitle:@"隐私证明" forState:UIControlStateNormal];
        _privacyProofBtn.layer.borderColor = [[Unity getColor:@"#999999"] CGColor];
        _privacyProofBtn.layer.borderWidth = 1.0f;
        _privacyProofBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_privacyProofBtn setTitleColor:[Unity getColor:@"#333333"] forState:UIControlStateNormal];
        _privacyProofBtn.layer.cornerRadius = 10;
    }
    return _privacyProofBtn;
}
- (UILabel *)copyrightL{
    if (!_copyrightL) {
        _copyrightL = [[UILabel alloc]initWithFrame:CGRectMake(0, _privacyProofBtn.bottom+[Unity countcoordinatesH:20], kScreenW, [Unity countcoordinatesH:20])];
        _copyrightL.text = @"大洋行联盟（香港）有限公司版权所有";
        _copyrightL.textColor = [Unity getColor:@"#333333"];
        _copyrightL.textAlignment = NSTextAlignmentCenter;
        _copyrightL.font = [UIFont systemFontOfSize:12];
    }
    return _copyrightL;
}
- (void)aboutClick{
    About_usViewController * avc = [[About_usViewController alloc]init];
    [self.navigationController pushViewController:avc animated:YES];
}
- (void)evaluateClick{
    [self goToAppStore];
}
- (void)privacyProofClick{
    PolicyWebViewController * pvc = [[PolicyWebViewController alloc]init];
    [self.navigationController pushViewController:pvc animated:YES];
}
-(void)goToAppStore{
    
    NSString *itunesurl = @"itms-apps://itunes.apple.com/cn/app/id1232094474?mt=8&action=write-review";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesurl]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
