//
//  ChoiceAddressViewController.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/9/15.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  ChoiceAddressViewControllerDelegate <NSObject>

-(void)RefreshAdd;

@end

@interface ChoiceAddressViewController : UIViewController

@property (nonatomic,strong)NSMutableArray *pickSource;
@property (nonatomic,strong)NSMutableArray *valueAddedServiceSource;
@property (nonatomic, strong) id<ChoiceAddressViewControllerDelegate>delegate;

@end
