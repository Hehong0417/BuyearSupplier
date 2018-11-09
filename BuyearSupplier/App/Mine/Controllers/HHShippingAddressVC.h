//
//  HHShippingAddressVC.h
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HHShippingAddressVCProtocol <NSObject>

//选择收货地址
- (void)shippingAddressTableView_didSelectRowWithaddressModel:(HHMineModel *)addressModel;
//返回
- (void)shippingAddressBackAction;

@end

@interface HHShippingAddressVC : UIViewController

@property (nonatomic, weak) id <HHShippingAddressVCProtocol> delegate;

@end
