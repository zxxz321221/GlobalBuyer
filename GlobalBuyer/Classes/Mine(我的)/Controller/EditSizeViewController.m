//
//  EditSizeViewController.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/4/8.
//  Copyright © 2019 薛铭. All rights reserved.
//

#import "EditSizeViewController.h"

@interface EditSizeViewController ()
{
    UIButton * manBtn;
    UIButton * womanBtn;
    UIButton * childrenBtn;
    UIButton * morenBtn;
    BOOL isDefault; //yes 设为默认  no不设置默认
}
@property (nonatomic , strong) UITextField *nameText;
@property (nonatomic , strong) UITextField *sgText;
@property (nonatomic , strong) UITextField *tgText;
@property (nonatomic , strong) UITextField *jkText;
@property (nonatomic , strong) UITextField *xwText;;
@property (nonatomic , strong) UITextField *ywText;
@property (nonatomic , strong) UITextField *bwText;
@property (nonatomic , strong) UITextField *jcText;
@property (nonatomic , strong) UITextField *jwText;

@property (nonatomic , strong) NSString * gender;
@property (nonatomic , strong) UIBarButtonItem * saveBtn;

@end

@implementation EditSizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _gender = @"男";//默认男
    isDefault = YES;
    [self creareUI];
    [self pushDic];
}
- (void)creareUI{
    UILabel * nameL = [Unity lableViewAddsuperview_superView:self.view _subViewFrame:CGRectMake([Unity countcoordinatesW:10], [Unity countcoordinatesH:10], [Unity countcoordinatesW:80], [Unity countcoordinatesH:30]) _string:@"角色名称" _lableFont:[UIFont systemFontOfSize:16] _lableTxtColor:labelTextColor _textAlignment:NSTextAlignmentLeft];
    _nameText = [Unity textFieldAddSuperview_superView:self.view _subViewFrame:CGRectMake(nameL.right, nameL.top, [Unity countcoordinatesW:80], nameL.height) _placeT:@"" _backgroundImage:nil _delegate:self andSecure:NO andBackGroundColor:[UIColor whiteColor]];
    _nameText.layer.borderColor = [labelTextColor CGColor];
    _nameText.layer.borderWidth = 1.0f;
    _nameText.layer.masksToBounds = YES;
    
    UILabel * sexL = [Unity lableViewAddsuperview_superView:self.view _subViewFrame:CGRectMake(nameL.left, nameL.bottom+[Unity countcoordinatesH:10], nameL.width, [Unity countcoordinatesH:30]) _string:@"性    别" _lableFont:[UIFont systemFontOfSize: 16] _lableTxtColor:labelTextColor _textAlignment:NSTextAlignmentLeft];
    
    manBtn = [Unity buttonAddsuperview_superView:self.view _subViewFrame:CGRectMake(sexL.right, sexL.top+[Unity countcoordinatesH:7], [Unity countcoordinatesW:16], [Unity countcoordinatesH:16]) _tag:self _action:@selector(manClick) _string:@"" _imageName:@"选中"];
    UILabel * manL = [Unity lableViewAddsuperview_superView:self.view _subViewFrame:CGRectMake(manBtn.right+[Unity countcoordinatesW:5], sexL.top, [Unity countcoordinatesW:40], [Unity countcoordinatesH:30]) _string:@"男" _lableFont:[UIFont systemFontOfSize:16] _lableTxtColor:labelTextColor _textAlignment:NSTextAlignmentLeft];
    womanBtn = [Unity buttonAddsuperview_superView:self.view _subViewFrame:CGRectMake(manL.right, sexL.top+[Unity countcoordinatesH:7], [Unity countcoordinatesW:16], [Unity countcoordinatesH:16]) _tag:self _action:@selector(womanClick) _string:@"" _imageName:@"未选中"];
    UILabel * womanL = [Unity lableViewAddsuperview_superView:self.view _subViewFrame:CGRectMake(womanBtn.right+[Unity countcoordinatesW:5], sexL.top, [Unity countcoordinatesW:40], [Unity countcoordinatesH:30]) _string:@"女" _lableFont:[UIFont systemFontOfSize:16] _lableTxtColor:labelTextColor _textAlignment:NSTextAlignmentLeft];
    childrenBtn = [Unity buttonAddsuperview_superView:self.view _subViewFrame:CGRectMake(womanL.right, sexL.top+[Unity countcoordinatesH:7], [Unity countcoordinatesW:16], [Unity countcoordinatesH:16]) _tag:self _action:@selector(childrenClick) _string:@"" _imageName:@"未选中"];
    UILabel * childrenL = [Unity lableViewAddsuperview_superView:self.view _subViewFrame:CGRectMake(childrenBtn.right+[Unity countcoordinatesW:5], sexL.top, [Unity countcoordinatesW:40], [Unity countcoordinatesH:30]) _string:@"儿童" _lableFont:[UIFont systemFontOfSize:16] _lableTxtColor:labelTextColor _textAlignment:NSTextAlignmentLeft];
    
    NSArray * arr = @[@"身高(cm)",@"体重(kg)",@"肩宽(cm)",@"胸围(cm)",@"腰围(cm)",@"臂围(cm)",@"脚长(cm)",@"脚围(cm)"];
    for (int i=0; i<arr.count; i++) {
        UILabel * label = [Unity lableViewAddsuperview_superView:self.view _subViewFrame:CGRectMake((i%2)*(kScreenW/2)+[Unity countcoordinatesW:10], childrenL.bottom+([Unity countcoordinatesH:30]*(i/2)), [Unity countcoordinatesW:80], [Unity countcoordinatesH:30]) _string:arr[i] _lableFont:[UIFont systemFontOfSize:16] _lableTxtColor:labelTextColor _textAlignment:NSTextAlignmentLeft];
        if (i==0) {
            self.sgText = [Unity textFieldAddSuperview_superView:self.view _subViewFrame:CGRectMake(label.right, label.top+[Unity countcoordinatesH:3], [Unity countcoordinatesW:60], [Unity countcoordinatesH:24]) _placeT:@"" _backgroundImage:nil _delegate:self andSecure:NO andBackGroundColor:[UIColor whiteColor]];
            self.sgText.layer.borderColor = [labelTextColor CGColor];
            self.sgText.layer.borderWidth = 1.0f;
            self.sgText.layer.masksToBounds = YES;
        }else if (i==1){
            self.tgText = [Unity textFieldAddSuperview_superView:self.view _subViewFrame:CGRectMake(label.right, label.top+[Unity countcoordinatesH:3], [Unity countcoordinatesW:60], [Unity countcoordinatesH:24]) _placeT:@"" _backgroundImage:nil _delegate:self andSecure:NO andBackGroundColor:[UIColor whiteColor]];
            self.tgText.layer.borderColor = [labelTextColor CGColor];
            self.tgText.layer.borderWidth = 1.0f;
            self.tgText.layer.masksToBounds = YES;
        }else if (i==2){
            self.jkText = [Unity textFieldAddSuperview_superView:self.view _subViewFrame:CGRectMake(label.right, label.top+[Unity countcoordinatesH:3], [Unity countcoordinatesW:60], [Unity countcoordinatesH:24]) _placeT:@"" _backgroundImage:nil _delegate:self andSecure:NO andBackGroundColor:[UIColor whiteColor]];
            self.jkText.layer.borderColor = [labelTextColor CGColor];
            self.jkText.layer.borderWidth = 1.0f;
            self.jkText.layer.masksToBounds = YES;
        }else if (i==3){
            self.xwText = [Unity textFieldAddSuperview_superView:self.view _subViewFrame:CGRectMake(label.right, label.top+[Unity countcoordinatesH:3], [Unity countcoordinatesW:60], [Unity countcoordinatesH:24]) _placeT:@"" _backgroundImage:nil _delegate:self andSecure:NO andBackGroundColor:[UIColor whiteColor]];
            self.xwText.layer.borderColor = [labelTextColor CGColor];
            self.xwText.layer.borderWidth = 1.0f;
            self.xwText.layer.masksToBounds = YES;
        }else if (i==4){
           self.ywText = [Unity textFieldAddSuperview_superView:self.view _subViewFrame:CGRectMake(label.right, label.top+[Unity countcoordinatesH:3], [Unity countcoordinatesW:60], [Unity countcoordinatesH:24]) _placeT:@"" _backgroundImage:nil _delegate:self andSecure:NO andBackGroundColor:[UIColor whiteColor]];
            self.ywText.layer.borderColor = [labelTextColor CGColor];
            self.ywText.layer.borderWidth = 1.0f;
            self.ywText.layer.masksToBounds = YES;
        }else if (i==5){
            self.bwText = [Unity textFieldAddSuperview_superView:self.view _subViewFrame:CGRectMake(label.right, label.top+[Unity countcoordinatesH:3], [Unity countcoordinatesW:60], [Unity countcoordinatesH:24]) _placeT:@"" _backgroundImage:nil _delegate:self andSecure:NO andBackGroundColor:[UIColor whiteColor]];
            self.bwText.layer.borderColor = [labelTextColor CGColor];
            self.bwText.layer.borderWidth = 1.0f;
            self.bwText.layer.masksToBounds = YES;
        }else if (i==6){
            self.jcText = [Unity textFieldAddSuperview_superView:self.view _subViewFrame:CGRectMake(label.right, label.top+[Unity countcoordinatesH:3], [Unity countcoordinatesW:60], [Unity countcoordinatesH:24]) _placeT:@"" _backgroundImage:nil _delegate:self andSecure:NO andBackGroundColor:[UIColor whiteColor]];
            self.jcText.layer.borderColor = [labelTextColor CGColor];
            self.jcText.layer.borderWidth = 1.0f;
            self.jcText.layer.masksToBounds = YES;
        }else if (i==7){
            self.jwText = [Unity textFieldAddSuperview_superView:self.view _subViewFrame:CGRectMake(label.right, label.top+[Unity countcoordinatesH:3], [Unity countcoordinatesW:60], [Unity countcoordinatesH:24]) _placeT:@"" _backgroundImage:nil _delegate:self andSecure:NO andBackGroundColor:[UIColor whiteColor]];
            self.jwText.layer.borderColor = [labelTextColor CGColor];
            self.jwText.layer.borderWidth = 1.0f;
            self.jwText.layer.masksToBounds = YES;
        }
    }
    UILabel * bgL = [Unity lableViewAddsuperview_superView:self.view _subViewFrame:CGRectMake(0, sexL.bottom+[Unity countcoordinatesH:140], kScreenW, [Unity countcoordinatesH:20]) _string:@"信息越完整,对您选择服饰时越有帮助" _lableFont:[UIFont systemFontOfSize:15] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentCenter];
    CGFloat W = [Unity widthOfString:@"设为默认" OfFontSize:16 OfHeight:[Unity countcoordinatesH:30]];
    morenBtn = [Unity buttonAddsuperview_superView:self.view _subViewFrame:CGRectMake((kScreenW-[Unity countcoordinatesW:21]-W)/2, bgL.bottom+[Unity countcoordinatesH:17], [Unity countcoordinatesW:16], [Unity countcoordinatesH:16]) _tag:self _action:@selector(morenClick) _string:@"" _imageName:@"选中"];
    UILabel * morenL = [Unity lableViewAddsuperview_superView:self.view _subViewFrame:CGRectMake(morenBtn.right+[Unity countcoordinatesW:5], bgL.bottom+[Unity countcoordinatesH:10], W, [Unity countcoordinatesH:30]) _string:@"设为默认" _lableFont:[UIFont systemFontOfSize:16] _lableTxtColor:labelTextColor _textAlignment:NSTextAlignmentLeft];
}
- (void)pushDic{
    if (self.dic) {
        _nameText.text = self.dic[@"name"];
        _sgText.text = self.dic[@"height"];
        _tgText.text = self.dic[@"weight"];
        _jkText.text = self.dic[@"shoulder"];
        _xwText.text = self.dic[@"chest"];
        _ywText.text = self.dic[@"waistline"];
        _bwText.text = self.dic[@"girth"];
        _jcText.text = self.dic[@"footSize"];
        _jwText.text = self.dic[@"bottoms"];
        if ([self.dic[@"sex"]isEqualToString:@"男"]) {
            [self manClick];
        }
    }
}
- (void)morenClick{
    if (isDefault) {
        [morenBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        isDefault = NO;
    }else{
        [morenBtn setBackgroundImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
        isDefault = YES;
    }
}
- (void)manClick{
    [manBtn setBackgroundImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
    [womanBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [childrenBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    _gender = @"男";
}
- (void)womanClick{
    [manBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [womanBtn setBackgroundImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
    [childrenBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    _gender = @"女";
}
- (void)childrenClick{
    [manBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [womanBtn setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [childrenBtn setBackgroundImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
    _gender = @"儿童";
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的尺码";
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.rightBarButtonItem = self.saveBtn;
}
-(UIBarButtonItem *)saveBtn{
    
    if (!_saveBtn) {
        
        UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"保存" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn sizeToFit];
        _saveBtn =  [[UIBarButtonItem alloc] initWithCustomView:btn];
        
    }
    return _saveBtn;
}
- (void)saveClick:(UIButton *)sender{
    NSLog(@"baocun");
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
