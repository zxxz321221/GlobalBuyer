//
//  CategoryTitleModel.h
//  GlobalBuyer
//
//  Created by 赵阳 && 薛铭 on 2017/6/9.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CategoryTitleModel : JSONModel
@property(nonatomic, strong)NSNumber <Optional>*Id;
@property(nonatomic, strong)NSString <Optional>*name;
@property(nonatomic, strong)NSString <Optional>*value;
@property(nonatomic, strong)NSString <Optional>*category;
@property(nonatomic, strong)NSString <Optional>*keyword;
@end
