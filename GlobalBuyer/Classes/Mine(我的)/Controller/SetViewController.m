//
//  SetViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/5/9.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "SetViewController.h"
#import <SDImageCache.h>
#import "FeedViewController.h"
#import "AboutUsViewController.h"
#import "RootViewController.h"
// 获取caches 文件夹路径
#define cachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true) firstObject]
@interface SetViewController ()
@property (nonatomic , strong) UILabel * cache;
@property (nonatomic , strong) UIButton * exitBtn;
@property (nonatomic , strong) MBProgressHUD * HUD;
@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self cacheSize];
}
- (void)initUI{
    NSArray * arr = @[@"消息推送设置",@"清除缓存",@"意见反馈",@"关于我们",@"分享APP"];
    for (int i=0; i<arr.count; i++) {
        UIButton * btn = [Unity buttonAddsuperview_superView:self.view _subViewFrame:CGRectMake(0, [Unity countcoordinatesH:10]+i*[Unity countcoordinatesH:50], kScreenW, [Unity countcoordinatesH:50]) _tag:self _action:@selector(setClick:) _string:@"" _imageName:@""];
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = i+1000;
        UILabel * btnTitle = [Unity lableViewAddsuperview_superView:btn _subViewFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:10], [Unity countcoordinatesW:120], [Unity countcoordinatesH:30]) _string:arr[i] _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
        if (i==0) {
            UILabel * setL = [Unity lableViewAddsuperview_superView:btn _subViewFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:128], [Unity countcoordinatesH:10], [Unity countcoordinatesW:100], [Unity countcoordinatesH:30]) _string:@"去设置" _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentRight];
        }
        if (i==1) {
            self.cache = [Unity lableViewAddsuperview_superView:btn _subViewFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:110], [Unity countcoordinatesH:10], [Unity countcoordinatesW:100], [Unity countcoordinatesH:30]) _string:@"正在计算..." _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentRight];
        }
        if (i!=4) {
            UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:49], kScreenW-[Unity countcoordinatesW:10], [Unity countcoordinatesH:1])];
            line.backgroundColor = [Unity getColor:@"#e0e0e0"];
            [btn addSubview:line];
        }
        if (i!=1) {
            UIImageView * imageView = [Unity imageviewAddsuperview_superView:btn _subViewFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:18], [Unity countcoordinatesH:18], [Unity countcoordinatesW:8], [Unity countcoordinatesH:14]) _imageName:@"箭头" _backgroundColor:nil];
        }
    }
    [self.view addSubview:self.exitBtn];
}
- (UIButton *)exitBtn{
    if (!_exitBtn) {
        _exitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, [Unity countcoordinatesH:270], kScreenW, [Unity countcoordinatesH:50])];
        _exitBtn.backgroundColor =[UIColor whiteColor];
        [_exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_exitBtn setTitleColor:[Unity getColor:@"#333333"] forState:UIControlStateNormal];
        [_exitBtn addTarget:self action:@selector(exitClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitBtn;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"设置";
    self.view.backgroundColor = [Unity getColor:@"f0f0f0"];
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
- (void)setClick:(UIButton *)sender{
    if (sender.tag == 1000) {
        
    }else if (sender.tag == 1001){
        [self clearCache:cachePath];
    }else if (sender.tag == 1002){
        FeedViewController * fvc = [[FeedViewController alloc]init];
        fvc.web_url = @"";
        fvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fvc animated:YES];
    }else if (sender.tag == 1003){
        AboutUsViewController * avc = [[AboutUsViewController alloc]init];
        avc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:avc animated:YES];
    }else{
        NSString *text = NSLocalizedString(@"GlobalBuyer_My_Share_text", nil);
        UMSocialMessageObject *message = [[UMSocialMessageObject alloc]init];
        UMShareWebpageObject *url = [[UMShareWebpageObject alloc]init];
        url.title = text;
        url.thumbImage = [UIImage imageNamed:@"logIcon.png"];
        url.webpageUrl = REURL;
        message.shareObject = url;
        [[UMSocialManager defaultManager]shareToPlatform:UMSocialPlatformType_WechatSession messageObject:message currentViewController:self completion:^(id result, NSError *error) {
            
        }];
    }
}
- (void)exitClick{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GlobalBuyer_UserInfo_Alert_title", nil) message:NSLocalizedString(@"GlobalBuyer_UserInfo_Alert_message", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
        NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        NSMutableDictionary *params = [NSMutableDictionary new];
        params[@"api_id"] = API_ID;
        params[@"api_token"] = TOKEN;
        params[@"secret_key"] = userToken;
        
        [manager POST:UnbundlingJPushApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path=[paths    objectAtIndex:0];
        NSLog(@"path = %@",path);
        NSString *filename=[path stringByAppendingPathComponent:@"user.plist"];
        NSFileManager *defaultManager = [NSFileManager defaultManager];
        [defaultManager removeItemAtPath:filename error:nil];
        [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"WECHATBIND"];
        [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"FACEBIND"];
        UserDefaultRemoveObjectForKey(USERTOKEN);
        [self.navigationController popViewControllerAnimated:YES];
        [[UMSocialManager defaultManager] cancelAuthWithPlatform:UMSocialPlatformType_Facebook   completion:^(id result, NSError *error) {
            
        }];
        [[UMSocialDataManager defaultManager] clearAllAuthorUserInfo];
        [[NSUserDefaults standardUserDefaults]setObject:@"false" forKey:@"DistributorBoss"];
        RootViewController * rvc = [[RootViewController alloc]init];
        [rvc refreshGoodsNum];
        [self.delegate loadMyPage];
        [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"APriceRule"];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (float)folderSizeAtPath:(NSString *)path {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize = 0.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:absolutePath];
        }
        // SDWebImage框架自身计算缓存的实现
        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;

        return folderSize;
    }
    NSLog(@"没缓存");
    return 0;
}
- (float)fileSizeAtPath:(NSString *)path {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}
//清楚缓存
- (void)clearCache:(NSString *)path {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        self.cache.text = @"0.00M";
        self.cache.textColor = [Unity getColor:@"#333333"];
    }];
}
- (void)cacheSize{
    
    float cacheS = [self folderSizeAtPath:cachePath];
    self.cache.text = [NSString stringWithFormat:@"%.2fM",cacheS];
    self.cache.textColor = [Unity getColor:@"#333333"];
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
