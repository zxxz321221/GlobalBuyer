//
//  SGQRCodeScanningVC.h
//  SGQRCodeExample
//
//  Created by kingsic on 17/3/20.
//  Copyright © 2017年 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  SGQRCodeScanningVCDelegate <NSObject>

- (void)openUrlWithScanUrl:(NSString *)url;

@end

@interface SGQRCodeScanningVC : UIViewController

@property (nonatomic, strong) id<SGQRCodeScanningVCDelegate>delegate;

@end
