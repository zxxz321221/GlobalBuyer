//
//  AddressCell.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/26.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"
@protocol AddressCellDelegate <NSObject>

-(void)delectAddress:(AddressModel *)model;
-(void)editAddress:(AddressModel *)model;
-(void)changeAddress;

@end

@interface AddressCell : UITableViewCell
@property (nonatomic, strong)id<AddressCellDelegate>delegate;
@property (nonatomic, strong)AddressModel *model;
@property (nonatomic, assign)BOOL hideBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *delectBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@end
