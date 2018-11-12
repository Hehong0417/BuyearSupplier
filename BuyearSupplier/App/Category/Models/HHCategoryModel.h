//
//  HHCategoryModel.h
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@interface HHCategoryModel : BaseModel

//大分类
@property(nonatomic,strong) NSString *category_id;
@property(nonatomic,strong) NSString *category_name;
@property(nonatomic,strong) NSString *category_type;
@property(nonatomic,strong) NSString *category_image;
@property(nonatomic,strong) NSArray *sub_category;

//商品列表
@property(nonatomic,strong) NSString *product_id;
@property(nonatomic,strong) NSString *product_name;
@property(nonatomic,strong) NSString *product_icon;
@property(nonatomic,strong) NSString *product_short_description;
@property(nonatomic,strong) NSString *product_min_price;
@property(nonatomic,strong) NSString *product_pageage_unit;
@property(nonatomic,strong) NSString *product_s_intergral;
@property(nonatomic,strong) NSString *product_type;
@property(nonatomic,strong) NSString *product_promo_s_integral;
@property(nonatomic,strong) NSString *product_supplier_name;
@property(nonatomic,strong) NSString *product_supplier_id;

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *logo;
@property(nonatomic,strong) NSString *supplierId;
@end

@interface HHsub_categoryModel : BaseModel
//小分类
@property(nonatomic,strong) NSString *category_id;
@property(nonatomic,strong) NSString *category_name;
@property(nonatomic,strong) NSString *category_image;

@end
