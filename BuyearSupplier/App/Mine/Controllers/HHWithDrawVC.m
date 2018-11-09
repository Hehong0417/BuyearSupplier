//
//  HHWithDrawVC.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHWithDrawVC.h"
#import "HHRechargeRecordVC.h"
#import "HHAddBankCardVC.h"

@interface HHWithDrawVC ()<UITextFieldDelegate>
{
    HHMineModel   *mineModel;
}
@property (nonatomic, strong)   UITextField *sPdTextField;
@property (nonatomic, strong)   UITextField *moneyTextField;
@property (nonatomic, strong)   UILabel *bankTextLab;
@property (nonatomic, strong)   HXCommonPickView *pickView;
@property (nonatomic, strong)   NSMutableArray *title_arr;
@property (nonatomic, strong)   NSMutableArray *Ids_Arr;
@property (nonatomic, strong)   NSString *bank_Id;
@end

@implementation HHWithDrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"提现";

    self.title_arr = [NSMutableArray array];
    self.Ids_Arr = [NSMutableArray array];
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
    [saveBtn1 setTitle:@"提现记录" forState:UIControlStateNormal];
    [saveBtn1 setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [footView addSubview:saveBtn1];
    
    self.tableV.tableFooterView = footView;
    
    [self getDatas];

    self.pickView = [[HXCommonPickView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    WEAK_SELF();
    self.pickView.completeBlock = ^(NSString *result) {
        
        weakSelf.bankTextLab.textColor = kBlackColor;

        NSInteger index =  [weakSelf.title_arr indexOfObject:result];
        weakSelf.bank_Id =  [weakSelf.Ids_Arr objectAtIndex:index];
        weakSelf.bankTextLab.text = result;
    };
}
- (void)getDatas{
    
    [[[HHMineAPI GetUserDetail] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.code == 0) {
                
                mineModel = [HHMineModel mj_objectWithKeyValues:api.data];
                
                [self.tableV reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
               
            }else{
                [SVProgressHUD showInfoWithStatus:api.msg];
            }
        }
        
    }];
    
    [self GetBankList];
    
}
- (void)GetBankList{
    //获取我的银行卡列表
    [self.title_arr removeAllObjects];
    [self.Ids_Arr removeAllObjects];

    [[[HHMineAPI GetBankListWithpage:@1] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.code == 0) {
                
                NSArray *arr =  api.data[@"list"];
                if (arr.count>0) {
                [arr enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                    HHMineModel *model = [HHMineModel mj_objectWithKeyValues:dic];
                    NSString *subCradNo;
                    if (model.bank_no.length>=4) {
                        subCradNo  = [model.bank_no substringFromIndex:model.bank_no.length-4];
                    }else{
                        subCradNo = model.bank_no;
                    }
                    if ([model.is_default isEqualToString:@"1"]) {
                       self.bankTextLab.textColor = kBlackColor;
                       self.bankTextLab.text = [NSString stringWithFormat:@"%@(尾号 %@)",model.bank_name,subCradNo];
                       self.bank_Id = model.Id;
                    }
                    [self.title_arr addObject:[NSString stringWithFormat:@"%@(尾号 %@)",model.bank_name,subCradNo]];
                    [self.Ids_Arr addObject:model.Id];
                    *stop = NO;
                }];
                    
                }

            }else{
                [SVProgressHUD showInfoWithStatus:api.msg];
            }
        }
        
    }];
}
- (void)saveBtnAction:(UIButton *)btn{
    
    NSString *money = self.moneyTextField.text;
    NSString *password = self.sPdTextField.text;
    
    NSString  *validStr = [self isValidWithmoney:money bank_id:self.bank_Id password:password];
    if (!validStr) {
        [btn lh_setBackgroundColor:KA0LabelColor forState:UIControlStateNormal];
        btn.enabled = NO;
        
        [[[HHMineAPI postWithdrawalsWithmoney:money password:password bank_id:self.bank_Id] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            [btn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
            btn.enabled = YES;
            if (!error) {
                if (api.code == 0) {
                    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                    [SVProgressHUD showSuccessWithStatus:@"提现成功！"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        HHRechargeRecordVC *vc = [HHRechargeRecordVC new];
                        vc.titleStr = @"提现记录";
                        [self.navigationController pushVC:vc];
                    });

                }else{
                    
                    [self alertTipWithMessage:api.msg];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:error.localizedDescription];
            }
        }];

    }else{
        
        [SVProgressHUD showInfoWithStatus:validStr];
    }
    
}
- (void)alertTipWithMessage:(NSString *)message {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:action1];
    [self presentViewController:alertC animated:YES completion:nil];

}

- (NSString *)isValidWithmoney:(NSString *)money  bank_id:(NSString *)bank_id password:(NSString *)password {
    
    NSArray *m_arr = [money componentsSeparatedByString:@"."];
    
    if (money.length == 0) {
        return @"请填写提现金额！";
    }else if (m_arr.count == 2) {
        NSString *moneyStr =  m_arr[1];
        if (moneyStr.length>2) {
            return @"提现金额不能超过两位小数！";
        }
    }else if(![money lh_isValidateNumber]){
        return @"提现金额输入不正确！";
    } else if (bank_id.length == 0){
        return @"请选择提现银行！";
    }else if (password.length == 0){
        return @"请填写安全密码！";
    }else if (password.length == 0){
        return @"安全密码不能小于6位！";
    }
    return nil;
}

#pragma mark - textfieldDelegate限制手机号为11位

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSInteger length=11;
    if (textField == self.moneyTextField) {
        length = 11;
    }else  if (textField == self.sPdTextField) {
        length = 20;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > length && range.length!=1){
        textField.text = [toBeString substringToIndex:length];
        return NO;
    }
    
    return YES;
}
//提现记录
- (void)saveBtn1Action{
    
    HHRechargeRecordVC *vc = [HHRechargeRecordVC new];
    vc.titleStr = @"提现记录";
    [self.navigationController pushVC:vc];
}
- (NSArray *)groupTitles{
    
    return @[@[@"现金积分",@"用户账号",@"提现金额"],@[@"提现银行"],@[@"安全密码"]];
    
}
- (NSArray *)groupIcons {
    
    return @[@[@"",@"",@""],@[@""],@[@""]];

}
- (NSArray *)groupDetials{
    
    return @[@[@" ",@" ",@""],@[@""],@[@" "]];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITextField *inteager = [UITextField lh_textFieldWithFrame:CGRectMake(140, 0, ScreenW-140-50, 44) placeholder:@"" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
            inteager.text = mineModel.money_integral;
            inteager.enabled = NO;
            [cell.contentView addSubview:inteager];
        }
        if (indexPath.row == 1) {
            UITextField *inteager1 = [UITextField lh_textFieldWithFrame:CGRectMake(140, 0, ScreenW-140-50, 44) placeholder:@"" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
            inteager1.text = mineModel.userid;
            inteager1.enabled = NO;
            [cell.contentView addSubview:inteager1];
        }
        if (indexPath.row == 2) {
            self.moneyTextField = [UITextField lh_textFieldWithFrame:CGRectMake(140, 0, ScreenW-140-50, 44) placeholder:@"点击编辑提现金额" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
            self.moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
            self.moneyTextField.delegate = self;
            [cell.contentView addSubview:self.moneyTextField];
        }
        
    }else if (indexPath.section == 1) {
      //加个箭头图标
        
        self.bankTextLab = [UILabel lh_labelWithFrame:CGRectMake(140, 0, ScreenW-140-50, 44) text:@"点击选择提现银行" textColor:KPlaceHoldColor font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
        self.bankTextLab.numberOfLines = 2;
        if ([self.bankTextLab.text isEqualToString:@"点击选择提现银行"]) {
            self.bankTextLab.textColor = KPlaceHoldColor;
        }else{
            self.bankTextLab.textColor = kBlackColor;
        }
        [cell.contentView addSubview:self.bankTextLab];

    }else if (indexPath.section == 2) {
        //加个密码图标
        self.sPdTextField = [UITextField lh_textFieldWithFrame:CGRectMake(140, 0, ScreenW-140-50, 44) placeholder:@"点击编辑安全密码" font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
        self.sPdTextField.keyboardType = UIKeyboardTypeASCIICapable;
        self.sPdTextField.secureTextEntry = YES;
        UIButton *btn1 = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 44, 44) target:self action:nil image:[UIImage imageNamed:@"icon_sign_password_default"]];
        cell.accessoryView = btn1;
        [cell.contentView addSubview:self.sPdTextField];

    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        if (self.title_arr.count>0) {
            
            [self.pickView setStyle:HXCommonPickViewStyleDIY titleArr:self.title_arr];
            [self.pickView showPickViewAnimation:YES];
        }else{
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请您先到“账户中心”->“管理银行卡”->添加银行卡" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                HHAddBankCardVC *vc = [HHAddBankCardVC new];
                vc.useridStr = mineModel.userid;
                vc.is_edit= @"no";
                vc.is_withDraw = @"yes";
                vc.bank_block = ^{
                    [self GetBankList];
                };
                [self.navigationController pushVC:vc];
                
            }];
 
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                [alertC dismissViewControllerAnimated:YES completion:nil];
                
            }];
            [alertC addAction:action1];
            [alertC addAction:action2];
            [self.navigationController presentViewController:alertC animated:YES completion:nil];
            
        }

    }
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        UILabel *lab = [UILabel lh_labelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50) text:@"提款手续费为3%" textColor:KACLabelColor font:FONT(13) textAlignment:NSTextAlignmentCenter backgroundColor:KVCBackGroundColor];
        return lab;
        
    }else{
        
        return  nil;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
       
        return 0.01;
        
    }else if(section == 1){
        
        return 50;
        
    }else if(section == 2){
        
        return 10;
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}
@end
