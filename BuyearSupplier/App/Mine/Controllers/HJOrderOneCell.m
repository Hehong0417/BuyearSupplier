//
//  HJOrderOneCell.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HJOrderOneCell.h"



@implementation HJOrderOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setOrderModel:(HHCartModel *)orderModel{
    
    _orderModel = orderModel;
    self.s_integralLabel.text = @"赠送积分";
    self.pya_totalLabel.text = orderModel.s_integral;
    
}

@end
