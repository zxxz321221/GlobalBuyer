//
//  HelpDetailViewController.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/6/14.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "HelpDetailViewController.h"
#import <WebKit/WebKit.h>
@interface HelpDetailViewController ()<WKNavigationDelegate>
@property (nonatomic , strong) WKWebView * wkWebView;
@end

@implementation HelpDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self loadData];
}


- (void)setupUI {
    [self setNavigationBackBtn];
    [self.view addSubview:self.wkWebView];
}
- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, NavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavBarHeight)];
        
        //以下代码适配大小
               NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
               
               WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
               WKUserContentController *wkUController = [[WKUserContentController alloc] init];
               [wkUController addUserScript:wkUScript];
               
               WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
               webConfig.userContentController = wkUController;
               
               _wkWebView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:webConfig];

               _wkWebView.navigationDelegate = self;
    }
    return _wkWebView;
}

- (void)loadData{
    
    NSMutableString *htmlString = [NSMutableString string];
    [htmlString appendString:@"<html>"];
    [htmlString appendString:self.bodyStr];
    NSMutableArray *muArr = [self getRangeStr:htmlString findText:@"src="];
    NSLog(@"====%@",muArr);
    for (int i = 0; i < muArr.count; i++) {
        [htmlString insertString:WebPictureApi atIndex:[muArr[i] integerValue] + 5 + 24*i +i];
    }
    [htmlString appendString:@"</html>"];
    
    NSLog(@"%@",htmlString);
    
    [self.wkWebView loadHTMLString:htmlString baseURL:nil];
    
    
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

-(void)insertStr:(NSMutableString *)str{
    
    NSString *string2 = @"src=\"";
    NSRange range = [str rangeOfString:string2];
    if (range.location != NSNotFound) {
        [str insertString:PictureApi atIndex: range.length +range.location];
    }
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
