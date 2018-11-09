//
//  HXHomeCollectionCell.m
//  Store
//
//  Created by User on 2018/1/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HXHomeCollectionCell.h"

@implementation HXHomeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.goodImageV lh_setCornerRadius:0 borderWidth:0 borderColor:nil];
    [self.tagLabel lh_setCornerRadius:3 borderWidth:0 borderColor:nil];
    self.product_min_priceLabel.font = BoldFONT(14);
    self.product_s_intergralLabel.font = FONT(11);
    self.product_nameLabel.font = FONT(14);
    self.product_supplier_name_btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

}
- (void)setProductsModel:(HHhomeProductsModel *)productsModel{
    _productsModel = productsModel;
    self.product_nameLabel.text = productsModel.product_name;
    [self.goodImageV sd_setImageWithURL:[NSURL URLWithString:productsModel.product_icon]];
    self.product_min_priceLabel.text = [NSString stringWithFormat:@"¥ %@",productsModel.product_min_price];
    
    NSString *product_s_intergral = productsModel.product_promo_s_integral.floatValue>0?[NSString stringWithFormat:@"赠送积分:%@|%@",productsModel.product_promo_s_integral,productsModel.product_s_intergral]:[NSString stringWithFormat:@"赠送积分:%@",productsModel.product_s_intergral];
    NSMutableAttributedString *attributeStr1 = [[NSMutableAttributedString alloc] initWithString:product_s_intergral];
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:FONT(11),NSFontAttributeName,
                                   KA0LabelColor,NSForegroundColorAttributeName,nil];
    [attributeStr1 addAttributes:attributeDict range:NSMakeRange(0, attributeStr1.length)];
    
    //添加图片
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"icon_integral_default"];
    attach.bounds = CGRectMake(0, -1, WidthScaleSize_W(8), WidthScaleSize_H(10));
    NSAttributedString *attributeStr2 = [NSAttributedString attributedStringWithAttachment:attach];
    [attributeStr1 insertAttributedString:attributeStr2 atIndex:2];
    
    if ([productsModel.product_type isEqualToString:@"0"]) {
        self.tagLabel.text = @"百";
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:@"chu"];
        attach.bounds = CGRectMake(0, 5, WidthScaleSize_W(8), WidthScaleSize_H(8));
        NSAttributedString *attributeStr2 = [NSAttributedString attributedStringWithAttachment:attach];
        [attributeStr1 appendAttributedString:attributeStr2];
        self.product_s_intergralLabel.attributedText = attributeStr1;

    }else{
        self.tagLabel.text = @"惠";
        self.product_s_intergralLabel.attributedText = attributeStr1;
    }
    [self.product_supplier_name_btn setTitle:productsModel.product_supplier_name forState:UIControlStateNormal];
    
}
- (void)setGoodsModel:(HHCategoryModel *)goodsModel{
    
    _goodsModel = goodsModel;
    self.product_nameLabel.text = goodsModel.product_name;
    [self.goodImageV sd_setImageWithURL:[NSURL URLWithString:goodsModel.product_icon]];
    self.product_min_priceLabel.text = [NSString stringWithFormat:@"¥ %@",goodsModel.product_min_price];

    NSString *product_s_intergral = goodsModel.product_promo_s_integral.floatValue>0?[NSString stringWithFormat:@"赠送积分:%@|%@",goodsModel.product_promo_s_integral,goodsModel.product_s_intergral]:[NSString stringWithFormat:@"赠送积分:%@",goodsModel.product_s_intergral];
    
    NSMutableAttributedString *attributeStr1 = [[NSMutableAttributedString alloc] initWithString:product_s_intergral];
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:FONT(11),NSFontAttributeName,
                                   KA0LabelColor,NSForegroundColorAttributeName,nil];
    [attributeStr1 addAttributes:attributeDict range:NSMakeRange(0, attributeStr1.length)];
    
    //添加图片
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"icon_integral_default"];
    attach.bounds = CGRectMake(0, -1, WidthScaleSize_W(8), WidthScaleSize_H(10));
    NSAttributedString *attributeStr2 = [NSAttributedString attributedStringWithAttachment:attach];
    [attributeStr1 insertAttributedString:attributeStr2 atIndex:2];
    self.product_s_intergralLabel.attributedText = attributeStr1;
    
    if ([goodsModel.product_type isEqualToString:@"0"]) {
        self.tagLabel.text = @"百";
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:@"chu"];
        attach.bounds = CGRectMake(0, 5, WidthScaleSize_W(8), WidthScaleSize_H(8));
        NSAttributedString *attributeStr2 = [NSAttributedString attributedStringWithAttachment:attach];
        [attributeStr1 appendAttributedString:attributeStr2];
        self.product_s_intergralLabel.attributedText = attributeStr1;
    }else{
        self.tagLabel.text = @"惠";
        self.product_s_intergralLabel.attributedText = attributeStr1;

    }
    [self.product_supplier_name_btn setTitle:goodsModel.product_supplier_name forState:UIControlStateNormal];

}


@end
