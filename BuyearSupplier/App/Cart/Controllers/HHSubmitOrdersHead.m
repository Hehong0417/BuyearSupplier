//
//  HHSubmitOrdersHead.m
//  Store
//
//  Created by User on 2018/1/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHSubmitOrdersHead.h"

@implementation HHSubmitOrdersHead

- (void)setAddressModel:(HHMineModel *)addressModel{
    _addressModel = addressModel;
    self.usernameLabel.text = [NSString stringWithFormat:@"收货人：%@    %@",addressModel.username,addressModel.mobile];
    self.full_addressLabel.text = [NSString stringWithFormat:@"收货地址：%@",addressModel.full_address];
}

@end
