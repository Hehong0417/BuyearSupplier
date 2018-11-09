//
//  HHHomeModel.h
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@class HHhomeProductsModel;

@interface HHHomeModel : BaseModel

@property(nonatomic,strong) NSString *category_id;
@property(nonatomic,strong) NSString *category_name;
@property(nonatomic,strong) NSString *category_type;
@property(nonatomic,strong) NSArray *product;

//月成交记录
@property(nonatomic,strong) NSString *user_name;
@property(nonatomic,strong) NSString *score;
@property(nonatomic,strong) NSString *sku;
@property(nonatomic,strong) NSString *count;
@property(nonatomic,strong) NSString *finish_date;

//轮播图
@property(nonatomic,strong) NSString *Id;
@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) NSString *text;
@property(nonatomic,strong) NSString *redirect;

@end
@interface HHhomeProductsModel : BaseModel

@property(nonatomic,strong) NSString *product_id;
@property(nonatomic,strong) NSString *product_name;
@property(nonatomic,strong) NSString *product_icon;
@property(nonatomic,strong) NSString *product_max_price;
@property(nonatomic,strong) NSString *product_min_price;
@property(nonatomic,strong) NSString *product_s_intergral;
@property(nonatomic,strong) NSString *product_promo_s_integral;
@property(nonatomic,strong) NSString *product_supplier_name;
@property(nonatomic,strong) NSString *product_supplier_id;
//0 百业惠 1惠万家
@property(nonatomic,strong) NSString *product_type;

@end
