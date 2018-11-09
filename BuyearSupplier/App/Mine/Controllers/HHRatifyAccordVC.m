//
//  HHRatifyAccordVC.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHRatifyAccordVC.h"
#import "HHTextfieldcell.h"
#import "HHAdvancedCooperationProtocolVC.h"
#import "HHBorrow_integralProtocolVC.h"
#import "HHContractManagerVC.h"
#import "HHTeamListVC.h"

@interface HHRatifyAccordVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIButton *borrow_integral_btn;//借积分协议
    UIButton *protocolBtn;//高级合作协议
    UISwitch *swi;
    UILabel *headLab;
    NSNumber *hidden;
}
@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, strong)   NSArray *title_arr;
@property (nonatomic, strong)   NSArray *placeHolder_arr;
//服务经理名称
@property (nonatomic, strong)   NSString *serviceManager;
//体验店名称
@property (nonatomic, strong)   NSString *shop_name;

@end

@implementation HHRatifyAccordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //高级合作微商
    self.title = @"签署协议";
    
    self.title_arr = @[@"借积分",@"协议时间",@"服务经理",@"服务经理姓名",@"体验店编号",@"体验店店长姓名"];
    self.placeHolder_arr = @[@"",@"",@"点击此处输入服务经理",@"",@"点击此处输入体验店编号",@""];

    
    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT - 64;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,50, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:self.tableView];
    
    
    UIView *headView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50) backColor:KVCBackGroundColor];
    UIImageView *icon = [UIImageView lh_imageViewWithFrame:CGRectMake(0, 0, 30, 50) image:[UIImage imageNamed:@"icon_integral_default"]];
    icon.contentMode = UIViewContentModeCenter;
    [headView addSubview:icon];

    headLab = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(icon.frame), 0, SCREEN_WIDTH - 20, 50) text:@"积分余额：0" textColor:APP_purple_Color font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:KVCBackGroundColor];
   
    [headView addSubview:headLab];
    self.tableView.tableHeaderView = headView;
    
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150) backColor:KVCBackGroundColor];
    
    WEAK_SELF();
    //高级合作微商协议
    protocolBtn = [UIButton lh_buttonWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 20) target:self action:@selector(protocolBtnAction:) image:[UIImage imageNamed:@"icon_checkbox_default"]];
    [protocolBtn setContentEdgeInsets:UIEdgeInsetsMake(0,0, 0, 0)];
    [protocolBtn setImage:[UIImage imageNamed:@"icon_checkbox_selected"] forState:UIControlStateSelected];
    NSMutableAttributedString *attrStr = [NSString lh_attriStrWithprotocolStr:@"《高级合作微商协议》" content:@"  同意注册协议《高级合作微商协议》" protocolFont:FONT(12) contentFont:FONT(12) protocolStrColor:APP_purple_Color contentColor:KTitleLabelColor];
    [protocolBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
    [footView addSubview:protocolBtn];
    protocolBtn.titleLabel.userInteractionEnabled = YES;
    [protocolBtn.titleLabel setTapActionWithBlock:^{
        HHAdvancedCooperationProtocolVC *vc = [[HHAdvancedCooperationProtocolVC alloc] initWithNibName:@"HHAdvancedCooperationProtocolVC" bundle:nil];

        [weakSelf.navigationController pushVC:vc];
        
    }];
//    protocolBtn.hidden = YES;

    //借积分协议
    borrow_integral_btn = [UIButton lh_buttonWithFrame:CGRectMake(0, CGRectGetMaxY(protocolBtn.frame), SCREEN_WIDTH, 20) target:self action:@selector(protocolBtnAction:) image:[UIImage imageNamed:@"icon_checkbox_default"]];
    [borrow_integral_btn setContentEdgeInsets:UIEdgeInsetsMake(0,-WidthScaleSize_H(36), 0, 0)];
    [borrow_integral_btn setImage:[UIImage imageNamed:@"icon_checkbox_selected"] forState:UIControlStateSelected];
    NSMutableAttributedString *borrow_attrStr = [NSString lh_attriStrWithprotocolStr:@"《借积分协议》" content:@"  同意注册协议《借积分协议》" protocolFont:FONT(12) contentFont:FONT(12) protocolStrColor:APP_purple_Color contentColor:KTitleLabelColor];
    [borrow_integral_btn setAttributedTitle:borrow_attrStr forState:UIControlStateNormal];
    [footView addSubview:borrow_integral_btn];
    
    borrow_integral_btn.titleLabel.userInteractionEnabled = YES;
    [borrow_integral_btn.titleLabel setTapActionWithBlock:^{
        HHBorrow_integralProtocolVC *vc = [[HHBorrow_integralProtocolVC alloc] initWithNibName:@"HHBorrow_integralProtocolVC" bundle:nil];
        [weakSelf.navigationController pushVC:vc];
        
    }];
    borrow_integral_btn.hidden = YES;
    
//    [[[HHLoginAPI GetIOSProtocolIsOpen] netWorkClient] getRequestInView:nil finishedBlock:^(HHLoginAPI *api, NSError *error) {
//        if (!error) {
//            if (api.code == 0) {
//                hidden = api.data;
//                if ([hidden isEqualToNumber:@0]) {
//                    //隐藏
//                    protocolBtn.hidden = YES;
//                }else{
//                    protocolBtn.hidden = NO;
//                }
//            }
//        }
//    }];
    

    
    UIButton *saveBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, CGRectGetMaxY(borrow_integral_btn.frame)+20, SCREEN_WIDTH-60, 45) target:self action:@selector(saveBtnAction:) image:nil];
    [saveBtn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
    [saveBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [saveBtn setTitle:@"提  交" forState:UIControlStateNormal];
    [saveBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [footView addSubview:saveBtn];
    self.tableView.tableFooterView = footView;
    //获取个人信息
    [self getDatas];
}
//获取数据
- (void)getDatas{
    
    [[[HHMineAPI GetUserDetail] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        
        if (!error) {
            if (api.code == 0) {
                
                HHMineModel *mineModel = [HHMineModel mj_objectWithKeyValues:api.data];
                NSMutableAttributedString *attriStr = [NSString lh_attriStrWithprotocolStr:mineModel.s_integral content:[NSString stringWithFormat:@"积分余额：%@",mineModel.s_integral] protocolStrColor:kRedColor contentColor:APP_purple_Color];
                headLab.attributedText = attriStr;
                
                if (mineModel.sign_shopname.length>0&&mineModel.sign_shopid.length>0) {
                    self.shop_name= mineModel.sign_shopname;
                    HHTextfieldcell *cell0 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                    cell0.inputTextField.text = mineModel.sign_shopid;
                    HHTextfieldcell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
                    cell1.inputTextField.text = mineModel.sign_shopname;
                    cell0.inputTextField.enabled =NO;
                    cell1.inputTextField.enabled =NO;
                }
                
            }
            
        }
    }];
    
    
    
}
- (void)protocolBtnAction:(UIButton *)btn{
    
    btn.selected = !btn.selected;

}
- (void)saveBtnAction:(UIButton *)btn{
    
    HHTextfieldcell *timeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    HHTextfieldcell *parentIdCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    HHTextfieldcell *shopsIdCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    
    NSString *validStr;
    NSString *isBorrowIntegral = @"0";
    if (swi.isOn) {
        
        isBorrowIntegral = @"1";
        validStr  = [self validWithtime:timeCell.inputTextField.text parentId:parentIdCell.inputTextField.text shopsId:shopsIdCell.inputTextField.text isBorrowIntegral:isBorrowIntegral];
    }else{
        
        isBorrowIntegral = @"0";
        validStr  = [self validWithtime:timeCell.inputTextField.text parentId:parentIdCell.inputTextField.text shopsId:shopsIdCell.inputTextField.text isBorrowIntegral:isBorrowIntegral];
        
    }
    
    if (!validStr) {
        
        NSString *message = [NSString stringWithFormat:@"\n%@\n\n协议时间:%@\n\n服务经理:%@,%@\n\n体验店编号:%@,%@",swi.isOn?@"现在借积分":@"现在不借积分",timeCell.inputTextField.text,parentIdCell.inputTextField.text,self.serviceManager,shopsIdCell.inputTextField.text.length?shopsIdCell.inputTextField.text:@"未填写",shopsIdCell.inputTextField.text.length?self.shop_name:@"未填写"];
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"确认信息" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [btn lh_setBackgroundColor:KA0LabelColor forState:UIControlStateNormal];
            btn.enabled = NO;
            
            [[ [HHMineAPI postSignWithtype:@"1" parentId:parentIdCell.inputTextField.text isBorrowIntegral:isBorrowIntegral shopsId:shopsIdCell.inputTextField.text] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
                [btn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
                btn.enabled = YES;
                
                if (!error) {
                    if (api.code == 0) {
                        
                        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
                        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                        [SVProgressHUD showSuccessWithStatus:@"协议签署成功！"];
                        
                        HHMineModel *model = [HHMineModel mj_objectWithKeyValues:api.data];
                        HHTeamListVC *vc = [HHTeamListVC new];

                        if (model.signid.length>0) {
                            [self.navigationController pushVC:vc];
                        }else{
                            [self.navigationController popVC];
                        }
                    }else{
                        [self alertTipMessageWithMsg:api.msg];
                    }
                }
                
            }];
            
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertC addAction:action1];
        [alertC addAction:action2];
        [self presentViewController:alertC animated:YES completion:nil];
        
    }else{
        
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        [SVProgressHUD showInfoWithStatus:validStr];
    }
    
}
- (void)alertTipMessageWithMsg:(NSString *)Msg{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:Msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    
    [alertC addAction:action1];
    [self presentViewController:alertC animated:YES completion:nil];
    
}
- (NSString *)validWithtime:(NSString *)time parentId:(NSString *)parentId shopsId:(NSString *)shopsId isBorrowIntegral:(NSString *)isBorrowIntegral{
    
    if (parentId.length == 0) {
        return @"请填写服务经理！";
    }else if ([isBorrowIntegral isEqualToString:@"1"]&&(shopsId.length == 0)) {
       return @"请填写体验店编号！";
    }else if (swi.isOn == YES&&borrow_integral_btn.selected == NO&&borrow_integral_btn.hidden == NO){
        return @"请您先勾选借积分微商协议！";
    }else if (protocolBtn.selected == NO&&protocolBtn.hidden == NO){
        return @"请您先勾选高级合作微商协议！";
    }
    return nil;
}
#pragma mark --- UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.tag == 1002) {
        //服务经理
        if (textField.text.length>0) {
            
        [[[HHMineAPI GetUserBySignNoWithsignno:textField.text] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
            if (!error) {
                if (api.code == 0) {
                    HHMineModel *model = [HHMineModel mj_objectWithKeyValues:api.data];
                    self.serviceManager = model.username;
                    HHTextfieldcell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                    cell.inputTextField.text = model.username;
                }else if (api.code == 1){
                    self.serviceManager = @"服务经理不存在";
                    HHTextfieldcell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                    cell.inputTextField.text = self.serviceManager;
                }
            }else{
                self.serviceManager = @"服务经理名称获取失败！";
            }
        }];
        }else{
            HHTextfieldcell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            cell.inputTextField.text = @"--";
        }
    }else if (textField.tag == 1004){
        //体验店编号
        if (textField.text.length>0) {
            
        [[[HHMineAPI GetUserByShopNoWithshopno:textField.text] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
            if (!error) {
                if (api.code == 0) {
                    
                    HHMineModel *model = [HHMineModel mj_objectWithKeyValues:api.data];
                    self.shop_name= model.username;
                    HHTextfieldcell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
                    cell.inputTextField.text = model.username;
                }else if (api.code == 1){
                    
                    self.shop_name = api.msg;
                    HHTextfieldcell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
                    cell.inputTextField.text = self.shop_name;
                }
            }else{
                self.shop_name = @"体验店名称获取失败！";
            }
        }];
        } else{
            HHTextfieldcell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
            cell.inputTextField.text = @"--";
            }
    }
    
}
#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHTextfieldcell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleLabel"];
    
    if (!cell) {
        cell = [[HHTextfieldcell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleLabel"];
    }
    if (indexPath.section == 0) {
        cell.titleLabel.text = self.title_arr[indexPath.row];
        if (indexPath.row == 0) {
            swi = [UISwitch new];
            [swi addTarget:self action:@selector(swiAction:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = swi;
        }else if(indexPath.row == 1) {
            cell.inputTextField.enabled = NO;
            cell.inputTextField.textAlignment = NSTextAlignmentRight;
            cell.inputTextField.text = [[NSDate date] lh_string_yyyyMMdd];
        }else if(indexPath.row ==3){
            cell.inputTextField.text =  @"--";
            cell.inputTextField.enabled = NO;
        }else if(indexPath.row ==5){
            cell.inputTextField.text =  @"--";
            cell.inputTextField.enabled = NO;
        }else{
            cell.inputTextField.placeholder =  self.placeHolder_arr[indexPath.row];
        }
    }
    cell.inputTextField.keyboardType = UIKeyboardTypeASCIICapable;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.inputTextField.delegate = self;
    cell.inputTextField.tag = indexPath.row+1000;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.title_arr.count;
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
- (void)swiAction:(UISwitch *)swi{
    if (swi.isOn) {
        if ([hidden isEqualToNumber:@0]) {
            //隐藏
            borrow_integral_btn.hidden = YES;
        }else{
            borrow_integral_btn.hidden = NO;
        }
    }else{
        borrow_integral_btn.hidden = YES;
    }
    
}
@end
