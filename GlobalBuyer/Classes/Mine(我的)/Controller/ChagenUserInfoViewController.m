//
//  ChagenUserInfoViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/28.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "ChagenUserInfoViewController.h"

@interface ChagenUserInfoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ChagenUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBackBtn];
    switch (self.indexs) {
        case 0:
            self.textField.placeholder = NSLocalizedString(@"GlobalBuyer_UserInfo_changenickname", nil);
            self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_UserInfo_changenickname", nil);
            break;
        case 2:
            self.textField.placeholder = NSLocalizedString(@"GlobalBuyer_UserInfo_changephone", nil);
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_UserInfo_changephone", nil);
            break;
            
        case 4:
            self.textField.placeholder = @"Email";
            self.navigationItem.title = @"Email";
        default:
            break;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style: UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
    // Do any additional setup after loading the view from its nib.
}

-(void)saveClick{
    [self.delegate changeInfo:self.textField.text AtIndex:self.indexs];
    [self.navigationController popViewControllerAnimated:YES];
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
