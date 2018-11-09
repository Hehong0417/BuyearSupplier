//
//  HHCartAPI.h
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseAPI.h"

@interface HHCartAPI : BaseAPI

#pragma mark - get

//获取购物车中商品
+ (instancetype)GetCartProducts;

//获得结算订单
+ (instancetype)GetConfirmOrderWithids:(NSString *)ids;

//热门搜索
+ (instancetype)GetHotSearchWithtop:(NSNumber *)top;
//用户历史搜索
+ (instancetype)GetUserSearchWithtop:(NSNumber *)top;
//用户输入抵扣的购物积分或提货积分，返回真实支付的金额
+ (instancetype)GetPayMoneyWithids:(NSString *)ids integral:(NSString *)integral;


#pragma mark - post
//添加或减少购物车数量
+ (instancetype)postAddQuantityWithcart_id:(NSString *)cart_id quantity:(NSString *)quantity;

//加入购车
+ (instancetype)postAddProductsWithsku_id:(NSString *)sku_id quantity:(NSString *)quantity;
//立即购买
+ (instancetype)postGotoBuyWithquantity:(NSString *)quantity skuid:(NSString *)skuid;
//删除购物车
+ (instancetype)postShopCartDeleteWithcart_id:(NSString *)cart_id;

//去支付订单，提交订单
+ (instancetype)postCreateOrderWithids:(NSString *)ids address_id:(NSString *)address_id shop_userid:(NSString *)shop_userid remark:(NSString *)remark pay_mode:(NSNumber *)pay_mode channe:(NSNumber *)channe integral:(NSString *)integral ship_mode:(NSString *)ship_mode;

//清除历史搜索
+ (instancetype)postClearUserSearch;
@end
