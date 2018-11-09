//
//  HHCartModel.h
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@class HHproductsModel;

@interface HHCartModel : BaseModel
//购物车
@property(nonatomic,strong) NSString *money_total;
@property(nonatomic,strong) NSString *sintegral_total;
@property(nonatomic,strong) NSArray <HHproductsModel*>*products;

//提交订单
@property(nonatomic,strong) NSString *s_integral_total;
@property(nonatomic,strong) NSString *shop_type;
@property(nonatomic,strong) NSString *shopping_integral;
@property(nonatomic,strong) NSString *picking_integral;
@property(nonatomic,strong) NSString *money_integral;
@property(nonatomic,strong) NSString *shop_card_ids;
@property(nonatomic,strong) NSString *price;
@property(nonatomic,strong) NSString *shop_card_id;
@property(nonatomic,strong) NSString *login_userid;
@property(nonatomic,strong) NSString *login_username;
@property(nonatomic,strong) NSString *max_usable_shopping_integral;

//我的订单
@property(nonatomic,strong) NSString *status;
@property(nonatomic,strong) NSString *datetime;
@property(nonatomic,strong) NSString *orderid;
@property(nonatomic,strong) NSString *pay_money_integral;
@property(nonatomic,strong) NSString *pay_shopping_integral;
@property(nonatomic,strong) NSString *pay_picking_integral;
@property(nonatomic,strong) NSString *pya_total;
@property(nonatomic,strong) NSString *order_total;
@property(nonatomic,strong) NSString *s_integral;
@property(nonatomic,strong) NSString *ship_phone;
@property(nonatomic,strong) NSString *ship_contacts;
@property(nonatomic,strong) NSString *ship_channel;
@property(nonatomic,strong) NSString *express_name;
@property(nonatomic,strong) NSString *express_order;
@property(nonatomic,strong) NSString *status_code;
@property(nonatomic,strong) NSString *refund_status;
@property(nonatomic,strong) NSString *is_agree_return_goods;
//是存在退货物流
@property(nonatomic,strong) NSString *is_exist_reeturn_goods_Express;
@property(nonatomic,strong) NSString *return_goods_express_code;
@property(nonatomic,strong) NSString *return_goods_express_order;
@property(nonatomic,strong) NSString *return_goods_express_name;
@property(nonatomic,assign) CGFloat footHeight;

//订单详情
@property(nonatomic,strong) NSString *username;
@property(nonatomic,strong) NSString *mobile;
@property(nonatomic,strong) NSString *createdate;
@property(nonatomic,strong) NSString *address;
@property(nonatomic,strong) NSString *paymode;
@property(nonatomic,strong) NSString *card_id;
@property(nonatomic,strong) NSString *ship_mode_name;
@property(nonatomic,strong) NSString *shopid;

@end

@interface HHproductsModel : BaseModel

@property(nonatomic,strong) NSString *cart_id;
@property(nonatomic,strong) NSString *pid;
@property(nonatomic,strong) NSString *product_name;
@property(nonatomic,strong) NSString *product_icon;
@property(nonatomic,strong) NSString *product_price;
@property(nonatomic,strong) NSString *sku_id;
@property(nonatomic,strong) NSString *sku_name;

@property(nonatomic,strong) NSString *quantity;
@property(nonatomic,strong) NSString *total;
@property(nonatomic,strong) NSString *s_integral;
@property(nonatomic,strong) NSString *shop_type;
@property(nonatomic,strong) NSString *s_integral_total;


//提交订单
@property(nonatomic,strong) NSString *price;
@property(nonatomic,strong) NSString *icon;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *stock;
@property(nonatomic,strong) NSString *integral;

//我的订单
@property(nonatomic,strong) NSString *item_id;
@property(nonatomic,strong) NSString *status;
@property(nonatomic,strong) NSString *status_code;


@end
