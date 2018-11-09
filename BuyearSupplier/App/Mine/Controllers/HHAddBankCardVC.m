//
//  HHAddBankCardVC.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHAddBankCardVC.h"

@interface HHAddBankCardVC ()<UITextFieldDelegate,YYTextViewDelegate>
{
    UITextField *userName;
    UITextField *cardNo;
    YYTextView *cardName;
    UISwitch *swi;
}
@end

@implementation HHAddBankCardVC

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self.is_edit isEqualToString:@"yes"]) {
        self.title = @"编辑银行卡";
    }else{
        self.title = @"添加银行卡";
    }
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) backColor:KVCBackGroundColor];
    UIButton *saveBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 45, SCREEN_WIDTH-60, 45) target:self action:@selector(saveBtnAction:) image:nil];
    [saveBtn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
    [saveBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [footView addSubview:saveBtn];
    self.tableV.tableFooterView = footView;
    
    //抓取返回按钮
    UIButton *backBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [backBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    HJSettingItem *item0 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    item0.detailTitle = self.useridStr;
    
}
- (void)backBtnAction{
    [self.navigationController popVC];
}

- (void)saveBtnAction:(UIButton *)btn{
    
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    if (userName.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写用户真实姓名！"];
    }else if (cardName.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写开户行名称！"];
    }else if (cardNo.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请填写开户卡号！"];
    }else{
        NSString *is_default = @"0";
        if (swi.isOn) {
            is_default = @"1";
            [self addBankReqest:is_default btn:btn];
        }else{
            is_default = @"0";
            [self addBankReqest:is_default btn:btn];

        }
        
    }

  
}
- (void)addBankReqest:(NSString *)is_default btn:(UIButton *)btn{
    
    if ([self.is_edit isEqualToString:@"no"]) {
        //添加
        btn.enabled = NO;
        [btn lh_setBackgroundColor:KA0LabelColor forState:UIControlStateNormal];

        [[[HHMineAPI postAddBankWithbank_name:cardName.text bank_no:cardNo.text bank_id:nil is_default:is_default username:userName.text Id:nil remarks:nil] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            btn.enabled = YES;
            [btn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];

            if (!error) {
                if (api.code == 0) {
                    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                    [SVProgressHUD showSuccessWithStatus:@"添加成功！"];
                    if (self.is_withDraw.length>0) {
                        self.bank_block();
                    }
                    [self.navigationController popVC];
                    
                }else{
                    [SVProgressHUD showInfoWithStatus:api.msg];
                }
            }
            
        }];
    }else{
        //编辑
        btn.enabled = NO;
        [btn lh_setBackgroundColor:KA0LabelColor forState:UIControlStateNormal];

        [[[HHMineAPI postEditBankWithbank_name:cardName.text bank_no:cardNo.text is_default:is_default username:self.useridStr Id:self.Id remarks:nil] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            btn.enabled = YES;
            [btn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];

            if (!error) {
                
                if (api.code == 0) {
                    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                    [SVProgressHUD showSuccessWithStatus:@"编辑成功！"];
                    [self.navigationController popVC];
                    
                }else{
                    [SVProgressHUD showInfoWithStatus:api.msg];
                }
            }
            
        }];
        
        
    }
    
    
}
- (NSArray *)groupTitles{
    
    return @[@[@"账号",@"用户真实姓名",@"开户行名称",@"开户卡号",@"是否设为默认银行卡"]];
    
}
- (NSArray *)groupIcons {
    
    return @[@[@"",@"",@"",@"",@""]];

}
- (NSArray *)groupDetials{
    
    return @[@[@" ",@" ",@" ",@" ",@" "]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 1) {
        userName = [UITextField lh_textFieldWithFrame:CGRectMake(80, 0, ScreenW - 110, 44) placeholder:@"点击此处编辑用户真实姓名" font:FONT(14) textAlignment:NSTextAlignmentRight backgroundColor:kClearColor];
        userName.delegate = self;
        userName.text = self.user_Name;
        [cell.contentView addSubview:userName];
    }
    if (indexPath.row == 2) {
        cardName = [[YYTextView alloc] initWithFrame:CGRectMake(120, 0, ScreenW - 140, 80)];
        cardName.font = FONT(14);
        cardName.placeholderText = @"农业银行(工商银行、中国银行、建设银行)XX省XX市区(县)XX路支行";
        cardName.delegate = self;
        cardName.text = self.bank_name;
        [cell.contentView addSubview:cardName];
    }
    if (indexPath.row == 3) {
        cardNo = [UITextField lh_textFieldWithFrame:CGRectMake(80, 0, ScreenW - 110, 44) placeholder:@"点击此处编辑开户卡号" font:FONT(14) textAlignment:NSTextAlignmentRight backgroundColor:kClearColor];
        cardNo.text = self.bank_no;
        cardNo.delegate = self;
        cardNo.keyboardType = UIKeyboardTypeNumberPad;
        [cell.contentView addSubview:cardNo];
    }else if (indexPath.row == 4){
        swi = [[UISwitch alloc] init];
        cell.accessoryView =  swi;
        if ([self.is_default isEqualToString:@"1"]) {
            [swi setOn:YES];
        }
    }

    return cell;
}
#pragma mark - textfieldDelegate限制手机号为11位

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
   NSInteger length = 8;
   if (textField == cardNo){
        length = 21;
    }else if (textField == userName){
        length = 15;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > length && range.length!=1){
        textField.text = [toBeString substringToIndex:length];
        return NO;
    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (toBeString.length > 30 && range.length!=1){
        textView.text = [toBeString substringToIndex:30];
        return NO;
    }
    return YES;
    
}
@end
