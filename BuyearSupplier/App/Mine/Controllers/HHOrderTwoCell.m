//
//  HHOrderTwoCell.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHOrderTwoCell.h"

@implementation HHOrderTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//订单总计
- (void)setOrderTotalModel:(HHCartModel *)orderTotalModel{
    _orderTotalModel = orderTotalModel;
    self.express_nameLabel.textColor = kRedColor;
    self.express_nameLabel.text = [NSString stringWithFormat:@"¥ %@",orderTotalModel.pya_total?orderTotalModel.pya_total:@""];
    self.express_orderLabel.text = @"订单总计";
}

//物流单号
- (void)setOrderModel:(HHCartModel *)orderModel{
    _orderModel = orderModel;
    self.express_nameLabel.textColor = kBlackColor;
    self.express_nameLabel.text =  orderModel.express_name;
    self.express_orderLabel.text = [NSString stringWithFormat:@"物流单号：%@",orderModel.express_order?orderModel.express_order:@""];
}
@end
