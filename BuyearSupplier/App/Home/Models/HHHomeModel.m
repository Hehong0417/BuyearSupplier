//
//  HHHomeModel.m
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHHomeModel.h"

@implementation HHHomeModel

+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"product": [HHhomeProductsModel class]};
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"Id": @"id"};
}
@end
@implementation HHhomeProductsModel

@end
