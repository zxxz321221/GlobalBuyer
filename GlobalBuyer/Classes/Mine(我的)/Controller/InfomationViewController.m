//
//  InfomationViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/4/2.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "InfomationViewController.h"
#import "SLDatePicker.h"
#import "UIColor+Category.h"
#import "JPhotoMagenage.h"
#import "UserModel.h"
#import "InterestViewController.h"
@interface InfomationViewController ()
{
    NSString * sexuality;//0 男 1女
    UIButton * manBtn;
    UIButton * womanBtn;
    UILabel * dateL;
}
@property (nonatomic,strong)UIView * headerView;//头部view
@property (nonatomic,strong)UIImageView * headImageView;
@property (nonatomic,strong)UILabel * accountL;//账号
@property (nonatomic,strong)UITextField * nameText;//昵称输入框

@property (nonatomic, weak) UIView *alphaBackgroundView;

@property (nonatomic, weak) SLGeneralDatePickerView *pickerView;

@property (nonatomic, weak) UIView *topContainerView;
@property (nonatomic, weak) UIButton *doneButton;
@property (nonatomic, weak) UIButton *cancelButton;

@property (nonatomic,strong)UIImage * phImage;

@property (nonatomic , strong) UserModel * model;

@property (nonatomic , strong) UIButton * interestBtn;
@end

@implementation InfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sexuality = @"0";
    self.view.backgroundColor = [Unity getColor:@"#f0f0f0"];
    [self setHeaderView];
    [self setItem];
    [self userInfo];
}
- (void)userInfo{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths    objectAtIndex:0];
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);;
    NSString *filename=[path stringByAppendingPathComponent:@"user.plist"];
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:filename];
    self.model = [[UserModel alloc]initWithDictionary:dict error:nil];
    
    NSLog(@"dic = %@",dict);
    if (userToken) {
        self.accountL.text = self.model.email;
        self.nameText.text = self.model.fullname;
        NSLog(@"图片  %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"UserHeadImgUrl"]);
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"UserHeadImgUrl"]) {
            [self.headImageView sd_setImageWithURL:[[NSUserDefaults standardUserDefaults]objectForKey:@"UserHeadImgUrl"] placeholderImage:[UIImage imageNamed:@"我的头像"]];
        }
        if ([[self.model.sex stringValue]isEqualToString:@"0"]) {
            sexuality = @"0";
            [manBtn setBackgroundImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
            [womanBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        }else{
            sexuality = @"1";
            [manBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
            [womanBtn setBackgroundImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
        }
        if (self.model.birth) {
            dateL.text = self.model.birth;
        }
    }
}
- (void)setHeaderView{
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, [Unity countcoordinatesH:240])];
    _headerView.userInteractionEnabled = YES;
    _headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headerView];
    UILabel * backLabel = [[UILabel  alloc]initWithFrame:CGRectMake(0, 0, kScreenW, [Unity countcoordinatesH:150])];
    backLabel.userInteractionEnabled = YES;
    CAGradientLayer *layerG = [CAGradientLayer new];
    layerG.colors=@[(__bridge id)[UIColor colorWithRed:75.0/255.0 green:14.0/255.0 blue:105.0/255.0 alpha:1].CGColor,(__bridge id)[UIColor py_colorWithHexString:@"#b444c8"].CGColor];
    layerG.startPoint = CGPointMake(0.5, 0);
    layerG.endPoint = CGPointMake(0.5, 1);
    layerG.frame = backLabel.bounds;
    [backLabel.layer addSublayer:layerG];
    [_headerView addSubview:backLabel];
    
    UIButton * back = [Unity buttonAddsuperview_superView:backLabel _subViewFrame:CGRectMake(10, 32, 18, 20) _tag:self _action:@selector(backBtn:) _string:@"" _imageName:@"back"];
    UILabel * navTitle = [Unity lableViewAddsuperview_superView:backLabel _subViewFrame:CGRectMake((kScreenW-[Unity countcoordinatesW:200])/2, 31, [Unity countcoordinatesW:200], 22) _string:@"个人信息" _lableFont:[UIFont systemFontOfSize:18] _lableTxtColor:[UIColor whiteColor] _textAlignment:NSTextAlignmentCenter];
    UIButton * add = [Unity buttonAddsuperview_superView:backLabel _subViewFrame:CGRectMake(kScreenW-50, navTitle.top, 40, 22) _tag:self _action:@selector(addClick:) _string:@"保存" _imageName:@""];
    [add setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    add.titleLabel.font = [UIFont systemFontOfSize:15];
    
    _headImageView = [Unity imageviewAddsuperview_superView:_headerView _subViewFrame:CGRectMake((kScreenW-100)/2, [Unity countcoordinatesH:105], 100, 100) _imageName:@"我的头像" _backgroundColor:nil];
    _headImageView.layer.cornerRadius = 50;
    _headImageView.clipsToBounds = YES;
    UITapGestureRecognizer *singleTap =   [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerAction)];
    singleTap.numberOfTapsRequired = 1; //点击次数
    singleTap.numberOfTouchesRequired = 1; //点击手指数
    [_headImageView addGestureRecognizer:singleTap];
    _headImageView.userInteractionEnabled = YES;
 
    UIImageView * xjImgView = [Unity imageviewAddsuperview_superView:_headerView _subViewFrame:CGRectMake(_headImageView.right-[Unity countcoordinatesH:25], _headImageView.bottom-[Unity countcoordinatesH:25], [Unity countcoordinatesH:25], [Unity countcoordinatesH:25]) _imageName:@"相机" _backgroundColor:nil];
    
    UILabel * nameL = [Unity lableViewAddsuperview_superView:_headerView _subViewFrame:CGRectMake((kScreenW-200)/2, _headImageView.bottom+[Unity countcoordinatesH:10], 200, [Unity countcoordinatesH:20]) _string:@"点击修改头像" _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:self.interestBtn];
}
- (void)setItem{
    NSArray * arr = @[@"账号",@"昵称",@"性别",@"出生日期"];
    for (int i=0; i<arr.count; i++) {
        UIButton * btn = [Unity buttonAddsuperview_superView:self.view _subViewFrame:CGRectMake(0, (_headerView.bottom+[Unity countcoordinatesH:10])+i*[Unity countcoordinatesH:50], kScreenW, [Unity countcoordinatesH:50]) _tag:nil _action:nil _string:@"" _imageName:@""];
        btn.backgroundColor = [UIColor whiteColor];
        UILabel * nameL = [Unity lableViewAddsuperview_superView:btn _subViewFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:10], [Unity countcoordinatesW:100], [Unity countcoordinatesH:30]) _string:arr[i] _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
        UILabel * line = [Unity lableViewAddsuperview_superView:btn _subViewFrame:CGRectMake(nameL.left, [Unity countcoordinatesH:49], kScreenW-[Unity countcoordinatesW:20], [Unity countcoordinatesH:1]) _string:@"" _lableFont:nil _lableTxtColor:nil _textAlignment:NSTextAlignmentLeft];
        line.backgroundColor = [Unity getColor:@"#f0f0f0"];
        if (i==0) {
            _accountL = [Unity lableViewAddsuperview_superView:btn _subViewFrame:CGRectMake(nameL.right, nameL.top, [Unity countcoordinatesW:170], nameL.height) _string:@"" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
        }else if (i==1){
            _nameText = [Unity textFieldAddSuperview_superView:btn _subViewFrame:CGRectMake(nameL.right, nameL.top, [Unity countcoordinatesW:100], nameL.height) _placeT:@"请输入昵称" _backgroundImage:nil _delegate:self andSecure:NO andBackGroundColor:nil];
        }else if (i==2){
            manBtn = [Unity buttonAddsuperview_superView:btn _subViewFrame:CGRectMake(nameL.right, [Unity countcoordinatesH:17], [Unity countcoordinatesW:16], [Unity countcoordinatesH:16]) _tag:self _action:@selector(manClick) _string:@"" _imageName:@"选中"];
            UILabel * manL = [Unity lableViewAddsuperview_superView:btn _subViewFrame:CGRectMake(manBtn.right+[Unity countcoordinatesW:10], nameL.top, [Unity countcoordinatesW:40], nameL.height) _string:@"男" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
            womanBtn = [Unity buttonAddsuperview_superView:btn _subViewFrame:CGRectMake(manL.right+[Unity countcoordinatesW:30], [Unity countcoordinatesH:17], [Unity countcoordinatesW:16], [Unity countcoordinatesH:16]) _tag:self _action:@selector(womanClick) _string:@"" _imageName:@"未选中"];
            UILabel * womanL = [Unity lableViewAddsuperview_superView:btn _subViewFrame:CGRectMake(womanBtn.right+[Unity countcoordinatesW:10], nameL.top, [Unity countcoordinatesW:100], nameL.height) _string:@"女" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
        }else if (i == 3){
            dateL = [Unity lableViewAddsuperview_superView:btn _subViewFrame:CGRectMake(nameL.right, nameL.top, [Unity countcoordinatesW:150], nameL.height) _string:@"1985-01-01" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
            dateL.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap =   [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(datePicker)];
            singleTap.numberOfTapsRequired = 1; //点击次数
            singleTap.numberOfTouchesRequired = 1; //点击手指数
            [dateL addGestureRecognizer:singleTap];
        }
    }
}
- (UIButton *)interestBtn{
    if (!_interestBtn) {
        _interestBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, _headerView.bottom+[Unity countcoordinatesH:220], kScreenW, [Unity countcoordinatesH:50])];
        [_interestBtn addTarget:self action:@selector(interestClick) forControlEvents:UIControlEventTouchUpInside];
        _interestBtn.backgroundColor = [UIColor whiteColor];
        UILabel * label = [Unity lableViewAddsuperview_superView:_interestBtn _subViewFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:10], [Unity countcoordinatesW:150], [Unity countcoordinatesH:30]) _string:@"感兴趣的分类" _lableFont:[UIFont systemFontOfSize:14] _lableTxtColor:[Unity getColor:@"#333333"] _textAlignment:NSTextAlignmentLeft];
        label.backgroundColor = [UIColor clearColor];
        UIImageView * goImg = [Unity imageviewAddsuperview_superView:_interestBtn _subViewFrame:CGRectMake(kScreenW-[Unity countcoordinatesW:15], [Unity countcoordinatesH:20], [Unity countcoordinatesW:5], [Unity countcoordinatesH:10]) _imageName:@"灰箭头" _backgroundColor:nil];
        goImg.backgroundColor = [UIColor clearColor];
        UILabel * dianL = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-[Unity countcoordinatesH:25]-5, ([Unity countcoordinatesH:50]-5)/2, 5, 5)];
        dianL.backgroundColor = [UIColor redColor];
        dianL.layer.cornerRadius =2.5;
        dianL.layer.masksToBounds = YES;
        [_interestBtn addSubview:dianL];
        
    }
    return _interestBtn;
}
- (void)datePicker{
    self.alphaBackgroundView.hidden = NO;
    self.pickerView.hidden = NO;
    
    //如果只需要默认值，则屏蔽这行代码
    [self.pickerView setupPickerViewDataWithDefaultSelectedDate:[NSDate date] dateFormatter:@"yyyy-MM-dd" datePickerMode:SLDatePickerModeDate];
}
- (void)manClick{
    sexuality = @"0";
    [manBtn setBackgroundImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
    [womanBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
}
- (void)womanClick{
    sexuality = @"1";
    [manBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [womanBtn setBackgroundImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
}
- (void)addClick:(UIButton *)btn{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
    
    NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":api_token,@"fullname":_nameText.text,@"sex":sexuality,@"birth":dateL.text};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:editInfomationApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        NSLog(@"上传基本信息返回数据  %@",responseObject);
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            NSDictionary *dict = responseObject[@"data"];
            UserModel *model = [[UserModel alloc]initWithDictionary:dict error:nil];
            
            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *path=[paths    objectAtIndex:0];
            NSLog(@"path = %@",path);
            NSString *filename=[path stringByAppendingPathComponent:@"user.plist"];
            NSFileManager* fm = [NSFileManager defaultManager];
            [fm createFileAtPath:filename contents:nil attributes:nil];
            
            NSString *emailName = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"email_name"]];
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:model.email,@"email",model.fullname,@"fullname",model.currency,@"currency",emailName,@"email_name",model.sex,@"sex",model.birth,@"birth",nil];
            [dic writeToFile:filename atomically:YES];
            
            
            NSDictionary* dic2 = [NSDictionary dictionaryWithContentsOfFile:filename];
//            NSLog(@"dic is:%@",dic2);
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"上传成功!", @"HUD message title");
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:2.f];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = NSLocalizedString(@"上传失败!", @"HUD message title");
            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            [hud hideAnimated:YES afterDelay:2.f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
    }];
}

- (void)backBtn:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)headerAction{
    [JPhotoMagenage getOneImageInController:self finish:^(UIImage *images) {
        NSLog(@"%@",images);
        
        NSData *data =UIImageJPEGRepresentation(images, 0.5);
        UIImage *img = [UIImage imageWithData:data];
        NSString *imgName = UserDefaultObjectForKey(USERTOKEN);

        NSString *path_sandox = NSHomeDirectory();

        NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat: @"/Documents/%@.png",imgName]];

        [UIImagePNGRepresentation(img) writeToFile:imagePath atomically:YES];

        _headImageView.image = img;


        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
        hud.label.text= NSLocalizedString(@"正在上传", nil);

        NSDictionary *api_token = UserDefaultObjectForKey(USERTOKEN);;
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

        NSData *dataAvatar;
        if (UIImagePNGRepresentation(_phImage) == nil) {

            dataAvatar = UIImageJPEGRepresentation(images, 1);

        } else {

            dataAvatar = UIImagePNGRepresentation(images);
        }


        NSDictionary *params = @{@"api_id":API_ID,@"api_token":TOKEN,@"secret_key":api_token};
        [manager POST:UploadAvatarApi parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

            [formData appendPartWithFileData:dataAvatar name:@"avatar" fileName:@"avatar.png" mimeType:@"image/png"];


        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [hud hideAnimated:YES];
            NSLog(@"上传头像返回结果 %@",responseObject);
            if ([responseObject[@"code"]isEqualToString:@"success"]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = NSLocalizedString(@"上传成功!", @"HUD message title");
                // Move to bottm center.
                hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
                [hud hideAnimated:YES afterDelay:3.f];
                [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"http://buy.dayanghang.net%@",responseObject[@"data"]] forKey:@"UserHeadImgUrl"];
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
    } cancel:^{
        
    }];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    
    [self.pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.alphaBackgroundView);
        make.height.equalTo(@(260.f));
    }];
    
    [self.topContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.alphaBackgroundView);
        make.bottom.equalTo(self.pickerView.mas_top);
        make.height.equalTo(@40.f);
    }];
    
    [self.doneButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.topContainerView);
        make.right.equalTo(self.topContainerView.mas_right);
        make.width.equalTo(@(60.f));
    }];
    
    [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerY.equalTo(self.doneButton);
        make.left.equalTo(self.topContainerView.mas_left);
    }];
}
- (void)doneButtonTapped:(id)sender {
    self.alphaBackgroundView.hidden = YES;
    dateL.text = self.pickerView.date;
//    NSLog(@"g.date = %@", self.pickerView.date);
}

- (void)cancelButtonTapped:(id)sender {
    self.alphaBackgroundView.hidden = YES;
}

#pragma mark - Getter
- (UIView *)alphaBackgroundView {
    if (!_alphaBackgroundView) {
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.28f];
        view.hidden = YES;
        [self.view addSubview:view];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonTapped:)];
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:recognizer];
        
        _alphaBackgroundView = view;
    }
    
    return _alphaBackgroundView;
}

- (SLGeneralDatePickerView *)pickerView {
    if (!_pickerView) {
        SLGeneralDatePickerView *view = [[SLGeneralDatePickerView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.hidden = YES;
        [self.alphaBackgroundView addSubview:view];
        
        _pickerView = view;
    }
    
    return _pickerView;
}

- (UIView *)topContainerView {
    if (!_topContainerView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor grayColor];
        [self.alphaBackgroundView addSubview:view];
        
        _topContainerView = view;
    }
    
    return _topContainerView;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [button addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.topContainerView addSubview:button];
        
        _doneButton = button;
    }
    
    return _doneButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"取消" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [button addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.topContainerView addSubview:button];
        
        _cancelButton = button;
    }
    
    return _cancelButton;
}
- (void)interestClick{
    InterestViewController * ivc = [[InterestViewController alloc]init];
    [self.navigationController pushViewController:ivc animated:YES];
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
