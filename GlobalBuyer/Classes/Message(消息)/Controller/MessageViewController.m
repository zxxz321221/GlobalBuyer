//
//  MessageViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/3/13.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "MessageViewController.h"
#import "TabScrollview.h"
#import "TabContentView.h"
#import "MsgPageViewController.h"
@interface MessageViewController ()
{
    NSInteger oldIndex;
}
@property (nonatomic,strong)TabScrollview *tabScrollView;
@property (nonatomic,strong)TabContentView *tabContent;

@property (nonatomic,strong)NSMutableArray *tabs;

@property (nonatomic,strong)NSMutableArray *contents;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    oldIndex = 0;
    
    //通知中心是个单例
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self selector:@selector(receiveNotification:) name:@"cesuo" object:nil];
    
    
    self.title=@"消息中心";
    self.edgesForExtendedLayout = UIRectEdgeAll; //系统默认值,系统布局需要从状态栏开始
    self.navigationController.navigationBar.translucent = NO;  //ios6之前默认为no,ios6之后默认为ysa,NO的时候,,布局就会自动从状态栏下方开始,我们布局直接从状态栏开始,无下移ß下64
    
    //创建模拟数据
    
    _tabs=[[NSMutableArray alloc]initWithCapacity:20];
    _contents=[[NSMutableArray alloc]initWithCapacity:20];
    
    NSArray * arr = @[@"活动消息",@"订单进度",@"系统通知",@"其他消息"];
    for(int i=0;i<arr.count;i++){
        NSString *titleStr=arr[i];
        
        UILabel *tab=[[UILabel alloc]init];
        tab.textAlignment=NSTextAlignmentCenter;
        tab.font = [UIFont systemFontOfSize:17];
        tab.text=titleStr;
        if (i==0) {
            tab.textColor=Main_Color;
        }else{
            tab.textColor=[UIColor grayColor];
        }
    
        [_tabs addObject:tab];
        
        
        MsgPageViewController *con=[MsgPageViewController new];
        con.view.backgroundColor=[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
        con.tag=i;
        [_contents addObject:con];
        
    }
    
    _tabScrollView=[[TabScrollview alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tabScrollView];
    [_tabScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    
    [_tabScrollView configParameter:horizontal viewArr:_tabs tabWidth:kScreenW/4 tabHeight:50 index:0 block:^(NSInteger index) {
        
        [_tabContent updateTab:index];
    }];
    
    
    _tabContent=[[TabContentView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tabContent];
    
    [_tabContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(_tabScrollView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    
    [_tabContent configParam:_contents Index:0 block:^(NSInteger index) {
        UILabel *find_label = (UILabel *)_tabs[oldIndex];
        find_label.textColor = [UIColor grayColor];
        UILabel *find_label1 = (UILabel *)_tabs[index];
        find_label1.textColor = Main_Color;
        oldIndex = index;
        [_tabScrollView updateTagLine:index];
    }];
}
- (void)receiveNotification:(NSNotification *)noti
{
    UILabel *find_label = (UILabel *)_tabs[oldIndex];
    find_label.textColor = [UIColor grayColor];
    int index = [noti.object intValue];
    UILabel *find_label1 = (UILabel *)_tabs[index];
    find_label1.textColor = Main_Color;
    oldIndex = index;
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
