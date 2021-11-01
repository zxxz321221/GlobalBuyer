//
//  AdditionInformationViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/1/25.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "AdditionInformationViewController.h"
#import "LoadingView.h"
#import <WebKit/WebKit.h>
@interface AdditionInformationViewController ()

@property (nonatomic,strong)LoadingView *loadingView;
@property (nonatomic,strong)NSMutableArray *dataSorce;
@property (nonatomic,strong)WKWebView *web;


@end

@implementation AdditionInformationViewController

//加载中动画
-(LoadingView *)loadingView{
    if (_loadingView == nil) {
        _loadingView = [LoadingView LoadingViewSetView:self.view];
    }
    return _loadingView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self downData];
}

- (NSMutableArray *)dataSorce
{
    if (_dataSorce == nil) {
        _dataSorce = [NSMutableArray new];
    }
    return _dataSorce;
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.web = [[WKWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.web];
}

- (void)downData
{
    [self.loadingView startLoading];
    
    NSUserDefaults *defaults = [ NSUserDefaults standardUserDefaults ];
    // 取得 iPhone 支持的所有语言设置
    NSArray *languages = [defaults objectForKey : @"AppleLanguages" ];
    NSLog (@"%@", languages);
    // 获得当前iPhone使用的语言
    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
    NSLog(@"当前使用的语言：%@",currentLanguage);
    NSString *language;
    if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
        language = @"zh_CN";
    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
        language = @"zh_TW";
    }else if([currentLanguage isEqualToString:@"en"]){
        language = @"en";
    }else if([currentLanguage isEqualToString:@"Japanese"]){
        language = @"ja";
    }else{
        language = @"zh_CN";
    }
    
    NSDictionary *params = @{@"api_id":API_ID,
                             @"api_token":TOKEN,
                             @"name":@"addition",
                             @"locale":language};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:HelpOneApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            
            self.title = responseObject[@"data"][@"title"];
            
            [self.loadingView stopLoading];
            
            NSMutableString *htmlString = [NSMutableString string];
            [htmlString appendString:@"<html>"];
            [htmlString appendString:responseObject[@"data"][@"body"]];
            NSMutableArray *muArr = [self getRangeStr:htmlString findText:@"src="];
            NSLog(@"====%@",muArr);
            for (int i = 0; i < muArr.count; i++) {
                [htmlString insertString:WebPictureApi atIndex:[muArr[i] integerValue] + 5 + 24*i +i];
            }
            [htmlString appendString:@"</html>"];
            
            NSLog(@"%@",htmlString);
            
            [self.web loadHTMLString:htmlString baseURL:nil];
            
//            [UIView animateWithDuration:2 animations:^{
//                self.loadingView.imgView.animationDuration = 3*0.15;
//                self.loadingView.imgView.animationRepeatCount = 0;
//                [self.loadingView.imgView startAnimating];
//                self.loadingView.imgView.frame = CGRectMake(kScreenW, self.view.bounds.size.height/2 - 50, self.loadingView.imgView.frame.size.width, self.loadingView.imgView.frame.size.height);
//            } completion:^(BOOL finished) {
//
//            }];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (NSMutableArray *)getRangeStr:(NSString *)text findText:(NSString *)findText

{
    
    NSMutableArray *arrayRanges = [NSMutableArray arrayWithCapacity:20];
    
    if (findText == nil && [findText isEqualToString:@""]) {
        
        return nil;
        
    }
    
    NSRange rang = [text rangeOfString:findText]; //获取第一次出现的range
    
    if (rang.location != NSNotFound && rang.length != 0) {
        
        [arrayRanges addObject:[NSNumber numberWithInteger:rang.location]];//将第一次的加入到数组中
        
        NSRange rang1 = {0,0};
        
        NSInteger location = 0;
        
        NSInteger length = 0;
        
        for (int i = 0;; i++)
            
        {
            
            if (0 == i) {//去掉这个xxx
                
                location = rang.location + rang.length;
                
                length = text.length - rang.location - rang.length;
                
                rang1 = NSMakeRange(location, length);
                
            }else
                
            {
                
                location = rang1.location + rang1.length;
                
                length = text.length - rang1.location - rang1.length;
                
                rang1 = NSMakeRange(location, length);
                
            }
            
            //在一个range范围内查找另一个字符串的range
            
            rang1 = [text rangeOfString:findText options:NSCaseInsensitiveSearch range:rang1];
            
            if (rang1.location == NSNotFound && rang1.length == 0) {
                
                break;
                
            }else//添加符合条件的location进数组
                
                [arrayRanges addObject:[NSNumber numberWithInteger:rang1.location]];
            
        }
        
        return arrayRanges;
        
    }
    
    return nil;
    
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
