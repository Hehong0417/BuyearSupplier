//
//  HHCashIntegralTranferVC.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHCashIntegralTranferVC.h"
#import "HHTextfieldcell.h"
#import "HHCashExchangeRecordVC.h"

@interface HHCashIntegralTranferVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, strong)   NSArray *title_arr;
@property (nonatomic, strong)   NSArray *placeHolder_arr;

@end

@implementation HHCashIntegralTranferVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"现金积分兑换";
    
    self.title_arr = @[@"积分余额",@"体验店编号",@"体验店店长姓名",@"安全密码",@"备注"];
    self.placeHolder_arr = @[@"点击编辑积分余额",@"点击编辑体验店编号",@"--",@"点击编辑安全密码",@"点击编辑备注"];
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
  
    UIView *headView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50) backColor:KVCBackGroundColor];
    UILabel *headLab = [UILabel lh_labelWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 50) text:[NSString stringWithFormat:@"用户名： %@   现金积分余额： %@",self.mineModel.userid,self.mineModel.money_integral?self.mineModel.money_integral:@"0"] textColor:kBlackColor font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:KVCBackGroundColor];
    [headView addSubview:headLab];
    NSString *contentStr = [NSString stringWithFormat:@"用户名： %@   现金积分余额： %@",self.mineModel.userid,self.mineModel.money_integral?self.mineModel.money_integral:@"0"];
    NSString *attrStr1 = [NSString stringWithFormat:@"%@",self.mineModel.userid];
    NSString *attrStr2 = [NSString stringWithFormat:@"%@",self.mineModel.money_integral?self.mineModel.money_integral:@"0"];
    headLab.attributedText =  [self lh_attriStrWithcontent:contentStr attrStr1:attrStr1 attrStr2:attrStr2 attrStr1Color:APP_purple_Color attrStr2Color:kRedColor contentColor:kBlackColor];
    
    self.tableView.tableHeaderView = headView;

    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180) backColor:KVCBackGroundColor];
    UIButton *saveBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 45, SCREEN_WIDTH-60, 45) target:self action:@selector(saveBtnAction:) image:nil];
    [saveBtn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
    [saveBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [saveBtn setTitle:@"提交" forState:UIControlStateNormal];
    [saveBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [footView addSubview:saveBtn];
    
    UIButton *saveBtn1 = [UIButton lh_buttonWithFrame:CGRectMake(30, CGRectGetMaxY(saveBtn.frame)+20, SCREEN_WIDTH-60, 45) target:self action:@selector(saveBtn1Action) image:nil];
    [saveBtn1 lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
    [saveBtn1 lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [saveBtn1 setTitle:@"现金积分兑换记录" forState:UIControlStateNormal];
    [saveBtn1 setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [footView addSubview:saveBtn1];
    
    self.tableView.tableFooterView = footView;
    
    
}
- (void)saveBtn1Action{
    
    HHCashExchangeRecordVC *vc = [HHCashExchangeRecordVC new];
    
    [self.navigationController pushVC:vc];
    
}
- (void)saveBtnAction:(UIButton *)btn{
    
    HHTextfieldcell *money_integralCell= (HHTextfieldcell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *money_integralStr = money_integralCell.inputTextField.text;
    
    HHTextfieldcell *shopidCell = (HHTextfieldcell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *shopidStr = shopidCell.inputTextField.text;
    
    HHTextfieldcell *security_pwdCell = (HHTextfieldcell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *security_pwdStr = security_pwdCell.inputTextField.text;
    
    HHTextfieldcell *remarkCell = (HHTextfieldcell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    NSString *remarkStr = remarkCell.inputTextField.text;
    
    NSString *validStr = [self isValidWithmoney_integralStr:money_integralStr shopidStr:shopidStr security_pwdStr:security_pwdStr];
    
    if (!validStr) {
        
        btn.enabled = NO;
        [[[HHMineAPI postChangePickingIntegralWithmoney_integral:money_integralStr shopid:shopidStr security_pwd:security_pwdStr remark:remarkStr] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            btn.enabled = YES;
            if (!error) {
                if (api.code == 0) {
                    
                    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
                    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                    [SVProgressHUD showSuccessWithStatus:@"兑换成功！"];
                    
                    HHCashExchangeRecordVC *vc = [HHCashExchangeRecordVC new];
                    [self.navigationController pushVC:vc];
                    
                }else{
                    [SVProgressHUD showInfoWithStatus:api.msg];
                }
            }
            
        }];
        
        
    }else{
        
        [SVProgressHUD showInfoWithStatus:validStr];
        
        }
    
}
- (NSString *)isValidWithmoney_integralStr:(NSString *)money_integralStr shopidStr:(NSString *)shopidStr  security_pwdStr:(NSString *)security_pwdStr {
    
    if (money_integralStr.length == 0) {
        return @"请填写积分余额！";
    }else  if (security_pwdStr.length == 0){
        return @"请填写安全密码！";
    }
    return nil;
}
- (NSMutableAttributedString *)lh_attriStrWithcontent:(NSString *)content attrStr1:(NSString *)attrStr1  attrStr2:(NSString *)attrStr2  attrStr1Color:(UIColor *)attrStr1Color attrStr2Color:(UIColor *)attrStr2Color  contentColor:(UIColor *)contentColor{
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:content];
    
    NSRange attrStr1Range = [content rangeOfString:attrStr1];
    NSRange attrStr2Range = [content rangeOfString:attrStr2];
    NSRange contentRange = [content rangeOfString:content];
    
    [attr addAttribute:NSFontAttributeName value:FONT(14) range:contentRange];
    [attr addAttribute:NSForegroundColorAttributeName value:contentColor range:contentRange];
    [attr addAttribute:NSForegroundColorAttributeName value:attrStr1Color range:attrStr1Range];
    [attr addAttribute:NSForegroundColorAttributeName value:attrStr2Color range:attrStr2Range];
    
    return attr;
}
#pragma mark --- UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
   
    if (textField.text.length>0) {
        //体验店编号
        [[[HHMineAPI GetUserByShopNoWithshopno:textField.text] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
            if (!error) {
                if (api.code == 0) {
                    HHMineModel *model = [HHMineModel mj_objectWithKeyValues:api.data];
                    HHTextfieldcell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                    cell.inputTextField.text = model.username;
                    
                }else if (api.code == 1){
                    
                    HHTextfieldcell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                    cell.inputTextField.text = api.msg;
                }
            }else{
                HHTextfieldcell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                cell.inputTextField.text = @"体验店名称获取失败！";
            }
        }];
    }else{
        HHTextfieldcell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell.inputTextField.text = @"--";
    }
}
#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHTextfieldcell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleLabel"];
    
    if (!cell) {
        cell = [[HHTextfieldcell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleLabel"];
    }
       cell.titleLabel.text = self.title_arr[indexPath.row];
       cell.inputTextField.placeholder = self.placeHolder_arr[indexPath.row];
    if (indexPath.row == 0) {
        cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        cell.inputTextField.enabled = YES;

    }else if (indexPath.row == 1) {
        cell.inputTextField.keyboardType = UIKeyboardTypeASCIICapable;
        cell.inputTextField.delegate = self;
        cell.inputTextField.enabled = YES;
    }else if (indexPath.row == 2) {
        cell.inputTextField.enabled = NO;
        cell.inputTextField.text = @"--";

    }else if (indexPath.row == 3) {
        //
        cell.inputTextField.enabled = YES;
        cell.inputTextField.keyboardType = UIKeyboardTypeASCIICapable;
        cell.inputTextField.secureTextEntry = YES;
        
    }else if (indexPath.row == 4) {
        cell.inputTextField.enabled = YES;
      
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}


@end
