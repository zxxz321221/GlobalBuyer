//
//  OptionalTransshipmentViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2020/3/30.
//  Copyright © 2020 薛铭. All rights reserved.
//

#import "OptionalTransshipmentViewController.h"
#import "ZxzyCell1.h"
#import "ZxzyCell2.h"
#import "ZxzyCell3.h"
#import "ZxzyCell4.h"
#import "ZxzyCell5.h"
#import "JPhotoMagenage.h"
#import "PhotoView.h"
#import "SeleteCurrecy.h"
#import "TaobaoTransportApplyViewController.h"
@interface OptionalTransshipmentViewController ()<UITableViewDelegate,UITableViewDataSource,PhotoViewDelegate,SeleteCurrecyDelegate,ZxzyCell1Delegate,ZxzyCell4Delegate>
{
    NSInteger cellNum;
    BOOL isAdd;
    BOOL isIcon;
    NSString * iconUrl;
    NSDictionary * currecyDic;
    BOOL isCell;
    NSInteger index;
    BOOL iscell1;
    NSInteger index1;
}
@property (nonatomic , strong) UITableView * tableView;
@property (nonatomic , strong) UIView * bottomView;

@property (nonatomic , strong) NSMutableDictionary * dict ;

@property (nonatomic , strong) PhotoView * pView;
@property (nonatomic , strong) SeleteCurrecy * sView;

@property (nonatomic , strong) NSMutableArray * dataArr;

@property (nonatomic , strong) UILabel * line1;
@property (nonatomic , strong) UIButton * confirmBtn;
@property (nonatomic , strong) UIButton * cancelBtn;
@end

@implementation OptionalTransshipmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    currecyDic = [NSDictionary new];
    self.title = NSLocalizedString(@"GlobalBuyer_zdy_cart", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    isAdd = NO;
    iscell1 = NO;
    isCell = NO;
    isIcon = NO;
    cellNum = 4;
    
    
    [self createUI];
}
- (void)createUI{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    
}
#pragma mark 初始化
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBarHeight, kScreenW, kScreenH-NavBarHeight-bottomH)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate=self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = FALSE;
        _tableView.showsHorizontalScrollIndicator = FALSE;
        [_tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        //没有数据时不显示cell
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}
#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return cellNum;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row ==0) {
        return [Unity countcoordinatesH:251];
    }else if (indexPath.row ==1){
        return [Unity countcoordinatesH:40];
    }else if (indexPath.row == cellNum-1){//总计
        if (isAdd) {
            return [Unity countcoordinatesH:30];
        }else{
            return 0.1;
        }
    }else{//添加的商品
        if (isAdd) {//已添加商品
            return [Unity countcoordinatesH:180];//序列数量
        }else{//未添加商品
            return [Unity countcoordinatesH:25];
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        ZxzyCell1 *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZxzyCell1 class])];
        if (cell == nil) {
            cell = [[ZxzyCell1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ZxzyCell1 class])];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configLink:iconUrl WithDic:currecyDic];
        if (isIcon) {
            [cell.icon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",iconUrl]]];
            cell.icon.hidden = NO;
        }else{
            cell.icon.hidden = YES;
        }
        cell.delegate = self;
        return cell;
    }else if (indexPath.row == 1){
        ZxzyCell2 *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZxzyCell2 class])];
        if (cell == nil) {
            cell = [[ZxzyCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ZxzyCell2 class])];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == cellNum-1){
        ZxzyCell5 *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZxzyCell5 class])];
        if (cell == nil) {
            cell = [[ZxzyCell5 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ZxzyCell5 class])];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSInteger count=0;
        for (int i=0; i<self.dataArr.count; i++) {
            count= count+[self.dataArr[i][@"quantity"] intValue];
        }
        [cell configWithIsAdd:isAdd WithNum:count];
        return cell;
    }else{//添加的商品
        if (isAdd) {//已添加商品
            ZxzyCell4 *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZxzyCell4 class])];
            if (cell == nil) {
                cell = [[ZxzyCell4 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ZxzyCell4 class])];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configWithData:self.dataArr[indexPath.row-2] xvhao:indexPath.row-1];
            cell.delegate = self;
            return cell;
        }else{//未添加商品
            ZxzyCell3 *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ZxzyCell3 class])];
            if (cell == nil) {
                cell = [[ZxzyCell3 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ZxzyCell3 class])];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return [Unity countcoordinatesH:10];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [UIView new];
    return footer;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-bottomH, SCREEN_WIDTH, bottomH)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_bottomView addSubview:self.line1];
        [_bottomView addSubview:self.confirmBtn];
        [_bottomView addSubview:self.cancelBtn];
    }
    return _bottomView;
}
- (UILabel *)line1{
    if (!_line1) {
        _line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        _line1.backgroundColor = [Unity getColor:@"f0f0f0"];
    }
    return _line1;
}
- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-[Unity countcoordinatesW:90], [Unity countcoordinatesH:10], [Unity countcoordinatesW:80], [Unity countcoordinatesH:35])];
        [_confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
        [_confirmBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmBtn.backgroundColor = Main_Color;
        _confirmBtn.layer.cornerRadius = _confirmBtn.height/2;
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _confirmBtn;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-[Unity countcoordinatesW:180], [Unity countcoordinatesH:10], [Unity countcoordinatesW:80], [Unity countcoordinatesH:35])];
        [_cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpOutside];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[Unity getColor:@"33333"] forState:UIControlStateNormal];
        _cancelBtn.layer.cornerRadius = _cancelBtn.height/2;
        _cancelBtn.layer.borderWidth =1;
        _cancelBtn.layer.borderColor = [Unity getColor:@"33333"].CGColor;
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _cancelBtn;
}
- (NSMutableDictionary *)dict{
    if (!_dict) {
        _dict = [NSMutableDictionary new];
    }
    return _dict;
}
- (PhotoView *)pView{
    if (!_pView) {
//        UIWindow * window = [UIApplication sharedApplication].windows[0];
        _pView = [PhotoView setPhotoView:self.view];
        _pView.delegate = self;
    }
    return _pView;
}
- (SeleteCurrecy *)sView{
    if (!_sView) {
        _sView = [SeleteCurrecy setSeleteCurrecy:self.view];
        _sView.delegate = self;
    }
    return _sView;
}
- (void)seleteCurrecy{
    [self.sView showSeleteCurrecy];
}
- (void)updateIcon{//弹出拍照 相册 连接
    isCell = NO;
    [self.pView showPhotoView];
}
- (void)seleteBtn:(NSInteger)tag{
    if (tag == 1000) {//拍照
        [JPhotoMagenage JphotoTakePhotoInController:self finish:^(UIImage *image) {
            [self uploadImage:image];
        } cancel:^{
            
        }];
    }else if (tag == 1001){//相册
        [JPhotoMagenage JphotoGetFromSystemInController:self finish:^(UIImage *image) {
            [self uploadImage:image];
        } cancel:^{
            
        }];
    }else{//链接
        iconUrl = [[UIPasteboard generalPasteboard] string];
        isIcon = YES;
        [self.tableView reloadData];
    }
    [self.pView hiddenCashWay];
}
- (void)uploadImage:(UIImage *)image{
    NSData *dataAvatar;
    if (UIImagePNGRepresentation(image) == nil) {
        dataAvatar = UIImageJPEGRepresentation(image, 1);
    } else {
        dataAvatar = UIImagePNGRepresentation(image);
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    hud.label.text= NSLocalizedString(@"正在上传", nil);
    
//    NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
//    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":api_token};
    [manager POST:@"http://buy.dayanghang.net/api/platform/web/bazhuayu/limit/webapi/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:dataAvatar name:@"imgfile" fileName:@"goodsIcon.png" mimeType:@"image/png"];
        
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        
        if ([responseObject[@"status"] intValue] == 0) {
            NSString * wotada = @"http://buy.dayanghang.net";
            if (!isCell) {
                iconUrl = [NSString stringWithFormat:@"%@%@",wotada,responseObject[@"url"]];
                isIcon = YES;
                [self.tableView reloadData];
            }else{
                for (int i=0; i<self.dataArr.count; i++) {
                    if (i==index) {
                        NSMutableDictionary * dicc = [self.dataArr[i] mutableCopy];
                        [dicc setObject:[NSString stringWithFormat:@"%@%@",wotada,responseObject[@"url"]] forKey:@"picture"];
                        [self.dataArr replaceObjectAtIndex:index withObject:dicc];
                    }
                }
                [self.tableView reloadData];
            }
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"上传成功!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"上传失败!", @"HUD message title");
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:3.f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"上传失败!", @"HUD message title");
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:3.f];
    }];
}
- (void)seleteCurrecyDic:(NSDictionary *)dic{
    if (!iscell1) {
        currecyDic = dic;
        [self.tableView reloadData];
    }else{
        for (int i=0; i<self.dataArr.count; i++) {
            if (i==index1) {
                NSMutableDictionary * dicc = [self.dataArr[i] mutableCopy];
                [dicc setObject:dic[@"bz"] forKey:@"currency"];
                [self.dataArr replaceObjectAtIndex:index1 withObject:dicc];
            }
        }
        [self.tableView reloadData];
    }
    
}
- (void)addIconUrl:(NSString *)url GoodsName:(NSString *)name GoodsLink:(NSString *)link GoodsParam:(NSString *)param GoodsPrice:(NSString *)price GoodsCurrecy:(NSString *)currecy GoodsNum:(NSString *)num{
    NSMutableDictionary * ddic = [NSMutableDictionary new];
    [ddic setObject:param forKey:@"attributes"];
    [ddic setObject:currecy forKey:@"currency"];
    [ddic setObject:link forKey:@"goodLink"];
    [ddic setObject:name forKey:@"name"];
    [ddic setObject:url forKey:@"picture"];
    [ddic setObject:price forKey:@"price"];
    [ddic setObject:num forKey:@"quantity"];
    [self.dataArr addObject:ddic];
    
    isAdd = YES;
    cellNum = 3+self.dataArr.count;
    [self.tableView reloadData];
}
- (void)showHud1:(NSString *)msg{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = msg;
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    [hud hideAnimated:YES afterDelay:3.f];
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
- (void)updateIcon:(ZxzyCell4 *)cell{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
//    NSLog(@"%d",indexPath.row);
    index = indexPath.row-2;
    isCell = YES;
    [self.pView showPhotoView];
}
- (void)seleteCurrecy:(ZxzyCell4 *)cell{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    iscell1 = YES;
    index1 = indexPath.row-2;
    [self.sView showSeleteCurrecy];
}
- (void)updataIcon:(NSString *)icon Name:(NSString *)name Price:(NSString *)price BZ:(NSString *)bz Param:(NSString *)param Num:(NSString *)num Cell:(ZxzyCell4 *)cell{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    for (int i=0; i<self.dataArr.count; i++) {
        if (i==indexPath.row) {
            NSMutableDictionary * dicc = [self.dataArr[i] mutableCopy];
            [dicc setObject:icon forKey:@"picture"];
            [dicc setObject:name forKey:@"name"];
            [dicc setObject:price forKey:@"price"];
            [dicc setObject:bz forKey:@"currency"];
            [dicc setObject:param forKey:@"attributes"];
            [dicc setObject:num forKey:@" quantity"];
            [self.dataArr replaceObjectAtIndex:indexPath.row withObject:dicc];
        }
    }
    [self.tableView reloadData];
}
- (void)goodsDelete:(ZxzyCell4 *)cell{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    [self.dataArr removeObjectAtIndex:indexPath.row-2];
    if (self.dataArr.count ==0) {
        cellNum = 4;
        isAdd = NO;
    }else{
        cellNum = 3+self.dataArr.count;
        isAdd = YES;
    }
    [self.tableView reloadData];
}
- (void)confirmClick{
    TaobaoTransportApplyViewController *vc = [[TaobaoTransportApplyViewController alloc]init];
    vc.goodsArr = self.dataArr;
    vc.type = 4;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
