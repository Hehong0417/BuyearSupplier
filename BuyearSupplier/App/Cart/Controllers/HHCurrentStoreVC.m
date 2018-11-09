//
//  HHCurrentStoreVC.m
//  Store
//
//  Created by User on 2018/2/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHCurrentStoreVC.h"

@interface HHCurrentStoreVC ()
{
    UILabel *numbLabel;
    UILabel *nameLabel;

}
@end

@implementation HHCurrentStoreVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
        HJUser *user = [HJUser sharedUser];
        if (user.login_userid.length == 0) {
            numbLabel.text = @"-";
            nameLabel.text = @"";
        }else{
            numbLabel.text = user.login_userid;
            nameLabel.text = user.login_username;
        }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"当前店长账号";
    
    UIView *bgView = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, WidthScaleSize_H(150)) backColor:kWhiteColor];
    [self.view addSubview:bgView];
    
    UILabel *titleLabel = [UILabel lh_labelWithFrame:CGRectMake(0, WidthScaleSize_H(20), ScreenW, WidthScaleSize_H(30)) text:@"当前店长账号" textColor:APP_COMMON_COLOR font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
    
    numbLabel = [UILabel lh_labelWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), ScreenW, WidthScaleSize_H(30)) text:@"" textColor:kRedColor font:FONT(15) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
    nameLabel = [UILabel lh_labelWithFrame:CGRectMake(0, CGRectGetMaxY(numbLabel.frame), ScreenW, WidthScaleSize_H(30)) text:@"" textColor:kRedColor font:FONT(15) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
    [bgView addSubview:titleLabel];
    [bgView addSubview:numbLabel];
    [bgView addSubview:nameLabel];

    UIButton *delete_btn = [UIButton lh_buttonWithFrame:CGRectMake(ScreenW-20-WidthScaleSize_H(30), CGRectGetMaxY(titleLabel.frame), WidthScaleSize_H(30), WidthScaleSize_H(30)) target:self action:@selector(delete_btn_action:) image:[UIImage imageNamed:@"icon_del_shopcar_default"]];
    [bgView addSubview:delete_btn];

    UIView *swap_bgView = [UIView lh_viewWithFrame:CGRectMake(0,0 , 200, 300) backColor:kClearColor];
    [self.view addSubview:swap_bgView];
    swap_bgView.centerX = self.view.centerX;
    swap_bgView.centerY = self.view.centerY-WidthScaleSize_H(30);

    WEAK_SELF();
    swap_bgView.userInteractionEnabled = YES;
    [swap_bgView setTapActionWithBlock:^{
        [weakSelf swapAction];
    }];
    
    UIImageView *swap_imagV = [UIImageView lh_imageViewWithFrame:CGRectMake(0,0 , 200, 200) image:[UIImage imageNamed:@"button_scan_shopcar_default"]];
    swap_imagV.contentMode = UIViewContentModeCenter;
    [swap_bgView addSubview:swap_imagV];
    
    NSString *text = @"扫描二维码";
    UILabel *nameLabel = [UILabel lh_labelWithFrame:CGRectMake(0, CGRectGetMaxY(swap_imagV.frame)-WidthScaleSize_H(40), 200, WidthScaleSize_H(30)) text:text textColor:kWhiteColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
    nameLabel.centerY = swap_imagV.centerY +10;
    [swap_bgView addSubview:nameLabel];
    
    //新增体验店按钮
    UIButton *add_Btn = [UIButton lh_buttonWithFrame:CGRectMake(0, CGRectGetMaxY(swap_imagV.frame)+20, 150, 40) target:self action:@selector(add_BtnAction) image:nil title:@"填写体验店" titleColor:kWhiteColor font:FONT(14)];
    [add_Btn lh_setCornerRadius:3 borderWidth:0 borderColor:nil];
    add_Btn.backgroundColor = RGB(53, 40, 86);
    add_Btn.centerX = swap_imagV.centerX;
    
    [swap_bgView addSubview:add_Btn];
    
    
    //抓取返回按钮
    UIButton *backBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [backBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)backBtnAction{
    
    if (self.isHome_enter) {
        [self.navigationController popToRootVC];
    }else{
        [self.navigationController popVC];
    }
    
}
//新增体验店按钮
- (void)add_BtnAction{
    
    [self addAlert];
    
}
- (void)addAlert{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"填写体验店编号" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"请输入体验店编号";
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray * textfields = alert.textFields;
        UITextField *textfield = textfields[0];
        
        NSString *valid = [self isvalidStrWithShopId:textfield.text];
        if (valid) {
            [SVProgressHUD showInfoWithStatus:valid];
        }else{
//  ***********
        [[[HHHomeAPI postLoginShopWithuserid:textfield.text] netWorkClient] postRequestInView:nil finishedBlock:^(HHHomeAPI *api, NSError *error) {
            if (!error) {
                if (api.code == 0) {
                    HHMineModel *model1 = [HHMineModel mj_objectWithKeyValues:api.data];
                    HJUser *user = [HJUser sharedUser];
                    user.is_login_shop = model1.is_login_shop;
                    user.login_userid = model1.login_userid;
                    user.login_username = model1.login_username;
                    [user write];
                    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"欢迎进入%@的体验店～",model1.login_username]];
                    numbLabel.text = model1.login_userid;
                    nameLabel.text = model1.login_username;
                }else{
                    [SVProgressHUD showInfoWithStatus:api.msg];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:error.localizedDescription];
            }
        }];
        }
//************
        
    }];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (NSString *)isvalidStrWithShopId:(NSString *)shopId{
    
    if (shopId.length==0) {
        return @"请填写体验店编号！";
    }else if (![self compareWithshopId:shopId]) {
        
    return @"体验店格式不正确！";
    }
    return nil;
}
- (BOOL)compareWithshopId:(NSString *)shopId{
    
    NSString *string3;
    if (shopId.length>3) {
        string3 = [shopId substringToIndex:3];
        
    }else{
        string3 = shopId;
    }
    
    NSString *string4 = @"BYH";
    BOOL result2 = [string3 compare:string4
                            options:NSCaseInsensitiveSearch |NSNumericSearch] == NSOrderedSame;
    return result2;
}

- (void)delete_btn_action:(UIButton *)btn{
    
      btn.enabled = NO;

    [[[HHHomeAPI postQuitShop] netWorkClient] postRequestInView:nil finishedBlock:^(HHHomeAPI *api, NSError *error) {
        btn.enabled = YES;

        if (!error) {
            if (api.code == 0) {
                numbLabel.text = @"-";
                nameLabel.text = @"";
                HJUser *user = [HJUser sharedUser];
                user.login_userid = @"";
                user.login_username = @"";
                user.is_login_shop = @"0";
                [user write];
            }else{
                [SVProgressHUD showInfoWithStatus:api.msg];
            }
        }
    }];
    
}
- (void)swapAction{
    
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        SGQRCodeScanningVC *vc = [[SGQRCodeScanningVC alloc] init];
                        
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                    
                    NSLog(@"当前线程 - - %@", [NSThread currentThread]);
                    // 用户第一次同意了访问相机权限
                    NSLog(@"用户第一次同意了访问相机权限");
                    
                } else {
                    
                    // 用户第一次拒绝了访问相机权限
                    NSLog(@"用户第一次拒绝了访问相机权限");
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            SGQRCodeScanningVC *vc = [[SGQRCodeScanningVC alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
            
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
        }
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    }
    
}
@end
