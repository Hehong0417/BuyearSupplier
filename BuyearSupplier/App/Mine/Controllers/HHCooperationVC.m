//
//  HHCooperationVC.m
//  Store
//
//  Created by User on 2018/1/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHCooperationVC.h"
#import "HHTextfieldcell.h"
#import "HHCooperationProtocolVC.h"
#import "HHContractManagerVC.h"
#import "HHTeamListVC.h"

@interface HHCooperationVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIButton *protocolBtn;
    UILabel *headLab;
    HHMineModel *mineModel;
}
@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, strong)   NSArray *title_arr;
@property (nonatomic, strong)   NSArray *placeHolder_arr;

//服务经理名称
@property (nonatomic, strong)   NSString *serviceManager;
//体验店名称
@property (nonatomic, strong)   NSString *shop_name;

@end

@implementation HHCooperationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //合作微商
    self.title = @"签署协议";
    
    self.title_arr = @[@"协议时间",@"服务经理",@"服务经理姓名",@"体验店编号",@"体验店店长姓名"];
    self.placeHolder_arr = @[@"",@"点击此处输入服务经理",@"",@"点击此处输入体验店编号",@""];
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
    
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170) backColor:KVCBackGroundColor];
    protocolBtn = [UIButton lh_buttonWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 40) target:self action:@selector(protocolBtnAction:) image:[UIImage imageNamed:@"icon_checkbox_default"]];
    [protocolBtn setImage:[UIImage imageNamed:@"icon_checkbox_selected"] forState:UIControlStateSelected];
    NSMutableAttributedString *attrStr = [NSString lh_attriStrWithprotocolStr:@"《合作微商协议》" content:@"  同意注册协议《合作微商协议》" protocolFont:FONT(12) contentFont:FONT(12) protocolStrColor:APP_purple_Color contentColor:KTitleLabelColor];
    [protocolBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
    WEAK_SELF();
    protocolBtn.titleLabel.userInteractionEnabled = YES;
    [protocolBtn.titleLabel setTapActionWithBlock:^{
        HHCooperationProtocolVC *vc = [[HHCooperationProtocolVC alloc] initWithNibName:@"HHCooperationProtocolVC" bundle:nil];
        [weakSelf.navigationController pushVC:vc];
        
    }];
    
    [protocolBtn setTitleColor:kLightGrayColor forState:UIControlStateNormal];
    [footView addSubview:protocolBtn];
    
    UIButton *saveBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, CGRectGetMaxY(protocolBtn.frame)+45, SCREEN_WIDTH-60, 45) target:self action:@selector(saveBtnAction:) image:nil];
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
                   mineModel = [HHMineModel mj_objectWithKeyValues:api.data];
                    if (mineModel.sign_shopname.length>0&&mineModel.sign_shopid.length>0) {
                        self.shop_name= mineModel.sign_shopname;
                        HHTextfieldcell *cell0 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                        cell0.inputTextField.text = mineModel.sign_shopid;
                        HHTextfieldcell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                        cell1.inputTextField.text = mineModel.sign_shopname;
                        cell0.inputTextField.enabled =NO;
                        cell1.inputTextField.enabled =NO;
                    }
                    
                    NSMutableAttributedString *attriStr = [NSString lh_attriStrWithprotocolStr:mineModel.s_integral content:[NSString stringWithFormat:@"积分余额：%@",mineModel.s_integral] protocolStrColor:kRedColor contentColor:APP_purple_Color];
                    headLab.attributedText = attriStr;
                    
                }
            }
        }];
}
- (void)protocolBtnAction:(UIButton *)btn{
    
    btn.selected = !btn.selected;
}
- (void)saveBtnAction:(UIButton *)btn{
    
    HHTextfieldcell *timeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    HHTextfieldcell *parentIdCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    HHTextfieldcell *shopsIdCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    
    NSString *validStr = [self validWithtime:timeCell.inputTextField.text parentId:parentIdCell.inputTextField.text shopsId:shopsIdCell.inputTextField.text];
    if (!validStr) {
        
        NSString *message = [NSString stringWithFormat:@"\n协议时间:%@\n\n服务经理:%@,%@\n\n体验店编号:%@,%@",timeCell.inputTextField.text,parentIdCell.inputTextField.text,self.serviceManager,shopsIdCell.inputTextField.text.length?shopsIdCell.inputTextField.text:@"未填写",shopsIdCell.inputTextField.text.length?self.shop_name:@"未填写"];
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"确认信息" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [btn lh_setBackgroundColor:KA0LabelColor forState:UIControlStateNormal];
            btn.enabled = NO;
            [[ [HHMineAPI postSignWithtype:@"0" parentId:parentIdCell.inputTextField.text isBorrowIntegral:@"0" shopsId:shopsIdCell.inputTextField.text] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
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
- (NSString *)validWithtime:(NSString *)time parentId:(NSString *)parentId shopsId:(NSString *)shopsId {
    
    if (parentId.length == 0) {
        return @"请填写服务经理！";
    }else if (protocolBtn.selected == NO&&protocolBtn.hidden == NO){
        return @"请您先勾选合作微商协议！";
    }
    return nil;
    
}
#pragma mark --- UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{

    
    if (textField.tag == 10001) {
        //服务经理
        if (textField.text.length>0) {

        [[[HHMineAPI GetUserBySignNoWithsignno:textField.text] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
            if (!error) {
                if (api.code == 0) {
                    HHMineModel *model = [HHMineModel mj_objectWithKeyValues:api.data];
                    self.serviceManager = model.username;
                    HHTextfieldcell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                    cell.inputTextField.text = model.username;
                    
                }else if (api.code == 1){
                    self.serviceManager = @"服务经理不存在";
                    HHTextfieldcell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                    cell.inputTextField.text = self.serviceManager;
                }
            }else{
                self.serviceManager = @"服务经理名称获取失败！";
                
            }
        }];
            
        }else{
            HHTextfieldcell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            cell.inputTextField.text = @"--";
        }

    }else if (textField.tag == 10003){
        //体验店编号
        if (textField.text.length>0) {

        [[[HHMineAPI GetUserByShopNoWithshopno:textField.text] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
            if (!error) {
                    if (api.code == 0) {

                        HHMineModel *model = [HHMineModel mj_objectWithKeyValues:api.data];
                        self.shop_name= model.username;
                        HHTextfieldcell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                        cell.inputTextField.text = model.username;
                        
                    }else if (api.code == 1){
                        self.shop_name = api.msg;
                        HHTextfieldcell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                        cell.inputTextField.text = self.shop_name;
                    }
            }else{
                        self.shop_name = @"体验店名称获取失败！";
            }
        }];
            
        }else{
            HHTextfieldcell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
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
        if (indexPath.row == 0) {
            cell.inputTextField.enabled = NO;
            cell.inputTextField.textAlignment = NSTextAlignmentRight;
            cell.inputTextField.text = [[NSDate date] lh_string_yyyyMMdd];

        }else if(indexPath.row == 2){
          cell.inputTextField.text = @"--";
          cell.inputTextField.enabled = NO;

        }else if(indexPath.row == 4){
            cell.inputTextField.text = @"--";
            cell.inputTextField.enabled = NO;

        }else{
            cell.inputTextField.placeholder = self.placeHolder_arr[indexPath.row];
        }
        cell.titleLabel.text = self.title_arr[indexPath.row];
    }
    cell.inputTextField.tag = indexPath.row+10000;
    cell.inputTextField.keyboardType = UIKeyboardTypeASCIICapable;
    cell.inputTextField.delegate = self;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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


@end
