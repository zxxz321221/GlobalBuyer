//
//  TaobaoTransportApplyViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/8/1.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "TaobaoTransportApplyViewController.h"
#import "FileArchiver.h"
#import "AddressViewController.h"
#import "DirectMailAddressViewController.h"
#import "BindIDViewController.h"
#import "TransshipmentResultsViewController.h"
#import "CustomsCategoryViewController.h"
#import "HelpDetailViewController.h"

@interface TaobaoTransportApplyViewController ()<CustomsCategoryDelegate,UITextFieldDelegate,AddressViewControllerDelegate>
{
    BOOL isKai;//yes发票信息已填写  no未填写发票信息
}
@property (nonatomic,strong)NSMutableArray *selectCountryArr;
@property (nonatomic,strong)UIView *choiceCurrencyV;
@property (nonatomic,assign)NSInteger countryTag;
@property (nonatomic,strong)UILabel *placeOfReceiptRightLb;
@property (nonatomic,strong)NSMutableArray *addressDataSource;
@property (nonatomic, strong)NSString *addressId;
@property (nonatomic, strong)UILabel *nameLb;
@property (nonatomic, strong)UILabel *phoneLb;
@property (nonatomic, strong)UILabel *addressLb;
@property (nonatomic, assign)int bindNum;

@property (nonatomic,strong)NSMutableArray *screenGoods;
@property (nonatomic,strong)UIScrollView *allBackSv;
@property (nonatomic,strong)UIView *goodsBackV;

@property (nonatomic,strong)UIView *transportBackV;

@property (nonatomic,strong)UIView *taobaoTransportChangeBackV;

@property (nonatomic,strong)UIButton *sureBtn;

@property (nonatomic,strong)NSString *currentCountrySign;
@property (nonatomic,assign)NSInteger currentCateLb;
@property (nonatomic,strong)NSMutableArray *goodsInfo;
@property (nonatomic,strong)UILabel *tmpLb;

@property (nonatomic,strong)UIView *tipsV;
@property (nonatomic,strong) MBProgressHUD *hud;

@property (nonatomic,strong)UIView *backCoverV;
@property (nonatomic,strong)UILabel *invoiceLb;
@property (nonatomic,strong)UIView *selectInvoiceTypeV;
@property (nonatomic,strong)UIButton *pBtn;
@property (nonatomic,strong)UIButton *cBtn;
@property (nonatomic,strong)NSString *invoiceYesOrNo;//是否
@property (nonatomic,strong)NSMutableDictionary *invoiceDict;//发票
@property (nonatomic,strong)UITextField *nameTf;
@property (nonatomic,strong)UITextField *ubnTf;
@property (nonatomic,strong)UITextField *emailTf;

@property (nonatomic,strong)UILabel *detailedAddressLb;
@property (nonatomic,strong)UIImageView *contryMoreIvTwo;

@property (nonatomic,strong)NSMutableDictionary * cDic;//公司发票对象
@property (nonatomic,strong)NSMutableDictionary * pDic;//个人发票对象

@property (nonatomic , retain)UIView *tipShadowView;

@property (nonatomic , retain)UIImageView *tipImgV;

@end

@implementation TaobaoTransportApplyViewController

- (NSMutableDictionary *)invoiceDict{
    if (_invoiceDict == nil) {
        _invoiceDict = [[NSMutableDictionary alloc]init];
    }
    return _invoiceDict;
}

-(UIView *)tipShadowView{
    if (!_tipShadowView) {
        _tipShadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _tipShadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        _tipImgV = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth(10), NAVIGATION_BAR_HEIGHT + self.addressLb.frame.origin.y+kWidth(10), kWidth(335), kWidth(66))];
        [_tipImgV setImage:[UIImage imageNamed:@"填写收货地址"]];
        [_tipShadowView addSubview:_tipImgV];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tipShadowViewClicked)];
        [_tipShadowView addGestureRecognizer:tap];
    }
    
    return _tipShadowView;
}

-(void)tipShadowViewClicked{
    if ([self.tipImgV.image isEqual:[UIImage imageNamed:@"填写收货地址"]]) {
        [self.tipImgV setImage:[UIImage imageNamed:@"选择商品类型"]];
        self.tipImgV.frame = CGRectMake(kWidth(10), NAVIGATION_BAR_HEIGHT + kWidth(170), kWidth(335), kWidth(147));
    }else if ([self.tipImgV.image isEqual:[UIImage imageNamed:@"选择商品类型"]]) {
        [self.tipImgV setImage:[UIImage imageNamed:@"收货地址"]];
        self.tipImgV.frame = CGRectMake(kWidth(10), NAVIGATION_BAR_HEIGHT + kWidth(350), kWidth(335), kWidth(88));
    }
    else if ([self.tipImgV.image isEqual:[UIImage imageNamed:@"收货地址"]]) {
        [self.tipImgV setImage:[UIImage imageNamed:@"点击确认提交"]];
        self.tipImgV.frame = CGRectMake(0, SCREEN_HEIGHT - kWidth(241), SCREEN_WIDTH, kWidth(231));
    }
    else{
        [self.tipShadowView removeFromSuperview];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentCountrySign = [NSString stringWithFormat:@"CHINA"];
    [self initGoodsData];
    isKai=NO;
    self.invoiceYesOrNo = @"NO";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self requestInvoiceInfo];
    if (self.addressId) {
        
    }else{
        [self getUserAdd];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.tipImgV) {
        if (![UserDefault valueForKey:@"transfromTip"]) {
            [self.navigationController.view addSubview:self.tipShadowView];
        }
    }
}

- (NSMutableArray *)selectCountryArr
{
    if (_selectCountryArr == nil){
        _selectCountryArr = [[NSMutableArray alloc]init];
    }
    return _selectCountryArr;
}

- (NSMutableArray *)addressDataSource
{
    if (_addressDataSource == nil) {
        _addressDataSource = [[NSMutableArray alloc]init];
    }
    return _addressDataSource;
}

- (NSMutableArray *)screenGoods
{
    if (_screenGoods == nil) {
        _screenGoods = [[NSMutableArray alloc]init];
    }
    return _screenGoods;
}

- (void)initGoodsData
{
    for (int i = 0; i < self.goodsArr.count; i++) {
        if (![self.goodsArr[i] isKindOfClass:[NSNull class]]) {
            [self.screenGoods addObject:self.goodsArr[i]];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         self.screenGoods[i][@"picture"],@"picture",
                                         self.screenGoods[i][@"name"],@"name",
                                         [NSString stringWithFormat:@"%@",self.screenGoods[i][@"attributes"]],@"class",
                                         self.screenGoods[i][@"quantity"],@"qty",
                                         self.screenGoods[i][@"quantity"],@"quantity",
                                         @"",@"special",
                                         self.screenGoods[i][@"price"],@"price",
                                         self.screenGoods[i][@"goodLink"],@"commodityLink",
                                         @"CNY",@"currency",
                                         nil];
            [self.goodsInfo addObject:dict];
        }
    }
}

- (NSMutableArray *)goodsInfo
{
    if (_goodsInfo == nil) {
        _goodsInfo = [[NSMutableArray alloc]init];
    }
    return _goodsInfo;
}

- (void)createUI
{
    self.title = NSLocalizedString(@"GlobalBuyer_TaobaoTransport_TransshipmentList", nil);
    [self.view addSubview:self.allBackSv];
    [self.view addSubview:self.sureBtn];
    
    [self.view addSubview:self.backCoverV];
    [self.view addSubview:self.selectInvoiceTypeV];
}

- (UIScrollView *)allBackSv
{
    if (_allBackSv == nil) {
        _allBackSv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavBarHeight, kScreenW, kScreenH-NavBarHeight-StatusBarHeight-20)];
        
        [_allBackSv addSubview:self.goodsBackV];
        [_allBackSv addSubview:self.transportBackV];
        _allBackSv.contentSize = CGSizeMake(0, self.goodsBackV.frame.size.height + self.transportBackV.frame.size.height);
    }
    
    return _allBackSv;
}

- (UIView *)goodsBackV
{
    if (_goodsBackV == nil) {
        _goodsBackV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 130*self.screenGoods.count + 50 + 100)];
        _goodsBackV.backgroundColor = Cell_BgColor;
        if (self.addressDataSource.count == 0) {
            UIImageView *noAddressIv = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2 - 35, 15, 70, 70)];
            noAddressIv.userInteractionEnabled = YES;
            noAddressIv.image = [UIImage imageNamed:@"AddAddress"];
            [_goodsBackV addSubview:noAddressIv];
            UITapGestureRecognizer *addAddressTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addAddress)];
            addAddressTap.numberOfTouchesRequired = 1;
            addAddressTap.numberOfTapsRequired = 1;
            [noAddressIv addGestureRecognizer:addAddressTap];
        }else{
            UIView *addressBackV = [[UIView alloc]initWithFrame:CGRectMake(0,  0, kScreenW , 100)];
            addressBackV.backgroundColor = [UIColor whiteColor];
            [_goodsBackV addSubview:addressBackV];
            UIImageView *lineIv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 98, kScreenW, 2)];
            lineIv.image = [UIImage imageNamed:@"order_line"];
            [_goodsBackV addSubview:lineIv];
            
            self.nameLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kScreenW/2 - 50, 20)];
            self.nameLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_Shopcart_Consignee", nil),self.addressDataSource[0][@"fullname"]];
            self.nameLb.font = [UIFont systemFontOfSize:15];
            [addressBackV addSubview:self.nameLb];
            
            self.phoneLb = [[UILabel alloc]initWithFrame:CGRectMake(addressBackV.frame.size.width - 150, 10, 100, 20)];
            self.phoneLb.text = [NSString stringWithFormat:@"%@",self.addressDataSource[0][@"mobile_phone"]];
            self.phoneLb.font = [UIFont systemFontOfSize:15];
            self.phoneLb.textAlignment = NSTextAlignmentRight;
            [addressBackV addSubview:self.phoneLb];
            
            self.addressLb = [[UILabel alloc]initWithFrame:CGRectMake(10, self.nameLb.frame.origin.y + self.nameLb.frame.size.height + 5, addressBackV.frame.size.width - 50, 55)];
            self.addressLb.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"GlobalBuyer_My_Tabview_Cell_Add", nil),self.addressDataSource[0][@"address"]];
            self.addressLb.font = [UIFont systemFontOfSize:15];
            self.addressLb.numberOfLines = 0;
            //[self.addressLb sizeToFit];
            [addressBackV addSubview:self.addressLb];
            
            UIImageView *arrowIv = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW - 40, 40, 30, 30)];
            arrowIv.image = [UIImage imageNamed:@"tipsarrow"];
            arrowIv.userInteractionEnabled = YES;
            [_goodsBackV addSubview:arrowIv];
            UITapGestureRecognizer *arrowTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectAddress)];
            arrowTap.numberOfTapsRequired = 1;
            arrowTap.numberOfTouchesRequired = 1;
            [arrowIv addGestureRecognizer:arrowTap];
            
            self.addressId = [NSString stringWithFormat:@"%@",self.addressDataSource[0][@"id"]];
            
            UITapGestureRecognizer *addressTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectAddress)];
            addressTap.numberOfTapsRequired = 1;
            addressTap.numberOfTouchesRequired = 1;
            [addressBackV addGestureRecognizer:addressTap];
            addressBackV.userInteractionEnabled = YES;
            
        }
        
        UIView *allGoodsBackV = [[UIView alloc]initWithFrame:CGRectMake(0, 100, kScreenW, 50)];
        allGoodsBackV.backgroundColor = [UIColor whiteColor];
        UIImageView *iconV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        if (self.type == 0) {
            iconV.image = [UIImage imageNamed:@"tb"];
        }else if (self.type == 1){
            iconV.image = [UIImage imageNamed:@"jd"];
        }else if (self.type == 4){
            iconV.image = [UIImage imageNamed:@"zdy"];
        }
        else{
            iconV.image = [UIImage imageNamed:@"yx"];
        }
        
        [allGoodsBackV addSubview:iconV];
        UILabel *allGoodsLb = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, kScreenW-50, 50)];
        allGoodsLb.text = NSLocalizedString(@"GlobalBuyer_TaobaoTransport_TransshipmentGoods", nil);
        [allGoodsBackV addSubview:allGoodsLb];
        [_goodsBackV addSubview:allGoodsBackV];
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 149, kScreenW, 1)];
        lineV.backgroundColor = [UIColor lightGrayColor];
        [_goodsBackV addSubview:lineV];
        for (int i = 0 ; i < self.screenGoods.count; i++) {
            UIImageView *goodsIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 120*i + 10 + 50 + 100, 80, 80)];
            [goodsIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.screenGoods[i][@"picture"]]]];
            [_goodsBackV addSubview:goodsIcon];
            UILabel *goodsTitle = [[UILabel alloc]initWithFrame:CGRectMake(100, 120*i + 10 + 50 + 100, kScreenW - 120, 40)];
            goodsTitle.numberOfLines = 0;
            goodsTitle.font = [UIFont systemFontOfSize:13];
            goodsTitle.text = [NSString stringWithFormat:@"%@",self.screenGoods[i][@"name"]];
            [_goodsBackV addSubview:goodsTitle];
            UILabel *attributesTitle = [[UILabel alloc]initWithFrame:CGRectMake(100, 120*i + 10 + 40 + 50 + 100, kScreenW - 120, 20)];
            attributesTitle.textColor = [UIColor lightGrayColor];
            attributesTitle.font = [UIFont systemFontOfSize:12];
            attributesTitle.text = [NSString stringWithFormat:@"%@",self.screenGoods[i][@"attributes"]];
            [_goodsBackV addSubview:attributesTitle];
            UILabel *quantity = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 50, 120*i + 10 + 50 + 40 + 100, 30, 30)];
            quantity.textAlignment = NSTextAlignmentRight;
            quantity.textColor = [UIColor lightGrayColor];
            quantity.text = [NSString stringWithFormat:@"x%@",self.screenGoods[i][@"quantity"]];
            [_goodsBackV addSubview:quantity];
            
            UILabel *categoryLb = [[UILabel alloc]initWithFrame:CGRectMake(10, goodsIcon.frame.origin.y + goodsIcon.frame.size.height + 10, kScreenW - 50, 20)];
            categoryLb.userInteractionEnabled = YES;
            categoryLb.text = NSLocalizedString(@"GlobalBuyer_TaobaoTransport_UnselectedCommodityCategory", nil);
            categoryLb.font = [UIFont systemFontOfSize:15];
            categoryLb.textColor = Main_Color;
            //categoryLb.textAlignment = NSTextAlignmentRight;
            [_goodsBackV addSubview:categoryLb];
            UITapGestureRecognizer *cateTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCate:)];
            cateTap.numberOfTapsRequired = 1;
            cateTap.numberOfTouchesRequired = 1;
            [categoryLb addGestureRecognizer:cateTap];
            categoryLb.tag = i;
            UILabel *arrowLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 50, goodsIcon.frame.origin.y + goodsIcon.frame.size.height + 10, 30, 20)];
            arrowLb.textAlignment = NSTextAlignmentRight;
            arrowLb.font = [UIFont systemFontOfSize:15];
            arrowLb.text = @">";
            arrowLb.textColor = [UIColor grayColor];
            [_goodsBackV addSubview:arrowLb];
        }
    }
    return _goodsBackV;
}

- (void)clickCate:(UITapGestureRecognizer *)tap
{
    self.tmpLb = (UILabel *)[tap view];
    self.currentCateLb = [tap view].tag;
    CustomsCategoryViewController *vc = [[CustomsCategoryViewController alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)cilckWithId:(NSString *)cateId name:(NSString *)name
{
    NSMutableDictionary *dict = self.goodsInfo[self.currentCateLb];
    [self.goodsInfo removeObjectAtIndex:self.currentCateLb];
    [dict setObject:[NSString stringWithFormat:@"%@",cateId] forKey:@"special"];
    [self.goodsInfo insertObject:dict atIndex:self.currentCateLb];
    
    self.tmpLb.text = name;
}

- (UIView *)transportBackV
{
    if (_transportBackV == nil) {
        _transportBackV = [[UIView alloc]initWithFrame:CGRectMake(0, self.goodsBackV.frame.origin.y + self.goodsBackV.frame.size.height, kScreenW + 10, 240)];
        UIImageView *iconV = [[UIImageView alloc]initWithFrame:CGRectMake(13, 12, 26, 26)];
        iconV.image = [UIImage imageNamed:@"logIcon"];
        iconV.layer.cornerRadius = 4;
        iconV.layer.masksToBounds = YES;
        [_transportBackV addSubview:iconV];
        UILabel *transportLb = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, kScreenW - 50, 50)];
        transportLb.text = NSLocalizedString(@"GlobalBuyer_TaobaoTransport_TransportDetails", nil);
        [_transportBackV addSubview:transportLb];
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 49, kScreenW, 1)];
        lineV.backgroundColor = [UIColor lightGrayColor];
        [_transportBackV addSubview:lineV];
        UILabel *placeOfDeliveryLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, kScreenW/2, 30)];
        placeOfDeliveryLb.font = [UIFont systemFontOfSize:15];
        placeOfDeliveryLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_shippingAreaLb", nil);
        [_transportBackV addSubview:placeOfDeliveryLb];
        UILabel *placeOfDeliveryRightLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - kScreenW/2 -10 -20, 60, kScreenW/2, 30)];
        placeOfDeliveryRightLb.textColor = [UIColor lightGrayColor];
        placeOfDeliveryRightLb.textAlignment = NSTextAlignmentRight;
        placeOfDeliveryRightLb.font = [UIFont systemFontOfSize:15];
        placeOfDeliveryRightLb.text = NSLocalizedString(@"中国", nil);
        [_transportBackV addSubview:placeOfDeliveryRightLb];
        UILabel *placeOfReceiptLb = [[UILabel alloc]initWithFrame:CGRectMake(10, placeOfDeliveryLb.frame.origin.y + placeOfDeliveryLb.frame.size.height , kScreenW/2, 30)];
        placeOfReceiptLb.font = [UIFont systemFontOfSize:15];
        placeOfReceiptLb.text = NSLocalizedString(@"GlobalBuyer_Entrust_Category_receivingAreaLb", nil);
        [_transportBackV addSubview:placeOfReceiptLb];
        self.placeOfReceiptRightLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - kScreenW/2 -10 - 20, placeOfDeliveryLb.frame.origin.y + placeOfDeliveryLb.frame.size.height, kScreenW/2, 30)];
        self.placeOfReceiptRightLb.userInteractionEnabled = YES;
        self.placeOfReceiptRightLb.textColor = [UIColor lightGrayColor];
        self.placeOfReceiptRightLb.textAlignment = NSTextAlignmentRight;
        self.placeOfReceiptRightLb.font = [UIFont systemFontOfSize:15];
        self.placeOfReceiptRightLb.text = NSLocalizedString(@"中国", nil);
        [_transportBackV addSubview:self.placeOfReceiptRightLb];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectContry)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self.placeOfReceiptRightLb addGestureRecognizer:tap];
        UIImageView *contryMoreIv = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW - 28, placeOfDeliveryLb.frame.origin.y + placeOfDeliveryLb.frame.size.height + 13, 17, 5)];
        contryMoreIv.image = [UIImage imageNamed:@"order_choose_more"];
        [_transportBackV addSubview:contryMoreIv];
        
        self.detailedAddressLb = [[UILabel alloc]initWithFrame:CGRectMake(10, placeOfReceiptLb.frame.origin.y + placeOfReceiptLb.frame.size.height, kScreenW/2, 30)];
        self.detailedAddressLb.font = [UIFont systemFontOfSize:15];
        self. detailedAddressLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_Invoice", nil);
        [_transportBackV addSubview:self.detailedAddressLb];
        self.invoiceLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - kScreenW/2 -10 - 20, placeOfReceiptLb.frame.origin.y + placeOfReceiptLb.frame.size.height, kScreenW/2, 30)];
        self.invoiceLb.userInteractionEnabled = YES;
        self.invoiceLb.textColor = [UIColor lightGrayColor];
        self.invoiceLb.textAlignment = NSTextAlignmentRight;
        self.invoiceLb.font = [UIFont systemFontOfSize:15];
        self.invoiceLb.text = NSLocalizedString(@"GlobalBuyer_Shopcart_NOInvoice", nil);
        [_transportBackV addSubview:self.invoiceLb];
        UITapGestureRecognizer *tapTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectInvoiceType)];
        tapTwo.numberOfTapsRequired = 1;
        tapTwo.numberOfTouchesRequired = 1;
        [self.invoiceLb addGestureRecognizer:tapTwo];
        self.contryMoreIvTwo = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW - 28, placeOfReceiptLb.frame.origin.y + placeOfReceiptLb.frame.size.height + 13, 17, 5)];
        self.contryMoreIvTwo.image = [UIImage imageNamed:@"order_choose_more"];
        [_transportBackV addSubview:self.contryMoreIvTwo];
        self.detailedAddressLb.hidden = YES;
        self.invoiceLb.hidden = YES;
        self.contryMoreIvTwo.hidden = YES;
    }
    return _transportBackV;
}

- (void)selectInvoiceType{
    self.backCoverV.hidden = NO;
    self.selectInvoiceTypeV.hidden = NO;
}

- (UIView *)selectInvoiceTypeV{
    if (_selectInvoiceTypeV == nil) {
        _selectInvoiceTypeV = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH - 500, kScreenW, 500)];
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
            isKai=YES;
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
            isKai=YES;
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

- (void)addAddress
{
    AddressViewController *addressVC = [AddressViewController new];
    self.navigationController.navigationBar.translucent = NO;
    addressVC.taobao = @"1";
    addressVC.delegate = self;
    [self.navigationController pushViewController:addressVC animated:YES];
}

- (void)selectAddress
{
//    DirectMailAddressViewController *dmaVC = [[DirectMailAddressViewController alloc]init];
//    dmaVC.dataSource = self.addressDataSource;
//    dmaVC.delegate = self;
//    [self.navigationController pushViewController:dmaVC animated:YES];
    AddressViewController *addressVC = [AddressViewController new];
    self.navigationController.navigationBar.translucent = NO;
    addressVC.taobao = @"1";
    addressVC.delegate = self;
    [self.navigationController pushViewController:addressVC animated:YES];
}
- (void)changeAddress:(NSDictionary *)addressInfo{
    NSLog(@"地址信息 %@",[self getObjectData:addressInfo]);
    NSDictionary * dic = [self getObjectData:addressInfo];
    if (!self.nameLb) {
        self.addressDataSource = [NSMutableArray arrayWithArray:@[dic]];
        [self.goodsBackV removeFromSuperview];
        self.goodsBackV = nil;
        [self.allBackSv addSubview:self.goodsBackV];

    }
  
    
    self.nameLb.text = dic[@"fullname"];
    self.phoneLb.text = dic[@"mobile_phone"];
    self.addressLb.text = dic[@"address"];
    self.addressId = dic[@"Id"];
}
- (NSDictionary*)getObjectData:(id)obj{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props =class_copyPropertyList([obj class], &propsCount);
    for(int i =0;i < propsCount; i++){
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value ==nil){
            value = [NSNull null];
        }else{
            value = [self getObjectInternal:value];
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}

- (id)getObjectInternal:(id)obj{
    if([obj isKindOfClass:[NSString class]]|| [obj isKindOfClass:[NSNumber class]]|| [obj isKindOfClass:[NSNull class]]){
        return obj;
    }
    if([obj isKindOfClass:[NSArray class]]){
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i =0;i < objarr.count; i++){
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]]atIndexedSubscript:i];
        }
        return arr;
    }
    if([obj isKindOfClass:[NSDictionary class]]){
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys){
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}
- (void)bindAddress
{
    BindIDViewController *bindIdVc = [[BindIDViewController alloc]init];
    [self.navigationController pushViewController:bindIdVc animated:YES];
}

- (void)selectContry
{
    [self.view addSubview:self.choiceCurrencyV];
}

- (UIView *)choiceCurrencyV
{
    if (_choiceCurrencyV == nil) {
        NSArray *readArr = [FileArchiver readFileArchiver:@"Country"];
        self.selectCountryArr = [NSMutableArray arrayWithArray:readArr];
        _choiceCurrencyV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _choiceCurrencyV.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.3];
        UIView *iv = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2 - 150, kScreenH/2 - 160, 300, 320)];
        iv.backgroundColor = [UIColor whiteColor];
        [_choiceCurrencyV addSubview:iv];
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 300 - 40, 40)];
        lb.text = NSLocalizedString(@"GlobalBuyer_Selectcurrency", nil);
        lb.textColor = Main_Color;
        lb.font = [UIFont systemFontOfSize:22 weight:2];
        lb.textAlignment = NSTextAlignmentCenter;
        [iv addSubview:lb];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 70, 300 - 30, 1)];
        line.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1];
        [iv addSubview:line];
        
        UIScrollView *backSv = [[UIScrollView alloc]initWithFrame:CGRectMake(15, 80, 270, 165)];
        backSv.contentSize = CGSizeMake(0, self.selectCountryArr.count/2*70);
        [iv addSubview:backSv];
        
        for (int i = 0; i < self.selectCountryArr.count; i++) {
            UIView *backIv = [[UIView alloc]initWithFrame:CGRectMake(10 + 15 * (i%2) + (i%2) * 115, 10 + ((i/2) * 50), 120, 40)];
            backIv.tag = 1000 + i;
            [backSv addSubview:backIv];
            UILabel *countryLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 120, 30)];
            countryLb.textColor = Main_Color;
            countryLb.textAlignment = NSTextAlignmentCenter;
            countryLb.text = self.selectCountryArr[i][@"name"];
            countryLb.font = [UIFont systemFontOfSize:14];
            [backIv addSubview:countryLb];
            if (i == 0) {
                backIv.backgroundColor = [UIColor colorWithRed:188.0/255.0 green:188.0/255.0 blue:188.0/255.0 alpha:0.3];
                self.countryTag = 1000;
            }else{
                backIv.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:0.3];
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectCurrency:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [backIv addGestureRecognizer:tap];
        }
        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 270, 300, 50)];
        sureBtn.backgroundColor = Main_Color;
        UILabel *sureLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 50)];
        sureLb.textColor = [UIColor whiteColor];
        sureLb.text = NSLocalizedString(@"GlobalBuyer_Ok", nil);
        sureLb.font = [UIFont systemFontOfSize:20 weight:2];
        sureLb.textAlignment = NSTextAlignmentCenter;
        [sureBtn addSubview:sureLb];
        [iv addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(sureCurrency) forControlEvents:UIControlEventTouchUpInside];

    }
    return _choiceCurrencyV;
}

- (void)selectCurrency:(UITapGestureRecognizer *)tap
{
    for (int i = 0; i < self.selectCountryArr.count; i++) {
        UIView *iv = (UIView *)[self.choiceCurrencyV viewWithTag:i + 1000];
        if (iv.tag == [tap view].tag) {
            iv.backgroundColor = [UIColor colorWithRed:188.0/255.0 green:188.0/255.0 blue:188.0/255.0 alpha:0.3];
            self.countryTag = [tap view].tag;
        }else{
            iv.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:0.3];
        }
    }
}

- (void)sureCurrency
{
    self.placeOfReceiptRightLb.text = [NSString stringWithFormat:@"%@",self.selectCountryArr[self.countryTag - 1000][@"name"]];
    self.currentCountrySign = [NSString stringWithFormat:@"%@",self.selectCountryArr[self.countryTag - 1000][@"sign"]];
    if ([self.currentCountrySign isEqualToString:@"TAIWAN"]) {
        self.detailedAddressLb.hidden = NO;
        self.invoiceLb.hidden = NO;
        self.contryMoreIvTwo.hidden = NO;
//        [self selectInvoiceType];
    }else{
        self.detailedAddressLb.hidden = YES;
        self.invoiceLb.hidden = YES;
        self.contryMoreIvTwo.hidden = YES;
    }
    NSLog(@"%@",self.currentCountrySign);
    NSLog(@"%@",self.selectCountryArr[self.countryTag - 1000][@"currency"]);
    [self.choiceCurrencyV removeFromSuperview];
}

- (void)getUserAdd
{
    [self.addressDataSource removeAllObjects];
    [self.allBackSv removeFromSuperview];
    self.allBackSv = nil;
    [self.goodsBackV removeFromSuperview];
    self.goodsBackV = nil;
    [self.transportBackV removeFromSuperview];
    self.transportBackV = nil;
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
        [self createUI];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [hud hideAnimated:YES];
        [self createUI];
    }];
}

- (UIButton *)sureBtn
{
    if (_sureBtn == nil) {
        _sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenH - StatusBarHeight-20, kScreenW, StatusBarHeight+20)];
        [_sureBtn setTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) forState:UIControlStateNormal];
        _sureBtn.backgroundColor = Main_Color;
        [_sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (void)sureClick
{
    for (int i = 0; i < self.goodsInfo.count; i++) {
        if ([self.goodsInfo[i][@"special"]isEqualToString:@""]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"GlobalBuyer_TaobaoTransport_UnselectedCommodityCategory", nil);
            // Move to bottm center.
            hud.offset = CGPointMake(0.5f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3];
            return;
        }
    }
    
    int specialZero = 0;
    int specialOne = 0;
    
    for (int i = 0 ;i < self.goodsInfo.count; i++) {
        if ([self.goodsInfo[i][@"special"]isEqualToString:@"0"]) {
            specialZero++;
        }
    }
    
    for (int i = 0 ;i < self.goodsInfo.count; i++) {
        if ([self.goodsInfo[i][@"special"]isEqualToString:@"1"]) {
            specialOne++;
        }
    }
    
    if (specialZero > 0 && specialOne > 0) {
        [self.view addSubview:self.tipsV];
        return;
    }
    if (!self.addressId) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"GlobalBuyer_Shopcart_Address_Tips", nil);
        // Move to bottm center.
        hud.offset = CGPointMake(0.5f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3];
         return;
    }
    

    
    NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    
    
    NSDictionary *tmpParams;
    if (![self.invoiceYesOrNo isEqualToString:@"NO"]) {
        if ([self.currentCountrySign isEqualToString:@"TAIWAN"]) {
            if (!isKai) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Shopcart_Invoice_Tips", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles: nil];
                [alert show];
                [self selectInvoiceType];
                return;
            }
        }
        tmpParams = @{@"secret_key":api_token,
                      @"region_from":@"CHINA",
                      @"region_to":self.currentCountrySign,
                      @"address":self.addressId,
                      @"locale":@"zh_CN",
                      @"goods_info":self.goodsInfo,
                      @"test":@"null",
                      @"invoiceArray":self.invoiceDict,
                      };
    }else{
        tmpParams = @{@"secret_key":api_token,
                      @"region_from":@"CHINA",
                      @"region_to":self.currentCountrySign,
                      @"address":self.addressId,
                      @"locale":@"zh_CN",
                      @"goods_info":self.goodsInfo,
                      @"test":@"null"
                      };
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tmpParams options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *params = @{@"data":jsonString};
    
    [manager POST:ForwardingInformationApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [self.tipsV removeFromSuperview];
            self.tipsV = nil;
            TransshipmentResultsViewController *vc = [[TransshipmentResultsViewController alloc]init];
            vc.type = self.type;
            vc.telPhone = [NSString stringWithFormat:@"%@",responseObject[@"address"][@"telphone"]];
            vc.address = [NSString stringWithFormat:@"%@",responseObject[@"address"][@"address"]];
            vc.receiver = [NSString stringWithFormat:@"%@",responseObject[@"address"][@"receiver"]];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
            // Move to bottm center.
            hud.offset = CGPointMake(0.5f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [hud hideAnimated:YES];
    }];
    
}

- (UIView *)tipsV
{
    if (_tipsV == nil) {
        _tipsV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _tipsV.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(20, kScreenH/2 - 100, kScreenW - 40, 220)];
        backV.backgroundColor = [UIColor whiteColor];
        backV.layer.cornerRadius = 1;
        [_tipsV addSubview:backV];
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW - 40, 50)];
        title.textAlignment = NSTextAlignmentCenter;
        title.text = NSLocalizedString(@"GlobalBuyer_Prompt", nil);
        title.font = [UIFont systemFontOfSize:15];
        [backV addSubview:title];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"GlobalBuyer_TaobaoTransport_TipsOne", nil),NSLocalizedString(@"GlobalBuyer_TaobaoTransport_TipsTwo", nil)]];
        NSRange range1 = [[str string] rangeOfString:NSLocalizedString(@"GlobalBuyer_TaobaoTransport_TipsTwo", nil)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range1];
        UILabel *contLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 55, kScreenW - 60, 100)];
        contLb.userInteractionEnabled = YES;
        contLb.attributedText = str;
        contLb.numberOfLines = 0;
        [backV addSubview:contLb];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(helpCost)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [contLb addGestureRecognizer:tap];
        
        
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 180, backV.frame.size.width/2, 40)];
        [cancelBtn setTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backV addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(cancelSelect) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(backV.frame.size.width/2, 180, backV.frame.size.width/2, 40)];
        [sureBtn setTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sureBtn.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:160.0/255.0 blue:18.0/255.0 alpha:1];
        [backV addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(commitExpress) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipsV;
}

- (void)helpCost
{
    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
    NSLog(@"当前使用的语言：%@",currentLanguage);
    NSString *language;
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
        language = @"zh_CN";
        return;
    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
        language = @"zh_TW";
    }else if([currentLanguage isEqualToString:@"en"]){
        language = @"en";
    }else if([currentLanguage isEqualToString:@"Japanese"]){
        language = @"ja";
    }else{
        language = @"zh_CN";
        return;
    }
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    NSDictionary *params = @{@"api_id":API_ID,
                             @"api_token":TOKEN,
                             @"name":@"taobaoFreight",
                             @"sign":@"symbol",
                             @"locale":language};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:HelpOneApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            HelpDetailViewController *helpDetailVC = [HelpDetailViewController new];
            helpDetailVC.hidesBottomBarWhenPushed = YES;
            helpDetailVC.bodyStr = responseObject[@"data"][@"body"];
            helpDetailVC.navigationItem.title = responseObject[@"data"][@"title"];
            [self.navigationController pushViewController:helpDetailVC animated:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.hud hideAnimated:YES];
    }];
}

- (void)cancelSelect
{
    [self.tipsV removeFromSuperview];
    self.tipsV = nil;
}

- (void)commitExpress
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    NSDictionary *tmpParams;
    if ([self.invoiceYesOrNo isEqualToString:@"NO"]) {

        if ([self.currentCountrySign isEqualToString:@"TAIWAN"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"GlobalBuyer_Prompt", nil) message:NSLocalizedString(@"GlobalBuyer_Shopcart_Invoice_Tips", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) otherButtonTitles: nil];
            [alert show];
            [self selectInvoiceType];
            return;
        }else{
            tmpParams = @{@"secret_key":api_token,
                          @"region_from":@"CHINA",
                          @"region_to":self.currentCountrySign,
                          @"address":self.addressId,
                          @"locale":@"zh_CN",
                          @"goods_info":self.goodsInfo,
                          @"test":@"null"
                          };
        }

    }else{
        tmpParams = @{@"secret_key":api_token,
                      @"region_from":@"CHINA",
                      @"region_to":self.currentCountrySign,
                      @"address":self.addressId,
                      @"locale":@"zh_CN",
                      @"goods_info":self.goodsInfo,
                      @"test":@"null",
                      @"invoiceArray":self.invoiceDict
                      };
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tmpParams options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *params = @{@"data":jsonString};
    
    [manager POST:ForwardingInformationApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            [self.tipsV removeFromSuperview];
            self.tipsV = nil;
            TransshipmentResultsViewController *vc = [[TransshipmentResultsViewController alloc]init];
            vc.telPhone = [NSString stringWithFormat:@"%@",responseObject[@"address"][@"telphone"]];
            vc.address = [NSString stringWithFormat:@"%@",responseObject[@"address"][@"address"]];
            vc.receiver = [NSString stringWithFormat:@"%@",responseObject[@"address"][@"receiver"]];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
            // Move to bottm center.
            hud.offset = CGPointMake(0.5f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [hud hideAnimated:YES];
    }];
}

- (UIView *)backCoverV{
    if (_backCoverV == nil) {
        _backCoverV = [[UIView alloc]initWithFrame:self.view.bounds];
        _backCoverV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _backCoverV.hidden = YES;
    }
    return _backCoverV;
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
