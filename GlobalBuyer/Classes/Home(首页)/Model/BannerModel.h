//
//  BannerModel.h
//  首页demo
//
//  Created by 赵阳 && 薛铭 on 2017/6/5.
//  Copyright © 2017年 赵阳 && 薛铭. All rights reserved.
//

#import "JSONModel.h"

@interface BannerModel : JSONModel
@property (nonatomic , copy) NSString              <Optional>* image;
@property (nonatomic , copy) NSString              <Optional>* href;
@property (nonatomic , copy) NSString              <Optional>* type;
@property (nonatomic , copy) NSString              <Optional>* list_url;
@end
