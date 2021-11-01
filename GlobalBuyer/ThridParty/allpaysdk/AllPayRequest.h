//
//  UPRequest.h
//  VTPayUPDemo
//
//  Created by 司瑞华 on 15/7/29.
//  Copyright (c) 2015年 __VTPayment__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FinishBlock)(id finResponseData);
typedef void (^FailedBlock)(id faiResponseData);

@interface AllPayRequest : NSObject

@property (strong, nonatomic) NSMutableData      *resultData;
@property (strong, nonatomic) FinishBlock        finishBlock;
@property (strong, nonatomic) FailedBlock        failedBlock;

/**
 *  这个是post请求
 *
 *  @param urlStr       要访问的网站  NSString类型
 *  @param paramters    请求的参数    NSMutableDictionary
 *  @param succeedBlock 成功时的回调  返回id类型
 *  @param failedBlock  失败时的回调  返回id类型
 */
+ (void)postRequestWithURL:(NSString *)urlStr
                 paramters:(NSMutableDictionary *)paramters
                   succeed:(FinishBlock)succeedBlock
                    failed:(FailedBlock)failedBlock;


/* md5加密 */

+(NSString *) md5: (NSString *) inPutText ;

@end
