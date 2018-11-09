//
//  HHgooodDetailModel.m
//  Store
//
//  Created by User on 2018/1/17.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHgooodDetailModel.h"

@implementation HHgooodDetailModel

+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"product_sku_value": [HHproduct_sku_valueModel class],@"product_sku": [HHproduct_skuModel class]};
}


@end
@implementation HHproduct_sku_valueModel

+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"sku_name_value": [HHsku_name_valueModel class]};
}

@end
@implementation HHsku_name_valueModel

@end
@implementation HHproduct_skuModel

@end



