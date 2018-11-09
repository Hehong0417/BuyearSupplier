//
//  HHAccountRechargeVC.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHAccountRechargeVC.h"
#import "HHTextfieldcell.h"
#import "HHRechargeRecordVC.h"

@interface HHAccountRechargeVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    HXCommonPickView *pickView;
    UIButton *saveBtn;
}
@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, strong)   NSArray *title_arr;
@property (nonatomic, strong)   NSArray *placeHolderArr;

@end

@implementation HHAccountRechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"账户充值";
    
    self.title_arr = @[@"收款银行卡号",@"充值金额",@"充值时间",@"说明"];
    
    self.placeHolderArr = @[@"百业惠账号",@"点击编辑充值金额",@"请选择充值时间",@""];

    
    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT - 64;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:self.tableView];
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180) backColor:kClearColor];
    saveBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 40, SCREEN_WIDTH-60, 45) target:self action:@selector(saveBtnAction:) image:nil];
    [saveBtn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
    [saveBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [saveBtn setTitle:@"提交" forState:UIControlStateNormal];
    [saveBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [footView addSubview:saveBtn];
    
    UIButton *saveBtn1 = [UIButton lh_buttonWithFrame:CGRectMake(30,CGRectGetMaxY(saveBtn.frame)+20, SCREEN_WIDTH-60, 45) target:self action:@selector(saveBtn2Action) image:nil];
    [saveBtn1 lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
    [saveBtn1 lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [saveBtn1 setTitle:@"充值记录" forState:UIControlStateNormal];
    [saveBtn1 setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [footView addSubview:saveBtn1];
    self.tableView.tableFooterView = footView;
    
    //充值时间
    pickView = [[HXCommonPickView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];

    WEAK_SELF();
    pickView.completeBlock2 = ^(NSDate *date) {
        HHTextfieldcell *cell  = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell.inputTextField.text = [date lh_string_yyyyMMdd];
    };
    
}
- (void)saveBtnAction:(UIButton *)btn{
    
    HHTextfieldcell *moneyCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    HHTextfieldcell *timeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    HHTextfieldcell *remarkCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    HHTextfieldcell *passwordCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    NSString *validStr = [self validWithmenoy:moneyCell.inputTextField.text time:timeCell.inputTextField.text remark:remarkCell.inputTextField.text password:passwordCell.inputTextField.text];
    if (!validStr) {
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        
        [btn lh_setBackgroundColor:KA0LabelColor forState:UIControlStateNormal];
        btn.enabled = NO;
        
         NSString *pd_md5Str = passwordCell.inputTextField.text;
        
         [[[HHMineAPI postRechargeWithmenoy:moneyCell.inputTextField.text remark:remarkCell.inputTextField.text password:pd_md5Str] netWorkClient] postRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
             
         [btn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
         btn.enabled = YES;

            if (!error) {
                if (api.code == 0) {
                    
                    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
                    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                    [SVProgressHUD showSuccessWithStatus:@"提交成功！"];
                    
                    HHRechargeRecordVC *vc = [HHRechargeRecordVC new];
                    vc.titleStr = @"充值记录";
                    [self.navigationController pushVC:vc];
                    
                }else{
                    
                    [SVProgressHUD showInfoWithStatus:api.msg];

                }
            }else{
                [SVProgressHUD showInfoWithStatus:api.msg];
            }
            
        }];

        
    }else{
        
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        [SVProgressHUD showInfoWithStatus:validStr];
    }
    
}
#pragma mark - textfieldDelegate限制手机号为11位

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSInteger length=11;
    if (textField.tag == 101) {
        length = 10;
    }else  if (textField.tag == 102) {
        length = 100;
    }else  if (textField.tag == 103) {
        length = 20;
    }else  if (textField.tag == 111) {
        length = 20;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > length && range.length!=1){
        textField.text = [toBeString substringToIndex:length];
        return NO;
    }
    
    return YES;
}
- (NSString *)validWithmenoy:(NSString *)menoy time:(NSString *)time remark:(NSString *)remark password:(NSString *)password {
    
    if (menoy.length == 0) {
        return @"请填写充值金额！";
    }else  if (time.length == 0) {
        return @"请选择充值时间！";
    }else  if (password.length == 0) {
        return @"请填写安全密码！";
    }else  if (password.length <6) {
        return @"安全密码不能小于6位！";
    }
    return nil;
    
}
//充值记录
- (void)saveBtn2Action{
    
    HHRechargeRecordVC *vc = [HHRechargeRecordVC new];
    vc.titleStr = @"充值记录";
    [self.navigationController pushVC:vc];
}

#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHTextfieldcell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleLabel"];
    
    if (!cell) {
        cell = [[HHTextfieldcell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleLabel"];
    }
    cell.inputTextField.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.titleLabel.text = self.title_arr[indexPath.row];
        cell.inputTextField.placeholder = self.placeHolderArr[indexPath.row];
        cell.inputTextField.tag = 100+indexPath.row;
        if (indexPath.row == 0) {
            cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
            cell.inputTextField.text = @"百业惠账号";
        }
        if (indexPath.row == 1) {
            cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;

        }
        if(indexPath.row == 2){
            UIButton *btn = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 44, 44) target:self action:@selector(selectTime) image:[UIImage imageNamed:@"icon_times_default"]];
            cell.inputTextField.rightView = btn;
            cell.inputTextField.rightViewMode = UITextFieldViewModeAlways;
            cell.inputTextField.userInteractionEnabled = NO;
            cell.inputTextField.delegate = self;
        }
        if(indexPath.row == 3){
            cell.inputTextField.text = @"购物消费";
        }
    }else{
        cell.titleLabel.text = @"安全密码";
        cell.inputTextField.secureTextEntry = YES;
        cell.inputTextField.placeholder = @"点击编辑安全密码";
        UIButton *btn1 = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 44, 44) target:self action:@selector(passWordAction) image:[UIImage imageNamed:@"icon_sign_password_default"]];
        cell.inputTextField.rightView = btn1;
        cell.inputTextField.rightViewMode = UITextFieldViewModeAlways;
        cell.inputTextField.tag = 111;

    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0&&indexPath.row == 2) {
        
        [self selectTime];
    }
    
}
- (void)passWordAction{
    
    
}
//充值时间
- (void)selectTime{
    
    [pickView setStyle:HXCommonPickViewStyleDate minimumDate:nil maximumDate:[NSDate date] titleArr:nil];
    [pickView showPickViewAnimation:YES];

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 100||textField.tag == 102) {
        return NO;
    }else{
        return YES;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 4;
        
    }else {
        
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}


@end
