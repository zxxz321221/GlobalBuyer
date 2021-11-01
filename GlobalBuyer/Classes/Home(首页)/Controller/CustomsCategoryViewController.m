//
//  CustomsCategoryViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/10/15.
//  Copyright © 2018年 薛铭. All rights reserved.
//

#import "CustomsCategoryViewController.h"
#import "CustomsCategoryCell.h"

@interface CustomsCategoryViewController ()<UITableViewDataSource,UITableViewDelegate,CustomsCategoryCellDelegate>

@property (nonatomic,strong)UITableView *tabV;
@property (nonatomic,strong)NSMutableArray *cateDataSource;

@property (nonatomic,strong)NSString *special;


@property (nonatomic , strong) UILabel * ptLabel;
@property (nonatomic , strong) UILabel * ptLle;
@property (nonatomic , strong) UILabel * lineL;
@property (nonatomic , strong) UILabel * tsLabel;
@property (nonatomic , strong) UILabel * tsLle;
@end

@implementation CustomsCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self createUI];
//    [self downCate];
    self.title = NSLocalizedString(@"GlobalBuyer_Entrust_Category_categoryLb", nil);
    self.view.backgroundColor = [Unity getColor:@"f0f0f0"];
    [self.view addSubview:self.ptLabel];
    [self.view addSubview:self.ptLle];
    [self.view addSubview:self.lineL];
    [self.view addSubview:self.tsLabel];
    [self.view addSubview:self.tsLle];
}
- (UILabel *)ptLabel{
    if (!_ptLabel) {
        _ptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, NavBarHeight, kScreenW, [Unity countcoordinatesH:40])];
        _ptLabel.backgroundColor = [UIColor whiteColor];
        _ptLabel.textColor = [Unity getColor:@"333333"];
        _ptLabel.font = [UIFont systemFontOfSize:16];
        NSMutableParagraphStyle*style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        //对齐方式
        style.alignment = NSTextAlignmentLeft;
        //首行缩进
        style.firstLineHeadIndent=[Unity countcoordinatesW:10];
        NSAttributedString*attrText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"GlobalBuyer_TaobaoTransport_Ordinary", nil) attributes:@{NSParagraphStyleAttributeName: style}];
        _ptLabel.attributedText = attrText;
        
        UITapGestureRecognizer *cateTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ptClick)];
        cateTap.numberOfTapsRequired = 1;
        cateTap.numberOfTouchesRequired = 1;
        [_ptLabel addGestureRecognizer:cateTap];
        
        _ptLabel.userInteractionEnabled = YES;
    }
    return _ptLabel;
}
- (UILabel *)ptLle{
    if (!_ptLle) {
        _ptLle = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], _ptLabel.bottom+[Unity countcoordinatesH:5], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:100])];
        _ptLle.text = @"服飾類及其輔料、鞋類及其輔料、包及其輔料、飾品、文具、塑膠製品、五金製品、衛浴器材、運動器材、體育用品、簡易工具類、電子類產品（連接線、插頭、開關等）等涉及民生類產品(不收文件類)";
        _ptLle.textColor = [Unity getColor:@"666666"];
        _ptLle.font = [UIFont systemFontOfSize:14];
        _ptLle.numberOfLines = 0;
        [_ptLle sizeToFit];
        UITapGestureRecognizer *cateTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ptClick)];
        cateTap.numberOfTapsRequired = 1;
        cateTap.numberOfTouchesRequired = 1;
        [_ptLle addGestureRecognizer:cateTap];
        _ptLle.userInteractionEnabled = YES;
    }
    return _ptLle;
}
- (UILabel *)lineL{
    if (!_lineL) {
        _lineL = [[UILabel alloc]initWithFrame:CGRectMake(0, _ptLle.bottom+[Unity countcoordinatesH:5], kScreenW, 1)];
        _lineL.backgroundColor = [Unity getColor:@"e0e0e0"];
    }
    return _lineL;
}
- (UILabel *)tsLabel{
    if (!_tsLabel) {
        _tsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _lineL.bottom, kScreenW, [Unity countcoordinatesH:40])];
        _tsLabel.backgroundColor = [UIColor whiteColor];
        _tsLabel.textColor = [Unity getColor:@"333333"];
        _tsLabel.font = [UIFont systemFontOfSize:16];
        NSMutableParagraphStyle*style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        //对齐方式
        style.alignment = NSTextAlignmentLeft;
        //首行缩进
        style.firstLineHeadIndent=[Unity countcoordinatesW:10];
        NSAttributedString*attrText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"GlobalBuyer_TaobaoTransport_Special", nil) attributes:@{NSParagraphStyleAttributeName: style}];
        _tsLabel.attributedText = attrText;
        UITapGestureRecognizer *cateTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tsClick)];
        cateTap.numberOfTapsRequired = 1;
        cateTap.numberOfTouchesRequired = 1;
        [_tsLabel addGestureRecognizer:cateTap];
        _tsLabel.userInteractionEnabled = YES;
    }
    return _tsLabel;
}
- (UILabel *)tsLle{
    if (!_tsLle) {
        _tsLle = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], _tsLabel.bottom+[Unity countcoordinatesH:5], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:100])];
        _tsLle.text = @"知名品牌包包、鞋子、箱子、帶電、磁性商品、液體、粉末、食品";
        _tsLle.textColor = [Unity getColor:@"666666"];
        _tsLle.font = [UIFont systemFontOfSize:14];
        _tsLle.numberOfLines = 0;
        [_tsLle sizeToFit];
        UITapGestureRecognizer *cateTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tsClick)];
        cateTap.numberOfTapsRequired = 1;
        cateTap.numberOfTouchesRequired = 1;
        [_tsLle addGestureRecognizer:cateTap];
        _tsLle.userInteractionEnabled = YES;
    }
    return _tsLle;
}
- (void)ptClick{
    [self.delegate cilckWithId:@"0" name:NSLocalizedString(@"GlobalBuyer_TaobaoTransport_Ordinary", nil)];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tsClick{
    [self.delegate cilckWithId:@"1" name:NSLocalizedString(@"GlobalBuyer_TaobaoTransport_Special", nil)];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)downCate
{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
//    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN};
//
//    [manager GET:CustomsCategoryApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [hud hideAnimated:YES];
//        if ([responseObject[@"code"]isEqualToString:@"success"]) {
//            [self.cateDataSource removeAllObjects];
//            for (int i = 0; i < [responseObject[@"data"] count]; i++) {
//                [self.cateDataSource addObject:responseObject[@"data"][i]];
//            }
//
//            [self.tabV reloadData];
//        }
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
    
    NSDictionary *dict = @{@"id":@"0",
                           @"category":NSLocalizedString(@"GlobalBuyer_TaobaoTransport_Ordinary", nil)};
    NSDictionary *dictTwo = @{@"id":@"1",
                          @"category":NSLocalizedString(@"GlobalBuyer_TaobaoTransport_Special", nil)
                              };
    [self.cateDataSource addObject:dict];
    [self.cateDataSource addObject:dictTwo];
    [self.tabV reloadData];
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tabV];
}

- (UITableView *)tabV
{
    if (_tabV == nil) {
        _tabV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
        _tabV.delegate = self;
        _tabV.dataSource = self;
        _tabV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tabV;
}

- (NSMutableArray *)cateDataSource
{
    if (_cateDataSource == nil) {
        _cateDataSource = [[NSMutableArray alloc]init];
    }
    return _cateDataSource;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if ([self.special isEqualToString:@"0"]) {
            return 150.0;
        }
    }
    if (indexPath.row == 1) {
        if ([self.special isEqualToString:@"1"]) {
            return 150.0;
        }
    }
    return 50.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cateDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomsCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cateCell"];
    
    if (cell == nil) {
        cell = [[CustomsCategoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cateCell"];
    }
    
    cell.nameLb.text = [NSString stringWithFormat:@"%@",self.cateDataSource[indexPath.row][@"category"]];
    cell.specialStr = [NSString stringWithFormat:@"%@",self.cateDataSource[indexPath.row][@"id"]];
    
    if ([cell.specialStr isEqualToString:self.special]) {
        if (indexPath.row == 0) {
            cell.contLb.text = @"服飾類及其輔料、鞋類及其輔料、包及其輔料、飾品、文具、塑膠製品、五金製品、衛浴器材、運動器材、體育用品、簡易工具類、電子類產品（連接線、插頭、開關等）等涉及民生類產品(不收文件類)";
        }
        if (indexPath.row == 1) {
            cell.contLb.text = @"知名品牌包包、鞋子、箱子、帶電、磁性商品、液體、粉末、食品";
        }
    }else{
        cell.contLb.text = @"";
        cell.isSelectbtn.selected = NO;
    }
    
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)isSelect:(NSString *)special
{
    self.special = special;
    [self.tabV reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate cilckWithId:[NSString stringWithFormat:@"%@",self.cateDataSource[indexPath.row][@"id"]] name:[NSString stringWithFormat:@"%@",self.cateDataSource[indexPath.row][@"category"]]];
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
