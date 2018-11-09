//
//  HHLoginVC.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHLoginVC.h"
#import "HHRegisterVC.h"
#import "HHRegisterVC.h"
#import "HHFindPwdVC.h"
#import "HHSelectChannelAlertView.h"

#define K_LoginInfo @"loginInfo"

@interface HHLoginVC ()<UITextFieldDelegate>


@property(nonatomic,strong) HHSelectChannelAlertView *alertView;

@end

@implementation HHLoginVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title = @"圣韵百业惠";
    
    [self setUpUI];
    
    [self addAction];
    
    //加阴影
    [self.loginBgView addShadowToView:self.loginBgView withOpacity:0.15 shadowRadius:5 andCornerRadius:5 shadowColor:APP_purple_Color layer_w:ScreenW - 60 layer_h:ScreenH*340/667 layer_y:ScreenH*311/667-77];
    self.phone_constant.constant = WidthScaleSize_H(42);
    self.pd_constant.constant = WidthScaleSize_H(34);
   self.loginBtn_top_Constant.constant = WidthScaleSize_H(45);
   self.remember_top_constant.constant = WidthScaleSize_H(23);
    
}

- (void)setUpUI{
    
    [self.loginBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [self.chooseBtn setImage:[UIImage imageNamed:@"icon_sign_default"] forState:UIControlStateNormal];
    [self.chooseBtn setImage:[UIImage imageNamed:@"icon_sign_selected"] forState:UIControlStateSelected];
    
    NSMutableDictionary *dic = [KeyChainManager keyChainReadData:K_LoginInfo];
    
    self.phoneTF.text = [dic objectForKey:@"phone"];
    self.pdTF.text = [dic objectForKey:@"password"];
    
    self.phoneTF.delegate = self;
    self.pdTF.delegate = self;
    
}
#pragma mark - textfieldDelegate限制手机号为11位

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSInteger length = 8;
    if (textField == self.phoneTF) {
        length = 8;
    }else{
        length = 20;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > length && range.length!=1){
        textField.text = [toBeString substringToIndex:length];
        return NO;
    }
    return YES;
}
- (void)addAction{
    
    //忘记密码
    self.forgetPdLabel.font = FONT(12);
    self.forgetPdLabel.userInteractionEnabled = YES;
    [self.forgetPdLabel setTapActionWithBlock:^{
        
        HHFindPwdVC *vc = [HHFindPwdVC new];
        [self.navigationController pushVC:vc];
        
    }];
    self.registerLabel.userInteractionEnabled = YES;
    self.registerLabel.font = FONT(12);
    [self.registerLabel setTapActionWithBlock:^{
        
        HHRegisterVC *vc = [HHRegisterVC new];
        [self.navigationController pushVC:vc];
    }];
    
    self.rememberLabel.font = FONT(12);

}
- (IBAction)backAction:(UIButton *)sender {
    
    self.tabBarVC.selectedIndex = 0;

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
- (IBAction)loginAction:(UIButton *)sender {
    
    NSString *phoneStr = self.phoneTF.text;
    NSString *login_pdStr = self.pdTF.text;

    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    if (phoneStr.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写手机号！"];
    }else if (login_pdStr.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写密码！"];
    }else{
        MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.color = KA0LabelColor;
        hud.detailsLabelText = @"登录中...";
        hud.detailsLabelColor = kWhiteColor;
        hud.detailsLabelFont = FONT(14);
        hud.activityIndicatorColor = kWhiteColor;
        [hud show:YES];

        [[[HHLoginAPI postLoginWithlogin_name:self.phoneTF.text pwd:login_pdStr] netWorkClient] postRequestInView:nil finishedBlock:^(HHLoginAPI *api, NSError *error) {
            [hud hideAnimated:YES];
            if (!error) {
                if (api.code == 0) {
                    
                    HHMineModel *model = [HHMineModel mj_objectWithKeyValues:api.data];
                    HJUser *user = [HJUser sharedUser];
                    user.token = model.ticke;
                    if (model.loginShopId.length>0) {
                        user.is_login_shop = @"1";
                    }else{
                        user.is_login_shop = @"0";
                    }
                    //保存上一个版本号
                    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
                    NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
                    user.version_no = currentVersion;
                    [user write];
                    //保存用户名和密码
                    if (self.chooseBtn.selected) {
                        NSMutableDictionary *loginInfo_dic = [NSMutableDictionary dictionary];
                        [loginInfo_dic setObject:self.phoneTF.text forKey:@"phone"];
                        [loginInfo_dic setObject:login_pdStr forKey:@"password"];
                        [KeyChainManager keyChainSaveData:loginInfo_dic withIdentifier:K_LoginInfo];
                    }else{
                        [KeyChainManager keyChainDelete:K_LoginInfo];
                    }
                    self.alertView = [[HHSelectChannelAlertView alloc]init];
                    self.alertView.close_btn.hidden = YES;
                    [self.alertView showAnimated:NO];
                    
                    WEAK_SELF();
                    self.alertView.commitBlock = ^(NSString  *channel) {
                        HJUser *user1 = [HJUser sharedUser];
                        user1.ship_channel = channel;
                        [user1 write];
                        [weakSelf.alertView hideWithCompletion:nil];
                        [weakSelf dismissViewControllerAnimated:YES completion:^{
                            weakSelf.tabBarVC.selectedIndex = weakSelf.tabSelectIndex;
                        }];
                    };
                    
                }else{
                    [SVProgressHUD showInfoWithStatus:api.msg];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:error.localizedDescription];
            }

        }];
    }

}
- (IBAction)remenberAcount:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    
}
@end
 
