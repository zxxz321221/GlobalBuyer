//
//  NewMessageViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/24.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "NewMessageViewController.h"
#import "NBLScrollTabController.h"
#import "MessagePageOneViewController.h"
#import "MessagePageTwoViewController.h"
#import "MessagePageThreeViewController.h"
#import "MessagePageFourViewController.h"
@interface NewMessageViewController ()<NBLScrollTabControllerDelegate>

@property (nonatomic, strong) NBLScrollTabController *scrollTabController;
@property (nonatomic, strong) NSArray *viewControllers;

@property (nonatomic , strong) NBLScrollTabItem * pageItem0;
@property (nonatomic , strong) NBLScrollTabItem * pageItem1;
@property (nonatomic , strong) NBLScrollTabItem * pageItem2;
@property (nonatomic , strong) NBLScrollTabItem * pageItem3;

@end

@implementation NewMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Unity getColor:@"#f0f0f0"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.scrollTabController.view];
}
- (NBLScrollTabController *)scrollTabController
{
    if (!_scrollTabController) {
        _scrollTabController = [[NBLScrollTabController alloc] init];
        _scrollTabController.view.frame = self.view.bounds;
        _scrollTabController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollTabController.delegate = self;
        _scrollTabController.viewControllers = self.viewControllers;
    }
    
    return _scrollTabController;
}
- (NSArray *)viewControllers
{
    if (!_viewControllers) {
        MessagePageOneViewController *page0 = [[MessagePageOneViewController alloc] init];
        _pageItem0 = [[NBLScrollTabItem alloc] init];
        _pageItem0.title = @"活动消息";
        _pageItem0.hideBadge = NO;//每个title可以做个性化配置
        _pageItem0.textColor = [Unity getColor:@"#999999"]; //每个title可以做个性化配置
        _pageItem0.highlightColor = [Unity getColor:@"#b445c8"];//每个title可以做个性化配置
        page0.tabItem = _pageItem0;
        
        MessagePageTwoViewController *page1 = [[MessagePageTwoViewController alloc] init];
        _pageItem1 = [[NBLScrollTabItem alloc] init];
        _pageItem1.title = @"订单进度";
        _pageItem1.hideBadge = NO;
        _pageItem1.textColor = [Unity getColor:@"#999999"]; //每个title可以做个性化配置
        _pageItem1.highlightColor = [Unity getColor:@"#b445c8"];//每个title可以做个性化配置
        page1.tabItem = _pageItem1;
        
        MessagePageThreeViewController *page2 = [[MessagePageThreeViewController alloc] init];
        _pageItem2 = [[NBLScrollTabItem alloc] init];
        _pageItem2.title = @"系统通知";
        _pageItem2.hideBadge = YES;
        _pageItem2.textColor = [Unity getColor:@"#999999"]; //每个title可以做个性化配置
        _pageItem2.highlightColor = [Unity getColor:@"#b445c8"];//每个title可以做个性化配置
        page2.tabItem = _pageItem2;
        
        MessagePageFourViewController *page3 = [[MessagePageFourViewController alloc] init];
        _pageItem3 = [[NBLScrollTabItem alloc] init];
        _pageItem3.title = @"其他消息";
        _pageItem3.hideBadge = YES;
        //        demo3Item.font = [UIFont systemFontOfSize:10];//每个title可以做个性化配置
        page3.tabItem = _pageItem3;
        _pageItem3.textColor = [Unity getColor:@"#999999"]; //每个title可以做个性化配置
        _pageItem3.highlightColor = [Unity getColor:@"#b445c8"];//每个title可以做个性化配置
        _viewControllers = @[page0, page1, page2, page3];
        
    }
    
    return _viewControllers;
}

#pragma mark - NBLScrollTabControllerDelegate

- (void)tabController:(NBLScrollTabController * __nonnull)tabController
didSelectViewController:( UIViewController * __nonnull)viewController
{
    //业务逻辑处理
//    if ([viewController isKindOfClass:[DemoViewController0 class]]) {
//        NSLog(@"%@，%@",tabController,viewController);
//    }
    
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
