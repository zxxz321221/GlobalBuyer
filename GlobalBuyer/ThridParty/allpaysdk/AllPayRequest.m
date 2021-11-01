//
//  UPRequest.m
//  VTPayUPDemo
//
//  Created by 司瑞华 on 15/7/29.
//  Copyright (c) 2015年 __VTPayment__. All rights reserved.
//

#import "AllPayRequest.h"
#import "commonCrypto/CommonDigest.h"

@implementation AllPayRequest

///**
// *  post请求
// *
// *  @param urlStr       要访问的网站  NSString类型
// *  @param paramters    请求的参数    NSMutableDictionary
// *  @param succeedBlock 成功时的回调  返回NSString类型
// *  @param failedBlock  失败时的回调  返回NSString类型
// */
+(void)postRequestWithURL:(NSString *)urlStr
                paramters:(NSMutableDictionary *)paramters
                  succeed:(FinishBlock)succeedBlock
                   failed:(FailedBlock)failedBlock
{
    AllPayRequest * httpRequest = [[AllPayRequest alloc]init];
    httpRequest.finishBlock = succeedBlock;
    httpRequest.failedBlock = failedBlock;
    
    NSURL * url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    NSString * strField;
    if (paramters.count>0)
    {
        strField = [self dictFieldInfo:paramters];
    }else
    {
        strField = @"";
    }
    ///把获得的整个请求字段用utf-8编码一下
    NSData * data = [strField dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    [request setHTTPMethod:@"POST"];
    
    NSURLConnection * connection = [[NSURLConnection alloc]initWithRequest:request delegate:httpRequest];
    [connection start];
}

// 将字典参数 拼接成一个有 &%@=%@ 的字符串
+(NSString *)dictFieldInfo:(NSMutableDictionary*)dict
{
    NSMutableString * Url = [NSMutableString string];
    NSArray * keys = [dict allKeys];
    for (int i = 0; i < keys.count; i++)
    {
        NSString * string;
        if (i == 0)
        {
            string = [NSString stringWithFormat:@"%@=%@", keys[i],dict[keys[i]]];
        }else{
            //拼接时加&
            string = [NSString stringWithFormat:@"&%@=%@", keys[i],dict[keys[i]]];
        }
        [Url appendString:string];
    }
    return Url;
}
/**
 *  接收到服务器回应的时回调
 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (!self.resultData)
    {
        self.resultData = [[NSMutableData alloc]init];
    }else
    {
        [self.resultData setLength:0];
    }
}
/**
 *  接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.resultData appendData:data];
}
/**
 *  数据传完之后调用此方法
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.finishBlock) {
        self.finishBlock(self.resultData);
    }
}
/**
 *  网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"network error : %@", [error localizedDescription]);
    
    if (self.failedBlock) {
        self.failedBlock([error localizedDescription]);
    }
}

// 将字符串，转化成数组或字典 objectFromJSONStringWithParseOptions
- (id)dictionaryOrArrayWithJSONSString:(NSString *)jsonString
{
    if (jsonString == nil)
    {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves |  NSJSONReadingMutableContainers error:nil];
}
#pragma mark - MD5加密
+(NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
    
}

@end
