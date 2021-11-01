//
//  PersonalCenterViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/4/2.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "InfomationViewController.h"
#import "AccountViewController.h"
#import "SizeViewController.h"
@interface PersonalCenterViewController ()
@property (nonatomic , strong)NSArray * listArr;
@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Unity getColor:@"#f5f5f5"];
    
    [self setupUI];
    
}
- (void)setupUI{
    _listArr = @[
                 @{@"name":@"个人信息", @"icon":@"个人信息"},
                 @{@"name":@"我的二维码", @"icon":@"我的二维码"},
                 @{@"name":@"我的尺码", @"icon":@"我的尺码"},
                 @{@"name":@"账号安全", @"icon":@""},
                 @{@"name":@"会员俱乐部", @"icon":@""},
                 @{@"name":@"积分中心", @"icon":@""}];
    for (int i=0; i<_listArr.count; i++) {
        UIButton * btn = [Unity buttonAddsuperview_superView:self.view _subViewFrame:CGRectMake(0, i*[Unity countcoordinatesH:50], kScreenW, [Unity countcoordinatesH:50]) _tag:self _action:@selector(btnClick:) _string:@"" _imageName:@""];
        btn.backgroundColor = [UIColor whiteColor];
        UILabel * nameL = [Unity lableViewAddsuperview_superView:btn _subViewFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:10], 100, [Unity countcoordinatesH:30]) _string:_listArr[i][@"name"] _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
        if (i<3) {
            UIImageView * imageView = [Unity imageviewAddsuperview_superView:btn _subViewFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:50], nameL.top+[Unity countcoordinatesH:5], [Unity countcoordinatesW:20], [Unity countcoordinatesH:20]) _imageName:_listArr[i][@"icon"] _backgroundColor:nil];
        }
        if (i==4) {
            UILabel * topL = [Unity lableViewAddsuperview_superView:btn _subViewFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:130], [Unity countcoordinatesH:10], [Unity countcoordinatesW:100], [Unity countcoordinatesH:30]) _string:@"普通用户" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentRight];
        }
        UIImageView * img = [Unity imageviewAddsuperview_superView:btn _subViewFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:15], [Unity countcoordinatesH:20], [Unity countcoordinatesW:5], [Unity countcoordinatesH:10]) _imageName:@"灰箭头" _backgroundColor:nil];
        UILabel * line = [Unity lableViewAddsuperview_superView:btn _subViewFrame:CGRectMake(nameL.left, [Unity countcoordinatesH:49], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:1]) _string:@"" _lableFont:nil _lableTxtColor:nil _textAlignment:NSTextAlignmentRight];
        line.backgroundColor = [Unity getColor:@"#f5f5f5"];
        
        btn.tag = i+2000;
        
        [self.view addSubview:btn];
    }
}
- (void)btnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 2000://个人信息
        {
            InfomationViewController * ivc = [[InfomationViewController alloc]init];
            ivc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ivc animated:YES];
        }
            break;
        case 2001://我的二维码
            
            break;
        case 2002://我的尺码
        {
            SizeViewController * svc = [[SizeViewController alloc]init];
            svc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:svc animated:YES];
        }
            break;
        case 2003://账号安全
        {
            AccountViewController * avc = [[AccountViewController alloc]init];
            avc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:avc animated:YES];
        }
            break;
        case 2004://会员俱乐部
            
            break;
        case 2005://积分中心
            
            break;
            
        default:
            break;
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"个人中心";
    self.navigationController.navigationBar.translucent = NO;
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
