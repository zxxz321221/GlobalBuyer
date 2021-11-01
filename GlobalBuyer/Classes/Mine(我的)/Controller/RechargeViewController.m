//
//  RechargeViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/4/9.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "RechargeViewController.h"
#import "Keyboard.h"
#import "PurseRechargeViewController.h"
@interface RechargeViewController ()<keyboardDelegate,UITextFieldDelegate>
@property (nonatomic , strong) UIView * backV;
@property (nonatomic , strong) UILabel * symbol;
@property (nonatomic , strong) UITextField * textField;
@property (nonatomic , strong) UIButton * rechargeBtn;

@property (nonatomic , strong) Keyboard * keyboard;

@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.keyboard.delegate = self;
    [self createUI];
    [self.view addSubview:self.rechargeBtn];
}
- (void)createUI{
    _backV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, [Unity countcoordinatesH:150])];
    _backV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backV];
    [self.view bringSubviewToFront:_backV];
    
    UILabel * cashTitle = [Unity lableViewAddsuperview_superView:_backV _subViewFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:15], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:25]) _string:NSLocalizedString(@"GlobalBuyer_CashView_Withdrawal_amount", nil) _lableFont:[UIFont systemFontOfSize:17] _lableTxtColor:[UIColor grayColor] _textAlignment:NSTextAlignmentLeft];
    
    CGFloat W = [Unity widthOfString:[Unity currencySymbol:self.currencyOfTheBalance] OfFontSize:30 OfHeight:[Unity countcoordinatesH:70]];
    _symbol = [Unity lableViewAddsuperview_superView:_backV _subViewFrame:CGRectMake(cashTitle.left, cashTitle.bottom, W, [Unity countcoordinatesH:70]) _string:[Unity currencySymbol:self.currencyOfTheBalance] _lableFont:[UIFont systemFontOfSize:30] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentCenter];
    
    _textField = [Unity textFieldAddSuperview_superView:_backV _subViewFrame:CGRectMake(_symbol.right, _symbol.top, kScreenW-W-[Unity countcoordinatesW:20], _symbol.height) _placeT:@"" _backgroundImage:nil _delegate:self andSecure:NO andBackGroundColor:nil];
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.font = [UIFont systemFontOfSize:30];
    
    UILabel * line = [Unity lableViewAddsuperview_superView:_backV _subViewFrame:CGRectMake(_symbol.left, _symbol.bottom, cashTitle.width, [Unity countcoordinatesH:1]) _string:@"" _lableFont:nil _lableTxtColor:nil _textAlignment:NSTextAlignmentCenter];
    line.backgroundColor = [UIColor py_colorWithHexString:@"#f0f0f0"];
}
- (UIButton *)rechargeBtn{
    if (_rechargeBtn == nil) {
        _rechargeBtn = [Unity buttonAddsuperview_superView:self.view _subViewFrame:CGRectMake([Unity countcoordinatesW:10], _backV.bottom+[Unity countcoordinatesH:30], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:40]) _tag:self _action:@selector(rechargeClick) _string:NSLocalizedString(@"GlobalBuyer_My_Wallet_Recharge", nil) _imageName:nil];
        _rechargeBtn.layer.cornerRadius = 25;
        [_rechargeBtn setTitleColor:[UIColor py_colorWithHexString:@"#b444c8"] forState:UIControlStateNormal];
        [_rechargeBtn.layer setBorderColor:[UIColor py_colorWithHexString:@"#b444c8"].CGColor];
        [_rechargeBtn.layer setBorderWidth:1.0];
    }
    return _rechargeBtn;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.keyboard showKeyboard];
    return NO;
}
- (void)rechargeClick{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"field":@"sign",@"name":@"折扣",@"locale":@"zh_TW",@"all_flag":@"1"};
    NSLog(@"分类接口 %@",params);
    [manager  POST: CategoryApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"response %@",responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
//    [self.keyboard hiddenKeyboard];
//    PurseRechargeViewController * pvc = [[PurseRechargeViewController alloc]init];
//    pvc.amount = self.textField.text;
//    [self.navigationController pushViewController:pvc animated:YES];
    
}
- (void)keyboardKeys:(NSString *)keys{
    if ([keys isEqualToString:@"X"]) {
        self.textField.text = @"";
    }else if ([keys isEqualToString:@"."]){
        NSArray *array = [self.textField.text componentsSeparatedByString:@"."];
        if (array.count>=2) {
            return;
        }else{
            self.textField.text = [self.textField.text stringByAppendingString:keys];
        }
    }else if ([keys isEqualToString:@"-"]){
        if (self.textField.text.length>0) {
            self.textField.text =[self.textField.text substringToIndex:self.textField.text.length-1];
        }
    }else if ([keys isEqualToString:@"enter"]){
        [self.keyboard hiddenKeyboard];
    }else{
        self.textField.text = [self.textField.text stringByAppendingString:keys];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [Unity getColor:@"#f5f5f5"];
    self.title = NSLocalizedString(@"GlobalBuyer_My_Wallet_Recharge", nil);
    self.navigationController.navigationBar.topItem.title = @"";
}
- (Keyboard *)keyboard{
    if (_keyboard == nil) {
        _keyboard = [Keyboard setKeyboard:self.view];
    }
    return _keyboard;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.keyboard hiddenKeyboard];
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
