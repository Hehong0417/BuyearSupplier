//
//  HHLoginVC.h
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHLoginVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *pdTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
//记住密码按钮
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UILabel *forgetPdLabel;
@property (weak, nonatomic) IBOutlet UILabel *registerLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phone_constant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pd_constant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBtn_top_Constant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remember_top_constant;
@property (weak, nonatomic) IBOutlet UILabel *rememberLabel;

@property(nonatomic,strong) HJTabBarController *tabBarVC;
@property (strong, nonatomic) IBOutlet UIView *loginBgView;

@property(nonatomic,assign) NSInteger tabSelectIndex;

@end
