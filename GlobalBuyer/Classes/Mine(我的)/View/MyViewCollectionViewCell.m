//
//  MyViewCollectionViewCell.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/3/29.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "MyViewCollectionViewCell.h"
@interface MyViewCollectionViewCell()

@property (strong, nonatomic) UIImageView * imageView;
@property (strong, nonatomic) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * cornerL;//角标

@end
@implementation MyViewCollectionViewCell
- (void)prepareForReuse {
    [super prepareForReuse];
    _imageView.image = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    if (_imageView) {
        return;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _imageView = ({
        UIImageView * imageView = [Unity imageviewAddsuperview_superView:self.contentView _subViewFrame:CGRectMake((self.contentView.width-[Unity countcoordinatesH:30])/2, [Unity countcoordinatesH:15], [Unity countcoordinatesH:30], [Unity countcoordinatesH:30]) _imageName:@"" _backgroundColor:[UIColor clearColor]];
        imageView;
    });
    
    _cornerL = ({
        UILabel * cornerL = [Unity lableViewAddsuperview_superView:self.contentView _subViewFrame:CGRectMake(_imageView.right-[Unity countcoordinatesH:10],[Unity countcoordinatesH:6], [Unity countcoordinatesH:14], [Unity countcoordinatesH:14]) _string:@"1" _lableFont:[UIFont systemFontOfSize:9] _lableTxtColor:[UIColor whiteColor] _textAlignment:NSTextAlignmentCenter];
        cornerL.layer.cornerRadius = 8;
        cornerL.font = [UIFont systemFontOfSize:9];
        cornerL.backgroundColor = [UIColor redColor];
        cornerL.layer.masksToBounds = YES;
        cornerL.hidden = YES;
        cornerL;
    });
    
    _titleLabel = ({
        UILabel * btnTitle = [Unity lableViewAddsuperview_superView:self.contentView _subViewFrame:CGRectMake(0, _imageView.bottom+[Unity countcoordinatesH:5], self.contentView.width, [Unity countcoordinatesH:20]) _string:@"" _lableFont:[UIFont systemFontOfSize:13] _lableTxtColor:[Unity getColor:@"#999999"] _textAlignment:NSTextAlignmentCenter];
        btnTitle.backgroundColor = [UIColor clearColor];
        btnTitle;
    });
    
}

#pragma mark - Public Method

- (void)configureCellWithImagePath:(NSString *)imagePath WithBusinessName:(NSString *)businessName WithCornerNum:(NSString *)corner{
   
    
    _titleLabel.text = businessName;
    _imageView.image = [UIImage imageNamed:imagePath];
    if (![corner isEqualToString:@"0"]) {
        self.cornerL.hidden = NO;
    }else{
        self.cornerL.hidden = YES;
    }
    _cornerL.text = corner;
    
}
@end
