//
//  HXForgetPwdVC.m
//  HXBudsProject
//
//  Created by n on 2017/5/11.
//  Copyright © 2017年 n. All rights reserved.
//

#import "HHEditPwdVC.h"
#import "HHTextfieldcell.h"
//#import "HXEditPwdAPI.h"

@interface HHEditPwdVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *leftTitleArr;
@property(nonatomic,strong)NSArray *placeHolderArr;

@end

@implementation HHEditPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改密码";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH,SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) backColor:KVCBackGroundColor];
    
    UIButton *saveBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 45, SCREEN_WIDTH-60, 45) target:self action:@selector(saveBtnAction:) image:nil];
    [saveBtn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
    [saveBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [saveBtn setTitle:@"提交" forState:UIControlStateNormal];
    [saveBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [footView addSubview:saveBtn];
    self.tableView.tableFooterView = footView;
    
    self.leftTitleArr = @[@"当前登录密码",@"新登录密码",@"确认新登录密码"];

    self.placeHolderArr = @[@"点击编辑登录密码",@"点击编辑新登录密码",@"再次编辑新登录密码"];
}
- (void)saveBtnAction:(UIButton *)btn{
    
    HHTextfieldcell *cell0_0 = (HHTextfieldcell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *login_pdStr = cell0_0.inputTextField.text;
    
    HHTextfieldcell *cell0_1 = (HHTextfieldcell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *new_login_pdStr = cell0_1.inputTextField.text;
    
    HHTextfieldcell *cell0_2 = (HHTextfieldcell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSString *commit_new_login_pdStr = cell0_2.inputTextField.text;
    
    NSString *vaildStr =  [self isValidWithlogin_pdStr:login_pdStr new_login_pdStr:new_login_pdStr commit_new_login_pdStr:commit_new_login_pdStr];
    
    if (!vaildStr) {
            btn.enabled = NO;
            [btn lh_setBackgroundColor:KA0LabelColor forState:UIControlStateNormal];

            [[[HHMineAPI  ModifyLoginPasswordWithold_pwd:login_pdStr new_pwd:new_login_pdStr repeat_new_pwd:commit_new_login_pdStr] netWorkClient] postRequestInView:nil finishedBlock:^(HHLoginAPI *api, NSError *error) {
                btn.enabled = YES;
                [btn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];

                if(!error){
                    if (api.code == 0) {
                        
                        [self logoutSuccess];
                        
                    }else{
                        
                        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
                        [SVProgressHUD showInfoWithStatus:api.msg];
                    }
                }
                
            }];
        
    }else{
        
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        [SVProgressHUD showInfoWithStatus:vaildStr];
        
    }
    
    
}

- (void)logoutSuccess{
    
    HJUser *user = [HJUser sharedUser];
    user.token = @"";
    [user write];
    [self.navigationController popToRootVC];
    
}
- (NSString *)isValidWithlogin_pdStr:(NSString *)login_pdStr new_login_pdStr:(NSString *)new_login_pdStr  commit_new_login_pdStr:(NSString *)commit_new_login_pdStr {
    
    if (login_pdStr.length == 0) {
        return @"请填写当前登录密码！";
    }else if (new_login_pdStr.length == 0){
        return @"请填写新登录密码！";
    } else if (commit_new_login_pdStr.length == 0){
        return @"请确认新登录密码！";
    }else if (![commit_new_login_pdStr isEqualToString:new_login_pdStr]){
        return @"两次输入的密码不一致！";
    }
    return nil;
}
#pragma mark - textfieldDelegate限制手机号为20位

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > 20 && range.length!=1){
        textField.text = [toBeString substringToIndex:20];
        return NO;
    }
    return YES;
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
    cell.titleLabel.textColor = KTitleLabelColor;
    cell.titleLabel.frame = CGRectMake(WidthScaleSize_W(18), 0, WidthScaleSize_W(150), WidthScaleSize_H(50));
    cell.inputTextField.frame =  CGRectMake(WidthScaleSize_W(150), 0, ScreenW-WidthScaleSize_W(150)-10, WidthScaleSize_H(50));
    cell.inputTextField.keyboardType = UIKeyboardTypeASCIICapable;
    cell.inputTextField.secureTextEntry = YES;
    cell.inputTextField.placeholder = self.placeHolderArr[indexPath.row];
    cell.inputTextField.delegate = self;
    return cell;
    
}
- (NSString *)isValidWitholdPwdStr:(NSString *)oldPwdStr newPwdStr:(NSString *)newPwdStr  commitPwdStr:(NSString *)commitPwdStr{
    
    if (oldPwdStr.length == 0) {
        return @"请输入旧密码！";
    }else if (newPwdStr.length == 0){
        return @"请输入新密码！";
    }else if (commitPwdStr.length == 0){
        return @"请再次输入新密码！";
    }else if (![commitPwdStr isEqualToString:newPwdStr]){
        return @"两次输入的密码不一致！";
    }
    return nil;
}

@end
