//
//  AdderssDetailViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/26.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "AdderssDetailViewController.h"

@interface AdderssDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextView *address;
@end

@implementation AdderssDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark 创建UI
- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self setNavigationBackBtn];
    self.navigationItem.title = NSLocalizedString(@"GlobalBuyer_Address_Adddetails", nil);
    [self.address becomeFirstResponder];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Address_Save", nil) style: UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
}

#pragma mark 保存事件
-(void) saveClick {
    [self.delegate sendAdderssDetail:self.address.text];
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
