//
//  MineTableViewCell.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/25.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLa;
@property (weak, nonatomic) IBOutlet UILabel *numLb;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UIImageView *nextPages;
@end
