//
//  MyFriendViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/1/22.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "MyFriendViewController.h"
#import "MyFriendCell.h"
#import "LoadingView.h"

@interface MyFriendViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)LoadingView *loadingView;
@property (nonatomic,strong)NSMutableArray *dataSorce;

@end

@implementation MyFriendViewController

//加载中动画
-(LoadingView *)loadingView{
    if (_loadingView == nil) {
        _loadingView = [LoadingView LoadingViewSetView:self.view];
    }
    return _loadingView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self downLoad];
}

- (NSMutableArray *)dataSorce
{
    if (_dataSorce == nil) {
        _dataSorce = [NSMutableArray new];
    }
    return _dataSorce;
}

- (void)downLoad
{
    [self.loadingView startLoading];
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *params = @{@"api_id":API_ID,
                             @"api_token":TOKEN,
                             @"secret_key":userToken};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:GetUserFriendApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            for (int i = 0; i < [responseObject[@"invitee"] count]; i++) {
                [self.dataSorce addObject:responseObject[@"invitee"][i]];
            }
            
            [self.loadingView stopLoading];
            [self createUI];
//            [UIView animateWithDuration:2 animations:^{
//                self.loadingView.imgView.animationDuration = 3*0.15;
//                self.loadingView.imgView.animationRepeatCount = 0;
//                [self.loadingView.imgView startAnimating];
//                self.loadingView.imgView.frame = CGRectMake(kScreenW, self.view.bounds.size.height/2 - 50, self.loadingView.imgView.frame.size.width, self.loadingView.imgView.frame.size.height);
//            } completion:^(BOOL finished) {
//                NSLog(@"%d",finished);
//
//            }];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (UITableView *)tableView
{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
    }
    return _tableView;
}

- (void)createUI
{
    self.title = NSLocalizedString(@"GlobalBuyer_My_MyFriend", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSorce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyFriendCell"];
    if (cell == nil) {
        cell = [[MyFriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyFriendCell"];
    }
    
    
    [cell.userImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PictureApi,self.dataSorce[indexPath.row][@"avatar"]]] placeholderImage:[UIImage imageNamed:@"icon"]];
    cell.userName.text = [NSString stringWithFormat:@"%@",self.dataSorce[indexPath.row][@"name"]];
    cell.dateLb.text = [NSString stringWithFormat:@"%@",self.dataSorce[indexPath.row][@"invite_time"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
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
