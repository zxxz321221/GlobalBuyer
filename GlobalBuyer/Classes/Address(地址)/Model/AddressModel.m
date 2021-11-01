//
//  AddressModel.m
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/4/26.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

-(CGFloat)cellH{
    CGSize size = [self.address boundingRectWithSize:CGSizeMake(kScreenW -  16, 1000) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
    return 8 + 20 + 8 + size.height + 8 + 20 + 8;
}

@end
