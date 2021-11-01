//
//  FileArchiver.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/5/26.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileArchiver : NSObject
+(NSArray *)readFileArchiver:(NSString *)fileName;
+(void)writeFileArchiver:(NSString *)fileName withArray:(NSArray *)array;
@end
