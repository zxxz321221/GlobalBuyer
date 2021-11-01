//
//  PurchasingCommissionViewController.m
//  GlobalBuyer
//
//17615116881      LiPeng3344
//  Created by 薛铭 on 2017/10/20.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import "PurchasingCommissionViewController.h"
#import "ShopDetailViewController.h"

@interface PurchasingCommissionViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UIScrollView *backSv;

//上传服务器的数据(包括self.webLink)
@property (nonatomic,strong) UILabel *commodityClassificationFirstLb;
@property (nonatomic,strong) UILabel *commodityClassificationSecondLb;
@property (nonatomic,strong) UITextField *colorTF;
@property (nonatomic,strong) UILabel *goodsNumberLb;
@property (nonatomic,strong) UITextField *priceTF;
@property (nonatomic,strong) UITextField *remarksTF;
@property (nonatomic,strong) UITextField *headerTF;
@property (nonatomic,strong) UITextField *mobilePhoneTF;
@property (nonatomic,strong) UITextField *weightTF;

@property (nonatomic,strong) UIView *headerV;
@property (nonatomic,strong) UIView *detailV;
@property (nonatomic,strong) UIView *pickerViewBackV;
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) UIView *pickerViewSureOrCancelV;
@property (nonatomic,strong) UIView *noticeBackV;
@property (nonatomic,strong) UIView *priceDetailsV;
@property (nonatomic,strong) UIView *submitV;

@property (nonatomic,strong) NSMutableArray *pickDataSorce;

@property (nonatomic,strong) NSMutableArray *typeDataSource;
@property (nonatomic,strong) NSMutableArray *shoesDataSource;
@property (nonatomic,strong) NSMutableArray *clothesDataSource;
@property (nonatomic,strong) NSMutableArray *trousersDataSource;

@property (nonatomic,strong) NSString *firstName;
@property (nonatomic,strong) NSString *secondName;
@property (nonatomic,assign) NSInteger num;

//费用试算


@end

@implementation PurchasingCommissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.num = 0;
    self.firstName = @"鞋";
    [self loadData];
    [self createUI];
    [self createDetailUI];
}

- (NSMutableArray *)typeDataSource
{
    if (_typeDataSource == nil) {
        _typeDataSource = [NSMutableArray new];
        NSArray *arr = @[@"鞋",@"服装",@"裤子",@"其他"];
        _typeDataSource = [NSMutableArray arrayWithArray:arr];
    }
    return _typeDataSource;
}

- (NSMutableArray *)shoesDataSource
{
    if (_shoesDataSource == nil) {
        _shoesDataSource = [NSMutableArray new];
        NSArray *arr = @[@"中35-欧2", @"中35.5-欧2.5", @"中36-欧3", @"中36.5-欧3.5", @"中37.5-欧4", @"中38-欧4.5", @"中38.5-欧5", @"中39-欧5.5", @"中40-欧6", @"中40.5-欧6.5", @"中41-欧7", @"中42-欧7.5", @"中42.5-欧8", @"中43-欧8.5", @"中44-欧9", @"中44.5-欧9.5", @"中45-欧10", @"中45.5-欧10.5", @"中46-欧11", @"中47-欧11.5", @"中47.5-欧12",@"男-中38.5-美6", @"男-中39-美6.5", @"男-中40-美7", @"男-中40.5-美7.5", @"男-中41-美8", @"男-中42-美8.5", @"男-中42.5-美9", @"男-中43-美9.5", @"男-中44-美10", @"女-中35.5-美5", @"女-中36-美5.5", @"女-中36.5-美6", @"女-中37.5-美6.5", @"女-中38-美7", @"女-中38.5-美7.5", @"女-中39-美8", @"女-中40-美8.5", @"女-中40.5-美9", @"女-中41-美9.5", @"女-中42-美10",@"男-中38.5-英5", @"男-中39-英5.5", @"男-中40-英6", @"男-中40.5-英6.5", @"男-中41-英7", @"男-中42-英7.5", @"男-中42.5-英8", @"男-中43-英8.5", @"男-中44-英9", @"女-中35.5-英2", @"女-中36-英2.5", @"女-中36.5-英3", @"女-中37.5-英4", @"女-中38-英4.5", @"女-中38.5-英5", @"女-中39-英5.5", @"女-中40-英6", @"女-中40.5-英6.5", @"女-中41-英7", @"女-中42-英7.5"];
//        NSDictionary *europeDict = @{@"欧码": @[@"中35-欧2", @"中35.5-欧2.5", @"中36-欧3", @"中36.5-欧3.5", @"中37.5-欧4", @"中38-欧4.5", @"中38.5-欧5", @"中39-欧5.5", @"中40-欧6", @"中40.5-欧6.5", @"中41-欧7", @"中42-欧7.5", @"中42.5-欧8", @"中43-欧8.5", @"中44-欧9", @"中44.5-欧9.5", @"中45-欧10", @"中45.5-欧10.5", @"中46-欧11", @"中47-欧11.5", @"中47.5-欧12"]};
//        NSDictionary *usaDict = @{@"美码": @[@"男-中38.5-美6", @"男-中39-美6.5", @"男-中40-美7", @"男-中40.5-美7.5", @"男-中41-美8", @"男-中42-美8.5", @"男-中42.5-美9", @"男-中43-美9.5", @"男-中44-美10", @"女-中35.5-美5", @"女-中36-美5.5", @"女-中36.5-美6", @"女-中37.5-美6.5", @"女-中38-美7", @"女-中38.5-美7.5", @"女-中39-美8", @"女-中40-美8.5", @"女-中40.5-美9", @"女-中41-美9.5", @"女-中42-美10"]};
//        NSDictionary *britainDict = @{@"英码": @[@"男-中38.5-英5", @"男-中39-英5.5", @"男-中40-英6", @"男-中40.5-英6.5", @"男-中41-英7", @"男-中42-英7.5", @"男-中42.5-英8", @"男-中43-英8.5", @"男-中44-英9", @"女-中35.5-英2", @"女-中36-英2.5", @"女-中36.5-英3", @"女-中37.5-英4", @"女-中38-英4.5", @"女-中38.5-英5", @"女-中39-英5.5", @"女-中40-英6", @"女-中40.5-英6.5", @"女-中41-英7", @"女-中42-英7.5"]};
        _shoesDataSource = [NSMutableArray arrayWithArray:arr];
        
    }
    return _shoesDataSource;
}

- (NSMutableArray *)clothesDataSource
{
    if (_clothesDataSource == nil) {
        _clothesDataSource = [NSMutableArray new];
        NSArray *arr = @[@"S码",@"M码",@"L码",@"XL码",@"XXL码",@"XXXL码"];
        //NSDictionary *clothesDict = @{@"服装":@[@"S码",@"M码",@"L码",@"XL码",@"XXL码",@"XXXL码"]};
        _clothesDataSource = [NSMutableArray arrayWithArray:arr];
    }
    return _clothesDataSource;
}

- (NSMutableArray *)trousersDataSource
{
    if (_trousersDataSource == nil) {
        _trousersDataSource = [NSMutableArray new];
        NSArray *arr = @[@"2尺1",@"2尺2",@"2尺3",@"2尺4",@"2尺5",@"2尺6",@"2尺7",@"2尺8",@"2尺9",@"3尺",@"3尺1",@"3尺2",@"3尺3",@"3尺4"];
        //NSDictionary *trousersDict = @{@"裤子":@[@"2尺1",@"2尺2",@"2尺3",@"2尺4",@"2尺5",@"2尺6",@"2尺7",@"2尺8",@"2尺9",@"3尺",@"3尺1",@"3尺2",@"3尺3",@"3尺4"]};
        _trousersDataSource = [NSMutableArray arrayWithArray:arr];
    }
    return _trousersDataSource;
}

- (NSMutableArray *)pickDataSorce
{
    if (_pickDataSorce == nil) {
        _pickDataSorce = [NSMutableArray new];
        
    }
    return _pickDataSorce;
}

- (void)loadData
{
    //    NSArray *arr = @[@{@"鞋":self.shoesDataSource,@"服装":self.clothesDataSource,@"裤子":self.trousersDataSource,@"其他":@[]}];
    NSDictionary *shoesDict = @{@"鞋":self.shoesDataSource};
    NSDictionary *clothesDict = @{@"服装":self.clothesDataSource};
    NSDictionary *trousersDict = @{@"裤子":self.trousersDataSource};
    NSDictionary *otherDict = @{@"其它":@[@"无"]};
    
    [self.pickDataSorce addObject:shoesDict];
    [self.pickDataSorce addObject:clothesDict];
    [self.pickDataSorce addObject:trousersDict];
    [self.pickDataSorce addObject:otherDict];
}

- (UIView *)pickerViewBackV
{
    if (_pickerViewBackV == nil) {
        _pickerViewBackV = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, 230)];
        [_pickerViewBackV addSubview:self.pickerViewSureOrCancelV];
        [_pickerViewBackV addSubview:self.pickerView];
    }
    return _pickerViewBackV;
}

- (UIView *)pickerViewSureOrCancelV
{
    if (_pickerViewSureOrCancelV == nil) {
        _pickerViewSureOrCancelV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
        _pickerViewSureOrCancelV.backgroundColor = [UIColor grayColor];
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        [cancelBtn setTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelPick) forControlEvents:UIControlEventTouchUpInside];
        [_pickerViewSureOrCancelV addSubview:cancelBtn];
        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 60, 0, 60, 30)];
        [sureBtn setTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(surePick) forControlEvents:UIControlEventTouchUpInside];
        [_pickerViewSureOrCancelV addSubview:sureBtn];
    }
    return _pickerViewSureOrCancelV;
}

//滚动选择视图
- (UIPickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, kScreenW, 200)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.tag = 111;
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.pickDataSorce.count;
    } else if (component == 1) {
        return [self.pickDataSorce[self.num][self.firstName] count];
    } else{
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.typeDataSource objectAtIndex:row];
    } else if (component == 1) {
        return [self.pickDataSorce[self.num][self.firstName] objectAtIndex:row];
    } else {
        return nil;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return kScreenW - 240;
    } else if (component == 1) {
        return 240;
    } else {
        return 0;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        self.num = row;
        self.firstName = self.typeDataSource[row];
        self.secondName = self.pickDataSorce[row][self.firstName][0];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
    }

    if (component == 1) {
        self.secondName = self.pickDataSorce[self.num][self.firstName][row];
    }
    

    
    
    NSLog(@"%ld    %ld",(long)component,(long)row);
    NSLog(@"%@    %@",self.firstName,self.secondName);

}

- (void)createUI
{
    self.view.backgroundColor = Cell_BgColor;
    
    //导航title 隐藏tabbar
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = [UIFont systemFontOfSize:18 weight:1];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"代购委托单", nil);
    self.navigationItem.titleView = titleLabel;
}

- (void)createDetailUI
{
    [self.view addSubview:self.backSv];
    [self.view addSubview:self.pickerViewBackV];
    [self.view addSubview:self.submitV];
}

- (UIScrollView *)backSv
{
    if (_backSv == nil) {
        _backSv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 60)];
        _backSv.backgroundColor = Cell_BgColor;
        _backSv.contentSize = CGSizeMake(0, 960);
        _backSv.contentOffset = CGPointMake(0, 0);
        _backSv.delegate = self;
        [_backSv addSubview:self.headerV];
        [_backSv addSubview:self.detailV];
        [_backSv addSubview:self.noticeBackV];
        //[_backSv addSubview:self.priceDetailsV];
    }
    return _backSv;
}

//头部视图
- (UIView *)headerV
{
    if (_headerV == nil) {
        _headerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW , 200)];
        _headerV.backgroundColor = [UIColor whiteColor];
        _headerV.layer.borderWidth = 1;
        _headerV.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        self.headerTF = [[UITextField alloc]initWithFrame:CGRectMake(30, 20, kScreenW - 60, 50)];
        self.headerTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.headerTF.layer.borderWidth = 0.8;
        self.headerTF.placeholder = @"商品名称";
        [_headerV addSubview:self.headerTF];
        
        UILabel *headerLb = [[UILabel alloc]initWithFrame:CGRectMake(30, 85, kScreenW - 60, 50)];
        headerLb.font = [UIFont systemFontOfSize:12];
        headerLb.numberOfLines = 0;
        headerLb.textColor = [UIColor lightGrayColor];
        headerLb.text = self.webLink;
        [headerLb sizeToFit];
        [_headerV addSubview:headerLb];
        
        UIView *headerBtn = [[UIView alloc]initWithFrame:CGRectMake(70, 140, kScreenW - 140, 40)];
        headerBtn.backgroundColor = Main_Color;
        headerBtn.userInteractionEnabled = YES;
        UITapGestureRecognizer *gotoWebViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotowebView)];
        gotoWebViewTap.numberOfTapsRequired = 1;
        gotoWebViewTap.numberOfTouchesRequired = 1;
        [headerBtn addGestureRecognizer:gotoWebViewTap];
        UILabel *headerTitleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW - 140, 40)];
        headerTitleLb.textColor = [UIColor whiteColor];
        headerTitleLb.font = [UIFont systemFontOfSize:16 weight:1];
        headerTitleLb.textAlignment = NSTextAlignmentCenter;
        headerTitleLb.text = @"原页面";
        [headerBtn addSubview:headerTitleLb];
        [_headerV addSubview:headerBtn];
    }
    return _headerV;
}

- (void)gotowebView
{
    ShopDetailViewController *shopDetailVC = [ShopDetailViewController new];
    shopDetailVC.link = self.webLink;
    shopDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shopDetailVC animated:YES];
}

//商品详情视图
- (UIView *)detailV
{
    if (_detailV == nil) {
        _detailV = [[UIView alloc]initWithFrame:CGRectMake(0, self.headerV.frame.origin.y + self.headerV.frame.size.height + 20, kScreenW, 380)];
        _detailV.backgroundColor = [UIColor whiteColor];
        _detailV.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _detailV.layer.borderWidth = 1;
        
        //商品分类
        UILabel *commodityClassificationLb = [[UILabel alloc]initWithFrame:CGRectMake(30, 20, 90, 50)];
        commodityClassificationLb.font = [UIFont systemFontOfSize:15];
        commodityClassificationLb.textColor = [UIColor grayColor];
        commodityClassificationLb.text = @"商品分类：";
        [_detailV addSubview:commodityClassificationLb];
        //选择分类
        UIView *commodityClassificationFirstV = [[UIView alloc]initWithFrame:CGRectMake(140, 20, (kScreenW - 140 - 30)/2 , 50)];
        commodityClassificationFirstV.layer.borderColor = [UIColor lightGrayColor].CGColor;
        commodityClassificationFirstV.layer.borderWidth = 0.8;
        commodityClassificationFirstV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapF = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPickView)];
        tapF.numberOfTapsRequired = 1;
        tapF.numberOfTouchesRequired = 1;
        [commodityClassificationFirstV addGestureRecognizer:tapF];
        self.commodityClassificationFirstLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, commodityClassificationFirstV.frame.size.width - 20, commodityClassificationFirstV.frame.size.height - 10)];
        self.commodityClassificationFirstLb.font = [UIFont systemFontOfSize:13];
        [commodityClassificationFirstV addSubview:self.commodityClassificationFirstLb];
        
        UIView *commodityClassificationSecondV = [[UIView alloc]initWithFrame:CGRectMake(commodityClassificationFirstV.frame.origin.x + commodityClassificationFirstV.frame.size.width, 20, (kScreenW - 140 - 30)/2, 50)];
        commodityClassificationSecondV.userInteractionEnabled = YES;
        commodityClassificationSecondV.layer.borderColor = [UIColor lightGrayColor].CGColor;
        commodityClassificationSecondV.layer.borderWidth = 0.8;
        UITapGestureRecognizer *tapS = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPickView)];
        tapS.numberOfTapsRequired = 1;
        tapS.numberOfTouchesRequired = 1;
        [commodityClassificationSecondV addGestureRecognizer:tapS];
        self.commodityClassificationSecondLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, commodityClassificationSecondV.frame.size.width - 20, commodityClassificationSecondV.frame.size.height - 10)];
        self.commodityClassificationSecondLb.font = [UIFont systemFontOfSize:13];
        [commodityClassificationSecondV addSubview:self.commodityClassificationSecondLb];
        
        [_detailV addSubview:commodityClassificationFirstV];
        [_detailV addSubview:commodityClassificationSecondV];
        
        self.commodityClassificationFirstLb.text = @"其它";
        self.commodityClassificationSecondLb.text = @"无";
        
        //颜色
        UILabel *colorLb = [[UILabel alloc]initWithFrame:CGRectMake(30, commodityClassificationLb.frame.origin.y + commodityClassificationLb.frame.size.height + 10, 90, 50)];
        colorLb.font = [UIFont systemFontOfSize:15];
        colorLb.textColor = [UIColor grayColor];
        colorLb.text = @"颜色：";
        [_detailV addSubview:colorLb];
        //填写颜色
        self.colorTF = [[UITextField alloc]initWithFrame:CGRectMake(140, colorLb.frame.origin.y, (kScreenW - 140 - 30), 50)];
        self.colorTF.layer.borderWidth = 0.8;
        self.colorTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_detailV addSubview:self.colorTF];
        
        //数量
        UILabel *numberLb = [[UILabel alloc]initWithFrame:CGRectMake(30, colorLb.frame.origin.y + colorLb.frame.size.height + 10, 90, 50)];
        numberLb.font = [UIFont systemFontOfSize:15];
        numberLb.textColor = [UIColor grayColor];
        numberLb.text = @"数量：";
        [_detailV addSubview:numberLb];
        //填写数量
        UILabel *reduceLb = [[UILabel alloc]initWithFrame:CGRectMake(140, numberLb.frame.origin.y, 50, 50)];
        reduceLb.userInteractionEnabled = YES;
        reduceLb.layer.borderWidth = 0.8;
        reduceLb.layer.borderColor = Main_Color.CGColor;
        reduceLb.font = [UIFont systemFontOfSize:28];
        reduceLb.text = @"-";
        reduceLb.textColor = Main_Color;
        reduceLb.textAlignment = NSTextAlignmentCenter;
        UITapGestureRecognizer *numReduceTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(numReduce)];
        numReduceTap.numberOfTapsRequired = 1;
        numReduceTap.numberOfTouchesRequired = 1;
        [reduceLb addGestureRecognizer:numReduceTap];
        [_detailV addSubview:reduceLb];
        UILabel *plusLb = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 30 - 50, numberLb.frame.origin.y, 50, 50)];
        plusLb.userInteractionEnabled = YES;
        plusLb.layer.borderWidth = 0.8;
        plusLb.layer.borderColor = Main_Color.CGColor;
        plusLb.font = [UIFont systemFontOfSize:28];
        plusLb.text = @"+";
        plusLb.textColor = Main_Color;
        plusLb.textAlignment = NSTextAlignmentCenter;
        UITapGestureRecognizer *numPlusTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(numPlus)];
        numPlusTap.numberOfTapsRequired = 1;
        numPlusTap.numberOfTouchesRequired = 1;
        [plusLb addGestureRecognizer:numPlusTap];
        [_detailV addSubview:plusLb];
        
        self.goodsNumberLb = [[UILabel alloc]initWithFrame:CGRectMake(reduceLb.frame.origin.x + reduceLb.frame.size.width + 10, numberLb.frame.origin.y, plusLb.frame.origin.x - reduceLb.frame.origin.x - reduceLb.frame.size.width - 20, 50)];
        self.goodsNumberLb.layer.borderWidth = 0.8;
        self.goodsNumberLb.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.goodsNumberLb.textAlignment = NSTextAlignmentCenter;
        self.goodsNumberLb.text = @"1";
        self.goodsNumberLb.font = [UIFont systemFontOfSize:18];
        [_detailV addSubview:self.goodsNumberLb];
        
        
        //价格
        UILabel *priceLb = [[UILabel alloc]initWithFrame:CGRectMake(30, numberLb.frame.origin.y + numberLb.frame.size.height + 10, 90, 50)];
        priceLb.font = [UIFont systemFontOfSize:15];
        priceLb.textColor = [UIColor grayColor];
        priceLb.text = @"价格：";
        [_detailV addSubview:priceLb];
        self.priceTF = [[UITextField alloc]initWithFrame:CGRectMake(140, priceLb.frame.origin.y, (kScreenW - 140 - 30), 50)];
        self.priceTF.layer.borderWidth = 0.8;
        self.priceTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.priceTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [_detailV addSubview:self.priceTF];
        
        //备注
        UILabel *remarksLb = [[UILabel alloc]initWithFrame:CGRectMake(30, priceLb.frame.origin.y + priceLb.frame.size.height + 10, 90, 80)];
        remarksLb.font = [UIFont systemFontOfSize:15];
        remarksLb.textColor = [UIColor grayColor];
        remarksLb.text = @"备注：";
        [_detailV addSubview:remarksLb];
        self.remarksTF = [[UITextField alloc]initWithFrame:CGRectMake(140, remarksLb.frame.origin.y, (kScreenW - 140 - 30), 80)];
        self.remarksTF.layer.borderWidth = 0.8;
        self.remarksTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_detailV addSubview:self.remarksTF];
    }
    return _detailV;
}

//用户联系信息
- (UIView *)noticeBackV
{
    if (_noticeBackV == nil) {
        _noticeBackV = [[UIView alloc]initWithFrame:CGRectMake(0, self.detailV.frame.origin.y + self.detailV.frame.size.height + 20, kScreenW, 330)];
        _noticeBackV.backgroundColor = [UIColor whiteColor];
        _noticeBackV.layer.borderWidth = 1;
        _noticeBackV.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        UILabel *noticeLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, _noticeBackV.frame.size.width, 50)];
        noticeLb.text = @"通知方式";
        noticeLb.font = [UIFont systemFontOfSize:18 weight:0.2];
        noticeLb.textColor = [UIColor grayColor];
        noticeLb.textAlignment = NSTextAlignmentCenter;
        [_noticeBackV addSubview:noticeLb];
        
        self.mobilePhoneTF = [[UITextField alloc]initWithFrame:CGRectMake(40, noticeLb.frame.origin.y + noticeLb.frame.size.height + 20, kScreenW - 80, 50)];
        self.mobilePhoneTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.mobilePhoneTF.layer.borderWidth = 0.8;
        self.mobilePhoneTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        self.mobilePhoneTF.placeholder = @"手机号码";
        self.mobilePhoneTF.tag = 888;
        self.mobilePhoneTF.delegate = self;
        [_noticeBackV addSubview:self.mobilePhoneTF];
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"UserPhone"]) {
            self.mobilePhoneTF.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserPhone"];
        }
        
        UILabel *weightLb = [[UILabel alloc]initWithFrame:CGRectMake(0, self.mobilePhoneTF.frame.origin.y + self.mobilePhoneTF.frame.size.height + 20 , kScreenW, 50)];
        weightLb.text = @"预估重量g";
        weightLb.font = [UIFont systemFontOfSize:18 weight:0.2];
        weightLb.textColor = [UIColor grayColor];
        weightLb.textAlignment = NSTextAlignmentCenter;
        [_noticeBackV addSubview:weightLb];
        
        self.weightTF = [[UITextField alloc]initWithFrame:CGRectMake(40, weightLb.frame.origin.y + weightLb.frame.size.height + 20, kScreenW - 80, 50)];
        self.weightTF.layer.borderWidth = 0.8;
        self.weightTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.weightTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        self.weightTF.placeholder = @"预计克数";
        self.weightTF.tag = 999;
        self.weightTF.delegate = self;
        [_noticeBackV addSubview:self.weightTF];
        
    }
    return _noticeBackV;
}

//商品估算
- (UIView *)priceDetailsV
{
    if (_priceDetailsV == nil) {
        _priceDetailsV = [[UIView alloc]initWithFrame:CGRectMake(0, self.noticeBackV.frame.origin.y + self.noticeBackV.frame.size.height + 20 , kScreenW, 340)];
        _priceDetailsV.backgroundColor = [UIColor whiteColor];
        _priceDetailsV.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _priceDetailsV.layer.borderWidth = 1;
        
        
    }
    return _priceDetailsV;
}

//提交信息bar
- (UIView *)submitV
{
    if (_submitV == nil) {
        _submitV = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH - 60, kScreenW, 60)];
        _submitV.backgroundColor = [UIColor whiteColor];
        _submitV.layer.shadowColor = [UIColor blackColor].CGColor;
        _submitV.layer.shadowOpacity = 0.8f;
        _submitV.layer.shadowRadius = 3.f;
        _submitV.layer.shadowOffset = CGSizeMake(0,0);
        
//        UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 100, 10, 90, 40)];
//        submitBtn.backgroundColor = Main_Color;
//        [submitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
//        [submitBtn addTarget:self action:@selector(submitOrder) forControlEvents:UIControlEventTouchUpInside];
//        [_submitV addSubview:submitBtn];
        
        
        UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 60)];
        submitBtn.backgroundColor = Main_Color;
        [submitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(submitOrder) forControlEvents:UIControlEventTouchUpInside];
        [_submitV addSubview:submitBtn];
        
    }
    return _submitV;
}

//提交订单
- (void)submitOrder
{
    if (self.headerTF.text == nil) {
        self.headerTF.text = @"";
    }
    
    if (self.commodityClassificationSecondLb.text == nil) {
        self.commodityClassificationSecondLb.text = @"";
    }
    
    
    if ([self.colorTF.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"信息填写不全" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([self.priceTF.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"信息填写不全" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([self.mobilePhoneTF.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"信息填写不全" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"提交中", nil);
    
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *params = @{@"api_id":API_ID,
                             @"api_token":TOKEN,
                             @"secret_key":userToken,
                             @"name":self.headerTF.text,
                             @"link":self.webLink,
                             @"category":self.commodityClassificationFirstLb.text,
                             @"attribute":self.commodityClassificationSecondLb.text,
                             @"color":self.colorTF.text,
                             @"price":self.priceTF.text,
                             @"quantity":self.goodsNumberLb.text,
                             @"weight":self.weightTF.text,
                             @"remark":self.remarksTF.text,
                             @"number":self.mobilePhoneTF.text,
                             @"country":[[NSUserDefaults standardUserDefaults]objectForKey:@"currencySign"]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:EntrustBuyApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"提交成功!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"提交失败!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"提交失败!", @"HUD message title");
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
    }];
}

- (void)showPickView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerViewBackV.frame = CGRectMake(0, kScreenH - 290, kScreenW, 230);
    }];
}

- (void)cancelPick
{
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerViewBackV.frame = CGRectMake(0, kScreenH , kScreenW, 230);
    }];
}

- (void)surePick
{
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerViewBackV.frame = CGRectMake(0, kScreenH , kScreenW, 230);
    }];
    
    self.commodityClassificationFirstLb.text = self.firstName;
    self.commodityClassificationSecondLb.text = self.secondName;
}

- (void)numReduce
{
    if ([self.goodsNumberLb.text isEqualToString:@"1"]) {
        return;
    }
    self.goodsNumberLb.text = [NSString stringWithFormat:@"%d",[self.goodsNumberLb.text intValue] - 1];
}

- (void)numPlus
{
    if ([self.goodsNumberLb.text isEqualToString:@"99"]) {
        return;
    }
    self.goodsNumberLb.text = [NSString stringWithFormat:@"%d",[self.goodsNumberLb.text intValue] + 1];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 888 || textField.tag == 999) {
        self.backSv.contentSize = CGSizeMake(0, 1360);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.pickerViewBackV.frame = CGRectMake(0, kScreenH , kScreenW, 230);
    }];
    
    if (self.mobilePhoneTF.isFirstResponder || self.weightTF.isFirstResponder) {
        
    }else{
        self.backSv.contentSize = CGSizeMake(0, 960);
    }
    
    
    
    [self.headerTF resignFirstResponder];
    [self.colorTF resignFirstResponder];
    [self.priceTF resignFirstResponder];
    [self.remarksTF resignFirstResponder];
    [self.mobilePhoneTF resignFirstResponder];
    [self.weightTF resignFirstResponder];

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
