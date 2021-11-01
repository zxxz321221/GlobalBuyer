//
//  GoodSpecification.m
//  GlobalBuyer
//
//  Created by 澜与轩 on 2020/10/15.
//  Copyright © 2020 薛铭. All rights reserved.
//

#import "GoodSpecification.h"
#import "MQToast.h"
@implementation GoodSpecification
{
    NSString *selectSpecification;
    NSString *selectNumber;
    UITextField *numberTextField;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)setDetail:(NSDictionary *)detail{
    _detail = detail;
    if (_detail) {
        NSArray *array = _detail[@"度數"];
        UILabel *title = [[UILabel alloc]init];
        title.frame = CGRectMake(10, 10, 100, 20);
        title.text = @"度數";
        [self addSubview:title];
        
        CGRect rect = self.frame;
        rect.size.height =80+45*(array.count%4==0 ? array.count/4 : array.count/4+1);
        
        for (int i=0; i<array.count; i++) {
            UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(10+(kScreenW-20)/4*(i%4), 40+48*(i/4), (kScreenW-30)/4, 44)];
            [btn setTitle:array[i] forState:UIControlStateNormal];
            btn.layer.borderWidth = 1;
            btn.layer.cornerRadius = 4;
            btn.tag = i+100;
            [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [btn setTitleColor:Main_Color forState:UIControlStateSelected];
            if (btn.selected) {
                btn.layer.borderColor = Main_Color.CGColor;
            }else{
                btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            }
            [btn setBackgroundColor:[UIColor colorWithRed:240.0f green:240.0f  blue:240.0f  alpha:1]];

            [self addSubview:btn];
        }
        
        UILabel *numberLabel = [[UILabel alloc]init];
        numberLabel.text = @"数量";
        [self addSubview:numberLabel];
        numberLabel.frame = CGRectMake(10, self.frame.size.height - 160, 100, 20);

        
        UIView *numberView = [[UIView alloc]init];
         [self addSubview:numberView];
        numberView.frame = CGRectMake(10, self.frame.size.height - 130
        , kScreenW -20, 50);
        numberView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        numberView.layer.borderWidth = 1;
        
        UIButton *reduce = [[UIButton alloc]init];
        [numberView addSubview:reduce];
        reduce.sd_layout.leftSpaceToView(numberView, 10).centerYEqualToView(numberView).heightIs(20).widthIs(20);
        [reduce setImage:[UIImage imageNamed:@"jianhao"] forState:(UIControlStateNormal)];
        [reduce addTarget:self action:@selector(reduceButtonClick) forControlEvents:(UIControlEventTouchUpInside)];

        
        UIButton *plus = [[UIButton alloc]init];
        [numberView addSubview:plus];
        plus.sd_layout.rightSpaceToView(numberView, 10).centerYEqualToView(numberView).heightIs(20).widthIs(20);
        [plus setImage:[UIImage imageNamed:@"jiahao"] forState:(UIControlStateNormal)];
        [plus addTarget:self action:@selector(plusButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
        
        numberTextField = [[UITextField alloc]init];
        [numberView addSubview:numberTextField];
        numberTextField.keyboardType = UIKeyboardTypeNumberPad;
        numberTextField.sd_layout.leftSpaceToView(reduce, 10).rightSpaceToView(plus, 10).heightIs(50).centerYEqualToView(numberView);
        numberTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        numberTextField.layer.borderWidth = 1;
        numberTextField.textAlignment = NSTextAlignmentCenter;
        numberTextField.delegate = self;
        if (self.detail[@"数量"]) {
            numberTextField.text = self.detail[@"数量"];
        }else{
            numberTextField.text = @"1";
        }
        
        UIButton *submit = [[UIButton alloc]init];
        submit.frame = CGRectMake(20, self.frame.size.height - 60
                                  , kScreenW -40, 50);
        submit.backgroundColor = Main_Color;
        submit.layer.cornerRadius = 25;
        [submit addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [submit setTitle:NSLocalizedString(@"GlobalBuyer_Ok", nil)forState:UIControlStateNormal];
        [self addSubview:submit];
        
    }
}

- (void)plusButtonClick{
    NSInteger number = [numberTextField.text integerValue];
    number++;
    numberTextField.text = [NSString stringWithFormat:@"%ld",(long)number];
}

- (void)reduceButtonClick{
    NSInteger number = [numberTextField.text integerValue];
    if (number>1) {
        number--;
        numberTextField.text = [NSString stringWithFormat:@"%ld",(long)number];
    }else{
        [MQToast showToast:@"不能再少了" duration:1.0 window:[[UIApplication sharedApplication].windows lastObject]];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger number = [numberTextField.text integerValue];
    if (number<1) {
        numberTextField.text = @"1";
        [MQToast showToast:@"数量需要大于1" duration:1.0 window:[[UIApplication sharedApplication].windows lastObject]];

    }
}

-(void)createUI{
    self.backgroundColor = [UIColor whiteColor];
}

- (void)click:(id)sender{
    UIButton *btn = (id)sender;
    
    NSArray *array = self.detail[@"度數"];
    NSLog(@"=============>%@",array[btn.tag-100]);
    selectSpecification = array[btn.tag-100];
    for (int i = 0; i<array.count; i++) {
        UIButton *temp = (UIButton *)[self viewWithTag:i+100];
        [temp setSelected:NO];
    }
    btn.selected = !btn.selected;
}

-(void)show{
    __weak typeof(self) weakself = self;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        weakself.frame = CGRectMake(0, 0, kScreenW, 500);
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself close];
        });
    }];
}


-(void)close{
    [numberTextField resignFirstResponder];
    if ([numberTextField.text intValue]>0) {
        NSLog(@"selectSpecification%@",selectSpecification);
        [self.delegate selectedSpecification:selectSpecification selectedNumber:numberTextField.text];
    }else{
        numberTextField.text = @"1";
        [MQToast showToast:@"数量需要大于1" duration:1.0 window:[[UIApplication sharedApplication].windows lastObject]];
    }
    
   
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

