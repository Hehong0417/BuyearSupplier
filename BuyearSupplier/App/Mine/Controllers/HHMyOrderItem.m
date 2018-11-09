//
//  HHMyOrderItem.m
//  Store
//
//  Created by User on 2018/3/30.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMyOrderItem.h"

@implementation HHMyOrderItem

+ (NSString *)shippingLogisticsStateWithStatus_code:(NSInteger)status_code{
    
    NSString *stutus;
    switch (status_code) {
        case 0:
            stutus = @"待付款";
            break;
        case 1:
            stutus = @"待发货";
            break;
        case 2:
            stutus = @"待收货";
            break;
        case 3:
            stutus = @"交易成功";
            break;
        case 4:
            stutus = @"已退款";
            break;
        case 5:
            stutus = @"已退货";
            break;
        case 6:
            stutus = @"订单关闭";
            break;
        default:
            break;
    }
    return stutus;
}
+ (CGFloat)rowHeightWithRow:(NSInteger)row Products_count:(NSInteger )products_count{
    
    if (row == products_count){
        return 44;
    }else if (row == products_count+1){
        return 44;
    }else if (row == products_count+2){
        return 44;
    }else{
        //商品
        return 85;
    }
}
@end
