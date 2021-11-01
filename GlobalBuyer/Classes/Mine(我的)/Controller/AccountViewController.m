//
//  AccountViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/4/4.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "AccountViewController.h"
#import "NewChangePasswordViewController.h"
#import "Modify_Binding_ToolsViewController.h"
@interface AccountViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) UILabel * mobileL;
@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creareUI];
}
- (void)creareUI{
    NSArray * arr = @[@"修改登录密码",@"修改绑定工具",@"修改支付密码",@"忘记支付密码"];
    for (int i=0; i<arr.count; i++) {
        UIButton * btn = [Unity buttonAddsuperview_superView:self.view _subViewFrame:CGRectMake(0, i*[Unity countcoordinatesH:50], kScreenW, [Unity countcoordinatesH:50]) _tag:self _action:@selector(btnClick:) _string:@"" _imageName:@""];
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = i+1000;
        UILabel * titlel = [Unity lableViewAddsuperview_superView:btn _subViewFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:15], [Unity widthOfString:arr[i] OfFontSize:15 OfHeight:[Unity countcoordinatesH:20]], [Unity countcoordinatesH:20]) _string:arr[i] _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
        UILabel * line = [Unity lableViewAddsuperview_superView:btn _subViewFrame:CGRectMake(titlel.left, [Unity countcoordinatesH:49], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:1]) _string:@"" _lableFont:nil _lableTxtColor:nil _textAlignment:NSTextAlignmentLeft];
        UIImageView * goImg = [Unity imageviewAddsuperview_superView:btn _subViewFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:18], [Unity countcoordinatesH:19], [Unity countcoordinatesW:8], [Unity countcoordinatesH:12]) _imageName:@"灰箭头" _backgroundColor:nil];
        line.backgroundColor = [Unity getColor:@"#f5f5f5"];
        if (i==1) {
            UILabel * tt = [Unity lableViewAddsuperview_superView:btn _subViewFrame:CGRectMake(titlel.right, titlel.top, [Unity widthOfString:@"(邮箱/手机)" OfFontSize:15 OfHeight:[Unity countcoordinatesH:20]], titlel.height) _string:@"(邮箱/手机)" _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentLeft];
            _mobileL = [Unity lableViewAddsuperview_superView:btn _subViewFrame:CGRectMake(tt.right, tt.top,kScreenW-titlel.width-tt.width-goImg.width-[Unity countcoordinatesW:25], tt.height) _string:@"17710268080" _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentRight];
        }
        
    }
}
- (void)btnClick:(UIButton *)btn{
    if (btn.tag == 1000) {
        NewChangePasswordViewController * nvc = [[NewChangePasswordViewController alloc]init];
        [self.navigationController pushViewController:nvc animated:YES];
    }else if (btn.tag == 1001){
        Modify_Binding_ToolsViewController * MBTVC = [[Modify_Binding_ToolsViewController alloc]init];
        [self.navigationController pushViewController:MBTVC animated:YES];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"账号安全";
    self.view.backgroundColor = [Unity getColor:@"#f5f5f5"];
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
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
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
