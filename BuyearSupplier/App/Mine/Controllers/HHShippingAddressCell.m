//
//  HHShippingAddressCell.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHShippingAddressCell.h"

@implementation HHShippingAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setShippingAddressModel:(HHMineModel *)shippingAddressModel{
    
    _shippingAddressModel = shippingAddressModel;
    
    self.usernameLabel.text = shippingAddressModel.username;
    self.mobileLabel.text = shippingAddressModel.mobile;
    self.provinceLabel.text =  [NSString stringWithFormat:@"%@%@",shippingAddressModel.city,shippingAddressModel.region];
    self.full_addressLabel.text = shippingAddressModel.full_address;
    if ([shippingAddressModel.is_default isEqualToString:@"0"]) {
        self.defaultAddressLabel.hidden = YES;
    }else{
        self.defaultAddressLabel.hidden = NO;
    }
    
}
@end
