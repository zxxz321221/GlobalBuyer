//
//  ShoppingCartDetailViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/12.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "ShoppingCartDetailViewController.h"
#import "ShoppingCartCell.h"
#import "ShopDetailViewController.h"
#import "ChoosePayViewController.h"
#import "CurrencyCalculation.h"
#import "CommissionViewController.h"
#import "CommissionDefaultViewController.h"
#import "FixedPriceShowViewController.h"
#import "DirectMailAddressViewController.h"
#import "AddressViewController.h"
#import "BindIDViewController.h"
#import "SelectCouponViewController.h"
#import "ShopCartSettlementDetailsViewController.h"
#import "CollectionViewController.h"
#import "ObjectAndString.h"


@interface ShoppingCartDetailViewController ()<UITableViewDelegate,UITableViewDataSource, ShoppingCartCellDelegate,UIAlertViewDelegate,DirectMailAddressViewControllerDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *btoomView;
@property (nonatomic, strong)UIButton *settleAccountsBtn;
@property (nonatomic, strong)UIButton *selectAllBtn;
@property (nonatomic, strong)UILabel *btoLa;
@property (nonatomic, strong)UILabel *countLa;
@property (nonatomic, strong)NSString *currency;
@property (nonatomic, assign)float count;
@property (nonatomic, assign)float oCount;
@property (nonatomic, assign)float ooCount;
@property (nonatomic, strong)NSArray *payArr;
@property (nonatomic, strong)ShopCartHeaderView *shopCartHeaderView;

@property (nonatomic, strong)UIView *selectCollectOrDirectMailBackV;
@property (nonatomic, strong)UIView *selectCollectOrDirectMailV;
@property (nonatomic, strong)UIButton *directMailBtn;
@property (nonatomic, strong)UIButton *collectBtn;
@property (nonatomic, strong)UIButton *inspectionBtn;
@property (nonatomic, strong)UIButton *noInspectionBtn;
@property (nonatomic, strong)NSMutableArray *addressDataSource;
@property (nonatomic, strong)NSString *addressId;
@property (nonatomic, strong)UILabel *nameLb;
@property (nonatomic, strong)UILabel *phoneLb;
@property (nonatomic, strong)UILabel *addressLb;
@property (nonatomic, assign)int bindNum;
@property (nonatomic, strong)NSString *orderType;
@property (nonatomic, strong)NSString *isInspection;

@property (nonatomic, strong)UIView *cancelQuestionBackV;
@property (nonatomic, strong)UIView *questionBackV;
@property (nonatomic, strong)UILabel *questionLb;

@property (nonatomic, strong)MBProgressHUD *hud;
@property (nonatomic, strong)NSMutableArray *couponsArr;


@end

@implementation ShoppingCartDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view.
}

#pragma mark 创建UI界面
- (void)setupUI {
    [self setNavigationBackBtn];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.btoomView];
    [self.btoomView addSubview:self.settleAccountsBtn];
    [self.btoomView addSubview:self.selectAllBtn];
    [self.btoomView addSubview:self.btoLa];
    [self.btoomView addSubview:self.countLa];
    [self.view addSubview:self.selectCollectOrDirectMailBackV];

}

- (UIView *)cancelQuestionBackV
{
    if (_cancelQuestionBackV == nil) {
        _cancelQuestionBackV = [[UIView alloc]initWithFrame:self.view.bounds];
        _cancelQuestionBackV.backgroundColor = [UIColor clearColor];
        [_cancelQuestionBackV addSubview:self.questionBackV];
        _cancelQuestionBackV.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappearQuestionBackV)];
        tap.numberOfTouchesRequired = 1;
        tap.numberOfTapsRequired = 1;
        [_cancelQuestionBackV addGestureRecognizer:tap];
    }
    return _cancelQuestionBackV;
}

- (void)disappearQuestionBackV
{
    self.cancelQuestionBackV.hidden = YES;
}

- (UIView *)questionBackV
{
    if (_questionBackV == nil) {
        _questionBackV = [[UIView alloc]initWithFrame:CGRectMake(50, 200, kScreenW - 100, kScreenH - 400)];
        _questionBackV.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:211.0/255.0 green:211.0/255.0 blue:211.0/255.0 alpha:0.8];
        _questionBackV.hidden = YES;
        [_questionBackV addSubview:self.questionLb];
    }
    return _questionBackV;
}

- (UILabel *)questionLb
{
    if (_questionLb == nil) {
        _questionLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kScreenW - 120, kScreenH - 400 - 20)];
        _questionLb.numberOfLines = 0;
        _questionLb.font = [UIFont systemFontOfSize:14];
    }
    return _questionLb;
}

- (UILabel *)countLa {
    if (_countLa == nil) {
        _countLa = [[UILabel alloc]init];
        _countLa.font = [UIFont systemFontOfSize:12];
        NSString *str = [NSString stringWithFormat:@"%@：¥0.00",NSLocalizedString(@"GlobalBuyer_Shopcart_Allprice", nil)];
        _countLa.text = str;
        _countLa.numberOfLines = 0;
        _countLa.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        _countLa.frame = CGRectMake(CGRectGetMaxX(self.btoLa.frame) + 8, 0, CGRectGetMinX(self.settleAccountsBtn.frame) - CGRectGetMinX(self.btoLa.frame) - 16, 49);
    }
    return _countLa;
}

- (UILabel *)btoLa {
    if (_btoLa == nil) {
        _btoLa = [[UILabel alloc]init];
        _btoLa.frame = CGRectMake(CGRectGetMaxX(self.selectAllBtn.frame) + 10, (49 - 25)/2, 30, 25);
        _btoLa.text = NSLocalizedString(@"GlobalBuyer_Shopcart_Allselect", nil);
        _btoLa.font = [UIFont systemFontOfSize:13];
        _btoLa.textColor = [UIColor colorWithRed:0.57 green:0.57 blue:0.68 alpha:1];
    }
    return _btoLa;
}

- (UIButton *)selectAllBtn {
    if (_selectAllBtn == nil) {
        _selectAllBtn = [[UIButton alloc]init];
        _selectAllBtn.frame = CGRectMake(10, (49 - 25)/2, 25, 25);
        [_selectAllBtn setImage:[UIImage imageNamed:@"勾选边框"] forState:UIControlStateNormal];
        [_selectAllBtn setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
        [_selectAllBtn addTarget:self action:@selector(selectAllClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectAllBtn;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW , kScreenH-NavBarHeight-49) style:UITableViewStyleGrouped];
        _tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(5, 0, 10, 0);
        //下面3局代码  方式刷新tableview 出现抖动
        _tableView.estimatedRowHeight =0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;

    }
    return _tableView;
}

- (UIView *)btoomView {
    if (_btoomView == nil) {
        _btoomView = [[UIView alloc]init];
        _btoomView.frame = CGRectMake(0, kScreenH - 49-NavBarHeight, kScreenW, 49);
        _btoomView.backgroundColor = Cell_BgColor;
    }
    return _btoomView;
}

- (UIButton *)settleAccountsBtn {
    if (_settleAccountsBtn == nil) {
        _settleAccountsBtn = [UIButton new];
        _settleAccountsBtn.frame = CGRectMake(kScreenW - 100, 0, 100, 49);
        [_settleAccountsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_settleAccountsBtn setBackgroundColor:Main_Color];
        _settleAccountsBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_settleAccountsBtn setTitle:NSLocalizedString(@"GlobalBuyer_Shopcart_Settlement", nil) forState:UIControlStateNormal];
        [_settleAccountsBtn addTarget:self action:@selector(settleAccountsClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settleAccountsBtn;
}

- (ShopCartHeaderView *)shopCartHeaderView {
    if (_shopCartHeaderView == nil) {
        _shopCartHeaderView = [[ShopCartHeaderView alloc]init];
        _shopCartHeaderView.frame =CGRectMake(0, 64, kScreenW, [_shopCartHeaderView getH]);
    }
    return _shopCartHeaderView;
}

#pragma mark tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSoucer.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    OrderModel *model =  self.dataSoucer[section];
    
    UIView *footerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    footerV.backgroundColor = Cell_BgColor;
    UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(0, 1, kScreenW, 38)];
    backV.backgroundColor = [UIColor whiteColor];
    [footerV addSubview:backV];
    
    
    if ([model.buy_type isEqualToString:@"item-price"]) {
        
        UILabel *goodsPriceLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 4, 170, 30)];
        goodsPriceLb.font = [UIFont systemFontOfSize:14];
        NSString *tmpStr = NSLocalizedString(@"GlobalBuyer_Amazon_FixedpriceAll", nil);
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:%@",tmpStr,[CurrencyCalculation calculationCurrencyCalculation:[model.price floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:model.body.currency numberOfGoods:[model.quantity floatValue] freight:0.0 serviceCharge:0.0 exciseTax:0.0]]];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1] range:NSMakeRange(tmpStr.length+1, [CurrencyCalculation calculationCurrencyCalculation:[model.price floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:model.body.currency numberOfGoods:[model.quantity floatValue] freight:0.0 serviceCharge:0.0 exciseTax:0.0].length)];
        goodsPriceLb.attributedText = attStr;
        [backV addSubview:goodsPriceLb];
        
        
    }else{
        UILabel *exciseTaxLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 180, 4, 170, 30)];
        exciseTaxLb.font = [UIFont systemFontOfSize:14];
        exciseTaxLb.textAlignment = NSTextAlignmentRight;
        NSString *tmpStrR = NSLocalizedString(@"GlobalBuyer_Entrust_secondPayDetailsLb", nil);
        NSMutableAttributedString *attStrR = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:%@",tmpStrR,[CurrencyCalculation calculationCurrencyCalculation:0.0 moneytypeArr:self.moneytypeArr currentCommodityCurrency:model.body.currency numberOfGoods:1.0 freight:0.0 serviceCharge:0.0 exciseTax:([model.tax floatValue] * [model.quantity floatValue])]]];
        [attStrR addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1] range:NSMakeRange(tmpStrR.length+1, [CurrencyCalculation calculationCurrencyCalculation:0.0 moneytypeArr:self.moneytypeArr currentCommodityCurrency:model.body.currency numberOfGoods:1.0 freight:0.0 serviceCharge:0.0 exciseTax:([model.tax floatValue] * [model.quantity floatValue])].length)];
        exciseTaxLb.attributedText = attStrR;
        [backV addSubview:exciseTaxLb];
        
        
        UILabel *goodsPriceLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 4, 170, 30)];
        goodsPriceLb.font = [UIFont systemFontOfSize:14];
        NSString *tmpStr = NSLocalizedString(@"GlobalBuyer_Entrust_commodityCostLb", nil);
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:%@",tmpStr,[CurrencyCalculation calculationCurrencyCalculation:[model.price floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:model.body.currency numberOfGoods:[model.quantity floatValue] freight:0.0 serviceCharge:0.0 exciseTax:0.0]]];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1] range:NSMakeRange(tmpStr.length+1, [CurrencyCalculation calculationCurrencyCalculation:[model.price floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:model.body.currency numberOfGoods:[model.quantity floatValue] freight:0.0 serviceCharge:0.0 exciseTax:0.0].length)];
        goodsPriceLb.attributedText = attStr;
        [backV addSubview:goodsPriceLb];
    }
    

    
    
    return footerV;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return 88;
    }else{
        return 90;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingCartCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        //解决xib复用数据混乱问题
        if (nil == cell) {
            
            cell= (ShoppingCartCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"ShoppingCartCell" owner:self options:nil]  lastObject];
            
        }else{
            //删除cell的所有子视图
            while ([cell.contentView.subviews lastObject] != nil)
            {
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            }
        }
//    ShoppingCartCell *cell = TableViewCellDequeueInit(NSStringFromClass([ShoppingCartCell class]));
//    TableViewCellDequeueXIB(cell, ShoppingCartCell);

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model =  self.dataSoucer[indexPath.section];
    cell.delegate = self;
    cell.hideBtn = NO;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderModel *model =  self.dataSoucer[indexPath.section];
    ShoppingCartCell *cell = (ShoppingCartCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.forthcomingCollectionLb.hidden == NO) {
//        CollectionViewController *vc = [[CollectionViewController alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (0) {
        CommissionViewController *commVC = [[CommissionViewController alloc]init];
        NSLog(@"%@",self.title);
        NSString *pictureUrl;
        NSString *pictureStr = model.body.picture;
        NSMutableArray *pictureHttpArr = [self getRangeStr:pictureStr findText:@"http"];
        NSMutableArray *pictureHttpsArr = [self getRangeStr:pictureStr findText:@"https"];
        if ((pictureHttpArr.count > 0) || (pictureHttpsArr.count > 0)) {
            pictureUrl = pictureStr;
        }else{
            NSString *tmpStr = model.body.link;
            NSMutableArray *tmpHttpArr = [self getRangeStr:tmpStr findText:@"http"];
            NSMutableArray *tmpHttpsArr = [self getRangeStr:tmpStr findText:@"https"];
            if (tmpHttpArr.count > 0) {
                pictureUrl = [NSString stringWithFormat:@"http:%@",pictureStr];
            }else if(tmpHttpsArr.count > 0){
                pictureUrl = [NSString stringWithFormat:@"https:%@",pictureStr];
            }
        }
        
        commVC.pictureUrl = pictureUrl;
        commVC.titleOfGoods = model.body.shopSource;
        commVC.numberOfGoods = [NSString stringWithFormat:@"%@",model.quantity];
        commVC.priceOfGoods = [NSString stringWithFormat:@"%@",model.price];
        if ([model.body.shopSource isEqualToString:@"1688"]) {
            commVC.tureNumberOfGoods = [NSString stringWithFormat:@"%@",model.quantity];
        }
        commVC.nameOfGoods = model.body.name;
        commVC.attributesOfGoods = model.body.attributes;
        commVC.moneyTypeOfGoods = model.body.currency;
        commVC.source = @"shopCart";
        commVC.link = model.body.link;
        commVC.nationalityStr = model.body.link;
        [self.navigationController pushViewController:commVC animated:YES];
    }else{
        if ([model.buy_type isEqualToString:@"item-price"]) {
//            FixedPriceShowViewController *fpVC = [[FixedPriceShowViewController alloc]init];
//            fpVC.navigationItem.title = NSLocalizedString(@"GlobalBuyer_Amazon_Fixedprice", nil);
//            fpVC.pictureUrl = model.body.picture;
//            fpVC.nameOfGoods = model.body.name;
//            fpVC.priceOfGoods = [NSString stringWithFormat:@"%@",model.price];
//            fpVC.numberOfGoods = [NSString stringWithFormat:@"%@",model.quantity];
//            fpVC.attributesOfGoods = model.body.attributes;
//            fpVC.moneyTypeOfGoods = model.body.currency;
//            fpVC.moneytypeArr = self.moneytypeArr;
//            [self.navigationController pushViewController:fpVC animated:YES];
            return;
        }
        CommissionDefaultViewController *commVC = [[CommissionDefaultViewController alloc]init];
        NSLog(@"嗯嗯%@",model.product_num);
        NSString *pictureUrl;
        NSString *pictureStr = model.body.picture;
        NSMutableArray *pictureHttpArr = [self getRangeStr:pictureStr findText:@"http"];
        NSMutableArray *pictureHttpsArr = [self getRangeStr:pictureStr findText:@"https"];
        if ((pictureHttpArr.count > 0) || (pictureHttpsArr.count > 0)) {
            pictureUrl = pictureStr;
        }else{
            NSString *tmpStr = model.body.link;
            NSMutableArray *tmpHttpArr = [self getRangeStr:tmpStr findText:@"http"];
            NSMutableArray *tmpHttpsArr = [self getRangeStr:tmpStr findText:@"https"];
            if (tmpHttpArr.count > 0) {
                pictureUrl = [NSString stringWithFormat:@"http:%@",pictureStr];
            }else if(tmpHttpsArr.count > 0){
                pictureUrl = [NSString stringWithFormat:@"https:%@",pictureStr];
            }
        }
        
        commVC.pictureUrl = pictureUrl;
        commVC.titleOfGoods = model.body.shopSource;
        commVC.numberOfGoods = [NSString stringWithFormat:@"%@",model.quantity];
        commVC.priceOfGoods = [NSString stringWithFormat:@"%@",model.price];
        if ([model.body.shopSource isEqualToString:@"1688"]) {
            commVC.tureNumberOfGoods = [NSString stringWithFormat:@"%@",model.quantity];
        }
        commVC.nameOfGoods = model.body.name;
        commVC.attributesOfGoods = model.body.attributes;
        commVC.moneyTypeOfGoods = model.body.currency;
        commVC.source = @"shopCart";
        commVC.link = model.body.link;
        commVC.nationalityStr = model.body.link;
        commVC.product_num = model.product_num;
        [self.navigationController pushViewController:commVC animated:YES];
    }

}


//获取http OR https
- (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText

{
    
    NSMutableArray *arrayRanges = [NSMutableArray arrayWithCapacity:20];
    
    if (findText == nil && [findText isEqualToString:@""]) {
        
        return nil;
        
    }
    
    NSRange rang = [text rangeOfString:findText]; //获取第一次出现的range
    
    if (rang.location != NSNotFound && rang.length != 0) {
        
        [arrayRanges addObject:[NSNumber numberWithInteger:rang.location]];//将第一次的加入到数组中
        
        NSRange rang1 = {0,0};
        
        NSInteger location = 0;
        
        NSInteger length = 0;
        
        for (int i = 0;; i++)
            
        {
            
            if (0 == i) {//去掉这个xxx
                
                location = rang.location + rang.length;
                
                length = text.length - rang.location - rang.length;
                
                rang1 = NSMakeRange(location, length);
                
            }else
                
            {
                
                location = rang1.location + rang1.length;
                
                length = text.length - rang1.location - rang1.length;
                
                rang1 = NSMakeRange(location, length);
                
            }
            
            //在一个range范围内查找另一个字符串的range
            
            rang1 = [text rangeOfString:findText options:NSCaseInsensitiveSearch range:rang1];
            
            if (rang1.location == NSNotFound && rang1.length == 0) {
                
                break;
                
            }else//添加符合条件的location进数组
                
                [arrayRanges addObject:[NSNumber numberWithInteger:rang1.location]];
            
        }
        
        return arrayRanges;
        
    }
    
    return nil;
    
}

#pragma mark 选择商品
-(void)isSelectGoods:(OrderModel *)model{
    self.selectAllBtn.selected = NO;
    BOOL select = [model.body.iSelect boolValue];
    if (select) {
        self.oCount += [model.price floatValue] * [model.quantity integerValue];
        self.count  += [model.price floatValue] * [model.quantity integerValue];
        self.ooCount += [model.tax floatValue] * [model.quantity integerValue];
    } else {
        self.oCount -= [model.price floatValue] * [model.quantity integerValue];
        self.count  -= [model.price floatValue] * [model.quantity integerValue];
        self.ooCount -= [model.tax floatValue] * [model.quantity integerValue];
    }
    
    [self showMoney];
    [self.tableView reloadData];
}


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedString(@"GlobalBuyer_Address_dele", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        OrderModel *model = self.dataSoucer[indexPath.section];
        NSArray *arr = [tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in arr) {
            ShoppingCartCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell releaseTimer];
        }
        [self delect:model];
    }];
    // 再次购买按钮
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:NSLocalizedString(@"GlobalBuyer_Shopcart_BuyAgain", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        OrderModel *model = self.dataSoucer[indexPath.section];
        NSArray *arr = [tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in arr) {
            ShoppingCartCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell releaseTimer];
        }
        [self delectToBuy:model];
    }];
    topRowAction.backgroundColor = [UIColor blueColor];
    
    // 收藏按钮
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"GlobalBuyer_My_Tabview_Collection", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        OrderModel *model = self.dataSoucer[indexPath.section];
        NSArray *arr = [tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in arr) {
            ShoppingCartCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell releaseTimer];
        }
        [self shopCartCollection:model];
        
        
    }];
    moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction, topRowAction, moreRowAction];
    
}


//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return NSLocalizedString(@"GlobalBuyer_Address_dele", nil);
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        OrderModel *model = self.dataSoucer[indexPath.section];
//        NSArray *arr = [tableView indexPathsForVisibleRows];
//        for (NSIndexPath *indexPath in arr) {
//            ShoppingCartCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            [cell releaseTimer];
//        }
//        [self delect:model];
//    }
//}

#pragma mark 删除订单
- (void)delect:(OrderModel *)model {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Change the background view style and color.
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_Address_deleteAdd", nil);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *api_token = UserDefaultObjectForKey(USERTOKEN);
    
    NSDictionary *params = @{@"product_id":model.Id,@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":api_token};
    
    [manager POST:DeleteShopCartApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            // Set the text mode to show only text.
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"删除成功!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            CGRect frame = hud.label.frame;
            frame.origin.y = kScreenH - 69;
            hud.label.frame = hud.frame;
            [hud hideAnimated:YES afterDelay:3.f];
            
            BOOL select = [model.body.iSelect boolValue];
            if (select == YES) {
                self.oCount -= [model.price floatValue] * [model.quantity integerValue];
                self.count  -= [model.price floatValue] * [model.quantity integerValue];
            }
            
            [self.dataSoucer removeObject:model];
            [self.tableView reloadData];
            [self showMoney];
            
        }else {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            // Set the text mode to show only text.
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"删除失败!", @"HUD message title");
            
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            CGRect frame = hud.label.frame;
            frame.origin.y = kScreenH - 69;
            hud.label.frame = hud.frame;
            [hud hideAnimated:YES afterDelay:3.f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [hud hideAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        // Set the text mode to show only text.
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"删除失败!", @"HUD message title");
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        CGRect frame = hud.label.frame;
        frame.origin.y = kScreenH - 69;
        hud.label.frame = hud.frame;
        [hud hideAnimated:YES afterDelay:3.f];
    }];
}

#pragma mark 删除订单去购买
- (void)delectToBuy:(OrderModel *)model {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Change the background view style and color.
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *api_token = UserDefaultObjectForKey(USERTOKEN);
    
    NSDictionary *params = @{@"product_id":model.Id,@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":api_token};
    
    [manager POST:DeleteShopCartApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            
            BOOL select = [model.body.iSelect boolValue];
            if (select == YES) {
                self.oCount -= [model.price floatValue] * [model.quantity integerValue];
                self.count  -= [model.price floatValue] * [model.quantity integerValue];
            }
            
            [self.dataSoucer removeObject:model];
            [self.tableView reloadData];
            [self showMoney];
            
            
            ShopDetailViewController *shopDetailVC = [[ShopDetailViewController alloc]init];
            shopDetailVC.link = model.body.link;
            [self.navigationController pushViewController:shopDetailVC animated:YES];
            
        }else {
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [hud hideAnimated:YES];

    }];
}


- (void)shopCartCollection:(OrderModel *)model{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"GlobalBuyer_Address_Adding", nil);
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    parameters[@"api_id"] = API_ID;
    parameters[@"api_token"] = TOKEN;
    parameters[@"secret_key"] = userToken;
    parameters[@"product_id"] = model.Id;
    
    [manager POST:AddShopCartFavoriteApi parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"收藏成功!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
            
            
            BOOL select = [model.body.iSelect boolValue];
            if (select == YES) {
                self.oCount -= [model.price floatValue] * [model.quantity integerValue];
                self.count  -= [model.price floatValue] * [model.quantity integerValue];
            }
            
            [self.dataSoucer removeObject:model];
            [self.tableView reloadData];
            [self showMoney];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"收藏失败!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"收藏失败!", @"HUD message title");
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
    }];

}

#pragma mark 计算
- (void)showMoney {
    OrderModel *model;
    if (self.dataSoucer.count != 0) {
        model = self.dataSoucer[0];
    }
    
    NSString *moneyTypeName;
    if ([model.body.currency isEqualToString:@"CNY"]) {
        moneyTypeName = [NSString stringWithFormat:@"%@%.2f",@"￥",self.count];
    }
    if ([model.body.currency isEqualToString:@"TWD"]) {
        moneyTypeName = [NSString stringWithFormat:@"%.2f%@",self.count,NSLocalizedString(@"GlobalBuyer_Currency_NT", nil)];
//        moneyTypeName = @"台币";
    }
    if ([model.body.currency isEqualToString:@"USD"]) {
        moneyTypeName = [NSString stringWithFormat:@"%@%.2f",@"$",self.count];
        //moneyTypeName = @" $";
    }
    if ([model.body.currency isEqualToString:@"JPY"]) {
        moneyTypeName = [NSString stringWithFormat:@"%.2f%@",self.count,@"日元"];
        moneyTypeName = @"日元";
    }
    if ([model.body.currency isEqualToString:@"EUR"]) {
        moneyTypeName = [NSString stringWithFormat:@"%@%.2f",@"€",self.count];
        //moneyTypeName = @"€";
    }
    if ([model.body.currency isEqualToString:@"GBP"]) {
        moneyTypeName = [NSString stringWithFormat:@"%@%.2f",@"£",self.count];
//        moneyTypeName = @"£";
    }
    if ([model.body.currency isEqualToString:@"aud_rate_rmb"]) {
        moneyTypeName = [NSString stringWithFormat:@"%@%.2f",@"澳元",self.count];
        moneyTypeName = @"澳元";
    }
    if ([model.body.currency isEqualToString:@"KRW"]) {
        moneyTypeName = [NSString stringWithFormat:@"%.2f%@",self.count,@"韩币"];
        moneyTypeName = @"韩币";
    }
    

    
//    self.countLa.text = [NSString stringWithFormat:@"%@\n(%.2f%@+10￥)",[CurrencyCalculation currencyCalculation:(self.count + 10) moneytypeArr:self.moneytypeArr currentCommodityCurrency:model.body.currency],self.oCount,moneyTypeName];
    
    self.currency = model.body.currency;
    
    if([self.title isEqualToString:@"amazon-price"]){
        self.countLa.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_Shopcart_Allprice", nil),[CurrencyCalculation calculationCurrencyCalculation:self.count moneytypeArr:self.moneytypeArr currentCommodityCurrency:model.body.currency numberOfGoods:1.0 freight:0.0 serviceCharge:[self.serviceCharge floatValue] exciseTax:self.ooCount]];
    }else{
        self.countLa.text = [NSString stringWithFormat:@"%@:%@\n(%@)",NSLocalizedString(@"GlobalBuyer_Shopcart_Allprice", nil),[CurrencyCalculation calculationCurrencyCalculation:self.count moneytypeArr:self.moneytypeArr currentCommodityCurrency:model.body.currency numberOfGoods:1.0 freight:0.0 serviceCharge:[self.serviceCharge floatValue] exciseTax:self.ooCount],NSLocalizedString(@"GlobalBuyer_Shopcart_AllNotice", nil)];
    }

    
    
    if (self.count == 0) {
        NSString *str = [NSString stringWithFormat:@"%@：¥0.00",NSLocalizedString(@"GlobalBuyer_Shopcart_Allprice", nil)];
        self.countLa.text = str;
    }
}

#pragma mark 结账事件
- (void)settleAccountsClick {
    
//    if (self.count == 0) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Shopcart_SelectGoods", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles: nil];
//        [alert show];
//        return;
//    }
    
    [self getUserAdd];
 
}

- (NSMutableArray *)addressDataSource
{
    if (_addressDataSource == nil) {
        _addressDataSource = [NSMutableArray new];
    }
    return _addressDataSource;
}

- (void)getUserAdd
{
    [self.addressDataSource removeAllObjects];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":api_token};
    
    [manager POST:GetAddressApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                [self.addressDataSource addObject:dict];
            }
            
        }
        
        UIAlertView *noticeAlt = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Shopcart_SettlementAlert", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) otherButtonTitles:NSLocalizedString(@"GlobalBuyer_Ok", nil) , nil];
        [noticeAlt show];
        
//        [self.view addSubview:self.selectCollectOrDirectMailV];
//
//        [self.view addSubview:self.cancelQuestionBackV];
//
//        [UIView animateWithDuration:1 animations:^{
//            self.selectCollectOrDirectMailBackV.hidden = NO;
//            self.selectCollectOrDirectMailV.frame = CGRectMake(0, kScreenH - 360, kScreenW, 360);
//        }];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *noticeAlt = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Shopcart_SettlementAlert", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) otherButtonTitles:NSLocalizedString(@"GlobalBuyer_Ok", nil) , nil];
        [noticeAlt show];
//        [hud hideAnimated:YES];
//
//        [self.view addSubview:self.selectCollectOrDirectMailV];
//
//        [UIView animateWithDuration:1 animations:^{
//            self.selectCollectOrDirectMailBackV.hidden = NO;
//            self.selectCollectOrDirectMailV.frame = CGRectMake(0, kScreenH - 360, kScreenW, 360);
//        }];
    }];
}

- (UIView *)selectCollectOrDirectMailBackV
{
    if (_selectCollectOrDirectMailBackV == nil) {
        _selectCollectOrDirectMailBackV = [[UIView alloc]initWithFrame:self.tabBarController.view.bounds];
        _selectCollectOrDirectMailBackV.backgroundColor = [UIColor blackColor];
        _selectCollectOrDirectMailBackV.alpha = 0.5;
        _selectCollectOrDirectMailBackV.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenBackV)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_selectCollectOrDirectMailBackV addGestureRecognizer:tap];
    }
    return _selectCollectOrDirectMailBackV;
}

- (void)hiddenBackV
{
    [UIView animateWithDuration:1 animations:^{
        self.selectCollectOrDirectMailBackV.hidden = YES;
        self.selectCollectOrDirectMailV.frame = CGRectMake(0, kScreenH , kScreenW, 360);
    } completion:^(BOOL finished) {
        [self.selectCollectOrDirectMailV removeFromSuperview];
        self.selectCollectOrDirectMailV = nil;
        self.addressId = nil;
        [self.questionBackV removeFromSuperview];
        [self.cancelQuestionBackV removeFromSuperview];
        self.questionBackV = nil;
    }];
}

- (UIView *)selectCollectOrDirectMailV
{
    if (_selectCollectOrDirectMailV == nil) {
        _selectCollectOrDirectMailV = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, 360)];
        _selectCollectOrDirectMailV.backgroundColor = [UIColor whiteColor];
        UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 310, kScreenW, 50)];
        submitBtn.backgroundColor = Main_Color;
        [submitBtn setTitle:NSLocalizedString(@"GlobalBuyer_Shopcart_Submit", nil) forState:UIControlStateNormal];
        [_selectCollectOrDirectMailV addSubview:submitBtn];
        [submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
        UILabel *selectReceivingAddressLb = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, kScreenW - 60, 30)];
        selectReceivingAddressLb.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"GlobalBuyer_Selectcurrency", nil)];
        selectReceivingAddressLb.textColor = Main_Color;
        selectReceivingAddressLb.font = [UIFont systemFontOfSize:18];
        [_selectCollectOrDirectMailV addSubview:selectReceivingAddressLb];
        UIView *firstLineV = [[UIView alloc]initWithFrame:CGRectMake(10, selectReceivingAddressLb.frame.origin.y + selectReceivingAddressLb.frame.size.height, kScreenW - 20, 1)];
        firstLineV.backgroundColor = Main_Color;
        [_selectCollectOrDirectMailV addSubview:firstLineV];
        
        
        //详细地址显示
        if (self.addressDataSource.count == 0) {
            
            UIImageView *noAddressIv = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2 - 35, firstLineV.frame.origin.y + 15, 70, 70)];
            noAddressIv.userInteractionEnabled = YES;
            noAddressIv.image = [UIImage imageNamed:@"AddAddress"];
            [_selectCollectOrDirectMailV addSubview:noAddressIv];
            UITapGestureRecognizer *addAddressTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addAddress)];
            addAddressTap.numberOfTouchesRequired = 1;
            addAddressTap.numberOfTapsRequired = 1;
            [noAddressIv addGestureRecognizer:addAddressTap];
            
            
        }else{
            
            
            UIView *addressBackV = [[UIView alloc]initWithFrame:CGRectMake(50, firstLineV.frame.origin.y + 10, kScreenW - 100, 85)];
            [_selectCollectOrDirectMailV addSubview:addressBackV];
            
            self.nameLb = [[UILabel alloc]initWithFrame:CGRectMake(1, 1, kScreenW/2 - 50, 20)];
            self.nameLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_Shopcart_Consignee", nil),self.addressDataSource[0][@"fullname"]];
            self.nameLb.font = [UIFont systemFontOfSize:15];
            [addressBackV addSubview:self.nameLb];
            
            self.phoneLb = [[UILabel alloc]initWithFrame:CGRectMake(addressBackV.frame.size.width - 100, 1, 100, 20)];
            self.phoneLb.text = [NSString stringWithFormat:@"%@",self.addressDataSource[0][@"mobile_phone"]];
            self.phoneLb.font = [UIFont systemFontOfSize:15];
            self.phoneLb.textAlignment = NSTextAlignmentRight;
            [addressBackV addSubview:self.phoneLb];
            
            self.addressLb = [[UILabel alloc]initWithFrame:CGRectMake(1, self.nameLb.frame.origin.y + self.nameLb.frame.size.height + 5, addressBackV.frame.size.width - 2, 55)];
            self.addressLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_Tabview_Cell_Add", nil),self.addressDataSource[0][@"address"]];
            self.addressLb.font = [UIFont systemFontOfSize:15];
            self.addressLb.numberOfLines = 0;
            //[self.addressLb sizeToFit];
            [addressBackV addSubview:self.addressLb];
            
            UIImageView *arrowIv = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW - 40, firstLineV.frame.origin.y + 40, 30, 30)];
            arrowIv.image = [UIImage imageNamed:@"tipsarrow"];
            arrowIv.userInteractionEnabled = YES;
            [_selectCollectOrDirectMailV addSubview:arrowIv];
            UITapGestureRecognizer *arrowTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectAddress)];
            arrowTap.numberOfTapsRequired = 1;
            arrowTap.numberOfTouchesRequired = 1;
            [arrowIv addGestureRecognizer:arrowTap];
            
            self.addressId = [NSString stringWithFormat:@"%@",self.addressDataSource[0][@"id"]];
            
            self.bindNum++;
            
            UITapGestureRecognizer *addressTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectAddress)];
            addressTap.numberOfTapsRequired = 1;
            addressTap.numberOfTouchesRequired = 1;
            [addressBackV addGestureRecognizer:addressTap];
            addressBackV.userInteractionEnabled = YES;
            
//            self.bindNum = 0;
//
//            for (int i = 0; i < self.addressDataSource.count; i++) {
//                if ([(NSMutableArray *)self.addressDataSource[i][@"get_customer_idcard"] count] != 0) {
//
////                    UIButton *addressBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, firstLineV.frame.origin.y + 40, 23, 23)];
////                    [addressBtn setImage:[UIImage imageNamed:@"勾选边框"] forState:UIControlStateNormal];
////                    [addressBtn setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
////                    addressBtn.selected = YES;
////                    [_selectCollectOrDirectMailV addSubview:addressBtn];
//
//
//                    UIView *addressBackV = [[UIView alloc]initWithFrame:CGRectMake(50, firstLineV.frame.origin.y + 10, kScreenW - 100, 85)];
//                    [_selectCollectOrDirectMailV addSubview:addressBackV];
//
//                    self.nameLb = [[UILabel alloc]initWithFrame:CGRectMake(1, 1, kScreenW/2 - 50, 20)];
//                    self.nameLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_Shopcart_Consignee", nil),self.addressDataSource[i][@"fullname"]];
//                    self.nameLb.font = [UIFont systemFontOfSize:15];
//                    [addressBackV addSubview:self.nameLb];
//
//                    self.phoneLb = [[UILabel alloc]initWithFrame:CGRectMake(addressBackV.frame.size.width - 100, 1, 100, 20)];
//                    self.phoneLb.text = [NSString stringWithFormat:@"%@",self.addressDataSource[i][@"mobile_phone"]];
//                    self.phoneLb.font = [UIFont systemFontOfSize:15];
//                    self.phoneLb.textAlignment = NSTextAlignmentRight;
//                    [addressBackV addSubview:self.phoneLb];
//
//                    self.addressLb = [[UILabel alloc]initWithFrame:CGRectMake(1, self.nameLb.frame.origin.y + self.nameLb.frame.size.height + 5, addressBackV.frame.size.width - 2, 55)];
//                    self.addressLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_Tabview_Cell_Add", nil),self.addressDataSource[i][@"address"]];
//                    self.addressLb.font = [UIFont systemFontOfSize:15];
//                    self.addressLb.numberOfLines = 0;
//                    //[self.addressLb sizeToFit];
//                    [addressBackV addSubview:self.addressLb];
//
//                    UIImageView *arrowIv = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW - 40, firstLineV.frame.origin.y + 40, 30, 30)];
//                    arrowIv.image = [UIImage imageNamed:@"tipsarrow"];
//                    arrowIv.userInteractionEnabled = YES;
//                    [_selectCollectOrDirectMailV addSubview:arrowIv];
//                    UITapGestureRecognizer *arrowTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectAddress)];
//                    arrowTap.numberOfTapsRequired = 1;
//                    arrowTap.numberOfTouchesRequired = 1;
//                    [arrowIv addGestureRecognizer:arrowTap];
//
//                    self.addressId = [NSString stringWithFormat:@"%@",self.addressDataSource[i][@"id"]];
//
//                    self.bindNum++;
//
//                    UITapGestureRecognizer *addressTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectAddress)];
//                    addressTap.numberOfTapsRequired = 1;
//                    addressTap.numberOfTouchesRequired = 1;
//                    [addressBackV addGestureRecognizer:addressTap];
//                    addressBackV.userInteractionEnabled = YES;
//
//                    break;
//                }
//
//            }
            
//            if (self.bindNum == 0) {
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_inputAdd", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles: nil];
//                [alert show];
//
//
//                UIImageView *bindAddressIv = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2 - 35, firstLineV.frame.origin.y + 15, 70, 70)];
//                bindAddressIv.userInteractionEnabled = YES;
//                bindAddressIv.image = [UIImage imageNamed:@"AddAddress"];
//                [_selectCollectOrDirectMailV addSubview:bindAddressIv];
//                UITapGestureRecognizer *bindAddressTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bindAddress)];
//                bindAddressTap.numberOfTouchesRequired = 1;
//                bindAddressTap.numberOfTapsRequired = 1;
//                [bindAddressIv addGestureRecognizer:bindAddressTap];
//            }
        }
        
        
        UILabel *inspectionTitleLb = [[UILabel alloc]initWithFrame:CGRectMake(30, firstLineV.frame.origin.y + 90, kScreenW - 60, 30)];
        inspectionTitleLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_SelectInspection", nil);
        inspectionTitleLb.textColor = Main_Color;
        inspectionTitleLb.font = [UIFont systemFontOfSize:18];
        [_selectCollectOrDirectMailV addSubview:inspectionTitleLb];
        UIView *inspectionLineV = [[UIView alloc]initWithFrame:CGRectMake(10, inspectionTitleLb.frame.origin.y + inspectionTitleLb.frame.size.height, kScreenW - 20, 1)];
        inspectionLineV.backgroundColor = Main_Color;
        [_selectCollectOrDirectMailV addSubview:inspectionLineV];
        self.inspectionBtn = [[UIButton alloc]initWithFrame:CGRectMake(10,inspectionLineV.frame.origin.y + 20, 23, 23)];
        [self.inspectionBtn setImage:[UIImage imageNamed:@"勾选边框"] forState:UIControlStateNormal];
        [self.inspectionBtn setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
        self.inspectionBtn.selected = YES;
        [_selectCollectOrDirectMailV addSubview:self.inspectionBtn];
        [self.inspectionBtn addTarget:self action:@selector(inspectionClick) forControlEvents:UIControlEventTouchUpInside];
        UILabel *inspectionLb = [[UILabel alloc]initWithFrame:CGRectMake(self.inspectionBtn.frame.origin.x + self.inspectionBtn.frame.size.width + 10, inspectionLineV.frame.origin.y + 23, 100, 30)];
        inspectionLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_Inspection", nil);
        inspectionLb.font = [UIFont systemFontOfSize:16];
        [inspectionLb sizeToFit];
        [_selectCollectOrDirectMailV addSubview:inspectionLb];
        UIImageView *inspectionIv = [[UIImageView alloc]initWithFrame:CGRectMake(inspectionLb.frame.origin.x + inspectionLb.frame.size.width + 5, inspectionLb.frame.origin.y - 3, 25, 25)];
        inspectionIv.userInteractionEnabled = YES;
        inspectionIv.image = [UIImage imageNamed:@"tabBar_help"];
        [_selectCollectOrDirectMailV addSubview:inspectionIv];
        UITapGestureRecognizer *inspectionIvTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(inspectionIvClick:)];
        inspectionIvTap.numberOfTapsRequired = 1;
        inspectionIvTap.numberOfTouchesRequired = 1;
        [inspectionIv addGestureRecognizer:inspectionIvTap];
        
        
        self.noInspectionBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/2, inspectionLineV.frame.origin.y + 20, 23, 23)];
        [self.noInspectionBtn setImage:[UIImage imageNamed:@"勾选边框"] forState:UIControlStateNormal];
        [self.noInspectionBtn setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
        [_selectCollectOrDirectMailV addSubview:self.noInspectionBtn];
        [self.noInspectionBtn addTarget:self action:@selector(noInspectionClick) forControlEvents:UIControlEventTouchUpInside];
        UILabel *noInspectionLb = [[UILabel alloc]initWithFrame:CGRectMake(self.noInspectionBtn.frame.origin.x + self.noInspectionBtn.frame.size.width + 10, inspectionLineV.frame.origin.y + 23, 100, 30)];
        noInspectionLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_NoInspection", nil);
        noInspectionLb.font = [UIFont systemFontOfSize:16];
        [noInspectionLb sizeToFit];
        [_selectCollectOrDirectMailV addSubview:noInspectionLb];
        
        
        UILabel *selectPurchaseModeLb = [[UILabel alloc]initWithFrame:CGRectMake(30, firstLineV.frame.origin.y + 100 + 75, kScreenW - 60, 30)];
        selectPurchaseModeLb.text = [NSString stringWithFormat:@"%@:",NSLocalizedString(@"GlobalBuyer_Shopcart_SelectPurchaseMode", nil)];
        selectPurchaseModeLb.textColor = Main_Color;
        selectPurchaseModeLb.font = [UIFont systemFontOfSize:18];
        [_selectCollectOrDirectMailV addSubview:selectPurchaseModeLb];
        UIView *secondLineV = [[UIView alloc]initWithFrame:CGRectMake(10, selectPurchaseModeLb.frame.origin.y + selectPurchaseModeLb.frame.size.height, kScreenW - 20, 1)];
        secondLineV.backgroundColor = Main_Color;
        [_selectCollectOrDirectMailV addSubview:secondLineV];
        
        self.directMailBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, secondLineV.frame.origin.y + 20, 23, 23)];
        [self.directMailBtn setImage:[UIImage imageNamed:@"勾选边框"] forState:UIControlStateNormal];
        [self.directMailBtn setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
        self.directMailBtn.selected = YES;
        [_selectCollectOrDirectMailV addSubview:self.directMailBtn];
        [self.directMailBtn addTarget:self action:@selector(directMailClick) forControlEvents:UIControlEventTouchUpInside];
        UILabel *directMailLb = [[UILabel alloc]initWithFrame:CGRectMake(self.directMailBtn.frame.origin.x + self.directMailBtn.frame.size.width + 10, secondLineV.frame.origin.y + 23, 100, 30)];
        directMailLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_DirectMail", nil);
        directMailLb.font = [UIFont systemFontOfSize:16];
        [directMailLb sizeToFit];
        [_selectCollectOrDirectMailV addSubview:directMailLb];
        UIImageView *directMailQuestionIv = [[UIImageView alloc]initWithFrame:CGRectMake(directMailLb.frame.origin.x + directMailLb.frame.size.width + 5, directMailLb.frame.origin.y - 3, 25, 25)];
        directMailQuestionIv.image = [UIImage imageNamed:@"tabBar_help"];
        directMailQuestionIv.userInteractionEnabled = YES;
        [_selectCollectOrDirectMailV addSubview:directMailQuestionIv];
        UITapGestureRecognizer *directMailQuestionTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(directMailQuestionClick:)];
        [directMailQuestionIv addGestureRecognizer:directMailQuestionTap];
        
        self.collectBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/2, secondLineV.frame.origin.y + 20, 23, 23)];
        [self.collectBtn setImage:[UIImage imageNamed:@"勾选边框"] forState:UIControlStateNormal];
        [self.collectBtn setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
        [_selectCollectOrDirectMailV addSubview:self.collectBtn];
        [self.collectBtn addTarget:self action:@selector(collectClick) forControlEvents:UIControlEventTouchUpInside];
        if ([self.title isEqualToString:@"amazon-price"]) {
            self.collectBtn.userInteractionEnabled = NO;
        }
        UILabel *collectLb = [[UILabel alloc]initWithFrame:CGRectMake(self.collectBtn.frame.origin.x + self.collectBtn.frame.size.width + 10, secondLineV.frame.origin.y + 23, 100, 30)];
        collectLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_Collect", nil);
        collectLb.font = [UIFont systemFontOfSize:16];
        [collectLb sizeToFit];
        [_selectCollectOrDirectMailV addSubview:collectLb];
        UIImageView *collectQuestionIv = [[UIImageView alloc]initWithFrame:CGRectMake(collectLb.frame.origin.x + collectLb.frame.size.width + 5, collectLb.frame.origin.y - 3, 25, 25)];
        collectQuestionIv.userInteractionEnabled = YES;
        collectQuestionIv.image = [UIImage imageNamed:@"tabBar_help"];
        [_selectCollectOrDirectMailV addSubview:collectQuestionIv];
        UITapGestureRecognizer *collectQuestionTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(collectClick:)];
        [collectQuestionIv addGestureRecognizer:collectQuestionTap];
    }
    return _selectCollectOrDirectMailV;
}

- (void)inspectionIvClick:(UITapGestureRecognizer *)sender
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
        filePath = [[NSBundle mainBundle]pathForResource:@"简-验货内容" ofType:@"txt"];
    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
        filePath = [[NSBundle mainBundle]pathForResource:@"繁-验货内容" ofType:@"txt"];
    }else if([currentLanguage isEqualToString:@"en"]){
        filePath = [[NSBundle mainBundle]pathForResource:@"英-验货内容" ofType:@"txt"];
    }else{
        filePath = [[NSBundle mainBundle]pathForResource:@"简-验货内容" ofType:@"txt"];
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
    
    
    self.questionLb.text = allStr;
    
    [self.questionLb sizeToFit];
    
    
    self.questionBackV.hidden = NO;
    self.cancelQuestionBackV.hidden = NO;
}

- (void)directMailQuestionClick:(UITapGestureRecognizer *)sender
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
        filePath = [[NSBundle mainBundle]pathForResource:@"简-代购直邮" ofType:@"txt"];
    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
        filePath = [[NSBundle mainBundle]pathForResource:@"繁-代购直邮" ofType:@"txt"];
    }else if([currentLanguage isEqualToString:@"en"]){
        filePath = [[NSBundle mainBundle]pathForResource:@"英-代购直邮" ofType:@"txt"];
    }else{
        filePath = [[NSBundle mainBundle]pathForResource:@"简-代购直邮" ofType:@"txt"];
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
    
 
    self.questionLb.text = allStr;
    
    [self.questionLb sizeToFit];
    
    
    self.questionBackV.hidden = NO;
    self.cancelQuestionBackV.hidden = NO;
    
}

- (void)collectClick:(UITapGestureRecognizer *)sender
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
        filePath = [[NSBundle mainBundle]pathForResource:@"简-寄仓集货" ofType:@"txt"];
    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
        filePath = [[NSBundle mainBundle]pathForResource:@"繁-寄仓集货" ofType:@"txt"];
    }else if([currentLanguage isEqualToString:@"en"]){
        filePath = [[NSBundle mainBundle]pathForResource:@"英-寄仓集货" ofType:@"txt"];
    }else{
        filePath = [[NSBundle mainBundle]pathForResource:@"简-寄仓集货" ofType:@"txt"];
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
    
    
    self.questionLb.text = allStr;
    
    [self.questionLb sizeToFit];
    
    self.questionBackV.hidden = NO;
    self.cancelQuestionBackV.hidden = NO;
    
}

- (void)addAddress
{
    [UIView animateWithDuration:1 animations:^{
        self.selectCollectOrDirectMailBackV.hidden = YES;
        self.selectCollectOrDirectMailV.frame = CGRectMake(0, kScreenH , kScreenW, 360);
    } completion:^(BOOL finished) {
        [self.selectCollectOrDirectMailV removeFromSuperview];
        self.selectCollectOrDirectMailV = nil;
        self.addressId = nil;
        [self.questionBackV removeFromSuperview];
        [self.cancelQuestionBackV removeFromSuperview];
        self.questionBackV = nil;
        self.cancelQuestionBackV = nil;
        AddressViewController *addressVC = [AddressViewController new];
        [self.navigationController pushViewController:addressVC animated:YES];
    }];

}

- (void)bindAddress
{
    [UIView animateWithDuration:1 animations:^{
        self.selectCollectOrDirectMailBackV.hidden = YES;
        self.selectCollectOrDirectMailV.frame = CGRectMake(0, kScreenH , kScreenW, 360);
    } completion:^(BOOL finished) {
        [self.selectCollectOrDirectMailV removeFromSuperview];
        self.selectCollectOrDirectMailV = nil;
        self.addressId = nil;
        [self.questionBackV removeFromSuperview];
        [self.cancelQuestionBackV removeFromSuperview];
        self.questionBackV = nil;
        BindIDViewController *bindIdVc = [[BindIDViewController alloc]init];
        [self.navigationController pushViewController:bindIdVc animated:YES];
    }];
}

- (void)selectAddress
{
    DirectMailAddressViewController *dmaVC = [[DirectMailAddressViewController alloc]init];
    dmaVC.dataSource = self.addressDataSource;
    dmaVC.delegate = self;
    [self.navigationController pushViewController:dmaVC animated:YES];
}

- (void)changeAddress:(NSDictionary *)addressInfo
{
    self.nameLb.text = addressInfo[@"fullname"];
    self.phoneLb.text = addressInfo[@"mobile_phone"];
    self.addressLb.text = addressInfo[@"address"];
    self.addressId = addressInfo[@"id"];
}

- (void)directMailClick
{
    self.directMailBtn.selected = YES;
    self.collectBtn.selected = NO;
}

- (void)collectClick
{
    self.directMailBtn.selected = NO;
    self.collectBtn.selected = YES;
}

- (void)inspectionClick
{
    self.inspectionBtn.selected = YES;
    self.noInspectionBtn.selected = NO;
}

- (void)noInspectionClick
{
    self.inspectionBtn.selected = NO;
    self.noInspectionBtn.selected = YES;
}


- (void)submitClick
{
    if (self.directMailBtn.selected == YES) {
        if (self.addressId == nil) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_My_inputAdd", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles: nil];
            [alert show];
            return;
        }
        self.orderType = @"direct";
    }
    
    
    if (self.collectBtn.selected == YES) {
        self.orderType = @"storage";
    }
    
    if (self.inspectionBtn.selected == YES) {
        self.isInspection = @"1";
    }else{
        self.isInspection = @"0";
    }
    
    
    
    UIAlertView *noticeAlt = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Shopcart_SettlementAlert", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) otherButtonTitles:NSLocalizedString(@"GlobalBuyer_Ok", nil) , nil];
    [noticeAlt show];
}

//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"clickButtonAtIndex:%ld",(long)buttonIndex);
    
    if (buttonIndex == 1) {
        
        [self getCoupons];
        
    }
}

- (void)getCoupons
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    // 获得当前iPhone使用的语言
    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
    NSLog(@"当前使用的语言：%@",currentLanguage);
    NSString *language;
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
        language = @"zh_CN";
    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
        language = @"zh_TW";
    }else if([currentLanguage isEqualToString:@"en"]){
        language = @"en";
    }else if([currentLanguage isEqualToString:@"Japanese"]){
        language = @"ja";
    }else{
        language = @"zh_CN";
    }
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *params = @{@"api_id":API_ID,
                             @"api_token":TOKEN,
                             @"secret_key":userToken,
                             @"locale":language};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:AllCouponsApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.hud hideAnimated:YES];
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            NSArray *tmpArr = responseObject[@"data"];
            for (int i = 0 ; i < tmpArr.count; i++) {
                if ([responseObject[@"data"][i][@"frozen"]isEqualToString:@"not_frozen"]) {
                    [self.couponsArr addObject:tmpArr[i]];
                }
                
            }
            NSMutableString *idsStr = [[NSMutableString alloc]initWithString:@"[]"];
            NSMutableArray *idsArr = [[NSMutableArray alloc]init];
            NSMutableArray *payArr = [[NSMutableArray alloc]init];
            
            
            for (OrderModel *model in self.dataSoucer) {
                if ([model.body.iSelect boolValue]){
                    [idsArr addObject:[NSString stringWithFormat:@"%@",model.Id]];
                    [payArr addObject:model];
                }
            }
            self.payArr = [NSArray arrayWithArray:payArr];
            NSString *str = [idsArr componentsJoinedByString:@","];
            [idsStr insertString:str atIndex:1];
            ShopCartSettlementDetailsViewController *vc = [[ShopCartSettlementDetailsViewController alloc]init];
            vc.addressDataSource = self.addressDataSource;
            vc.payArr = payArr;
            vc.idsStr = idsStr;
            vc.moneytypeArr = self.moneytypeArr;
            vc.couponsArr = self.couponsArr;
            vc.count = self.count;
            vc.serviceCharge = self.serviceCharge;
            vc.ooCount = self.ooCount;
            vc.currency = self.currency;
            vc.vc = self.vc;
            [self.navigationController pushViewController:vc animated:YES];
            return ;
            
            if (self.couponsArr.count != 0) {
                SelectCouponViewController *selectCouponVC = [[SelectCouponViewController alloc]init];
                selectCouponVC.hidesBottomBarWhenPushed = YES;

                NSMutableString *idsStr = [[NSMutableString alloc]initWithString:@"[]"];
                NSMutableArray *idsArr = [[NSMutableArray alloc]init];
                NSMutableArray *payArr = [[NSMutableArray alloc]init];
                
                
                for (OrderModel *model in self.dataSoucer) {
                    if ([model.body.iSelect boolValue]){
                        [idsArr addObject:[NSString stringWithFormat:@"%@",model.Id]];
                        [payArr addObject:model];
                    }
                }
                
                for (int i = 0; i < payArr.count; i++) {
                    OrderModel *model = payArr[i];
                    [self.dataSoucer removeObject:model];
                }
                
                [self.tableView removeFromSuperview];
                self.tableView = nil;
                [self.view addSubview:self.tableView];
                
                [self.tableView reloadData];
                
                self.payArr = [NSArray arrayWithArray:payArr];
                NSString *str = [idsArr componentsJoinedByString:@","];
                
                [idsStr insertString:str atIndex:1];
                
                selectCouponVC.idsStr = idsStr;
                selectCouponVC.shopCartVC = self.vc;
                selectCouponVC.orderType = self.orderType;
                selectCouponVC.orderAddress = self.addressId;
                selectCouponVC.isInspection = self.isInspection;
                
                
                
                [self.navigationController pushViewController:selectCouponVC animated:YES];
                
            }else{
                ChoosePayViewController *choosePayVC = [[ChoosePayViewController alloc]init];
                choosePayVC .hidesBottomBarWhenPushed = YES;
                NSMutableString *idsStr = [[NSMutableString alloc]initWithString:@"[]"];
                NSMutableArray *idsArr = [[NSMutableArray alloc]init];
                NSMutableArray *payArr = [[NSMutableArray alloc]init];
                choosePayVC.type = @"shoppingCart";
                
                for (OrderModel *model in self.dataSoucer) {
                    if ([model.body.iSelect boolValue]){
                        [idsArr addObject:[NSString stringWithFormat:@"%@",model.Id]];
                        [payArr addObject:model];
                    }
                }
                
                for (int i = 0; i < payArr.count; i++) {
                    OrderModel *model = payArr[i];
                    [self.dataSoucer removeObject:model];
                }
                
                [self.tableView removeFromSuperview];
                self.tableView = nil;
                [self.view addSubview:self.tableView];
                
                [self.tableView reloadData];
                
                self.payArr = [NSArray arrayWithArray:payArr];
                NSString *str = [idsArr componentsJoinedByString:@","];
                
                [idsStr insertString:str atIndex:1];
                
                choosePayVC.idsStr = idsStr;
                choosePayVC.shopCartVC = self.vc;
                choosePayVC.orderType = self.orderType;
                choosePayVC.orderAddress = self.addressId;
                choosePayVC.isInspection = self.isInspection;
                
                NSLog(@"%@",idsStr);
                //choosePayVC.urlString = urlString;
                [self.navigationController pushViewController:choosePayVC animated:YES];
                NSLog(@"结账");

            }
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.hud hideAnimated:YES];
        ChoosePayViewController *choosePayVC = [[ChoosePayViewController alloc]init];
        choosePayVC .hidesBottomBarWhenPushed = YES;
        NSMutableString *idsStr = [[NSMutableString alloc]initWithString:@"[]"];
        NSMutableArray *idsArr = [[NSMutableArray alloc]init];
        NSMutableArray *payArr = [[NSMutableArray alloc]init];
        choosePayVC.type = @"shoppingCart";
        
        for (OrderModel *model in self.dataSoucer) {
            if ([model.body.iSelect boolValue]){
                [idsArr addObject:[NSString stringWithFormat:@"%@",model.Id]];
                [payArr addObject:model];
            }
        }
        
        for (int i = 0; i < payArr.count; i++) {
            OrderModel *model = payArr[i];
            [self.dataSoucer removeObject:model];
        }
        
        [self.tableView removeFromSuperview];
        self.tableView = nil;
        [self.view addSubview:self.tableView];
        
        [self.tableView reloadData];
        
        self.payArr = [NSArray arrayWithArray:payArr];
        NSString *str = [idsArr componentsJoinedByString:@","];
        
        [idsStr insertString:str atIndex:1];
        
        choosePayVC.idsStr = idsStr;
        choosePayVC.shopCartVC = self.vc;
        choosePayVC.orderType = self.orderType;
        choosePayVC.orderAddress = self.addressId;
        choosePayVC.isInspection = self.isInspection;
        
        NSLog(@"%@",idsStr);
        //choosePayVC.urlString = urlString;
        [self.navigationController pushViewController:choosePayVC animated:YES];
        NSLog(@"结账");

    }];
}

- (NSMutableArray *)couponsArr
{
    if (_couponsArr == nil) {
        _couponsArr = [NSMutableArray new];
    }
    return _couponsArr;
}


#pragma mark 全选事件
- (void)selectAllClick {
    
    
    self.selectAllBtn.selected = !self.selectAllBtn.selected;
    
    self.count = 0;
    self.oCount = 0;
    self.ooCount = 0;
    if (self.selectAllBtn.selected) {
        int tmpNum = 0;
        for (OrderModel *model in self.dataSoucer) {
            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:0 inSection:tmpNum];
            ShoppingCartCell *cell = [self.tableView cellForRowAtIndexPath:tmpIndexPath];
            
            NSDateFormatter * df = [[NSDateFormatter alloc] init];
               df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
               
           NSString * dateString2 = model.created_at;
           
           NSDate *date1 = [NSDate date];
           NSDate *date2 = [df dateFromString:dateString2];
           
           
           NSTimeInterval time = [date1 timeIntervalSinceDate:date2];

            if (time < 86400) {
                model.body.iSelect = @YES;
                               self.oCount += [model.price floatValue] * [model.quantity integerValue];
                               self.count  += [model.price floatValue] * [model.quantity integerValue];
                               self.ooCount += [model.tax floatValue] * [model.quantity integerValue];
            }
            
//            if (cell.forthcomingCollectionLb.hidden == YES) {
//                model.body.iSelect = @YES;
//                self.oCount += [model.price floatValue] * [model.quantity integerValue];
//                self.count  += [model.price floatValue] * [model.quantity integerValue];
//                self.ooCount += [model.tax floatValue] * [model.quantity integerValue];
//            }
            tmpNum++;
        }
        [self showMoney];
    }else{
        for (OrderModel *model in self.dataSoucer) {
            
            model.body.iSelect = @NO;
        }
        self.oCount = 0;
        self.ooCount = 0;
        self.countLa.text = [NSString stringWithFormat:@"%@：¥0.00",NSLocalizedString(@"GlobalBuyer_Shopcart_Allprice", nil)];
    }
    [self.tableView reloadData];
    
    
}

-(void)backClick{
    if (self.isAutoPush) {
        NSArray<RootViewController *> *controllers = self.navigationController.viewControllers;
        [self.navigationController popToViewController:controllers[controllers.count-3] animated:YES]; //屏蔽上层购物车页面
    }else{
        [super backClick];
    }
}




#pragma mark view生命周期
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!UserDefaultObjectForKey(USERTOKEN)) {
        [self.dataSoucer removeAllObjects];
        [self.tableView reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.translucent =NO;
    //    NSLog(@"传过来的数据%@",model.shop_source);
//    for (OrderModel *model in self.dataSoucer) {
//        model.body.iSelect = @NO;
//    }
//    [self.tableView reloadData];
//    NSString *str = [NSString stringWithFormat:@"%@：¥0.00",NSLocalizedString(@"GlobalBuyer_Shopcart_Allprice", nil)];
//    self.countLa.text = str;
//    self.count = 0.0;
//    self.oCount = 0;
//    self.ooCount = 0;
//    self.selectAllBtn.selected = NO;
    
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
