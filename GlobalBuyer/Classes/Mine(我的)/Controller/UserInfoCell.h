//
//  UserInfoCell.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/26.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titileLa;
@property (weak, nonatomic) IBOutlet UILabel *detailLa;
@property (weak, nonatomic) IBOutlet UIImageView *nextView;
@property (strong, nonatomic) IBOutlet UIView *line;
@end
