//
//  HHRegisterVC.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHRegisterVC.h"
#import "HHTextfieldcell.h"
#import "HHRegisterProtocolVC.h"

@interface HHRegisterVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UIButton *protocolBtn;
    
}
@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, strong)   NSMutableArray *titlesArr;
@property (nonatomic, strong)   NSArray *placeHolderArr;
@property(nonatomic,strong) LHVerifyCodeButton *verifyCodeBtn;

@property (nonatomic, strong)   UIImageView *imageCodeImageV;
@property (nonatomic, strong)   NSNumber *protocalHiden;


@end

@implementation HHRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"注册";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT - Status_HEIGHT-44;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.backgroundColor = KVCBackGroundColor;
    [self.view addSubview:self.tableView];
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) backColor:KVCBackGroundColor];
    
    protocolBtn =  [UIButton lh_buttonWithFrame:CGRectMake(30, 0, SCREEN_WIDTH, WidthScaleSize_H(40)) target:self action:@selector(protocolBtnAction:) backgroundImage:nil title:@"我已经阅读并接受《注册协议》" titleColor:KTitleLabelColor font:FONT(14)];
    [protocolBtn setImage:[UIImage imageNamed:@"icon_checkbox_default"] forState:UIControlStateNormal];
    [protocolBtn setImage:[UIImage imageNamed:@"icon_checkbox_selected"] forState:UIControlStateSelected];
    
    protocolBtn.titleLabel.userInteractionEnabled = YES;
    WEAK_SELF();
    [protocolBtn.titleLabel setTapActionWithBlock:^{
        HHRegisterProtocolVC *vc = [[HHRegisterProtocolVC alloc] initWithNibName:@"HHRegisterProtocolVC" bundle:nil];
        [weakSelf.navigationController pushVC:vc];
        
    }];
    
    NSMutableAttributedString *attrStr = [NSString lh_attriStrWithprotocolStr:@"《注册协议》" content:@"  我已经阅读并接受《注册协议》" protocolFont:FONT(13) contentFont:FONT(13) protocolStrColor:APP_purple_Color contentColor:KTitleLabelColor];
    
    [protocolBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
    [footView addSubview:protocolBtn];
   
    UIButton *finishBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, CGRectGetMaxY(protocolBtn.frame)+20, SCREEN_WIDTH - 60, WidthScaleSize_H(40)) target:self action:@selector(rigsterAction:) backgroundImage:nil title:@"立即注册" titleColor:kWhiteColor font:FONT(15)];
    
    finishBtn.backgroundColor = APP_COMMON_COLOR;
    [finishBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    
    [footView addSubview:finishBtn];
    self.tableView.tableFooterView = footView;
    
    self.titlesArr = [NSMutableArray arrayWithArray:@[@"",@"姓名",@"手机号",@"图片验证码",@"密码",@"确认密码",@"安全密码",@"确认安全密码",@"消费来源"]];
    self.placeHolderArr = @[@"点击更换用户名",@"点击此处编辑姓名",@"点击此处编辑手机号",@"点击编辑图片验证码",@"点击此处编辑密码",@"点击此处确认密码",@"点击此处编辑安全密码",@"点击此处确认安全密码",@"请输入消费来源"];
    
    //获取用户名
    [self changeUserName:nil];
    
    
}

- (void)protocolBtnAction:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    
}
- (void)rigsterAction:(UIButton *)btn{
    
    HHTextfieldcell *nameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *nameStr = nameCell.inputTextField.text;
    HHTextfieldcell *phoneCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *phoneStr = phoneCell.inputTextField.text;
    
    HHTextfieldcell *imgCodeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *imgCodeStr = imgCodeCell.inputTextField.text;
    
    HHTextfieldcell *pdCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    NSString *pdStr = pdCell.inputTextField.text;
    
    HHTextfieldcell *commitPdCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    NSString *commitPdStr = commitPdCell.inputTextField.text;
    
    HHTextfieldcell *securityPdCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    NSString *securityPdStr = securityPdCell.inputTextField.text;
    
    HHTextfieldcell *commitSecurityPdCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
    NSString *commitSecurityPdStr = commitSecurityPdCell.inputTextField.text;
    
    HHTextfieldcell *referralCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
    NSString *referralStr = referralCell.inputTextField.text;
    
    
    NSString *vaildStr =  [self validWithmobile:phoneStr fullname:nameStr imgCodeStr:imgCodeStr  login_pwd:pdStr repeat_login_pwd:commitPdStr security_pwd:securityPdStr repeat_security_pwd:commitSecurityPdStr referral_username:referralStr];
    
    if (!vaildStr) {
        
        if (protocolBtn.selected == NO &&protocolBtn.hidden == NO) {
            
            [SVProgressHUD setMinimumDismissTimeInterval:1.0];
            [SVProgressHUD showInfoWithStatus:@"请先勾选注册协议！"];
            
        }else{
            btn.enabled = NO;
            [btn lh_setBackgroundColor:KA0LabelColor forState:UIControlStateNormal];

        [[[HHLoginAPI postRegisterWithmobile:phoneStr fullname:nameStr smscode:nil login_pwd:pdStr repeat_login_pwd:pdStr security_pwd:securityPdStr repeat_security_pwd:securityPdStr referral_username:referralStr ] netWorkClient] postRequestInView:nil finishedBlock:^(HHLoginAPI *api, NSError *error) {
            btn.enabled = YES;
            [btn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];

            if(!error){
                if (api.code == 0) {
                    
                    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
                    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                    [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                    [self.navigationController popToRootVC];
                    [self dismissViewControllerAnimated:YES completion:nil];

                }else{
                    
                    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
                    [SVProgressHUD showInfoWithStatus:api.msg];
                }
            }
            
        }];
              }
    }else{
        
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        [SVProgressHUD showInfoWithStatus:vaildStr];
        
    }
    
}
- (NSString *)validWithmobile:(NSString *)mobile fullname:(NSString *)fullname imgCodeStr:(NSString *)imgCodeStr login_pwd:(NSString *)login_pwd repeat_login_pwd:(NSString *)repeat_login_pwd security_pwd:(NSString *)security_pwd repeat_security_pwd:(NSString *)repeat_security_pwd referral_username:(NSString *)referral_username {
    
    if (fullname.length == 0) {
        return @"请填写姓名！";
    }else if (mobile.length == 0) {
        return @"请填写手机号！";
    }else  if (imgCodeStr.length == 0) {
        return @"请填写图片验证码！";
    }else  if (login_pwd.length == 0) {
        return @"请填写登录密码！";
    }else  if (login_pwd.length < 6) {
        return @"登录密码不能小于6位！";
    }else  if (repeat_login_pwd.length == 0) {
        return @"请确认登录密码！";
    }else  if (![repeat_login_pwd isEqualToString:login_pwd]) {
        return @"两次登录密码不一致！";
    }else  if (security_pwd.length == 0) {
        return @"请填写安全密码！";
    }else  if (security_pwd.length < 6) {
        return @"安全密码不能小于6位！";
    }else  if (repeat_security_pwd.length == 0) {
        return @"请确认安全密码！";
    }else  if (![repeat_security_pwd isEqualToString:security_pwd]) {
        return @"两次安全密码不一致！";
    }else  if (referral_username.length == 0) {
        return @"请填写消费来源！";
    }
    return nil;
    
}
#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHTextfieldcell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleLabel"];

    if (!cell) {
        cell = [[HHTextfieldcell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleLabel"];
    }
    cell.inputTextField.font = FONT(13);
    cell.inputTextField.delegate = self;
    cell.inputTextField.tag = 100+indexPath.row;

    if (indexPath.row == 0) {
        //用户名
        UIButton *modifyBtn = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 100, 27) target:self action:@selector(changeUserName:) image:nil title:@"点击更换用户名" titleColor:kWhiteColor font:FONT(12)];
        
        modifyBtn.backgroundColor = APP_COMMON_COLOR;
        [modifyBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
        cell.inputTextField.rightView = modifyBtn;
        cell.inputTextField.rightViewMode = UITextFieldViewModeAlways;

    }else{

      cell.inputTextField.placeholder = self.placeHolderArr[indexPath.row];
        
     if (indexPath.row == 2) {
        //手机号
         cell.inputTextField.keyboardType = UIKeyboardTypePhonePad;
         cell.inputTextField.delegate = self;
         
      }
        
    if (indexPath.row == 3) {
       // 图片验证码
        self.imageCodeImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 27)];
        WEAK_SELF();
        [self getRandom];
        self.imageCodeImageV.userInteractionEnabled = YES;
        [self.imageCodeImageV lh_setCornerRadius:0 borderWidth:0 borderColor:nil];
        [self.imageCodeImageV setTapActionWithBlock:^{
            [weakSelf getRandom];
        }];
        cell.inputTextField.keyboardType = UIKeyboardTypeASCIICapable;
        self.imageCodeImageV.contentMode = UIViewContentModeCenter;
        cell.inputTextField.rightView = self.imageCodeImageV;
        cell.inputTextField.rightViewMode = UITextFieldViewModeAlways;
    }

        if (indexPath.row == 4) {
          //  密码
            cell.inputTextField.secureTextEntry = YES;

        }
        if (indexPath.row == 5) {
            //  确认密码
            cell.inputTextField.secureTextEntry = YES;

        }
        if (indexPath.row == 6) {
            //  安全密码
            cell.inputTextField.secureTextEntry = YES;

        }
        if (indexPath.row == 7) {
            //  确认安全密码
            cell.inputTextField.secureTextEntry = YES;

        }
        if (indexPath.row == 8) {
            //  消费来源
            cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        }
    }
    cell.titleLabel.text = self.titlesArr[indexPath.row];
    cell.titleLabel.textColor = KTitleLabelColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
//获取随机数
- (int)getRandom{
    
     srand((unsigned)time(0));
     int i = arc4random() % 500;
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 开始请求
    NSString *api_url = [NSString stringWithFormat:@"%@/Api/Image/GetCode",API_HOST];
    [manager GET:api_url parameters:@{@"v":[NSString stringWithFormat:@"%d",i]} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        UIImage *image = [UIImage imageWithData:responseObject];
        self.imageCodeImageV.image = image;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
    return i;
}
//点击更换用户名
- (void)changeUserName:(UIButton *)btn{
    btn.enabled = NO;
    [btn lh_setBackgroundColor:KA0LabelColor forState:UIControlStateNormal];

    [[[HHLoginAPI getUserNo] netWorkClient] getRequestInView:nil finishedBlock:^(HHLoginAPI *api, NSError *error) {
        btn.enabled = YES;
        [btn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];

        if (!error) {
            
            if (api.code == 0) {
                
                [self.titlesArr replaceObjectAtIndex:0 withObject:api.data];
                [self.tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
            }else{
                
                [SVProgressHUD showInfoWithStatus:api.msg];
            }
            
        }
        
    }];

    
}
//发送验证码
- (void)sendVerifyCode{
    
    HHTextfieldcell *phoneCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    HHTextfieldcell *imageCodeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    NSString *phoneStr = phoneCell.inputTextField.text;
    NSString *imageCodeStr = imageCodeCell.inputTextField.text;

    [SVProgressHUD  setMinimumDismissTimeInterval:1.0];
    if (phoneStr.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写手机号！"];
    }else if (imageCodeStr.length == 0){
        [SVProgressHUD showInfoWithStatus:@"请填写图片验证码！"];
    }else {
        self.verifyCodeBtn.userInteractionEnabled = NO;
        [[[HHLoginAPI getSms_SendCodeWithmobile:phoneStr code:imageCodeStr] netWorkClient] postRequestInView:nil finishedBlock:^(HHLoginAPI *api, NSError *error) {
            self.verifyCodeBtn.userInteractionEnabled = YES;

            if (!error) {
                
                if (api.code == 0) {
                    [self.verifyCodeBtn startTimer:60];
                    
                }else {
                    //刷新图片验证码
                    [self getRandom];
                    
                    [SVProgressHUD showInfoWithStatus:api.msg];

                }
                
            }
            
        }];
       }
}
#pragma mark - textfieldDelegate限制手机号为11位

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSInteger length=11;
    if (textField.tag == 101) {
        length = 15;
    }else  if (textField.tag == 102) {
        length = 11;
    }else  if (textField.tag == 103) {
        length = 4;
    }else  if (textField.tag == 104) {
        length = 6;
    }else  if (textField.tag == 105) {
        length = 20;
    }else  if (textField.tag == 106) {
        length = 20;
    }else  if (textField.tag == 107) {
        length = 20;
    }else  if (textField.tag == 108) {
        length = 20;
    }else  if (textField.tag == 109) {
        length = 8;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > length && range.length!=1){
        textField.text = [toBeString substringToIndex:length];
        return NO;
    }
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 100) {
        return NO;
    }
    return YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titlesArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
     
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}

@end
