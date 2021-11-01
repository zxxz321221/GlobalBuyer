//
//  MyQRCodeViewController.m
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/1/22.
//  Copyright © 2018年 赵阳. All rights reserved.
//

#import "MyQRCodeViewController.h"
#import "LoadingView.h"
#import "WXApi.h"
@interface MyQRCodeViewController ()

@property (nonatomic,strong) UIImageView *qrCodeIv;
@property (nonatomic,strong) UIView *qrCodeV;
@property (nonatomic,strong)LoadingView *loadingView;

@property (nonatomic,strong) NSString *qrCodeImgUrl;
@property (nonatomic,strong) NSString *qrCodeNum;

@end

@implementation MyQRCodeViewController

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
    
    [self downData];
    
}


- (void)downData
{
    [self.loadingView startLoading];
    NSString *userToken = UserDefaultObjectForKey(USERTOKEN);
    NSDictionary *params = @{@"api_id":API_ID,
                             @"api_token":TOKEN,
                             @"secret_key":userToken};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:GetUserQRCodeApi parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"code"]isEqualToString:@"success"]) {
            self.qrCodeImgUrl = [NSString stringWithFormat:@"%@",responseObject[@"invite_code_img"]];
            self.qrCodeNum = [NSString stringWithFormat:@"%@",responseObject[@"invite_code"]];
            [self.loadingView stopLoading];
            [self createUI];
            
//            [UIView animateWithDuration:2 animations:^{
//                self.loadingView.imgView.animationDuration = 3*0.15;
//                self.loadingView.imgView.animationRepeatCount = 0;
//                [self.loadingView.imgView startAnimating];
//                self.loadingView.imgView.frame = CGRectMake(kScreenW, self.view.bounds.size.height/2 - 50, self.loadingView.imgView.frame.size.width, self.loadingView.imgView.frame.size.height);
//            } completion:^(BOOL finished) {
//                NSLog(@"%d",finished);
//
//            }];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)createUI
{
    self.title = NSLocalizedString(@"GlobalBuyer_MyQRCodeV_Title", nil);    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backIv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64)];
    backIv.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapAction:)];
    longPress.minimumPressDuration = 1; //定义按的时间
    longPress.numberOfTouchesRequired = 1;
    [backIv addGestureRecognizer:longPress];
    
    NSUserDefaults *defaults = [ NSUserDefaults standardUserDefaults ];
    // 取得 iPhone 支持的所有语言设置
    NSArray *languages = [defaults objectForKey : @"AppleLanguages" ];
    NSLog (@"%@", languages);
    // 获得当前iPhone使用的语言
    NSString* currentLanguage = NSLocalizedString(@"GlobalBuyer_Nativelanguage", nil);
    NSLog(@"当前使用的语言：%@",currentLanguage);
//    if ([currentLanguage isEqualToString:@"zh-Hans-US"]) {
//        backIv.image = [UIImage imageNamed:@"QRCode-j.jpg"];
//    }else if([currentLanguage isEqualToString:@"zh-Hant"]){
//        backIv.image = [UIImage imageNamed:@"QRCode-f.jpg"];
//    }else if([currentLanguage isEqualToString:@"en"]){
//        backIv.image = [UIImage imageNamed:@"QRCode-e.jpg"];
//    }else{
//        backIv.image = [UIImage imageNamed:@"QRCode-j.jpg"];
//    }
    [backIv sd_setImageWithURL:[NSURL URLWithString:@"http://buy.dayanghang.net/app/images/share_background.jpg"] placeholderImage:[UIImage imageNamed:@"QRCode-j.jpg"]];
    
    [self.view addSubview:backIv];
    [self.view addSubview:self.qrCodeIv];
    [self.view addSubview:self.qrCodeV];
}

- (void)longTapAction:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        NSLog(@"long pressTap state :begin");
        UIGraphicsBeginImageContext(CGSizeMake(kScreenW, kScreenH- 64));
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
        
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_My_SaveQRCode", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {

            //写入相册
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
            
        }];
        __weak __typeof(self) weakSelf = self;
        UIAlertAction *shareAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"GlobalBuyer_My_ShareQRCode", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {

            [weakSelf sendImage:image];
            
        }];
        
        [alertVc addAction:saveAction];
        [alertVc addAction:shareAction];
        
        [self presentViewController:alertVc animated:YES completion:nil];

    }else {
        NSLog(@"long pressTap state :end");
    }
    
}


- (void)sendImage:(UIImage *)image{
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
       
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData = imageData;

    WXMediaMessage *message = [WXMediaMessage message];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res5"
                                                         ofType:@"jpg"];
    message.thumbData = [NSData dataWithContentsOfFile:filePath];
    message.mediaObject = imageObject;

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
}





- (UIImageView *)qrCodeIv
{
    if (_qrCodeIv == nil) {
        _qrCodeIv = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2 - 80, kScreenH/2 - 80, 160, 160)];
        _qrCodeIv.layer.borderColor = [UIColor whiteColor].CGColor;
        _qrCodeIv.layer.borderWidth = 0.7;
        
        //1. 实例化二维码滤镜
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        // 2. 恢复滤镜的默认属性
        [filter setDefaults];
        // 3. 将字符串转换成NSData
        //就得http://buy.dayanghang.net/user_data/special/20180528/index.html?code=dyh-wotada%@
        NSString *urlStr = [NSString stringWithFormat:@"http://buy.dayanghang.net/user_data/special/20201017/Other.html?code=dyh-wotada%@",self.qrCodeNum];
        NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
        // 4. 通过KVO设置滤镜inputMessage数据
        [filter setValue:data forKey:@"inputMessage"];
        // 5. 获得滤镜输出的图像
        CIImage *outputImage = [filter outputImage];
        // 6. 将CIImage转换成UIImage，并显示于imageView上 (此时获取到的二维码比较模糊,所以需要用下面的createNonInterpolatedUIImageFormCIImage方法重绘二维码)
        
        
        UIImageView *qrCodeMidIv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 140, 140)];
        qrCodeMidIv.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:170];
//        [qrCodeMidIv sd_setImageWithURL:[NSURL URLWithString:self.qrCodeImgUrl]];
        [_qrCodeIv addSubview:qrCodeMidIv];
        
    }
    return _qrCodeIv;
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (UIView *)qrCodeV
{
    if (_qrCodeV == nil) {
        _qrCodeV = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/2 - 80, kScreenH/2 + 100, 160, 50)];
        _qrCodeV.backgroundColor = [UIColor colorWithRed:33.0/255.0 green:0 blue:105.0/255.0 alpha:0.7];
        _qrCodeV.layer.cornerRadius = 5;
        
        UIImageView *headerImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
        headerImg.layer.cornerRadius = 20;
        [headerImg sd_setImageWithURL:[[NSUserDefaults standardUserDefaults]objectForKey:@"UserHeadImgUrl"] placeholderImage:[UIImage imageNamed:@"icon"]];
        [_qrCodeV addSubview:headerImg];
        
        UILabel *titleNumLb = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 110, 10)];
        titleNumLb.text = NSLocalizedString(@"GlobalBuyer_MyQRCodeV_Title", nil);
        titleNumLb.font = [UIFont systemFontOfSize:12];
        titleNumLb.textAlignment = NSTextAlignmentCenter;
        titleNumLb.textColor = [UIColor whiteColor];
        [_qrCodeV addSubview:titleNumLb];
        UILabel *qrNumLb = [[UILabel alloc]initWithFrame:CGRectMake(50, 20 , 110, 30)];
        qrNumLb.text = self.qrCodeNum;
        qrNumLb.textAlignment = NSTextAlignmentCenter;
        qrNumLb.textColor = [UIColor whiteColor];
        [_qrCodeV addSubview:qrNumLb];
        
    }
    return _qrCodeV;
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
