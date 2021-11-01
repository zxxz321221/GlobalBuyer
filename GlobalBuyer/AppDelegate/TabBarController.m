//
//  TabBarController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/24.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor colorWithRed:150.0/255.0 green:85.0/255.0 blue:185.0/255.0 alpha:1]}forState:UIControlStateSelected];
    self.tabBar.barStyle = UIBarStyleDefault;
    self.tabBar.tintColor = [UIColor colorWithRed:150.0/255.0 green:85.0/255.0 blue:185.0/255.0 alpha:1];
    
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
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
