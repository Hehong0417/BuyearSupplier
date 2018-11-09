//
//  HXFindPwdAPI.m
//  HXBudsProject
//
//  Created by n on 2017/5/11.
//  Copyright © 2017年 n. All rights reserved.
//

#import "HHFindPwdVC.h"
#import "HHTextfieldcell.h"
#import "LHVerifyCodeButton.h"


@interface HHFindPwdVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *leftTitleArr;
@property(nonatomic,strong)LHVerifyCodeButton *verifyCodeBtn;
@property(nonatomic,strong)NSString *verifyCode;
@property(nonatomic,strong)NSArray *placeholerArr;

@end

@implementation HHFindPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"忘记密码";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60) backColor:KVCBackGroundColor];
    UIButton *finishBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 25, SCREEN_WIDTH - 60, WidthScaleSize_H(40)) target:self action:@selector(finishAction:) backgroundImage:nil title:@"找回密码" titleColor:kWhiteColor font:FONT(15)];
    finishBtn.backgroundColor = APP_COMMON_COLOR;
    [finishBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];

    [footView addSubview:finishBtn];
    self.tableView.tableFooterView = footView;
    self.leftTitleArr = @[@"用户账号",@"验证码",@"新密码",@"确认新密码"];
    self.placeholerArr = @[@"请输入用户账号",@"请输入验证码",@"请输入新密码",@"请确认新密码"];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.leftTitleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return WidthScaleSize_H(0.01);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return WidthScaleSize_H(0.01);
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    HHTextfieldcell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleLabel"];
    if(!cell){
        cell = [[HHTextfieldcell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleLabel"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.titleLabel.text = self.leftTitleArr[indexPath.row];
    cell.titleLabel.adjustsFontSizeToFitWidth = YES;
    cell.inputTextField.placeholder = self.placeholerArr[indexPath.row];
    cell.titleLabel.textColor = KTitleLabelColor;
    cell.inputTextField.delegate = self;
    cell.inputTextField.tag = 1000+indexPath.row;
    if (indexPath.row == 0){
        cell.inputTextField.rightView = [UILabel lh_labelWithFrame:CGRectMake(0, 0, 100, 44) text:@"" textColor:KTitleLabelColor font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
        cell.inputTextField.rightViewMode = UITextFieldViewModeAlways;
        cell.inputTextField.secureTextEntry = NO;
        cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        
    }else if (indexPath.row == 1){
        
        self.verifyCodeBtn = [[LHVerifyCodeButton alloc]initWithFrame:CGRectMake(0, 4, WidthScaleSize_W(100), 36)];
        [self.verifyCodeBtn addTarget:self action:@selector(sendVerifyCode:) forControlEvents:UIControlEventTouchUpInside];
        [self.verifyCodeBtn setTitle:@"点击发送验证码" forState:UIControlStateNormal];
        [self.verifyCodeBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        self.verifyCodeBtn.titleLabel.font = FONT(13);
        [self.verifyCodeBtn setBackgroundColor:APP_COMMON_COLOR];
        [self.verifyCodeBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
        cell.inputTextField.rightView = self.verifyCodeBtn;
        cell.inputTextField.rightViewMode = UITextFieldViewModeAlways;
        cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        cell.inputTextField.secureTextEntry = NO;
        
    }else{
        cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
        cell.inputTextField.secureTextEntry = YES;
    }
    return cell;
    
}

- (void)sendVerifyCode:(UIButton *)btn{
    
    //判断手机号是否填写--手机号是否存在
    [self checkPhoneOnly:btn];

}
#pragma mark-手机号唯一性验证
- (void)checkPhoneOnly:(UIButton *)btn
{
    HHTextfieldcell *cell = (HHTextfieldcell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (cell.inputTextField.text.length == 0) {
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        [SVProgressHUD showInfoWithStatus:@"请先填写用户账号"];
    }else{
            [self sendverifyCodeRequest:cell.inputTextField.text btn:btn];
  }
}
#pragma mark-发送验证码请求

- (void)sendverifyCodeRequest:(NSString *)account btn:(UIButton *)btn
{
    btn.enabled = NO;
    [btn lh_setBackgroundColor:KA0LabelColor forState:UIControlStateNormal];
    [[[HHLoginAPI getSms_SendCodeWithuserno:account] netWorkClient] postRequestInView:nil finishedBlock:^(HHLoginAPI *api, NSError *error) {
        btn.enabled = YES;
        [btn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
        if (!error) {
            if (api.code == 0) {
                [self.verifyCodeBtn startTimer:60];
            }else {
                [SVProgressHUD showInfoWithStatus:api.msg];
            }
        }
    }];
    
}

- (NSString *)isValidWithaccountStr:(NSString *)accountStr  verifyCodeStr:(NSString *)verifyCodeStr  newPwdStr:(NSString *)newPwdStr commitPwdStr:(NSString *)commitPwdStr {
    if (accountStr.length == 0) {
        return @"请输入用户账号！";
    }else if (verifyCodeStr.length == 0){
        return @"请输入验证码！";
    }else if (newPwdStr.length == 0){
        return @"请输入新密码！";
    }else if (newPwdStr.length < 6){
        return @"新密码不能小于6位！";
    }else if (commitPwdStr.length == 0){
        return @"请输入确认密码！";
    }else if (![commitPwdStr isEqualToString:newPwdStr]){
        return @"两次输入的密码不一致！";
    }
    return nil;
}

#pragma mark - textfieldDelegate限制手机号为11位

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSInteger length=8;
    if (textField.tag == 1000) {
        length = 8;
    }else  if (textField.tag == 1001) {
        length = 6;
    }else  if (textField.tag == 1002) {
        length = 20;
    }else  if (textField.tag == 1003) {
        length = 20;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > length && range.length!=1){
        textField.text = [toBeString substringToIndex:length];
        return NO;
    }
    return YES;
}
- (void)finishAction:(UIButton *)btn {
    
   HHTextfieldcell *cell0 = (HHTextfieldcell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *accountStr = cell0.inputTextField.text;
    
   HHTextfieldcell *cell1 = (HHTextfieldcell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *verifyCodeStr = cell1.inputTextField.text;
    
   HHTextfieldcell *cell2 = (HHTextfieldcell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *newPwdStr = cell2.inputTextField.text;
    
    HHTextfieldcell *cell3 = (HHTextfieldcell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *commitPwdStr = cell3.inputTextField.text;
    
    NSString *isValid =  [self isValidWithaccountStr:accountStr verifyCodeStr:verifyCodeStr newPwdStr:newPwdStr commitPwdStr:commitPwdStr];
    
    if (!isValid) {
        btn.enabled = NO;
        [btn lh_setBackgroundColor:KA0LabelColor forState:UIControlStateNormal];
        [[[HHLoginAPI postResetPasswordWithuserno:accountStr smscode:verifyCodeStr newpwd:newPwdStr repeat_newpwd:commitPwdStr] netWorkClient] postRequestInView:nil finishedBlock:^(HHLoginAPI *api, NSError *error) {
            btn.enabled = YES;
            [btn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];

            if (!error) {
                
                if (api.code == 0) {
                    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
                    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                    [SVProgressHUD showSuccessWithStatus:@"重置密码成功，请重新登录～"];
                    [self.navigationController popVC];
                }else {
                    [SVProgressHUD showInfoWithStatus:api.msg];
                }
            }
        }];
        
    }else{
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];

        [SVProgressHUD showInfoWithStatus:isValid];
    }
    
    
}
@end
