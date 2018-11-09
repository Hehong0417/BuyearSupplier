//
//  HHAddBankCardVC.h
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJStaticGroupTableVC.h"

@interface HHAddBankCardVC : HJStaticGroupTableVC
@property (nonatomic,strong) NSString *useridStr;
@property (nonatomic,strong) NSString *bank_name;
@property (nonatomic,strong) NSString *user_Name;

@property (nonatomic,strong) NSString *bank_no;
@property (nonatomic,strong) NSString *is_default;
@property (nonatomic,strong) NSString *Id;

@property (nonatomic,strong) NSString *is_edit;
@property (nonatomic,strong) NSString *is_withDraw;

@property (nonatomic,copy) voidBlock bank_block;

@end
