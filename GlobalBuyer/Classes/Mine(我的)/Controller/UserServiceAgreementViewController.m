//
//  UserServiceAgreementViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/10/9.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "UserServiceAgreementViewController.h"

@interface UserServiceAgreementViewController ()

@end

@implementation UserServiceAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    // Do any additional setup after loading the view.
    [self createUI];
    [self loadTXT];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"GlobalBuyer_RegisterView_Agreement", nil);
    self.navigationItem.titleView = titleLabel;
}

- (void)loadTXT
{

    NSUserDefaults *defaults = [ NSUserDefaults standardUserDefaults ];
    // 取得 iPhone 支持的所有语言设置
    NSArray *languages = [defaults objectForKey : @"AppleLanguages" ];
    NSLog (@"%@", languages);
    // 获得当前iPhone使用的语言
    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
    NSLog(@"当前使用的语言：%@",currentLanguage);
    NSString *filePath;
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
        filePath = [[NSBundle mainBundle]pathForResource:@"简-用户服务协议" ofType:@"txt"];
    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
        filePath = [[NSBundle mainBundle]pathForResource:@"繁-用户服务协议" ofType:@"txt"];
    }else if([currentLanguage isEqualToString:@"en"]){
        filePath = [[NSBundle mainBundle]pathForResource:@"英-用户服务协议" ofType:@"txt"];
    }else{
        filePath = [[NSBundle mainBundle]pathForResource:@"简-用户服务协议" ofType:@"txt"];
    }
    
    NSLog(@"%@",filePath);
    
    //读取txt时用0x80000632解码
    NSError *error;
    NSString *content = [[NSString alloc] initWithContentsOfFile:filePath encoding:0x80000632 error:&error];
    NSLog(@"%@",error);
    NSLog(@"%@",content);
    
    NSArray *line = [content componentsSeparatedByString:@"\n"];
    
    NSString *allStr;
    for (int i = 0; i < line.count; i++) {
        if (i == 0) {
            allStr = [NSString stringWithFormat:@"%@",line[i]];
        }else{
            allStr = [NSString stringWithFormat:@"%@\n%@",allStr,line[i]];
        }
    }
    UILabel *txtLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    txtLb.numberOfLines = 0;
    txtLb.text = allStr;
    
    if([currentLanguage isEqualToString:@"en"]){
        txtLb.font = [UIFont systemFontOfSize:12];
        [txtLb sizeToFit];
    }else{
        [txtLb sizeToFit];
    }
    
    
    UIScrollView *backSv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    backSv.contentSize = CGSizeMake(0, txtLb.frame.size.height);
    [backSv addSubview:txtLb];
    [self.view addSubview:backSv];
    
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
