//
//  HXForgetPwdVC.h
//  HXBudsProject
//
//  Created by n on 2017/5/11.
//  Copyright © 2017年 n. All rights reserved.
//

typedef enum : NSUInteger {
    LoginPd,
    SafetyPd,
} pdType;

#import <UIKit/UIKit.h>

@interface HHEditPwdVC : UIViewController

@property (nonatomic, assign)   pdType  pdType;

@end

