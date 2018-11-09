
//
//  HHSubmitOrderCell.m
//  Store
//
//  Created by User on 2018/1/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHSubmitOrderCell.h"

@implementation HHSubmitOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.iconImageV lh_setCornerRadius:0 borderWidth:0 borderColor:nil];
    
}
- (void)setProductsModel:(HHproductsModel *)productsModel{
    _productsModel = productsModel;
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",productsModel.price];
    self.namelabel.text = [NSString stringWithFormat:@"%@",productsModel.name];
    self.quantityLabel.text = [NSString stringWithFormat:@"X%@",productsModel.quantity];
    self.sku_nameLabel.text = productsModel.sku_name?productsModel.sku_name:@"";
    [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:productsModel.icon]];
    [self.iconImageV lh_setCornerRadius:0 borderWidth:0 borderColor:nil];

}
- (void)setOrderProductsModel:(HHproductsModel *)orderProductsModel{
    _orderProductsModel = orderProductsModel;
    
    self.StandardLab.text = orderProductsModel.status;

    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",orderProductsModel.product_price];
    self.namelabel.text = [NSString stringWithFormat:@"%@",orderProductsModel.product_name];
    self.quantityLabel.text = [NSString stringWithFormat:@"X %@",orderProductsModel.quantity];
    self.sku_nameLabel.text = orderProductsModel.sku_name?orderProductsModel.sku_name:@"";
    [self.iconImageV sd_setImageWithURL:[NSURL URLWithString:orderProductsModel.product_icon]];

}



@end
