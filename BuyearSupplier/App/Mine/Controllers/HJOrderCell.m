
//
//  HJOrderCell.m
//  Mcb
//
//  Created by IMAC on 15/12/25.
//  Copyright (c) 2015年 hejing. All rights reserved.
//

#import "HJOrderCell.h"

@interface HJOrderCell ()
@property (strong, nonatomic) IBOutlet UIImageView *goodsIco;
@property (strong, nonatomic) IBOutlet UILabel *goodsNameLab;
@property (strong, nonatomic) IBOutlet UILabel *StandardLab;
@property (strong, nonatomic) IBOutlet UILabel *priceLab;
@property (strong, nonatomic) IBOutlet UILabel *quantityLab;

@end

@implementation HJOrderCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.goodsIco lh_setCornerRadius:0 borderWidth:0 borderColor:nil];
    
}

- (void)setProductModel:(HHproductsModel *)productModel{
    _productModel = productModel;

    [self.goodsIco sd_setImageWithURL:[NSURL URLWithString:productModel.product_icon]];
    self.goodsNameLab.text = productModel.product_name;
    self.priceLab.text = [NSString stringWithFormat:@"￥%.2f",productModel.product_price.floatValue];

    self.StandardLab.text = productModel.status;
    self.quantityLab.text = [NSString stringWithFormat:@"X%@",productModel.quantity];
    self.sku_nameLab.text = [NSString stringWithFormat:@"%@",productModel.sku_name?productModel.sku_name:@""];

}

@end
