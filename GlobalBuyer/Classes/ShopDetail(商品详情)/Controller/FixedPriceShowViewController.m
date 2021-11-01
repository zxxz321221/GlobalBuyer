//
//  FixedPriceShowViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/11/30.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "FixedPriceShowViewController.h"
#import "CurrencyCalculation.h"

@interface FixedPriceShowViewController ()

@property (nonatomic,strong)UIView *titleBackV;
@property (nonatomic,strong)UIView *expenseListV;
@property (nonatomic,strong)UIView *payDetailsV;

@end

@implementation FixedPriceShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.titleBackV];
    [self.view addSubview:self.expenseListV];
    [self.view addSubview:self.payDetailsV];
}

//头部商品信息
- (UIView *)titleBackV
{
    if (_titleBackV == nil) {
        _titleBackV = [[UIView alloc]initWithFrame:CGRectMake(0, 64 , [[UIScreen mainScreen] bounds].size.width, 120)];
        _titleBackV.backgroundColor = [UIColor whiteColor];
        //商品图片
        UIImageView *iconIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
        [iconIV sd_setImageWithURL:[NSURL URLWithString:self.pictureUrl]];
        [_titleBackV addSubview:iconIV];
        //商品名字
        UILabel *nameLb = [[UILabel alloc]initWithFrame:CGRectMake(120, 15, [[UIScreen mainScreen] bounds].size.width - 180, 30)];
        nameLb.numberOfLines = 0;
        nameLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        nameLb.font = [UIFont systemFontOfSize:12];
        nameLb.text = self.nameOfGoods;
        [_titleBackV addSubview:nameLb];
        //商品副标题
        UILabel *attributesLb = [[UILabel alloc]initWithFrame:CGRectMake(120, 50, [[UIScreen mainScreen] bounds].size.width - 180, 30)];
        attributesLb.numberOfLines = 0;
        attributesLb.font = [UIFont systemFontOfSize:10];
        attributesLb.text = self.attributesOfGoods;
        [attributesLb sizeToFit];
        attributesLb.textColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1];
        [_titleBackV addSubview:attributesLb];
        //商品个数
        UILabel *numberLb = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 80, 40, 70, 40)];
        numberLb.font = [UIFont systemFontOfSize:20];
        numberLb.text = [NSString stringWithFormat:@"x%@",self.numberOfGoods];
        numberLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        numberLb.textAlignment = NSTextAlignmentRight;
        [_titleBackV addSubview:numberLb];
        //商品价格
        UILabel *priceLb = [[UILabel alloc]initWithFrame:CGRectMake(120, 80, 200, 20)];
        priceLb.text = [CurrencyCalculation getcurrencyCalculation:[self.priceOfGoods floatValue] currentCommodityCurrency:self.moneyTypeOfGoods numberOfGoods:[self.numberOfGoods floatValue]];
        priceLb.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        priceLb.font = [UIFont systemFontOfSize:15];
        [_titleBackV addSubview:priceLb];
    }
    return _titleBackV;
}

//费用清单标题
- (UIView *)expenseListV
{
    if (_expenseListV == nil) {
        _expenseListV = [[UIView alloc]initWithFrame:CGRectMake(0,self.titleBackV.frame.size.height + 64, [[UIScreen mainScreen] bounds].size.width, 50)];
        _expenseListV.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:241.0/255.0 blue:208.0/255.0 alpha:1];
        UILabel *expenseListLb = [[UILabel alloc]initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width)/2 - 80, 0, 160, 50)];
        expenseListLb.textAlignment = NSTextAlignmentCenter;
        expenseListLb.text = NSLocalizedString(@"GlobalBuyer_Amazon_Fixedprice", nil);
        expenseListLb.font = [UIFont systemFontOfSize:22 weight:2];
        expenseListLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        [_expenseListV addSubview:expenseListLb];
    }
    return _expenseListV;
}


//支付详情
- (UIView *)payDetailsV
{
    if (_payDetailsV == nil) {
        _payDetailsV = [[UIView alloc]initWithFrame:CGRectMake(0, self.expenseListV.frame.origin.y + self.expenseListV.frame.size.height + 1, [[UIScreen mainScreen] bounds].size.width, 114)];
        _payDetailsV.backgroundColor = [UIColor whiteColor];
        //商品费用title
        UILabel *commodityCostLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, 200, 30)];
        commodityCostLb.text = NSLocalizedString(@"GlobalBuyer_Amazon_FixedpriceAll", nil);
        commodityCostLb.font = [UIFont systemFontOfSize:16];
        commodityCostLb.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        [_payDetailsV addSubview:commodityCostLb];
        //商品价格右侧price
        UILabel *commodityCostRightLb = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 300, 8, 290, 30)];
        commodityCostRightLb.text = [NSString stringWithFormat:@"%@:%@(%@%@)",NSLocalizedString(@"GlobalBuyer_Shopcart_Allprice", nil),[CurrencyCalculation getcurrencyCalculation:[self.priceOfGoods floatValue] currentCommodityCurrency:self.moneyTypeOfGoods numberOfGoods:[self.numberOfGoods floatValue]],NSLocalizedString(@"GlobalBuyer_Entrust_About", nil),[CurrencyCalculation getcurrencyCalculation:[self.priceOfGoods floatValue] moneytypeArr:self.moneytypeArr currentCommodityCurrency:self.moneyTypeOfGoods numberOfGoods:[self.numberOfGoods floatValue]]];
        commodityCostRightLb.font = [UIFont systemFontOfSize:13];
        commodityCostRightLb.textAlignment = NSTextAlignmentRight;
        commodityCostRightLb.textColor = [UIColor colorWithRed:255.0/255.0 green:95.0/255.0 blue:62.0/255.0 alpha:1];
        [_payDetailsV addSubview:commodityCostRightLb];
    }
    return _payDetailsV;
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
