//
//  CustomsCategoryViewController.h
//  GlobalBuyer
//
//  Created by 薛铭 on 2018/10/15.
//  Copyright © 2018年 薛铭. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  CustomsCategoryDelegate <NSObject>

-(void)cilckWithId:(NSString *)cateId name:(NSString *)name;

@end

@interface CustomsCategoryViewController : UIViewController

@property (nonatomic, strong) id<CustomsCategoryDelegate>delegate;

@end
