//
//  HHIntegralTransferVC.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHIntegralTransferVC.h"
#import "HHTextfieldcell.h"
#import "HHRechargeRecordVC.h"

@interface HHIntegralTransferVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, strong)   NSArray *title_arr;
@property (nonatomic, strong)   NSArray *placeHoder_arr;
@property (nonatomic, strong)   HHMineModel *mineModel;

@end

@implementation HHIntegralTransferVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"积分转账";
    
    self.title_arr = @[@"现金积分",@"收款用户账号",@"收款人姓名",@"转账金额",@"说明"];
    self.placeHoder_arr = @[@"",@"点击此处编辑用户账号",@"点击编辑姓名",@"点击编辑转账金额",@"选填"];
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
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180) backColor:KVCBackGroundColor];
    UIButton *saveBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 40, SCREEN_WIDTH-60, 45) target:self action:@selector(saveBtnAction:) image:nil];
    [saveBtn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
    [saveBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [saveBtn setTitle:@"提交" forState:UIControlStateNormal];
    [saveBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [footView addSubview:saveBtn];
    
    UIButton *saveBtn1 = [UIButton lh_buttonWithFrame:CGRectMake(30,CGRectGetMaxY(saveBtn.frame)+20, SCREEN_WIDTH-60, 45) target:self action:@selector(saveBtn1Action) image:nil];
    [saveBtn1 lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
    [saveBtn1 lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [saveBtn1 setTitle:@"转账记录" forState:UIControlStateNormal];
    [saveBtn1 setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [footView addSubview:saveBtn1];
    self.tableView.tableFooterView = footView;
    [self getDatas];
}
- (void)getDatas{
    
    [[[HHMineAPI GetUserDetail] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.code == 0) {
                
                self.mineModel = [HHMineModel mj_objectWithKeyValues:api.data];
                [self.tableView reloadRow:0 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        
    }];
    
}
- (void)saveBtnAction:(UIButton *)btn{
    
    HHTextfieldcell *useridcell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *userid  = useridcell.inputTextField.text;
    HHTextfieldcell *namecell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *username  = namecell.inputTextField.text;
    HHTextfieldcell *moneycell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *money  = moneycell.inputTextField.text;;
    HHTextfieldcell *remarkcell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    NSString *remark  = remarkcell.inputTextField.text;
    HHTextfieldcell *passwordcell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSString *password  = passwordcell.inputTextField.text;

    NSString *validStr = [self validWithmoney:money userid:userid username:username password:password remark:remark];
    if (!validStr) {
        [btn lh_setBackgroundColor:KA0LabelColor forState:UIControlStateNormal];
        btn.enabled = NO;
        [[[HHMineAPI postTransferWithmoney:money userid:userid username:username password:password remark:remark] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            [btn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
            btn.enabled = YES;
            
            if (!error) {
                if (api.code == 0) {
                    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
                    [SVProgressHUD showSuccessWithStatus:@"转账成功"];
                    
                    HHRechargeRecordVC *vc = [HHRechargeRecordVC new];
                    vc.titleStr = @"转账记录";
                    [self.navigationController pushVC:vc];
                }else{
                    
                    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
                    [SVProgressHUD showInfoWithStatus:api.msg];
                }
            }

        }];

    }else{

        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        [SVProgressHUD showInfoWithStatus:validStr];
    }
    
}
- (NSString *)validWithmoney:(NSString *)money userid:(NSString *)userid username:(NSString *)username password:(NSString *)password remark:(NSString *)remark{
    
    NSArray *m_arr = [money componentsSeparatedByString:@"."];
    
    if (money.length == 0) {
        return @"请填写转账金额！";
    }else if (userid.length == 0) {
        return @"请填写收款用户账号！";
    }else if (username.length == 0) {
        return @"请填写收款人姓名！";
    }else if (m_arr.count == 2) {
        NSString *moneyStr =  m_arr[1];
        if (moneyStr.length>2) {
            return @"提现金额不能超过两位小数！";
        }
    }else if(![money lh_isValidateNumber]){
        return @"转账金额输入不正确！";
    }else if (password.length == 0) {
        return @"请填写安全密码！";
    }
    return nil;
}
//转账记录
- (void)saveBtn1Action{
    
    HHRechargeRecordVC *vc = [HHRechargeRecordVC new];
    vc.titleStr = @"转账记录";
    [self.navigationController pushVC:vc];
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(textField.tag == 100){
        
    return NO;
        
    }else{
        return YES;
    }
}
#pragma mark - textfieldDelegate限制手机号为11位

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSInteger length=11;
    if (textField.tag == 101) {
        length = 8;
    }else  if (textField.tag == 102) {
        length = 15;
    }else  if (textField.tag == 103) {
        length = 11;
    }else  if (textField.tag == 104) {
        length = 100;
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
#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHTextfieldcell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleLabel"];
    
    if (!cell) {
        cell = [[HHTextfieldcell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"titleLabel"];
    }
    cell.inputTextField.delegate = self;
    if (indexPath.section == 0) {
        cell.titleLabel.text = self.title_arr[indexPath.row];
        cell.inputTextField.tag = indexPath.row+100;
        cell.inputTextField.placeholder = self.placeHoder_arr[indexPath.row];
        if (indexPath.row == 0) {
            cell.inputTextField.text = self.mineModel.money_integral?self.mineModel.money_integral:@"0";
        }
        if (indexPath.row == 1) {
            cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (indexPath.row == 3) {
            cell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
        }

    }else{
        cell.inputTextField.tag = 111;
        cell.titleLabel.text = @"安全密码";
        cell.inputTextField.secureTextEntry = YES;
        cell.inputTextField.placeholder = @"点击编辑安全密码";
        UIButton *btn1 = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 40, 50) target:self action:@selector(selectTime) image:[UIImage imageNamed:@"icon_sign_password_default"]];
        cell.inputTextField.rightView = btn1;
        cell.inputTextField.rightViewMode = UITextFieldViewModeAlways;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)selectTime{
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
     return 2;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 5;
        
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
