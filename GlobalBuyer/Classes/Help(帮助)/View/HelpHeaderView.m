//
//  HelpHeaderView.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/6/14.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "HelpHeaderView.h"

@interface HelpHeaderView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@end

@implementation HelpHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
    
        self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"brand_expand"]];
        self.arrowImageView.frame = CGRectMake(w - 25, (44 - 8) / 2, 15, 8);
        [self.contentView addSubview:self.arrowImageView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(onExpand:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        button.frame = CGRectMake(0, 0, w, 44);
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 200, 44)];
        self.titleLabel.textColor = [UIColor scrollViewTexturedBackgroundColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.titleLabel];
      
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - 0.5, w, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:line];
    }
    
    return self;
}
- (void)setModel:(HelpSectionModel *)model {
    if (_model != model) {
        _model = model;
    }
    
    if (model.isExpanded) {
        self.arrowImageView.transform = CGAffineTransformIdentity;
    } else {
         self.arrowImageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
    
    self.titleLabel.text = model.sectionTitle;
}

- (void)onExpand:(UIButton *)sender {
    self.model.isExpanded = !self.model.isExpanded;
    
    [UIView animateWithDuration:0.25 animations:^{
        if (self.model.isExpanded) {
            self.arrowImageView.transform = CGAffineTransformIdentity;
        } else {
            self.arrowImageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        }
    }];
    
    if (self.expandCallback) {
        self.expandCallback(self.model.isExpanded);
    }
}
@end
