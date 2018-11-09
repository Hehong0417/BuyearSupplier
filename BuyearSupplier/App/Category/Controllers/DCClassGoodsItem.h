//
//  DCClassGoodsItem.h
//  CDDMall
//
//  Created by apple on 2017/6/8.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCClassGoodsItem : BaseModel

/** 分类id  */
@property(nonatomic,strong) NSString *category_id;
/** 分类名称 */
@property(nonatomic,strong) NSString *category_name;
@property(nonatomic,strong) NSString *category_type;
@property(nonatomic,strong) NSString *category_image;

@property(nonatomic,strong) NSString *tip;

/** 右边数据 */
@property(nonatomic,strong) NSArray *sub_category;

@end
@interface HHsubGoodsItem : BaseModel

@property(nonatomic,strong) NSString *category_id;
@property(nonatomic,strong) NSString *category_name;
@property(nonatomic,strong) NSString *category_image;

@end
