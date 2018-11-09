//
//  HHCartAPI.m
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHCartAPI.h"

@implementation HHCartAPI

#pragma mark - get

//获取购物车中商品
+ (instancetype)GetCartProducts{
    HHCartAPI *api = [self new];
    api.subUrl = API_GetProducts;
    api.parametersAddToken = NO;
    return api;
}

//获得结算订单
+ (instancetype)GetConfirmOrderWithids:(NSString *)ids{
    
    HHCartAPI *api = [self new];
    api.subUrl = API_GetConfirmOrder;
    if (ids) {
        [api.parameters setObject:ids forKey:@"ids"];
    }
    api.parametersAddToken = NO;
    return api;
}

//热门搜索
+ (instancetype)GetHotSearchWithtop:(NSNumber *)top{
    
    HHCartAPI *api = [self new];
    api.subUrl = API_GetHotSearch;
    if (top) {
        [api.parameters setObject:top forKey:@"top"];
    }
    api.parametersAddToken = NO;
    return api;
}
//用户历史搜索
+ (instancetype)GetUserSearchWithtop:(NSNumber *)top{
    
    HHCartAPI *api = [self new];
    api.subUrl = API_GetUserSearch;
    if (top) {
        [api.parameters setObject:top forKey:@"top"];
    }
    api.parametersAddToken = NO;
    return api;
}

//用户输入抵扣的购物积分或提货积分，返回真实支付的金额
+ (instancetype)GetPayMoneyWithids:(NSString *)ids integral:(NSString *)integral{
    HHCartAPI *api = [self new];
    api.subUrl = API_GetPayMoney;
    if (ids) {
        [api.parameters setObject:ids forKey:@"ids"];
    }
    if (integral) {
        [api.parameters setObject:integral forKey:@"integral"];
    }
    api.parametersAddToken = NO;
    return api;

}
#pragma mark - post

//添加或减少购物车数量
+ (instancetype)postAddQuantityWithcart_id:(NSString *)cart_id quantity:(NSString *)quantity{
    
    HHCartAPI *api = [self new];
    api.subUrl = API_AddQuantity;
    if (cart_id) {
        [api.parameters setObject:cart_id forKey:@"cart_id"];
    }
    if (quantity) {
        [api.parameters setObject:quantity forKey:@"quantity"];
    }
    api.parametersAddToken = NO;
    return api;
}
//加入购车
+ (instancetype)postAddProductsWithsku_id:(NSString *)sku_id quantity:(NSString *)quantity{
    
    HHCartAPI *api = [self new];
    api.subUrl = API_AddProducts;
    if (sku_id) {
        [api.parameters setObject:sku_id forKey:@"sku_id"];
    }
    if (quantity) {
        [api.parameters setObject:quantity forKey:@"quantity"];
    }
    api.parametersAddToken = NO;
    return api;
}
//立即购买
+ (instancetype)postGotoBuyWithquantity:(NSString *)quantity skuid:(NSString *)skuid{
    
    HHCartAPI *api = [self new];
    api.subUrl = API_GotoBuy;
    if (quantity) {
        [api.parameters setObject:quantity forKey:@"quantity"];
    }
    if (skuid) {
        [api.parameters setObject:skuid forKey:@"skuid"];
    }
    api.parametersAddToken = NO;
    return api;
}
//删除购物车
+ (instancetype)postShopCartDeleteWithcart_id:(NSString *)cart_id{
    
    HHCartAPI *api = [self new];
    api.subUrl = API_ShopCart_Delete;
    if (cart_id) {
        [api.parameters setObject:cart_id forKey:@"cart_id"];
    }
    api.parametersAddToken = NO;
    return api;
}
//去支付订单，提交订单
+ (instancetype)postCreateOrderWithids:(NSString *)ids address_id:(NSString *)address_id shop_userid:(NSString *)shop_userid remark:(NSString *)remark pay_mode:(NSNumber *)pay_mode channe:(NSNumber *)channe integral:(NSString *)integral ship_mode:(NSString *)ship_mode{
    
    HHCartAPI *api = [self new];
    api.subUrl = API_CreateOrder;
    if (ids) {
        [api.parameters setObject:ids forKey:@"ids"];
    }
    if (address_id) {
        [api.parameters setObject:address_id forKey:@"address_id"];
    }
    if (integral) {
        [api.parameters setObject:integral forKey:@"integral"];
    }
//    if (shop_userid) {
//        [api.parameters setObject:shop_userid forKey:@"shopid"];
//    }
    if (remark) {
        [api.parameters setObject:remark forKey:@"remark"];
    }
    if (pay_mode) {
        [api.parameters setObject:pay_mode forKey:@"pay_mode"];
    }
    if (channe) {
        [api.parameters setObject:channe forKey:@"channe"];
    }
    if (ship_mode) {
        [api.parameters setObject:ship_mode forKey:@"ship_mode"];
    }
    api.parametersAddToken = NO;
    
    return api;
}
//清除历史搜索
+ (instancetype)postClearUserSearch{
    
    HHCartAPI *api = [self new];
    api.subUrl = API_ClearUserSearch;
    api.parametersAddToken = NO;
    return api;
}

@end
