//
//  HHCartItemModel.m
//  Store
//
//  Created by User on 2018/11/12.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHCartItemModel.h"

@implementation HHCartItemModel
+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"products": [HHItemsModel class]};
}

@end
@implementation HHItemsModel

+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"items": [HHproductsModel class]};
}
@end
