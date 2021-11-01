//
//  FeedViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/4/28.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "FeedViewController.h"

#import "UserModel.h"
#define ViewFrame CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
#define TitleSize [UIFont systemFontOfSize:15]

@interface FeedViewController ()<UITextViewDelegate>
{
    NSString * record;
    NSArray * arr;
}
@property (nonatomic,retain) UIScrollView * backGroundView;
@property (nonatomic,retain) UILabel * textviewplace;
@property (nonatomic,retain) UITextView * feedBackText;
@property (nonatomic , strong) UIButton * btn;

@property (nonatomic , strong) UserModel * model;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    record = @"";
    arr =@[NSLocalizedString(@"GlobalBuyer_feed_btn_1", nil),NSLocalizedString(@"GlobalBuyer_feed_btn_2", nil),NSLocalizedString(@"GlobalBuyer_feed_btn_3", nil),NSLocalizedString(@"GlobalBuyer_feed_btn_4", nil),NSLocalizedString(@"GlobalBuyer_feed_btn_5", nil),NSLocalizedString(@"GlobalBuyer_feed_btn_6", nil),];
    // Do any additional setup after loading the view.
    [self.view addSubview:[self bGroudView]];
}
- (UIScrollView *)bGroudView{
    if (self.backGroundView==nil) {
        self.backGroundView=[[UIScrollView alloc]initWithFrame:ViewFrame];
        UITapGestureRecognizer * backGroundViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGroundViewTap:)];
        [self.backGroundView addGestureRecognizer:backGroundViewTap];
        
        UILabel * label = [Unity lableViewAddsuperview_superView:self.backGroundView _subViewFrame:CGRectMake(10, 0, kScreenW-20, [Unity countcoordinatesH:40]) _string:NSLocalizedString(@"GlobalBuyer_feed_titleType",nil) _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
        [self configDatasource];
        
        //        UILabel * label=[Unity lableViewAddsuperview_superView:self.backGroundView _subViewFrame:CGRectMake([Unity countcoordinatesX:40/2], [Unity countcoordinatesY:30/2]+self.btn.bottom, [Unity countcoordinatesW:200], [Unity countcoordinatesY:40]) _string:@"动动手指给我们您的想法" _lableFont:TitleSize _lableTxtColor:[UIColor blackColor] _textAlignment:NSTextAlignmentLeft];
        
        UIImageView * imageView=[Unity imageviewAddsuperview_superView:self.backGroundView _subViewFrame:CGRectMake(10, self.btn.bottom+20, kScreenW-20,341/2) _imageName:@"feededit.png" _backgroundColor:[UIColor clearColor]];
        UITextView * view =[[UITextView alloc]init];
        view.frame=CGRectMake(2, [Unity countcoordinatesY:10], imageView.width-4, imageView.height-15);
        view.delegate=self;
        view.font=[UIFont systemFontOfSize:15];
        self.feedBackText=view;
        [imageView addSubview:view];
        self.textviewplace = [Unity lableViewAddsuperview_superView:self.feedBackText _subViewFrame:CGRectMake(2, 2, self.feedBackText.width-4, 20) _string:NSLocalizedString(@"GlobalBuyer_feed_placeHoder", nil) _lableFont:TitleSize _lableTxtColor:[UIColor grayColor] _textAlignment:NSTextAlignmentLeft];
        self.textviewplace.textColor=[Unity getColor:@"#CCCCCC"];
        self.textviewplace.numberOfLines=0;
        imageView.userInteractionEnabled=YES;
        
        UILabel * label1 = [Unity lableViewAddsuperview_superView:self.backGroundView _subViewFrame:CGRectMake(imageView.left, imageView.bottom, imageView.width, [Unity countcoordinatesH:80]) _string:NSLocalizedString(@"GlobalBuyer_feed_tishi", nil) _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:[Unity getColor:@"#666666"] _textAlignment:NSTextAlignmentLeft];
        label1.numberOfLines = 0;
        
        UIButton * button=[Unity buttonAddsuperview_superView:self.backGroundView _subViewFrame:CGRectMake(label1.left,label1.bottom+[Unity countcoordinatesY:60], label1.width ,[Unity countcoordinatesH:50]) _tag:self _action:@selector(btnClick) _string:NSLocalizedString(@"GlobalBuyer_feed_submit", nil) _imageName:@""];
        button.titleLabel.font = [UIFont systemFontOfSize: 16.0];
        [button setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        button.backgroundColor = Main_Color;
        button.layer.cornerRadius = 10;
        self.backGroundView.contentSize=CGSizeMake(kScreenW , kScreenH);
    }
    return self.backGroundView;
}
- (void)configDatasource{
    
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = [Unity countcoordinatesH:40]+10;//用来控制button距离父视图的高
    CGFloat lastBtnY = 0;
    for (int i = 0; i < arr.count; i++) {//创建button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = i+1000;
        button.backgroundColor = [UIColor whiteColor];
        //设置边框颜色
        button.layer.borderColor = [[Unity getColor:@"#999999"] CGColor];
        //设置边框宽度
        button.layer.borderWidth = 1.0f;
        button.layer.cornerRadius = 10.0f;
        [button addTarget:self action:@selector(clickHotSearchAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[Unity getColor:@"#999999"] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:14];
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button sizeToFit];
        CGFloat length = button.frame.size.width;
        //设置button的frame
                button.frame = CGRectMake(10 + w, h, length + 15 , 30);// 距离屏幕左右边距各10,
        //当button的位置超出屏幕边缘时换行
        if(20 + w + length + 15 > kScreenW){
            w = 0; //换行时将w置为0
            h = h + button.frame.size.height + 10;//距离父视图也变化
            button.frame = CGRectMake(10 + w, h, length + 15, 30);//重设button的frame
        }
        if (length + 20 > kScreenW - 20) {
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 8)];// 设置button的title距离边框有一定的间隙,显示不下的字会省略
            button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, kScreenW - 20, 30);//重设button的frame
            
        }
        w = button.frame.size.width + button.frame.origin.x;//重新赋值
        if (i==arr.count-1) {
            lastBtnY=button.frame.origin.y;
        }
        [self.backGroundView addSubview:button];
        self.btn = button;
    }
}
-(void)clickHotSearchAction:(UIButton *)btn{
    if ([self contains:[NSString stringWithFormat:@"%ld",btn.tag-1000]]) {
        UIButton * button = (UIButton *)[self.backGroundView viewWithTag:btn.tag];
        //设置边框颜色
        button.layer.borderColor = [[Unity getColor:@"#999999"] CGColor];
        //设置边框宽度
        button.layer.borderWidth = 1.0f;
        [button setTitleColor:[Unity getColor:@"#999999"] forState:UIControlStateNormal];
    }else{
        UIButton * button = (UIButton *)[self.backGroundView viewWithTag:btn.tag];
        //设置边框颜色
        button.layer.borderColor = [Main_Color CGColor];
        //设置边框宽度
        button.layer.borderWidth = 1.0f;
        [button setTitleColor:Main_Color forState:UIControlStateNormal];
    }
}
- (void)btnClick{ //意见反馈请求
    NSString *parm=@"";
    NSString * Feedback=@"反馈问题:";//反馈问题默认空
    NSString * date = [self getCurrentTimes];
    NSString * web_url = [NSString stringWithFormat:@"反馈网页链接:%@",self.web_url];
    if (record.length>0) {
        for (int i=0; i<record.length; i++) {
            NSRange range = {i,1};
            NSString *string1 = [record substringWithRange:range];//截取范围内的字符串
            
            if (i == record.length-1) {
                Feedback = [Feedback stringByAppendingFormat:@"%@",arr[[string1 intValue]]];
            }else{
                Feedback = [Feedback stringByAppendingFormat:@"%@、",arr[[string1 intValue]]];
            }
        }
    }
    NSString * creare_at = @"";
    if (self.model.created_at != nil) {
        creare_at = self.model.created_at;
    }
    NSString * detail = [NSString stringWithFormat:@"反馈详情:%@",self.feedBackText.text];
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    
    if (userToken) {//已登录
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path=[paths    objectAtIndex:0];
        NSLog(@"path = %@",path);
        NSString *filename=[path stringByAppendingPathComponent:@"user.plist"];
        NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:filename];
        self.model = [[UserModel alloc]initWithDictionary:dict error:nil];
        
        NSLog(@"dic = %@",dict);
        
        parm = [NSString stringWithFormat:@"反馈时间:%@\n用户名:%@\n注册邮箱:%@\n个人信息填写邮箱:%@\n手机号:%@\n注册时间:%@\n%@\n%@\n%@",date,self.model.fullname,self.model.email,self.model.email_name,self.model.mobile_phone,creare_at,web_url,Feedback,detail];
        
    }else{//未登录
        parm = [NSString stringWithFormat:@"反馈时间:%@\n未登录\n%@\n%@\n%@",date,web_url,Feedback,detail];
    }
    if (record.length == 0 && [self.feedBackText.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = NSLocalizedString(@"GlobalBuyer_feed_label1", nil);
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, 180.f);
        [hud hideAnimated:YES afterDelay:2.f];
    }else{
        [self request:parm];
    }
}
-(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}
- (void)backGroundViewTap:(UITapGestureRecognizer *)tap{
    [self.feedBackText resignFirstResponder];
}
//- (void)delayMethod{
//    [self.navigationController popViewControllerAnimated:YES];
//}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.feedBackText resignFirstResponder];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.textviewplace.hidden = YES;
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        self.textviewplace.hidden = NO;
    }else{
        self.textviewplace.hidden = YES;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    if ([text isEqualToString:@""] && range.length > 0) {
        return YES;
    }else{
        if (textView.text.length  >= 300) {
            return NO;
        }else {
            return YES;
        }
    }
    return YES;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"GlobalBuyer_feed_title", nil);

    self.view.backgroundColor = [Unity getColor:@"#f5f5f5"];
}
- (BOOL)contains:(NSString *)str{
    if ([record containsString:str]) {
        record = [record stringByReplacingOccurrencesOfString:str withString:@""];
        return YES;
    } else {
        record = [record stringByAppendingFormat:@"%@", str];
        return NO;
    }
}
- (void)leftBtnPressed:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)request:(NSString *)content{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary new];
    //    params[@"api_id"] = API_ID;
    //    params[@"api_token"] = TOKEN;
    params[@"title"] = @"iOS反馈信息";
    params[@"text"] = content;
    params[@"level"] = @"normal";
    params[@"group"] = @"app-ios";
    
    
    [manager POST:ErrorApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"success"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"GlobalBuyer_feed_label2", nil);
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, 180.f);
            [hud hideAnimated:YES afterDelay:2.f];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(2.0* NSEC_PER_SEC)),dispatch_get_main_queue(),^{
                
                //2秒后执行这里的代码...
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"GlobalBuyer_feed_label3", nil);
            // Move to bottm center.
            hud.offset = CGPointMake(0.f, 180.f);
            [hud hideAnimated:YES afterDelay:2.f];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
 
    }];
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
