//
//  SizeViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/4/8.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "SizeViewController.h"
#import "SizeTableViewCell.h"
#import "EditSizeViewController.h"
@interface SizeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UIButton * addBtn;
@property (nonatomic,strong) NSMutableArray * sizeList;
@end

@implementation SizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的尺码";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addBtn];
    [self addLeftBarButtonWithImage:[UIImage imageNamed:@"back"] action:@selector(backClick)];
}
- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addLeftBarButtonWithImage:(UIImage *)image action:(SEL)action
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(0, 0, 44, 44);
    [firstButton setImage:image forState:UIControlStateNormal];
    [firstButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 5 * SCREEN_WIDTH / 375.0, 0, 0)];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64-[Unity countcoordinatesH:70])];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (UIButton *)addBtn{
    if (_addBtn == nil) {
        _addBtn = [[UIButton alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], self.tableView.bottom+[Unity countcoordinatesH:10], kScreenW- [Unity countcoordinatesW:20], [Unity countcoordinatesH:50])];
        _addBtn.backgroundColor = [UIColor redColor];
        _addBtn.layer.cornerRadius = 5;
        [_addBtn setTitle:@"新增" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}
- (NSMutableArray *)sizeList{
    if (_sizeList == nil) {
        _sizeList = [NSMutableArray new];
        NSArray * arr = @[@{@"name":@"我的尺码", @"sex":@"男",@"height":@"170",@"weight":@"65",@"shoulder":@"60",@"chest":@"60",@"waistline":@"60",@"girth":@"",@"footSize":@"60",@"bottoms":@""}];
        _sizeList = [NSMutableArray arrayWithArray:arr];
    }
    return _sizeList;
}
- (void)addClick{
    EditSizeViewController * evc = [[EditSizeViewController alloc]init];
    evc.hidesBottomBarWhenPushed = YES;
    evc.isEdit = NO;
    [self.navigationController pushViewController:evc animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sizeList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Unity countcoordinatesH:190];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NameIdentifier";
    SizeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[SizeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell configName:self.sizeList[indexPath.row][@"name"] Sex:self.sizeList[indexPath.row][@"sex"] Height:self.sizeList[indexPath.row][@"height"] Weight:self.sizeList[indexPath.row][@"weight"] Shoulder:self.sizeList[indexPath.row][@"shoulder"] Chest:self.sizeList[indexPath.row][@"chest"] Waistline:self.sizeList[indexPath.row][@"waistline"] Girth:self.sizeList[indexPath.row][@"girth"] FootSize:self.sizeList[indexPath.row][@"footSize"] Bottoms:self.sizeList[indexPath.row][@"bottoms"] Index:indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    cell.editBlock = ^(NSInteger index) {
        [weakSelf myFavoriteCellAddToShoppingCart:index];
    };
    
    return cell;
}
- (void)myFavoriteCellAddToShoppingCart:(NSInteger)index{
    EditSizeViewController * evc = [[EditSizeViewController alloc]init];
    evc.hidesBottomBarWhenPushed = YES;
    evc.dic = self.sizeList[index];
    evc.isEdit = YES;
    [self.navigationController pushViewController:evc animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"点击的是%@",self.sizeList[indexPath.row]);

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
