//
//  HHDetailGoodReferralCell.m
//  Store
//
//  Created by User on 2018/1/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHDetailGoodReferralCell.h"

@implementation HHDetailGoodReferralCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.product_nameLabel.font = FONT(14);
    self.product_min_priceLabel.font = FONT(16);
    
}

- (void)setGooodDetailModel:(HHgooodDetailModel *)gooodDetailModel{
    
    _gooodDetailModel = gooodDetailModel;
    self.product_nameLabel.text = gooodDetailModel.product_name;
    self.product_min_priceLabel.text = [NSString stringWithFormat:@"¥ %@",gooodDetailModel.product_min_price?gooodDetailModel.product_min_price:@""];
    
    NSMutableAttributedString *attributeStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"赠送积分:%@",gooodDetailModel.product_s_intergral?gooodDetailModel.product_s_intergral:@""]];
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
    self.product_supplier_name_label.text = gooodDetailModel.product_supplier_name;
}

@end

