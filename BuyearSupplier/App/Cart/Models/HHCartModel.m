//
//  HHCartModel.m
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHCartModel.h"

@implementation HHCartModel

+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"products": [HHproductsModel class]};
}
//我的订单
- (void)mj_keyValuesDidFinishConvertingToObject {
    
    switch (self.status_code.integerValue) {
        case 0:{
//            stutus = @"待付款";
            self.footHeight = 60;
        }
            break;
        case 1:{
//            stutus = @"待发货";
            if ([self.ship_channel isEqualToString:@"0"]) {
                //总部
                self.footHeight = 60;
            }else{
                //体验店
                self.footHeight = 8;
            }
        }
            break;
        case 2:{
//            stutus = @"待收货";
            self.footHeight = 60;
        }
            break;
        case 3:{
//            stutus = @"交易成功";
            self.footHeight = 8;
        }
            break;
        case 4:{
//            stutus = @"已退款";
            self.footHeight = 8;
        }
            break;
        case 5:{
//            stutus = @"已退货";
            self.footHeight = 8;
        }
            break;
        case 6:{
//            stutus = @"订单关闭";
            self.footHeight = 8;
        }
            break;
        default:{
            self.footHeight = 60;
        }
            break;
    }
    
}
@end
@implementation HHproductsModel

@end
