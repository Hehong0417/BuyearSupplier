//
//  HHCategoryAPI.m
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHCategoryAPI.h"

@implementation HHCategoryAPI

#pragma mark - get
//获取商品分类列表
+ (instancetype)GetCategoryListWithType:(NSNumber *)type{
    
    HHCategoryAPI *api = [self new];
    api.subUrl = API_GetCategoryList;
    if (type) {
        [api.parameters setObject:type forKey:@"type"];
    }
    
    api.parametersAddToken = NO;
    
    return api;
}
//获取商品列表
+ (instancetype)GetProductListWithType:(NSNumber *)type categoryId:(NSString *)categoryId name:(NSString *)name orderby:(NSNumber *)orderby page:(NSNumber *)page pageSize:(NSNumber *)pageSize supplierId:(NSString *)supplierId{
    
    HHCategoryAPI *api = [self new];
    api.subUrl = API_Product_search;
    if (type) {
        [api.parameters setObject:type forKey:@"type"];
    }
    if (categoryId) {
        [api.parameters setObject:categoryId forKey:@"categoryId"];
    }
    if (name) {
        [api.parameters setObject:name forKey:@"name"];
    }
    if (orderby) {
        [api.parameters setObject:orderby forKey:@"orderby"];
    }
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    if (pageSize) {
        [api.parameters setObject:pageSize forKey:@"pageSize"];
    }
    if (supplierId) {
        [api.parameters setObject:supplierId forKey:@"supplierId"];
    }
    
    api.parametersAddToken = NO;
    
    return api;
}
//获取供应商列表
+ (instancetype)GetSupplierListWithName:(NSString *)name{
    HHCategoryAPI *api = [self new];
    api.subUrl = API_SearchSupplier;
    if (name) {
        [api.parameters setObject:name forKey:@"name"];
    }
    
    api.parametersAddToken = NO;
    
    return api;
    
}
@end
