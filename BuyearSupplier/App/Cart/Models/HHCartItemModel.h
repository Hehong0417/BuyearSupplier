//
//  HHCartItemModel.h
//  Store
//
//  Created by User on 2018/11/12.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@class HHItemsModel;
NS_ASSUME_NONNULL_BEGIN

//提交订单（拆单数组）
@interface HHCartItemModel : BaseModel

@property(nonatomic,strong) NSArray <HHItemsModel*>*products;
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
@property(nonatomic,strong) NSString  *ship_channel;
@property(nonatomic,strong) NSString *money_total;

@end
@interface HHItemsModel : BaseModel

@property(nonatomic,strong) NSArray <HHproductsModel*>*items;
@property(nonatomic,strong) NSString *supplier_name;
@property(nonatomic,strong) NSString *supplier_id;
@property(nonatomic,strong) NSString *s_sntegral;
@property(nonatomic,strong) NSString *money;

@end
NS_ASSUME_NONNULL_END
