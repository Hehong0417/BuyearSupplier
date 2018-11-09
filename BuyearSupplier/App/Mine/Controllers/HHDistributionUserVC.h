//
//  HHDistributionUserVC.h
//  Store
//
//  Created by User on 2018/1/6.
//  Copyright © 2018年 User. All rights reserved.
//

typedef enum : NSUInteger {
    HHdistribe_type_user,
    HHdistribe_type_sign
} HHdistribe_type;

#import <UIKit/UIKit.h>

@interface HHDistributionUserVC : UIViewController
@property(nonatomic,strong)NSString *shopid;
@property(nonatomic,assign)HHdistribe_type distrb_type;

@end
