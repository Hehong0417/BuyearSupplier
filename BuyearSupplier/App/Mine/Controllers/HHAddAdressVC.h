//
//  HHAddAdressVC.h
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HHAddress_addType,
    HHAddress_editType,
} HHAddressType;

@interface HHAddAdressVC : UIViewController

@property (nonatomic, strong)   NSString *titleStr;

@property (nonatomic, assign)   HHAddressType  addressType;

@property (nonatomic, strong)   NSString *Id;

@property (nonatomic, strong)   NSString *province;

@property (nonatomic, strong)   NSString *city;

@property (nonatomic, strong)   NSString *region;

@end
