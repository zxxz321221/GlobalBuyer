//
//  ShopCartSettlementDetailsViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/12/24.
//  Copyright © 2018年 薛铭. All rights reserved.
//

#import "ShopCartSettlementDetailsViewController.h"
#import "DirectMailAddressViewController.h"
#import "OrderModel.h"
#import "CurrencyCalculation.h"
#import "SelectCouponViewController.h"
#import "ChoosePayViewController.h"
#import "AddressViewController.h"
#import "AddressModel.h"

@interface ShopCartSettlementDetailsViewController ()<DirectMailAddressViewControllerDelegate,UITextFieldDelegate,SelectCouponViewDelegate,AddressViewControllerDelegate>
{
    BOOL isKai;//yes已填写发票信息 no未填写
}
@property (nonatomic,strong)UIView *backCoverV;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)NSString *addressId;//地址
@property (nonatomic,strong)UIView *addressV;
@property (nonatomic,strong)UILabel *addressNameLb;
@property (nonatomic,strong)UILabel *addressPhoneLb;
@property (nonatomic,strong)UILabel *addressLb;
@property (nonatomic,strong)UIView *buyTypeV;
@property (nonatomic,strong)NSString *buyType;//direct直邮 storage集货
@property (nonatomic,strong)NSString *inspect;//1验货 0不验货
@property (nonatomic,strong)UILabel *buyTypeLb;
@property (nonatomic,strong)UILabel *inspectLb;
@property (nonatomic,strong)UIView *selectBuyTypeV;
@property (nonatomic,strong)UIButton *directBtn;
@property (nonatomic,strong)UIButton *storageBtn;
@property (nonatomic,strong)UILabel *buyTypeContentLb;
@property (nonatomic,strong)UIView *selectInspectTypeV;
@property (nonatomic,strong)UIButton *inspectBtn;
@property (nonatomic,strong)UIButton *noInspectBtn;
@property (nonatomic,strong)UILabel *inspectTypeContentLb;
@property (nonatomic,strong)UIView *invoiceV;
@property (nonatomic,strong)UILabel *invoiceLb;
@property (nonatomic,strong)UIView *selectInvoiceTypeV;
@property (nonatomic,strong)UIButton *pBtn;
@property (nonatomic,strong)UIButton *cBtn;
@property (nonatomic,strong)NSString *invoiceYesOrNo;//是否
@property (nonatomic,strong)NSMutableDictionary *invoiceDict;//发票
@property (nonatomic,strong)UITextField *nameTf;
@property (nonatomic,strong)UITextField *ubnTf;
@property (nonatomic,strong)UITextField *emailTf;
@property (nonatomic,strong)UILabel *couponLb;
@property (nonatomic,strong)NSString *couponCode;//优惠劵
@property (nonatomic,strong)UIView *goodsPriceV;
@property (nonatomic,strong)UILabel *goodsPriceLb;
@property (nonatomic,strong)UILabel *serviceChargeLb;
@property (nonatomic,strong)UILabel *leftReduceServiceChargeLb;
@property (nonatomic,strong)UILabel *reduceServiceChargeLb;
@property (nonatomic,strong)UIView *bottomV;
@property (nonatomic,strong)UILabel *allPriceLb;
@property (nonatomic , strong) AddressModel * model;

@property (nonatomic,strong)NSMutableDictionary * cDic;//公司发票对象
@property (nonatomic,strong)NSMutableDictionary * pDic;//个人发票对象
@end

@implementation ShopCartSettlementDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.buyType = @"direct";
    self.inspect = @"0";
    isKai=NO;
    self.invoiceYesOrNo = @"NO";
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self requestInvoiceInfo];
    if (self.addressId) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":api_token};
    
    [manager POST:GetAddressApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [self.addressDataSource removeAllObjects];
            for (NSDictionary *dict in responseObject[@"data"]) {
                [self.addressDataSource addObject:dict];
            }
            if (self.addressDataSource.count != 0) {
                [self.addressV removeFromSuperview];
                self.addressV = nil;
                [self.scrollView addSubview:self.addressV];
                self.addressNameLb.text = self.addressDataSource[0][@"fullname"];
                self.addressPhoneLb.text = self.addressDataSource[0][@"mobile_phone"];
                self.addressLb.text = self.addressDataSource[0][@"address"];
                self.addressId = self.addressDataSource[0][@"id"];
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
    
}

- (NSMutableDictionary *)invoiceDict{
    if (_invoiceDict == nil) {
        _invoiceDict = [[NSMutableDictionary alloc]init];
    }
    return _invoiceDict;
}

- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"填写订单", nil);
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.backCoverV];
    [self.view addSubview:self.bottomV];
    [self.view addSubview:self.selectBuyTypeV];
    [self.view addSubview:self.selectInspectTypeV];
    [self.view addSubview:self.selectInvoiceTypeV];
}

- (UIView *)backCoverV{
    if (_backCoverV == nil) {
        _backCoverV = [[UIView alloc]initWithFrame:self.view.bounds];
        _backCoverV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _backCoverV.hidden = YES;
    }
    return _backCoverV;
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW , kScreenH - kNavigationBarH)];
        _scrollView.backgroundColor = Cell_BgColor;
        _scrollView.contentSize = CGSizeMake(0, self.payArr.count*150 + 515);
        [_scrollView addSubview:self.addressV];
        [_scrollView addSubview:self.buyTypeV];
        for (int i = 0 ; i < self.payArr.count; i++) {
            OrderModel *model = self.payArr[i];
            UIView *goodsBackV = [[UIView alloc]initWithFrame:CGRectMake(10, 220 + 150*i, kScreenW - 20, 140)];
            goodsBackV.backgroundColor = [UIColor whiteColor];
            UIImageView *goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
            if ([model.body.picture hasPrefix:@"https:"] || [model.body.picture hasPrefix:@"http:"]) {
                [goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.body.picture ] ]placeholderImage:[UIImage imageNamed:@"goods.png"]];
            }else {
                [goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https:%@",model.body.picture ] ]placeholderImage:[UIImage imageNamed:@"goods.png"]];
            }
            [goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.body.picture]]];
            [goodsBackV addSubview:goodsImage];
            
            UILabel *nameLb = [[UILabel alloc]initWithFrame:CGRectMake(120, 10, kScreenW - 150, 40)];
            nameLb.text = [NSString stringWithFormat:@"%@",model.body.name];
            nameLb.font = [UIFont systemFontOfSize:12];
            [goodsBackV addSubview:nameLb];
            
            UILabel *priceLb = [[UILabel alloc]initWithFrame:CGRectMake(120, 70, 200, 30)];
            priceLb.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
            NSString *moneyTypeName;
            if ([model.body.currency isEqualToString:@"CNY"]) {
                moneyTypeName = @"CNY";
                priceLb.text = [NSString stringWithFormat:@"%@%.2f",moneyTypeName,[model.price floatValue] ];
            }
            if ([model.body.currency isEqualToString:@"TWD"]) {
                moneyTypeName = NSLocalizedString(@"TWD", nil);
                priceLb.text = [NSString stringWithFormat:@"%.2f%@",[model.price floatValue],moneyTypeName ];
            }
            if ([model.body.currency isEqualToString:@"USD"]) {
                moneyTypeName = @"USD";
                priceLb.text = [NSString stringWithFormat:@"%@%.2f",moneyTypeName,[model.price floatValue] ];
            }
            if ([model.body.currency isEqualToString:@"JPY"]) {
                moneyTypeName = @"JPY";
                priceLb.text = [NSString stringWithFormat:@"%.2f%@",[model.price floatValue],moneyTypeName ];
            }
            if ([model.body.currency isEqualToString:@"EUR"]) {
                moneyTypeName = @"EUR";
                priceLb.text = [NSString stringWithFormat:@"%@%.2f",moneyTypeName,[model.price floatValue] ];
            }
            if ([model.body.currency isEqualToString:@"GBP"]) {
                moneyTypeName = @"GBP";
                priceLb.text = [NSString stringWithFormat:@"%@%.2f",moneyTypeName,[model.price floatValue] ];
            }
            if ([model.body.currency isEqualToString:@"AUD"]) {
                moneyTypeName = @"AUD";
                priceLb.text = [NSString stringWithFormat:@"%.2f%@",[model.price floatValue],moneyTypeName ];
            }
            if ([model.body.currency isEqualToString:@"KRW"]) {
                moneyTypeName = @"KRW";
                priceLb.text = [NSString stringWithFormat:@"%.2f%@",[model.price floatValue],moneyTypeName ];
            }
            [goodsBackV addSubview:priceLb];
            
            UILabel *numberLb = [[UILabel alloc]initWithFrame:CGRectMake(goodsBackV.frame.size.width - 60, 50, 50, 50)];
            numberLb.text = [NSString stringWithFormat:@"x%@",model.quantity];
            numberLb.textAlignment = NSTextAlignmentRight;
            numberLb.font = [UIFont systemFontOfSize:15];
            [goodsBackV addSubview:numberLb];
            
            if ([model.buy_type isEqualToString:@"item-price"]) {
                
                UILabel *goodsPriceLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 105, 170, 30)];
                goodsPriceLb.font = [UIFont systemFontOfSize:14];
                NSString *tmpStr = NSLocalizedString(@"GlobalBuyer_Amazon_FixedpriceAll", nil);
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:%@",tmpStr,[CurrencyCalculation calculationCurrencyCalculation:[model.price floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:model.body.currency numberOfGoods:[model.quantity floatValue] freight:0.0 serviceCharge:0.0 exciseTax:0.0]]];
                [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1] range:NSMakeRange(tmpStr.length+1, [CurrencyCalculation calculationCurrencyCalculation:[model.price floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:model.body.currency numberOfGoods:[model.quantity floatValue] freight:0.0 serviceCharge:0.0 exciseTax:0.0].length)];
                goodsPriceLb.attributedText = attStr;
                [goodsBackV addSubview:goodsPriceLb];
                
                
            }else{
                UILabel *exciseTaxLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 200, 105, 170, 30)];
                exciseTaxLb.font = [UIFont systemFontOfSize:14];
                exciseTaxLb.textAlignment = NSTextAlignmentRight;
                NSString *tmpStrR = NSLocalizedString(@"GlobalBuyer_Entrust_secondPayDetailsLb", nil);
                NSMutableAttributedString *attStrR = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:%@",tmpStrR,[CurrencyCalculation calculationCurrencyCalculation:0.0 moneytypeArr:self.moneytypeArr currentCommodityCurrency:model.body.currency numberOfGoods:1.0 freight:0.0 serviceCharge:0.0 exciseTax:([model.tax floatValue] * [model.quantity floatValue])]]];
                [attStrR addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1] range:NSMakeRange(tmpStrR.length+1, [CurrencyCalculation calculationCurrencyCalculation:0.0 moneytypeArr:self.moneytypeArr currentCommodityCurrency:model.body.currency numberOfGoods:1.0 freight:0.0 serviceCharge:0.0 exciseTax:([model.tax floatValue] * [model.quantity floatValue])].length)];
                exciseTaxLb.attributedText = attStrR;
                [goodsBackV addSubview:exciseTaxLb];
                
                
                UILabel *goodsPriceLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 105, 170, 30)];
                goodsPriceLb.font = [UIFont systemFontOfSize:14];
                NSString *tmpStr = NSLocalizedString(@"GlobalBuyer_Entrust_commodityCostLb", nil);
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:%@",tmpStr,[CurrencyCalculation calculationCurrencyCalculation:[model.price floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:model.body.currency numberOfGoods:[model.quantity floatValue] freight:0.0 serviceCharge:0.0 exciseTax:0.0]]];
                [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1] range:NSMakeRange(tmpStr.length+1, [CurrencyCalculation calculationCurrencyCalculation:[model.price floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:model.body.currency numberOfGoods:[model.quantity floatValue] freight:0.0 serviceCharge:0.0 exciseTax:0.0].length)];
                goodsPriceLb.attributedText = attStr;
                [goodsBackV addSubview:goodsPriceLb];
            }
            [_scrollView addSubview:goodsBackV];
        }
        [_scrollView addSubview:self.invoiceV];
        [_scrollView addSubview:self.goodsPriceV];
    }
    return _scrollView;
}

- (UIView *)addressV{
    if (_addressV == nil) {
        _addressV = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenW - 20, 100)];
        _addressV.backgroundColor = [UIColor whiteColor];
        _addressV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectAddress)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_addressV addGestureRecognizer:tap];
        if (self.addressDataSource.count == 0) {
            UIImageView *noAddressIv = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2 - 35, 15, 70, 70)];
            noAddressIv.userInteractionEnabled = YES;
            noAddressIv.image = [UIImage imageNamed:@"AddAddress"];
            [_addressV addSubview:noAddressIv];
            UITapGestureRecognizer *addAddressTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addAddress)];
            addAddressTap.numberOfTouchesRequired = 1;
            addAddressTap.numberOfTapsRequired = 1;
            [noAddressIv addGestureRecognizer:addAddressTap];
        }else{
            self.addressId = [NSString stringWithFormat:@"%@",self.addressDataSource[0][@"id"]];
            self.addressNameLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 110, 30)];
            self.addressNameLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_Shopcart_Consignee", nil),self.addressDataSource[0][@"fullname"]];
            self.addressNameLb.font = [UIFont systemFontOfSize:12];
            [_addressV addSubview:self.addressNameLb];
            self.addressPhoneLb = [[UILabel alloc]initWithFrame:CGRectMake(130, 10, 200, 30)];
            self.addressPhoneLb.text = [NSString stringWithFormat:@"%@",self.addressDataSource[0][@"mobile_phone"]];
            [_addressV addSubview:self.addressPhoneLb];
            self.addressPhoneLb.font = [UIFont systemFontOfSize:12];
            self.addressLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, _addressV.frame.size.width - 50, 45)];
            self.addressLb.numberOfLines = 0;
            self.addressLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_Tabview_Cell_Add", nil),self.addressDataSource[0][@"address"]];
            self.addressLb.font = [UIFont systemFontOfSize:12];
            [_addressV addSubview:self.addressLb];
            UIImageView *lineV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 97, _addressV.frame.size.width, 3)];
            lineV.image = [UIImage imageNamed:@"order_line"];
            [_addressV addSubview:lineV];
            UIImageView *arrowV = [[UIImageView alloc]initWithFrame:CGRectMake(_addressV.frame.size.width -  35, 35, 30, 30)];
            arrowV.image = [UIImage imageNamed:@"tipsarrow"];
            [_addressV addSubview:arrowV];
        }
    }
    return _addressV;
}

- (void)addAddress{
    AddressViewController *addressVC = [AddressViewController new];
    [self.navigationController pushViewController:addressVC animated:YES];
}

- (void)selectAddress
{
//    DirectMailAddressViewController *dmaVC = [[DirectMailAddressViewController alloc]init];
//    dmaVC.dataSource = self.addressDataSource;
//    dmaVC.delegate = self;
//    [self.navigationController pushViewController:dmaVC animated:YES];
    AddressViewController *addressVC = [AddressViewController new];
    addressVC.istrue = YES;
    addressVC.delegate=self;
    addressVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addressVC animated:YES];
}

- (void)changeAddress:(AddressModel *)model{
    
    NSLog(@"选中的%@",model);
//    self.model = [[AddressModel alloc]initWithDictionary:addressInfo error:nil];
    self.addressNameLb.text = model.fullname;
    self.addressPhoneLb.text = model.mobile_phone;
    self.addressLb.text = model.address;
    self.addressId = [model.Id stringValue];
}

- (UIView *)buyTypeV{
    if (_buyTypeV == nil) {
        _buyTypeV = [[UIView alloc]initWithFrame:CGRectMake(10, 120, kScreenW - 20, 90)];
        _buyTypeV.backgroundColor = [UIColor whiteColor];
        UILabel *leftTypeLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
        leftTypeLb.font = [UIFont systemFontOfSize:15];
        leftTypeLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_SelectPurchaseMode", nil);
        [_buyTypeV addSubview:leftTypeLb];
        self.buyTypeLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 160, 10, 100, 30)];
        self.buyTypeLb.textAlignment = NSTextAlignmentRight;
        self.buyTypeLb.font = [UIFont systemFontOfSize:15];
        self.buyTypeLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_DirectMail", nil);
        [_buyTypeV addSubview:self.buyTypeLb];
        UIImageView *buyTypeMore = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW - 53, 21, 20, 7)];
        buyTypeMore.image = [UIImage imageNamed:@"order_choose_more"];
        [_buyTypeV addSubview:buyTypeMore];
        UIView *tapIv = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreenW - 20, 30)];
        tapIv.backgroundColor = [UIColor clearColor];
        tapIv.userInteractionEnabled = YES;
        [_buyTypeV addSubview:tapIv];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectBuyType)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [tapIv addGestureRecognizer:tap];
        
        
        UILabel *leftInspect = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 100, 30)];
        leftInspect.font = [UIFont systemFontOfSize:15];
        leftInspect.text = NSLocalizedString(@"GlobalBuyer_Shopcart_SelectInspection", nil);
        [_buyTypeV addSubview:leftInspect];
        self.inspectLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 160, 50, 100, 30)];
        self.inspectLb.textAlignment = NSTextAlignmentRight;
        self.inspectLb.font = [UIFont systemFontOfSize:15];
        self.inspectLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_NoInspection", nil);
        [_buyTypeV addSubview:self.inspectLb];
        UIImageView *inspectMore = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW - 53, 61, 20, 7)];
        inspectMore.image = [UIImage imageNamed:@"order_choose_more"];
        [_buyTypeV addSubview:inspectMore];
        UIView *tapTwoIv = [[UIView alloc]initWithFrame:CGRectMake(0, 50, kScreenW - 20, 30)];
        tapTwoIv.backgroundColor = [UIColor clearColor];
        tapTwoIv.userInteractionEnabled = YES;
        [_buyTypeV addSubview:tapTwoIv];
        UITapGestureRecognizer *tapTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectInspectType)];
        tapTwo.numberOfTapsRequired = 1;
        tapTwo.numberOfTouchesRequired = 1;
        [tapTwoIv addGestureRecognizer:tapTwo];
    }
    return _buyTypeV;
}

- (void)selectBuyType{
    self.selectBuyTypeV.hidden = NO;
    self.backCoverV.hidden = NO;
}

- (void)selectInspectType{
    self.selectInspectTypeV.hidden = NO;
    self.backCoverV.hidden = NO;
}

- (UIView *)selectBuyTypeV{
    if (_selectBuyTypeV == nil) {
        _selectBuyTypeV = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH - 400, kScreenW, 400)];
        _selectBuyTypeV.backgroundColor = [UIColor whiteColor];
        _selectBuyTypeV.hidden = YES;
        
        UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/2 - 100, 30, 200, 40)];
        titleLb.font = [UIFont systemFontOfSize:16];
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_SelectPurchaseMode", nil);
        [_selectBuyTypeV addSubview:titleLb];
        
        UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 60, 40, 20, 20)];
        [closeBtn setImage:[UIImage imageNamed:@"selection_close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBuyTypeV) forControlEvents:UIControlEventTouchUpInside];
        [_selectBuyTypeV addSubview:closeBtn];
        
        self.directBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 80, 80, 30)];
        self.directBtn.layer.cornerRadius = 15;
        self.directBtn.layer.borderWidth = 0.5;
        self.directBtn.layer.borderColor = [UIColor redColor].CGColor;
        self.directBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.directBtn setTitle:NSLocalizedString(@"GlobalBuyer_Shopcart_DirectMail", nil) forState:UIControlStateNormal];
        [self.directBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.directBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_selectBuyTypeV addSubview:self.directBtn];
        self.directBtn.selected = YES;
        [self.directBtn addTarget:self action:@selector(selectDirect) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.storageBtn = [[UIButton alloc]initWithFrame:CGRectMake(120, 80, 80, 30)];
        self.storageBtn.layer.cornerRadius = 15;
        self.storageBtn.layer.borderWidth = 0.5;
        self.storageBtn.layer.borderColor = [UIColor blackColor].CGColor;
        self.storageBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.storageBtn setTitle:NSLocalizedString(@"GlobalBuyer_Shopcart_Collect", nil) forState:UIControlStateNormal];
        [self.storageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.storageBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_selectBuyTypeV addSubview:self.storageBtn];
        [self.storageBtn addTarget:self action:@selector(selectStorage) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.buyTypeContentLb = [[UILabel alloc]initWithFrame:CGRectMake(20, 120, kScreenW - 40, 280)];
        self.buyTypeContentLb.numberOfLines = 0;
        self.buyTypeContentLb.font = [UIFont systemFontOfSize:12];
        
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
        
        
        self.buyTypeContentLb.text = allStr;
        [self.buyTypeContentLb sizeToFit];
        [_selectBuyTypeV addSubview:self.buyTypeContentLb];
    }
    return _selectBuyTypeV;
}

- (void)closeBuyTypeV{
    self.backCoverV.hidden = YES;
    self.selectBuyTypeV.hidden = YES;
}

- (void)selectDirect{
    self.directBtn.selected = YES;
    self.storageBtn.selected = NO;
    self.directBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.storageBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.buyType = @"direct";
    self.buyTypeLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_DirectMail", nil);
    
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
    
    
    self.buyTypeContentLb.text = allStr;
    [self.buyTypeContentLb sizeToFit];
}

- (void)selectStorage{
    self.directBtn.selected = NO;
    self.storageBtn.selected = YES;
    self.directBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.storageBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.buyType = @"storage";
    self.buyTypeLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_Collect", nil);
    
    
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
    
    
    self.buyTypeContentLb.text = allStr;
    [self.buyTypeContentLb sizeToFit];
}

- (UIView *)selectInspectTypeV{
    if (_selectInspectTypeV == nil) {
        _selectInspectTypeV = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH - 400, kScreenW, 400)];
        _selectInspectTypeV.backgroundColor = [UIColor whiteColor];
        _selectInspectTypeV.hidden = YES;
        
        UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/2 - 100, 30, 200, 40)];
        titleLb.font = [UIFont systemFontOfSize:16];
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_SelectInspection", nil);
        [_selectInspectTypeV addSubview:titleLb];
        
        UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 60, 40, 20, 20)];
        [closeBtn setImage:[UIImage imageNamed:@"selection_close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeInspectTypeV) forControlEvents:UIControlEventTouchUpInside];
        [_selectInspectTypeV addSubview:closeBtn];
        
        self.inspectBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 80, 80, 30)];
        self.inspectBtn.layer.cornerRadius = 15;
        self.inspectBtn.layer.borderWidth = 0.5;
        self.inspectBtn.layer.borderColor = [UIColor blackColor].CGColor;
        self.inspectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.inspectBtn setTitle:NSLocalizedString(@"GlobalBuyer_Shopcart_Inspection", nil) forState:UIControlStateNormal];
        [self.inspectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.inspectBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_selectInspectTypeV addSubview:self.inspectBtn];
        
        [self.inspectBtn addTarget:self action:@selector(selectInspect) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.noInspectBtn = [[UIButton alloc]initWithFrame:CGRectMake(120, 80, 80, 30)];
        self.noInspectBtn.layer.cornerRadius = 15;
        self.noInspectBtn.layer.borderWidth = 0.5;
        self.noInspectBtn.layer.borderColor = [UIColor redColor].CGColor;
        self.noInspectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.noInspectBtn setTitle:NSLocalizedString(@"GlobalBuyer_Shopcart_NoInspection", nil) forState:UIControlStateNormal];
        [self.noInspectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.noInspectBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        self.noInspectBtn.selected = YES;
        [_selectInspectTypeV addSubview:self.noInspectBtn];
        [self.noInspectBtn addTarget:self action:@selector(selectNoInspect) forControlEvents:UIControlEventTouchUpInside];
        
        self.inspectTypeContentLb = [[UILabel alloc]initWithFrame:CGRectMake(20, 120, kScreenW - 40, 280)];
        self.inspectTypeContentLb.numberOfLines = 0;
        self.inspectTypeContentLb.font = [UIFont systemFontOfSize:12];
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
        
        
        self.inspectTypeContentLb.text = allStr;
        [self.inspectTypeContentLb sizeToFit];
        [_selectInspectTypeV addSubview:self.inspectTypeContentLb];
    }
    return _selectInspectTypeV;
}

- (void)closeInspectTypeV{
    self.backCoverV.hidden = YES;
    self.selectInspectTypeV.hidden = YES;
}

- (void)selectInspect{
    self.inspectBtn.selected = YES;
    self.noInspectBtn.selected = NO;
    self.inspectBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.noInspectBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.inspect = @"1";
    self.inspectLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_Inspection", nil);
    
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
    
    
    self.inspectTypeContentLb.text = allStr;
    [self.inspectTypeContentLb sizeToFit];
}

- (void)selectNoInspect{
    self.inspectBtn.selected = NO;
    self.noInspectBtn.selected = YES;
    self.inspectBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.noInspectBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.inspect = @"0";
    self.inspectLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_NoInspection", nil);
    
    self.inspectTypeContentLb.text = @"";
    [self.inspectTypeContentLb sizeToFit];
}

- (UIView *)invoiceV{
    if (_invoiceV == nil) {
        _invoiceV = [[UIView alloc]initWithFrame:CGRectMake(10, 220 + self.payArr.count*150, kScreenW - 20, 90)];
        _invoiceV.backgroundColor = [UIColor whiteColor];
        UILabel *leftTypeLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
        leftTypeLb.font = [UIFont systemFontOfSize:15];
        leftTypeLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_Invoice", nil);
        [_invoiceV addSubview:leftTypeLb];
        self.invoiceLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 160, 10, 100, 30)];
        self.invoiceLb.textAlignment = NSTextAlignmentRight;
        self.invoiceLb.font = [UIFont systemFontOfSize:15];
        self.invoiceLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_NOInvoice", nil);
        [_invoiceV addSubview:self.invoiceLb];
        UIImageView *buyTypeMore = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW - 53, 21, 20, 7)];
        buyTypeMore.image = [UIImage imageNamed:@"order_choose_more"];
        [_invoiceV addSubview:buyTypeMore];
        UIView *tapIv = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreenW - 20, 30)];
        tapIv.backgroundColor = [UIColor clearColor];
        tapIv.userInteractionEnabled = YES;
        [_invoiceV addSubview:tapIv];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectInvoiceType)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [tapIv addGestureRecognizer:tap];
        
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"currencySign"]isEqualToString:@"TAIWAN"]) {
            leftTypeLb.hidden = NO;
            self.invoiceLb.hidden = NO;
            buyTypeMore.hidden = NO;
//            [self selectInvoiceType];
        }else{
            leftTypeLb.hidden = YES;
            self.invoiceLb.hidden = YES;
            buyTypeMore.hidden = YES;
        }
        
        UILabel *leftInspect = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 100, 30)];
        leftInspect.font = [UIFont systemFontOfSize:15];
        leftInspect.text = NSLocalizedString(@"GlobalBuyer_My_Tabview_Coupon", nil);
        [_invoiceV addSubview:leftInspect];
        self.couponLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 160, 50, 100, 30)];
        self.couponLb.textAlignment = NSTextAlignmentRight;
        self.couponLb.font = [UIFont systemFontOfSize:15];
        self.couponLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_Coupon_NO", nil);
        [_invoiceV addSubview:self.couponLb];
        UIImageView *inspectMore = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW - 53, 61, 20, 7)];
        inspectMore.image = [UIImage imageNamed:@"order_choose_more"];
        [_invoiceV addSubview:inspectMore];
        UIView *tapTwoIv = [[UIView alloc]initWithFrame:CGRectMake(0, 50, kScreenW - 20, 30)];
        tapTwoIv.backgroundColor = [UIColor clearColor];
        tapTwoIv.userInteractionEnabled = YES;
        [_invoiceV addSubview:tapTwoIv];
        UITapGestureRecognizer *tapTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectCouponType)];
        tapTwo.numberOfTapsRequired = 1;
        tapTwo.numberOfTouchesRequired = 1;
        [tapTwoIv addGestureRecognizer:tapTwo];
    }
    return _invoiceV;
}

- (void)selectCouponType{
    SelectCouponViewController *vc = [[SelectCouponViewController alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)isSelectCoupon:(NSString *)couponCode{
    self.couponCode = couponCode;
    self.leftReduceServiceChargeLb.hidden = NO;
    self.reduceServiceChargeLb.hidden = NO;
    self.couponLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_Coupon_YES", nil);
    self.allPriceLb.text = [CurrencyCalculation calculationCurrencyCalculation:self.count moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.currency numberOfGoods:1.0 freight:0.0 serviceCharge:0.0 exciseTax:self.ooCount];
}

- (void)cancelSelectCoupon{
    self.couponCode = @"";
    self.leftReduceServiceChargeLb.hidden = YES;
    self.reduceServiceChargeLb.hidden = YES;
    self.couponLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_Coupon_NO", nil);
    self.allPriceLb.text = [CurrencyCalculation calculationCurrencyCalculation:self.count moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.currency numberOfGoods:1.0 freight:0.0 serviceCharge:[self.serviceCharge floatValue] exciseTax:self.ooCount];
}

- (void)selectInvoiceType{
    self.backCoverV.hidden = NO;
    self.selectInvoiceTypeV.hidden = NO;
}

- (UIView *)selectInvoiceTypeV{
    if (_selectInvoiceTypeV == nil) {
        _selectInvoiceTypeV = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH - 500-LL_TabbarHeight, kScreenW, 500)];
        _selectInvoiceTypeV.backgroundColor = [UIColor whiteColor];
        _selectInvoiceTypeV.hidden = YES;
        
        UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW/2 - 100, 30, 200, 40)];
        titleLb.font = [UIFont systemFontOfSize:16];
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_Invoice", nil);
        [_selectInvoiceTypeV addSubview:titleLb];
        
        UILabel *titleOneLb = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 200, 40)];
        titleOneLb.font = [UIFont systemFontOfSize:15];
        titleOneLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_Invoice_Type", nil);
        [_selectInvoiceTypeV addSubview:titleOneLb];
        
        UIButton *noInvoiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 140, 40, 60, 20)];
        noInvoiceBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [noInvoiceBtn setTitle:NSLocalizedString(@"GlobalBuyer_Shopcart_NOInvoice", nil) forState:UIControlStateNormal];
        [noInvoiceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [noInvoiceBtn addTarget:self action:@selector(noInvoiceTypeV) forControlEvents:UIControlEventTouchUpInside];
        [_selectInvoiceTypeV addSubview:noInvoiceBtn];
        
        UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 60, 40, 20, 20)];
        [closeBtn setImage:[UIImage imageNamed:@"selection_close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeInvoiceTypeV) forControlEvents:UIControlEventTouchUpInside];
        [_selectInvoiceTypeV addSubview:closeBtn];
        
        self.pBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 120, 80, 30)];
        self.pBtn.layer.cornerRadius = 15;
        self.pBtn.layer.borderWidth = 0.5;
        self.pBtn.layer.borderColor = [UIColor redColor].CGColor;
        self.pBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.pBtn setTitle:NSLocalizedString(@"GlobalBuyer_Shopcart_Invoice_Type_R", nil) forState:UIControlStateNormal];
        [self.pBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.pBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_selectInvoiceTypeV addSubview:self.pBtn];
        self.pBtn.selected = YES;
        [self.pBtn addTarget:self action:@selector(selectP) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.cBtn = [[UIButton alloc]initWithFrame:CGRectMake(120, 120, 80, 30)];
        self.cBtn.layer.cornerRadius = 15;
        self.cBtn.layer.borderWidth = 0.5;
        self.cBtn.layer.borderColor = [UIColor blackColor].CGColor;
        self.cBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.cBtn setTitle:NSLocalizedString(@"GlobalBuyer_Shopcart_Invoice_Type_C", nil) forState:UIControlStateNormal];
        [self.cBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.cBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_selectInvoiceTypeV addSubview:self.cBtn];
        [self.cBtn addTarget:self action:@selector(selectC) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleTwoLb = [[UILabel alloc]initWithFrame:CGRectMake(20, 160, 200, 40)];
        titleTwoLb.font = [UIFont systemFontOfSize:15];
        titleTwoLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_Invoice_Information", nil);
        [_selectInvoiceTypeV addSubview:titleTwoLb];
        
        self.nameTf = [[UITextField alloc]initWithFrame:CGRectMake(20, 210, kScreenW - 40, 30)];
        self.nameTf.delegate = self;
        self.nameTf.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1];
        self.nameTf.layer.cornerRadius = 15;
        self.nameTf.placeholder = NSLocalizedString(@"GlobalBuyer_Shopcart_Invoice_Type_R_Name", nil);
        [_selectInvoiceTypeV addSubview:self.nameTf];
        UIImageView *starIV = [[UIImageView alloc]initWithFrame:CGRectMake(self.nameTf.frame.size.width - 20, 10, 10, 10)];
        starIV.image = [UIImage imageNamed:@"must_fill"];
        [self.nameTf addSubview:starIV];
        
        self.ubnTf = [[UITextField alloc]initWithFrame:CGRectMake(20, 250, kScreenW - 40, 30)];
        self.ubnTf.delegate = self;
        self.ubnTf.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1];
        self.ubnTf.layer.cornerRadius = 15;
        self.ubnTf.placeholder = NSLocalizedString(@"GlobalBuyer_Shopcart_Invoice_Type_C_ID", nil);
        [_selectInvoiceTypeV addSubview:self.ubnTf];
        self.ubnTf.hidden = YES;
        UIImageView *starTwoIV = [[UIImageView alloc]initWithFrame:CGRectMake(self.nameTf.frame.size.width - 20, 10, 10, 10)];
        starTwoIV.image = [UIImage imageNamed:@"must_fill"];
        [self.ubnTf addSubview:starTwoIV];
        
        self.emailTf = [[UITextField alloc]initWithFrame:CGRectMake(20, 250, kScreenW - 40, 30)];
        self.emailTf.delegate = self;
        self.emailTf.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1];
        self.emailTf.layer.cornerRadius = 15;
        self.emailTf.placeholder = NSLocalizedString(@"GlobalBuyer_Shopcart_Invoice_Type_R_Email", nil);
        [_selectInvoiceTypeV addSubview:self.emailTf];
//        UIImageView *starThreeIV = [[UIImageView alloc]initWithFrame:CGRectMake(self.nameTf.frame.size.width - 20, 10, 10, 10)];
//        starThreeIV.image = [UIImage imageNamed:@"must_fill"];
//        [self.emailTf addSubview:starThreeIV];
        
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/4 - 60, _selectInvoiceTypeV.frame.size.height - 60, 120, 40)];
        cancelBtn.layer.cornerRadius = 20;
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        cancelBtn.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1];
        [cancelBtn setTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_selectInvoiceTypeV addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(closeInvoiceTypeV) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/4*3 - 60, _selectInvoiceTypeV.frame.size.height - 60, 120, 40)];
        sureBtn.layer.cornerRadius = 20;
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        sureBtn.backgroundColor = [UIColor redColor];
        [sureBtn setTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) forState:UIControlStateNormal];
        [_selectInvoiceTypeV addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(sureInvoiceTypeV) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectInvoiceTypeV;
}

- (void)noInvoiceTypeV{
    self.backCoverV.hidden = YES;
    self.selectInvoiceTypeV.hidden = YES;
    self.invoiceYesOrNo = @"NO";
    self.invoiceLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_NOInvoice", nil);
}

- (void)closeInvoiceTypeV{
    self.backCoverV.hidden = YES;
    self.selectInvoiceTypeV.hidden = YES;
    [self.nameTf resignFirstResponder];
    [self.ubnTf resignFirstResponder];
    [self.emailTf resignFirstResponder];
}

- (void)sureInvoiceTypeV{
    if (self.pBtn.selected == YES) {
        if (self.nameTf.text.length > 0) {
            self.invoiceDict[@"inv_category"] = @"0";
            self.invoiceDict[@"inv_name"] = [NSString stringWithFormat:@"%@",self.nameTf.text];
            self.invoiceDict[@"inv_email"] = [NSString stringWithFormat:@"%@",self.emailTf.text];
            self.invoiceLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_Invoice_Type_R", nil);
            self.invoiceYesOrNo = @"YES";
            isKai = YES;
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"带*项必填", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles: nil];
            [alert show];
            return;
        }
    }else{
        if (self.nameTf.text.length > 0 && self.ubnTf.text.length > 0) {
            self.invoiceDict[@"inv_category"] = @"1";
            self.invoiceDict[@"inv_name"] = [NSString stringWithFormat:@"%@",self.nameTf.text];
            self.invoiceDict[@"inv_name"] = [NSString stringWithFormat:@"%@",self.nameTf];
            self.invoiceDict[@"inv_ubn"] = [NSString stringWithFormat:@"%@",self.ubnTf.text];
            self.invoiceDict[@"inv_email"] = [NSString stringWithFormat:@"%@",self.emailTf.text];
            self.invoiceLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_Invoice_Type_C", nil);
            self.invoiceYesOrNo = @"YES";
            isKai = YES;
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"带*项必填", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles: nil];
            [alert show];
            return;
        }
    }
    self.backCoverV.hidden = YES;
    self.selectInvoiceTypeV.hidden = YES;
    [self.nameTf resignFirstResponder];
    [self.ubnTf resignFirstResponder];
    [self.emailTf resignFirstResponder];
}

- (void)selectP{
    self.pBtn.selected = YES;
    self.cBtn.selected = NO;
    self.pBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.cBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.ubnTf.hidden = YES;
    self.emailTf.frame = CGRectMake(20, 250, kScreenW - 40, 30);
    if ([self.pDic count] != 0) {
        self.nameTf.text = [self.pDic objectForKey:@"name"];//姓名
        self.emailTf.text = [self.pDic objectForKey:@"email"];//邮箱
    }
}

- (void)selectC{
    self.pBtn.selected = NO;
    self.cBtn.selected = YES;
    self.pBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.cBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.ubnTf.hidden = NO;
    self.emailTf.frame = CGRectMake(20, 290, kScreenW - 40, 30);
    if ([self.cDic count] != 0) {
        self.nameTf.text = [self.cDic objectForKey:@"name"];//姓名
        self.ubnTf.text = [self.cDic objectForKey:@"ubn"];//统一编号
        self.emailTf.text = [self.cDic objectForKey:@"email"];//邮箱
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.nameTf resignFirstResponder];
    [self.ubnTf resignFirstResponder];
    [self.emailTf resignFirstResponder];
    return YES;
}

- (UIView *)goodsPriceV{
    if (_goodsPriceV == nil) {
        _goodsPriceV = [[UIView alloc]initWithFrame:CGRectMake(10, 320 + self.payArr.count*150, kScreenW - 20, 135)];
        _goodsPriceV.backgroundColor = [UIColor whiteColor];
        UILabel *leftTypeLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
        leftTypeLb.font = [UIFont systemFontOfSize:15];
        leftTypeLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_commodityCostLb", nil);
        [_goodsPriceV addSubview:leftTypeLb];
        self.goodsPriceLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 140, 10, 100, 30)];
        self.goodsPriceLb.textAlignment = NSTextAlignmentRight;
        self.goodsPriceLb.font = [UIFont systemFontOfSize:15];
        self.goodsPriceLb.text = [NSString stringWithFormat:@"%@",[CurrencyCalculation calculationCurrencyCalculation:self.count moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.currency numberOfGoods:1.0 freight:0.0 serviceCharge:0.0 exciseTax:self.ooCount]];
        [_goodsPriceV addSubview:self.goodsPriceLb];
        
        
        UILabel *leftInspect = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 100, 30)];
        leftInspect.font = [UIFont systemFontOfSize:15];
        leftInspect.text = NSLocalizedString(@"GlobalBuyer_Entrust_purchasingLb", nil);
        [_goodsPriceV addSubview:leftInspect];
        self.serviceChargeLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 140, 50, 100, 30)];
        self.serviceChargeLb.textAlignment = NSTextAlignmentRight;
        self.serviceChargeLb.font = [UIFont systemFontOfSize:15];
        self.serviceChargeLb.textColor = [UIColor redColor];
        self.serviceChargeLb.text = [NSString stringWithFormat:@"+%@",[CurrencyCalculation calculationCurrencyCalculation:0.0 moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.currency numberOfGoods:1.0 freight:0.0 serviceCharge:[self.serviceCharge floatValue] exciseTax:0.0]];
        [_goodsPriceV addSubview:self.serviceChargeLb];

        self.leftReduceServiceChargeLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, 100, 30)];
        self.leftReduceServiceChargeLb.font = [UIFont systemFontOfSize:15];
        self.leftReduceServiceChargeLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_purchasingLb", nil);
        [_goodsPriceV addSubview:self.leftReduceServiceChargeLb];
        self.reduceServiceChargeLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 140, 90, 100, 30)];
        self.reduceServiceChargeLb.textAlignment = NSTextAlignmentRight;
        self.reduceServiceChargeLb.font = [UIFont systemFontOfSize:15];
        self.reduceServiceChargeLb.textColor = [UIColor redColor];
        self.reduceServiceChargeLb.text = [NSString stringWithFormat:@"-%@",[CurrencyCalculation calculationCurrencyCalculation:0.0 moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.currency numberOfGoods:1.0 freight:0.0 serviceCharge:[self.serviceCharge floatValue] exciseTax:0.0]];
        [_goodsPriceV addSubview:self.reduceServiceChargeLb];
        self.leftReduceServiceChargeLb.hidden = YES;
        self.reduceServiceChargeLb.hidden = YES;
    }
    return _goodsPriceV;
}

- (UIView *)bottomV{
    if (_bottomV == nil) {
        _bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH - 60-NavBarHeight, kScreenW, 60)];
        _bottomV.backgroundColor = [UIColor whiteColor];
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
//        lineV.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1];
        lineV.backgroundColor = [UIColor lightGrayColor];
        self.allPriceLb = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 60)];
        self.allPriceLb.font = [UIFont systemFontOfSize:18];
        self.allPriceLb.textColor = [UIColor redColor];
        self.allPriceLb.text = [CurrencyCalculation calculationCurrencyCalculation:self.count moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.currency numberOfGoods:1.0 freight:0.0 serviceCharge:[self.serviceCharge floatValue] exciseTax:self.ooCount];
        [_bottomV addSubview:self.allPriceLb];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 100, 0, 100, 60)];
        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:NSLocalizedString(@"GlobalBuyer_Shopcart_Submit", nil) forState:UIControlStateNormal];
        [_bottomV addSubview:btn];
        [btn addTarget:self action:@selector(gotoPay) forControlEvents:UIControlEventTouchUpInside];
        
        
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 240, 0, 140, 60)];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_AllNotice", nil);
        lb.font = [UIFont systemFontOfSize:12];
        [_bottomV addSubview:lb];
    }
    return _bottomV;
}

- (void)gotoPay{
    if(!self.addressId){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Shopcart_Address_Tips", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles: nil];
        [alert show];
    }else{
        if (![self.invoiceYesOrNo isEqualToString:@"NO"]) {
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"currencySign"]isEqualToString:@"TAIWAN"]) {
                if (!isKai) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Shopcart_Invoice_Tips", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles: nil];
                    [alert show];
                    [self selectInvoiceType];
                    return;
                }
            }
        }
        ChoosePayViewController *choosePayVC = [[ChoosePayViewController alloc]init];
        choosePayVC .hidesBottomBarWhenPushed = YES;
        choosePayVC.idsStr = self.idsStr;
        choosePayVC.shopCartVC = self.vc;
        choosePayVC.orderType = self.buyType;
        choosePayVC.orderAddress = self.addressId;
        choosePayVC.isInspection = self.inspect;
        choosePayVC.couponsCode = self.couponCode;
        choosePayVC.invoiceDict = self.invoiceDict;
        choosePayVC.invoiceYesOrNo = self.invoiceYesOrNo;
        choosePayVC.type = @"shoppingCart";
        [self.navigationController pushViewController:choosePayVC animated:YES];
    }
    
}
//请求发票信息
- (void)requestInvoiceInfo{
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"api_id"] = API_ID;
    params[@"api_token"] = TOKEN;
    params[@"secret_key"] = userToken;

    [manager GET:@"http://buy.dayanghang.net/api/platform/web/invoicemanager/information/member" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发票信息请求返回 %@",responseObject);
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            NSArray * arr = responseObject[@"data"];
            if (arr.count != 0) {
                for (int i=0; i<arr.count; i++) {
                    if ([[arr[i]objectForKey:@"category"]intValue] == 1) {
                        [arr[i] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                            NSLog(@"key = %@, value = %@", key, obj);
                            if ([obj isKindOfClass:[NSNull class]]) {
                                obj = @"";
                            }
                            [self.cDic setObject:obj forKey:key];
                        }];
                    }else{
                        [arr[i] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                            NSLog(@"key = %@, value = %@", key, obj);
                            if ([obj isKindOfClass:[NSNull class]]) {
                                obj = @"";
                            }
                            [self.pDic setObject:obj forKey:key];
                        }];
                        self.nameTf.text = [self.pDic objectForKey:@"name"];//姓名
                        self.emailTf.text = [self.pDic objectForKey:@"email"];//邮箱
                    }
                }
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}
- (NSMutableDictionary *)cDic
{
    if (_cDic == nil) {
        _cDic = [[NSMutableDictionary alloc]init];
    }
    return _cDic;
}
- (NSMutableDictionary *)pDic
{
    if (_pDic == nil) {
        _pDic = [[NSMutableDictionary alloc]init];
    }
    return _pDic;
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
