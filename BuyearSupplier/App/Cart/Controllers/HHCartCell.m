//
//  HHCartCell.m
//  Store
//
//  Created by User on 2017/12/29.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHCartCell.h"

@implementation HHCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.chooseBtn setImage:[UIImage imageNamed:@"icon_sign_default"] forState:UIControlStateNormal];
     [self.chooseBtn setImage:[UIImage imageNamed:@"icon_sign_selected"] forState:UIControlStateSelected];
    [self.product_iconLabel lh_setCornerRadius:0 borderWidth:0 borderColor:nil];
}
- (IBAction)chooseBtnAction:(UIButton *)sender {
    
    sender.selected = ! sender.selected;
 
    if (self.ChooseBtnSelectAction) {

        self.ChooseBtnSelectAction(self.indexPath,sender.selected);
    }
}

- (void)setProductModel:(HHproductsModel *)productModel{
    
    _productModel = productModel;
    
    [self.product_iconLabel sd_setImageWithURL:[NSURL URLWithString:productModel.product_icon] placeholderImage:nil];
    self.product_nameLabel.text = productModel.product_name;
    self.product_priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",productModel.product_price.floatValue];
    self.quantityTextField.text = productModel.quantity;
    self.sku_nameLabel.text = productModel.sku_name;
    
}
- (void)setPModel:(HHproductsModel *)pModel{
    
    _pModel = pModel;
    
    [self.product_iconLabel sd_setImageWithURL:[NSURL URLWithString:pModel.product_icon] placeholderImage:nil];
    self.product_nameLabel.text = pModel.product_name;
    self.product_priceLabel.text = [NSString stringWithFormat:@"¥ %.2f",pModel.product_price.floatValue];
    self.sku_nameLabel.text = pModel.sku_name;
    
}
- (void)setLeftSelected:(BOOL)leftSelected {
    _leftSelected = leftSelected;
    self.chooseBtn.selected = leftSelected;
}

@end
