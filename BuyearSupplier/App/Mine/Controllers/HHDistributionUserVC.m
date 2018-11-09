//
//  HHDistributionUserVC.m
//  Store
//
//  Created by User on 2018/1/6.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHDistributionUserVC.h"
#import "HHTextfieldcell.h"

@interface HHDistributionUserVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *leftTitleArr;
@property(nonatomic,strong)NSArray *placeHolderArr;
@end

@implementation HHDistributionUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
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
    [saveBtn setTitle:@"提  交" forState:UIControlStateNormal];
    [saveBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [footView addSubview:saveBtn];
    self.tableView.tableFooterView = footView;
    
    if (self.distrb_type == HHdistribe_type_user) {
        self.title = @"分配用户";
        self.leftTitleArr = @[@"用户账号",@"配额个数",@"备注"];
        self.placeHolderArr = @[@"点击编辑用户账号",@"点击编辑配额个数",@"点击编辑备注内容"];
    }else{
        self.title = @"分配签约权";
        self.leftTitleArr = @[@"用户账号",@"用户姓名",@"签约权个数",@"备注"];
        self.placeHolderArr = @[@"点击编辑用户账号",@"点击编辑用户姓名",@"点击签约权个数",@"点击编辑备注内容"];
        
    }
    
}
- (void)saveBtnAction:(UIButton *)btn{
    
    HHTextfieldcell *useridCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *useridStr = useridCell.inputTextField.text;
    NSString *countStr = nil;
    NSString *usernameStr = nil;
    NSString *remarkStr = nil;
    if (self.distrb_type == HHdistribe_type_user) {
        //        配额个数
        HHTextfieldcell *countCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        countStr = countCell.inputTextField.text;
    }else{
        //        用户姓名
        HHTextfieldcell *countCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        usernameStr = countCell.inputTextField.text;
    }
    if (self.distrb_type == HHdistribe_type_user) {
        //       备注
        HHTextfieldcell *remarkCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        remarkStr = remarkCell.inputTextField.text;
    }else{
        //        签约权个数
        HHTextfieldcell *remarkCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        countStr = remarkCell.inputTextField.text;
    }
    
    if (self.distrb_type == HHdistribe_type_sign) {
        //       备注
        HHTextfieldcell *remarkCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        remarkStr = remarkCell.inputTextField.text;
    }
    
    NSString *validStr = [self isValidWithuseridStr:useridStr countStr:countStr remarkStr:remarkStr username:usernameStr];
    
    if (!validStr) {
        btn.enabled = NO;
        [btn lh_setBackgroundColor:KA0LabelColor forState:UIControlStateNormal];
        if (self.distrb_type == HHdistribe_type_user) {
            //分配用户
            [[[HHMineAPI postAddBorrowLimitWithshopid:self.shopid userid:useridStr count:countStr remark:remarkStr] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
                btn.enabled = YES;
                [btn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
                if (!error) {
                    if (api.code == 0) {
                        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                        [SVProgressHUD showSuccessWithStatus:@"分配成功！"];
                        [self.navigationController popVC];
                    }else{
                        [SVProgressHUD showInfoWithStatus:api.msg];
                    }
                }
            }];
        }else{
            //分配签约权
            [[[HHMineAPI postAssignQuotaWithuserid:useridStr value:countStr remark:remarkStr username:usernameStr] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
                btn.enabled = YES;
                [btn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
                if (!error) {
                    if (api.code == 0) {
                        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                        [SVProgressHUD showSuccessWithStatus:@"分配成功！"];
                        [self.navigationController popVC];
                    }else{
                        [SVProgressHUD showInfoWithStatus:api.msg];
                    }
                }
            }];
        }
    }else{
        [SVProgressHUD showInfoWithStatus:validStr];
    }
    
}
- (NSString *)isValidWithuseridStr:(NSString *)useridStr countStr:(NSString *)countStr  remarkStr:(NSString *)remarkStr username:(NSString *)username{
    
    if (useridStr.length == 0) {
        return @"请填写用户账号！";
    }else if (countStr.length == 0){
        if (self.distrb_type == HHdistribe_type_user) {
            return @"请填写配额数！";
        }else{
            return @"请填写签约权数！";
        }
    }else if (username.length == 0){
        if (self.distrb_type == HHdistribe_type_user) {
            return nil;
        }else{
            return @"请填写姓名！";
        }
    }
    return nil;
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
    //    cell.inputTextField.secureTextEntry = YES;
    if (indexPath.row == 0) {
        cell.inputTextField.keyboardType = UIKeyboardTypeASCIICapable;
    }

    if (self.distrb_type == HHdistribe_type_user) {
        if (indexPath.row == 1) {
            cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
            cell.inputTextField.delegate = self;
        }
        
    }else{
        if (indexPath.row == 2) {
            cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
            cell.inputTextField.delegate = self;
        }
    }
    cell.titleLabel.text = self.leftTitleArr[indexPath.row];
    cell.titleLabel.textColor = kBlackColor;
    cell.inputTextField.placeholder = self.placeHolderArr[indexPath.row];
    
    return cell;
    
}
#pragma mark - textfieldDelegate限制手机号为11位

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSInteger length = 9;
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > length && range.length!=1){
        textField.text = [toBeString substringToIndex:length];
        return NO;
    }
    return YES;
}
@end
