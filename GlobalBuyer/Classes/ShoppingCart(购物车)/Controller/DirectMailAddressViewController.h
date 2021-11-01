//
//  DirectMailAddressViewController.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2017/12/13.
//  Copyright © 2017年 赵阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  DirectMailAddressViewControllerDelegate <NSObject>

-(void)changeAddress:(NSDictionary *)addressInfo;

@end

@interface DirectMailAddressViewController : UIViewController

@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic, strong) id<DirectMailAddressViewControllerDelegate>delegate;

@end
