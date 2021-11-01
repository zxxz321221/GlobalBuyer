//
//  DYHURLSessionProtocol.m
//  GlobalBuyer
//
//  Created by 桂在明 on 2019/3/8.
//  Copyright © 2019年 薛铭. All rights reserved.
//

#import "DYHURLSessionProtocol.h"
static NSString * const DYHURLProtocolHandledKey = @"DYHURLProtocolHandledKey";
@interface DYHURLSessionProtocol()<NSURLSessionDelegate>

@property (atomic,strong,readwrite) NSURLSessionDataTask *task;
@property (nonatomic,strong) NSURLSession *session;

@end
@implementation DYHURLSessionProtocol
+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    //只处理http和https请求
    NSString *scheme = [[request URL] scheme];
    if ( ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
          [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame))
    {
        //        NSLog(@"====>%@",request.URL);
        
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:DYHURLProtocolHandledKey inRequest:request]) {
            return NO;
        }
        
        return YES;
    }
    return NO;
}

+ (NSURLRequest *) canonicalRequestForRequest:(NSURLRequest *)request {
    /** 可以在此处添加头等信息  */
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    return mutableReqeust;
}
- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    //打标签，防止无限循环
    [NSURLProtocol setProperty:@YES forKey:DYHURLProtocolHandledKey inRequest:mutableReqeust];
    
    NSURLSessionConfiguration *configure = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    self.session  = [NSURLSession sessionWithConfiguration:configure delegate:self delegateQueue:queue];
    self.task = [self.session dataTaskWithRequest:mutableReqeust];
    [self.task resume];
}

- (void)stopLoading
{
    [self.session invalidateAndCancel];
    self.session = nil;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error != nil) {
        [self.client URLProtocol:self didFailWithError:error];
    }else
    {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.client URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler
{
    completionHandler(proposedResponse);
}

//TODO: 重定向
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)newRequest completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    NSMutableURLRequest*    redirectRequest;
    redirectRequest = [newRequest mutableCopy];
    [[self class] removePropertyForKey:DYHURLProtocolHandledKey inRequest:redirectRequest];
    [[self client] URLProtocol:self wasRedirectedToRequest:redirectRequest redirectResponse:response];
    
    [self.task cancel];
    [[self client] URLProtocol:self didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
}

- (instancetype)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client
{
    
    NSMutableURLRequest*    redirectRequest;
    redirectRequest = [request mutableCopy];
    
    
    NSLog(@"拦截的请求:%@",request.URL.absoluteString);
    if ([request.URL.absoluteString isEqualToString:@"https://pay.google.com/gp/p/js/pay.js"]) {
        
        NSMutableURLRequest * str = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@""]];
        self = [super initWithRequest:str cachedResponse:cachedResponse client:client];
        
    }else{
        self = [super initWithRequest:redirectRequest cachedResponse:cachedResponse client:client];
    }
    
    
    if (self) {
        
        // Some stuff
    }
    return self;
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    
    //    NSLog(@"自定义Protocol开始认证...");
    //    NSString *authMethod = [[challenge protectionSpace] authenticationMethod];
    //    NSLog(@"%@认证...",authMethod);
    //
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    }
    //
    //
    //    NSLog(@"自定义Protocol认证结束");
}
@end
