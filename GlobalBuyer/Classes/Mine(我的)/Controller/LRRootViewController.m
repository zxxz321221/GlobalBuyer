//
//  LRRootViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/24.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

    /**
     登录和注册基类
     
     */

#import "LRRootViewController.h"

@interface LRRootViewController ()

@end

@implementation LRRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

#pragma mark 创建UI界面
- (void)setupUI {
    [self setNavigationBackBtn];
    UIImageView *bgImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    //yulan
    bgImgView.frame = CGRectMake(0, 0, kScreenW, kScreenH );
    [self.view addSubview:bgImgView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.iconImgView];
}

- (UIImageView *)iconImgView {
    if (_iconImgView == nil) {
        _iconImgView = [[UIImageView alloc]init];
        _iconImgView.frame = CGRectMake(kScreenW/2-100, 34, 200, 80);
        _iconImgView.image = [UIImage imageNamed:@"logIcon_register.png"];
    }
    return _iconImgView;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - (kNavigationBarH + kStatusBarH))];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.contentSize =CGSizeMake(0, 600);
    }
    return _scrollView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
