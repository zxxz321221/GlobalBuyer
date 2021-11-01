//
//  FinalPaymentDetailView.m
//  GlobalBuyer
//
//  Created by 赵祥 on 2021/9/7.
//  Copyright © 2021 薛铭. All rights reserved.
//

#import "FinalPaymentDetailView.h"
#import "FinalPaymentTableViewCell.h"
#import "CurrencyCalculation.h"

@interface FinalPaymentDetailView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , retain)UIView *bgView;

@property (nonatomic , strong)UITableView *tableView;

@property (nonatomic , retain)NSArray *packageProductArr;

@property (nonatomic , retain)UILabel *allPriceLab;

@end

@implementation FinalPaymentDetailView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    
    self.bgView = [[UIView alloc]initWithFrame:self.bounds];
    self.bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgView];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, StatusBarHeight+kWidth(20), SCREEN_WIDTH, kWidth(50))];
    titleView.backgroundColor = Main_Color;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:titleView.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){10.0f, 10.0f}].CGPath;
    titleView.layer.masksToBounds = YES;
    titleView.layer.mask = maskLayer;
    [self.bgView addSubview:titleView];
    
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(self);
        make.top.equalTo(titleView.mas_bottom);
    }];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text = NSLocalizedString(@"GlobalBuyer_My_FreightDetails", nil);
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont boldSystemFontOfSize:18];
    [titleView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(titleView);
    }];
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    [cancelBtn setImage:[UIImage imageNamed:@"whiteClose"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(kWidth(-15));
        make.centerY.equalTo(titleView);
        make.width.height.mas_offset(kWidth(15));
    }];
    
    UIButton *paymentBtn = [[UIButton alloc]init];
    [paymentBtn setTitle:NSLocalizedString(@"GlobalBuyer_My_Tabview_Cell_Paytransport", nil) forState:UIControlStateNormal];
    [paymentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    paymentBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    paymentBtn.backgroundColor = Main_Color;
    paymentBtn.layer.cornerRadius = kWidth(27);
    self.paymentBtn = paymentBtn;
    [self.bgView addSubview:paymentBtn];
    [paymentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kWidth(10));
        make.right.mas_offset(kWidth(-10));
        make.bottom.mas_offset(-kWidth(5)-TabbarSafeBottomMargin);
        make.height.mas_offset(kWidth(54));
    }];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[FinalPaymentTableViewCell class] forCellReuseIdentifier:NSStringFromClass([FinalPaymentTableViewCell class])];
    [self.bgView addSubview:self.tableView];
    
    UIView *footerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kWidth(60))];
    footerV.backgroundColor = [UIColor whiteColor];
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineV.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    [footerV addSubview:lineV];
    
    UILabel *allPriceTitleLab = [[UILabel alloc]init];
    allPriceTitleLab.text = NSLocalizedString(@"GlobalBuyer_Shopcart_Allprice", nil);
    allPriceTitleLab.textColor = [UIColor blackColor];
    allPriceTitleLab.font = [UIFont systemFontOfSize:14];
    [footerV addSubview:allPriceTitleLab];
    [allPriceTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kWidth(15));
        make.centerY.equalTo(footerV);
        make.width.mas_offset(SCREEN_WIDTH/3);
    }];
    
    self.allPriceLab = [[UILabel alloc]init];
    self.allPriceLab.textColor = [UIColor colorWithRed:255.0/255.0 green:30.0/255.0 blue:22.0/255.0 alpha:1];
    self.allPriceLab.font = [UIFont systemFontOfSize:13];
    [footerV addSubview:self.allPriceLab];
    [self.allPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(kWidth(-10));
        make.centerY.equalTo(footerV);
    }];
    
    self.tableView.tableFooterView = footerV;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self);
        make.top.equalTo(titleView.mas_bottom);
        make.bottom.equalTo(paymentBtn.mas_top).mas_offset(kWidth(-10));
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section<3) {
        return self.packageProductArr.count;
    }else if (section == 6){
        if ([self.dataDic[@"get_freights"][@"freight_category_id"] integerValue] == 2) {
            return 1;
        }
        return 2;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FinalPaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FinalPaymentTableViewCell class]) forIndexPath:indexPath];
    if (!cell) {
        cell = [[FinalPaymentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([FinalPaymentTableViewCell class])];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section < 3) {
        NSDictionary *productDic = [self.packageProductArr objectAtIndex:indexPath.row];
        NSString *string = productDic[@"get_pay_product"][@"body"];
        NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        cell.explainLab.hidden = YES;
        if (indexPath.section == 0) {
            
            if ([self.dataDic[@"package_adjust_price"] floatValue]) {
                cell.titleLab.text = [jsonDict valueForKey:@"name"];
                cell.priceLab.text = [CurrencyCalculation getcurrencyCalculation:[productDic[@"adjust_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:productDic[@"currency"] numberOfGoods:1.0];
            }else{
                cell.titleLab.text = @"";
                cell.priceLab.text = @"";
            }
        }
        if (indexPath.section == 1 ) {
            
            
            if ([self.dataDic[@"package_tax"] floatValue]) {
                cell.titleLab.text = [jsonDict valueForKey:@"name"];
                cell.priceLab.text = [CurrencyCalculation getcurrencyCalculation:[productDic[@"cur_tax"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:productDic[@"currency"] numberOfGoods:1.0];
            }else{
                cell.titleLab.text = @"";
                cell.priceLab.text = @"";
            }

        }
        if (indexPath.section == 2) {
            if ([self.dataDic[@"package_freight"] floatValue]) {
                cell.titleLab.text = [jsonDict valueForKey:@"name"];
                cell.priceLab.text = [CurrencyCalculation getcurrencyCalculation:[productDic[@"cur_freight"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:productDic[@"currency"] numberOfGoods:1.0];
            }else{
                cell.titleLab.text = @"";
                cell.priceLab.text = @"";
            }
            

        }
    }else if (indexPath.section == 6){
        if (indexPath.row == 0) {
            cell.titleLab.text = NSLocalizedString(@"GlobalBuyer_My_FirstWeight", nil);
            cell.priceLab.text = [CurrencyCalculation getcurrencyCalculation:[[[self.dataDic valueForKey:@"get_freights"] valueForKey:@"first_price"] floatValue] currentCommodityCurrency:self.dataDic[@"currency"] numberOfGoods:1.0];
            
            cell.explainLab.text = [NSString stringWithFormat:@"%@/kg",[CurrencyCalculation getcurrencyCalculation:[[[self.dataDic valueForKey:@"get_freights"] valueForKey:@"first_price"] floatValue] currentCommodityCurrency:self.dataDic[@"currency"] numberOfGoods:1.0]];
            
        }else if (indexPath.row == 1){
            cell.titleLab.text = NSLocalizedString(@"GlobalBuyer_My_OtherWeight", nil);
            CGFloat otherPrice = [[[self.dataDic valueForKey:@"get_freights"] valueForKey:@"other_price"] floatValue];
            CGFloat otherW = [[self.dataDic valueForKey:@"weight"] floatValue]-1;
            
            if (otherW > 0) {
                CGFloat price = otherPrice * otherW;
                cell.explainLab.text = [NSString stringWithFormat:@"%@/kg x %.1lfkg",[CurrencyCalculation getcurrencyCalculation:otherPrice currentCommodityCurrency:self.dataDic[@"currency"] numberOfGoods:1.0],otherW];
                cell.priceLab.text = [CurrencyCalculation getcurrencyCalculation:price currentCommodityCurrency:self.dataDic[@"currency"] numberOfGoods:1.0];
            }
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && [self.dataDic[@"package_adjust_price"] floatValue] == 0) {
        return 0.001;
    }
    if (indexPath.section == 1 && [self.dataDic[@"package_tax"] floatValue] == 0) {
        return 0.001;
    }
    if (indexPath.section == 2 && [self.dataDic[@"package_freight"] floatValue] == 0) {
        return 0.001;
    }
    if (indexPath.section == 3 && [self.dataDic[@"package_storage"] floatValue] == 0) {
        return 0.001;
    }
    if (indexPath.section == 4 && [self.dataDic[@"package_tariff"] floatValue] == 0) {
        return 0.001;
    }
    if (indexPath.section == 5 && [self.dataDic[@"package_addfee"] floatValue] == 0) {
        return 0.001;
    }
    if (indexPath.section == 6 && [self.dataDic[@"package_transfer_freight"] floatValue] == 0) {
        return 0.001;
    }
    return kWidth(44);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 && [self.dataDic[@"package_adjust_price"] floatValue] == 0) {
        return 0.001;
    }
    if (section == 1 && [self.dataDic[@"package_tax"] floatValue] == 0) {
        return 0.001;
    }
    if (section == 2 && [self.dataDic[@"package_freight"] floatValue] == 0) {
        return 0.001;
    }
    if (section == 3 && [self.dataDic[@"package_storage"] floatValue] == 0) {
        return 0.001;
    }
    if (section == 4 && [self.dataDic[@"package_tariff"] floatValue] == 0) {
        return 0.001;
    }
    if (section == 5 && [self.dataDic[@"package_addfee"] floatValue] == 0) {
        return 0.001;
    }
    if (section == 6 && [self.dataDic[@"package_transfer_freight"] floatValue] == 0) {
        return 0.001;
    }
    
    return kWidth(54);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kWidth(54))];
    header.backgroundColor = [UIColor whiteColor];
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.textColor = [UIColor blackColor];
    titleLab.font = [UIFont systemFontOfSize:14];
    [header addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kWidth(15));
        make.centerY.equalTo(header);
        make.width.mas_offset(SCREEN_WIDTH/3);
    }];
    
    UILabel *priceLab = [[UILabel alloc]init];
    priceLab.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
    priceLab.font = [UIFont systemFontOfSize:13];
    [header addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(kWidth(-10));
        make.centerY.equalTo(header);
    }];
    
    UILabel *explainLab = [[UILabel alloc]init];
    explainLab.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
    explainLab.font = [UIFont systemFontOfSize:12];
    [header addSubview:explainLab];
    [explainLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(kWidth(100));
        make.centerY.equalTo(header);
    }];
    
    if (section == 0 && [self.dataDic[@"package_adjust_price"] floatValue]) {
        titleLab.text = NSLocalizedString(@"GlobalBuyer_My_CommodityPriceDifference", nil);
        //priceLab.text = [CurrencyCalculation getcurrencyCalculation:[self.dataDic[@"package_adjust_price"] floatValue] currentCommodityCurrency:self.dataDic[@"product_currency"] numberOfGoods:1.0];
        priceLab.text = [CurrencyCalculation getcurrencyCalculation:[self.dataDic[@"package_adjust_price"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.dataDic[@"product_currency"] numberOfGoods:1.0];
        
    }else if (section == 1 && [self.dataDic[@"package_tax"] floatValue]){
        titleLab.text = NSLocalizedString(@"GlobalBuyer_Entrust_secondPayDetailsLb", nil);
//        priceLab.text = [CurrencyCalculation getcurrencyCalculation:[self.dataDic[@"package_tax"] floatValue] currentCommodityCurrency:self.dataDic[@"product_currency"] numberOfGoods:1.0];
        priceLab.text = [CurrencyCalculation getcurrencyCalculation:[self.dataDic[@"package_tax"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.dataDic[@"product_currency"] numberOfGoods:1.0];
    }
    else if (section == 2 && [self.dataDic[@"package_freight"] floatValue]){
        titleLab.text = NSLocalizedString(@"GlobalBuyer_Entrust_purchasingLb_2", nil);
        //priceLab.text = [CurrencyCalculation getcurrencyCalculation:[self.dataDic[@"package_freight"] floatValue] currentCommodityCurrency:self.dataDic[@"product_currency"] numberOfGoods:1.0];
        priceLab.text = [CurrencyCalculation getcurrencyCalculation:[self.dataDic[@"package_freight"] floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.dataDic[@"product_currency"] numberOfGoods:1.0];
    }
    else if (section == 3 && [self.dataDic[@"package_storage"] floatValue]){
        titleLab.text = NSLocalizedString(@"GlobalBuyer_My_WarehousingFee", nil);
        priceLab.text = [CurrencyCalculation getcurrencyCalculation:[self.dataDic[@"package_storage"] floatValue] currentCommodityCurrency:self.dataDic[@"package_storage_currency"] numberOfGoods:1.0];
    }
    else if (section == 4 && [self.dataDic[@"package_tariff"] floatValue]){
        titleLab.text = NSLocalizedString(@"GlobalBuyer_My_ParcelDuty", nil);
        priceLab.text = [CurrencyCalculation getcurrencyCalculation:[self.dataDic[@"package_tariff"] floatValue] currentCommodityCurrency:self.dataDic[@"package_rate_currency"] numberOfGoods:1.0];
    }
    else if (section == 5 && [self.dataDic[@"package_addfee"] floatValue]){
        titleLab.text = NSLocalizedString(@"GlobalBuyer_My_ParcelIncrement", nil);
        priceLab.text = [CurrencyCalculation getcurrencyCalculation:[self.dataDic[@"package_addfee"] floatValue] currentCommodityCurrency:self.dataDic[@"package_addfee_currency"] numberOfGoods:1.0];
    }
    else if (section == 6 && [self.dataDic[@"package_transfer_freight"] floatValue]){
        titleLab.text = NSLocalizedString(@"GlobalBuyer_My_InternationalShipping", nil);
        priceLab.text = [CurrencyCalculation getcurrencyCalculation:[self.dataDic[@"package_transfer_freight"] floatValue] currentCommodityCurrency:self.dataDic[@"package_transport_currency"] numberOfGoods:1.0];
        explainLab.text = [NSString stringWithFormat:@"%@kg",[self.dataDic valueForKey:@"weight"]];
    }
    
    
    return header;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(void)cancelClicked{
    [self removeFromSuperview];
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.packageProductArr = [dataDic valueForKey:@"get_package_product"];
    NSString *currency = self.dataDic[@"currency"];
    if (!currency.length) {
        currency = [[NSUserDefaults standardUserDefaults]objectForKey:@"currency"];
    }
    self.allPriceLab.text = [CurrencyCalculation getcurrencyCalculation:[self.dataDic[@"package_amount"] floatValue] currentCommodityCurrency:currency numberOfGoods:1.0];
    [self.tableView scrollsToTop];
    [self.tableView reloadData];
    
    CGFloat contentSizeH = self.tableView.tableFooterView.frame.origin.y;
    self.bgView.frame = CGRectMake(0, self.bounds.size.height-contentSizeH, SCREEN_WIDTH, contentSizeH);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
