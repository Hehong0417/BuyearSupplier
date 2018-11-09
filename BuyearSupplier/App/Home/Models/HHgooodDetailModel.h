//
//  HHgooodDetailModel.h
//  Store
//
//  Created by User on 2018/1/17.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@class HHsku_name_valueModel;

@interface HHgooodDetailModel : BaseModel

@property(nonatomic,strong) NSString *product_id;
@property(nonatomic,strong) NSString *product_name;
@property(nonatomic,strong) NSString *product_short_description;
@property(nonatomic,strong) NSString *product_description;
@property(nonatomic,strong) NSString *product_max_price;
@property(nonatomic,strong) NSString *product_min_price;
@property(nonatomic,strong) NSString *product_market_price;
@property(nonatomic,strong) NSString *product_brand_name;
@property(nonatomic,strong) NSString *product_number;
@property(nonatomic,strong) NSString *product_stock;
@property(nonatomic,strong) NSString *product_grounding_date;
@property(nonatomic,strong) NSString *product_pageage_unit;
@property(nonatomic,strong) NSString *product_base_unit;
@property(nonatomic,strong) NSString *product_s_intergral;
@property(nonatomic,strong) NSString *product_type;

@property(nonatomic,strong) NSArray *product_icon;
@property(nonatomic,strong) NSArray *product_sku_value;
@property(nonatomic,strong) NSArray *product_sku;

@property(nonatomic,strong) NSString *tip;
@property(nonatomic,strong) NSString *product_supplier_name;
@property(nonatomic,strong) NSString *product_supplier_id;

@end
@interface HHproduct_sku_valueModel : BaseModel
@property(nonatomic,strong) NSString *sku_name_id;
@property(nonatomic,strong) NSString *sku_name_name;
@property(nonatomic,strong) NSArray <HHsku_name_valueModel*> *sku_name_value;
//*是否点击选择了某一组
@property (nonatomic,assign)BOOL isSelect;
@end
@interface HHsku_name_valueModel : BaseModel
@property(nonatomic,strong) NSString *sku_value_id;
@property(nonatomic,strong) NSString *sku_value_value;

//*是否点击 (自己添加的属性)
@property (nonatomic,assign)BOOL isSelect;

//*属性是否能选
@property (nonatomic,assign)BOOL modelLocked;

@end

@interface HHproduct_skuModel : BaseModel
@property(nonatomic,strong) NSString *sku_id;
@property(nonatomic,strong) NSString *sku_price;
@property(nonatomic,strong) NSString *sku_stock;
@property(nonatomic,strong) NSString *sku_image;
@property(nonatomic,strong) NSString *sku_s_integral;

@end

