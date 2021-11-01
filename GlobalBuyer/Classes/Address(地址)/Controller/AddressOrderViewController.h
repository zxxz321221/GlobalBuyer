//
//  AddressRootViewController.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/22.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "RootViewController.h"
#import "AddressModel.h"
@protocol  AddressViewControllerDelegate<NSObject>
    
- (void)sendAdressModel:(AddressModel *)model;
    
@end

@interface AddressOrderViewController : RootViewController
@property(nonatomic,assign)id<AddressViewControllerDelegate>delegate;
@end
