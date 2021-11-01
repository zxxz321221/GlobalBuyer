//
//  ActViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/11/1.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "ActViewController.h"
//京东：https://p.m.jd.com/cart/cart.action?fromnav=1
//网易：http://m.you.163.com/cart
//淘宝：https://h5.m.taobao.com/mlapp/cart.html
#import "TaobaoShopCartViewController.h"
#import "OptionalTransshipmentViewController.h"
@interface ActViewController ()

@end

@implementation ActViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *titleView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.navigationItem.titleView = titleView;
    titleView.text = NSLocalizedString(@"GlobalBuyer_TaobaoTransport_AuthorizedLogin", nil);
    titleView.textColor = [UIColor whiteColor];

    self.view.backgroundColor = [Unity getColor:@"f0f0f0"];
    [self INIT];
}
- (void)INIT{

    NSArray * arr = @[NSLocalizedString(@"GlobalBuyer_jd_cart", nil),NSLocalizedString(@"GlobalBuyer_yx_cart", nil),NSLocalizedString(@"GlobalBuyer_zdy_cart", nil),NSLocalizedString(@"GlobalBuyer_1688_cart", nil)];
    NSArray * img = @[@"jd",@"yx",@"zdy",@"1688i"];
    for (int i=0; i<arr.count; i++) {
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, NavBarHeight+[Unity countcoordinatesH:15]+i*[Unity countcoordinatesH:10]+i*[Unity countcoordinatesH:60], SCREEN_WIDTH, [Unity countcoordinatesH:60])];
        btn.tag = i+1001;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:btn];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:10], [Unity countcoordinatesW:40], [Unity countcoordinatesH:40])];
//        imageView.backgroundColor = [UIColor redColor];
        imageView.image = [UIImage imageNamed:img[i]];
        [btn addSubview:imageView];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:60], 0, SCREEN_WIDTH-[Unity countcoordinatesW:70], [Unity countcoordinatesH:60])];
        label.text = arr[i];
        label.textColor = [Unity getColor:@"333333"];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:18];
        [btn addSubview:label];
    }
}
- (void)btnClick:(UIButton *)sender{
    TaobaoShopCartViewController * tvc = [[TaobaoShopCartViewController alloc]init];
    if (sender.tag == 1000) {
        tvc.shopCartStr = @"https://h5.m.taobao.com/mlapp/cart.html";
        tvc.type = 0;
        tvc.navT = @"TaoBaoCart";
        [self.navigationController pushViewController:tvc animated:YES];
    }else if (sender.tag == 1001){
        tvc.shopCartStr = @"https://p.m.jd.com/cart/cart.action?fromnav=1";
        tvc.type = 1;
        tvc.navT = @"JingDongCart";
        [self.navigationController pushViewController:tvc animated:YES];
    }else if (sender.tag == 1002){
        tvc.shopCartStr = @"http://m.you.163.com/cart";
        tvc.type = 2;
        tvc.navT = @"YanXuanCart";
        [self.navigationController pushViewController:tvc animated:YES];
    }else if (sender.tag == 1003){
        //自选转运
        OptionalTransshipmentViewController * ovc = [[OptionalTransshipmentViewController alloc]init];
        [self.navigationController pushViewController:ovc animated:YES];
    }else{
        tvc.shopCartStr = @"https://cart2.m.1688.com/page/cart.html";
        tvc.type = 3;
        tvc.navT = @"1688Cart";
        [self.navigationController pushViewController:tvc animated:YES];
    }
    
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
