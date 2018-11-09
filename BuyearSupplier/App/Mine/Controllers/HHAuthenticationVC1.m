//
//  HHAuthenticationVC1.m
//  Store
//
//  Created by User on 2018/1/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHAuthenticationVC1.h"
#import "HHTextfieldcell.h"


@interface HHAuthenticationVC1 ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *leftTitleArr;
@property(nonatomic,strong)NSArray *placeholerArr;
@property(nonatomic,strong) BXTextField *bXTextField;


@end

@implementation HHAuthenticationVC1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"实名认证";

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH,SCREEN_HEIGHT-64-44) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];

    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60) backColor:KVCBackGroundColor];
    
    UILabel *lab = [UILabel lh_labelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30) text:@"请慎重！每个账户只可校验2次" textColor:kRedColor font:FONT(12) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
    [footView addSubview:lab];
    
    
    UIButton *finishBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 30, SCREEN_WIDTH - 60, WidthScaleSize_H(40)) target:self action:@selector(finishAction) backgroundImage:nil title:@"提交" titleColor:kWhiteColor font:FONT(15)];
    finishBtn.backgroundColor = APP_COMMON_COLOR;
    [finishBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];

    [footView addSubview:finishBtn];
    self.tableView.tableFooterView = footView;
    
    self.placeholerArr = @[@"点击编辑姓名",@"点击编辑身份证号"];
    
    self.leftTitleArr = @[@"姓名",@"身份证号"];

    UIView *emptyView = [UIView lh_viewWithFrame:CGRectMake(0, 44, ScreenW, ScreenH-44) backColor:kWhiteColor];
    UILabel *discribLabel = [UILabel lh_labelWithFrame:CGRectMake(0, 0, ScreenW, 100) text:@"" textColor:APP_purple_Color font:BoldFONT(25) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
    UIButton *backBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, CGRectGetMaxY(discribLabel.frame)+30, ScreenW - 60, 40) target:self action:@selector(backAction) image:nil title:@"返回" titleColor:kWhiteColor font:FONT(14)];
    backBtn.backgroundColor = APP_COMMON_COLOR;
    [backBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [self.view addSubview:emptyView];
    [emptyView addSubview:discribLabel];
    [emptyView addSubview:backBtn];

    if ([self.status isEqualToString:@"0"]) {
        emptyView.hidden = YES;
    }else if ([self.status isEqualToString:@"1"]) {
        emptyView.hidden = NO;
        discribLabel.text = @"待审核！";
    }else if ([self.status isEqualToString:@"2"]) {
        emptyView.hidden = NO;
        discribLabel.text = @"您已经是实名制用户！";
    }
    
}
- (void)backAction{
    
    [self.navigationController popVC];
}
- (void)finishAction{
    
    HHTextfieldcell *nameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *nameStr = nameCell.inputTextField.text;
    NSString *idcardStr = self.bXTextField.text;
    
    NSString *isValid =  [self isValidWithnameStr:nameStr idcardStr:idcardStr];
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];

    if (!isValid) {

        [[[HHMineAPI postAuthenticationWithusername:nameStr idcard:idcardStr] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
                    if (!error) {
                        if (api.code == 0) {
                            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                            [SVProgressHUD showSuccessWithStatus:@"认证成功！"];
                            //发送通知
                            POST_NOTIFY(kNotificationCertified, nil);
                            [self.navigationController popVC];
                            
                        }else{
                            [SVProgressHUD showInfoWithStatus:api.msg];
                           
                        }
                    }
                }];
        
    }else{
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        
        [SVProgressHUD showInfoWithStatus:isValid];
    }
    
}
- (NSString *)isValidWithnameStr:(NSString *)nameStr idcardStr:(NSString *)idcardStr {
    
    if (nameStr.length == 0) {
        return @"请填写姓名！";
    }else if (idcardStr.length == 0){
        return @"请填写身份证号！";
    }
    return nil;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return WidthScaleSize_H(0.01);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return WidthScaleSize_H(0.01);
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return WidthScaleSize_H(50);
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    HHTextfieldcell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleLabel"];
    if(!cell){
        cell = [[HHTextfieldcell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleLabel"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.titleLabel.text = self.leftTitleArr[indexPath.row];
    cell.titleLabel.adjustsFontSizeToFitWidth = YES;
    cell.titleLabel.textColor = KTitleLabelColor;
    if (indexPath.row == 0) {
        cell.inputTextField.placeholder = self.placeholerArr[indexPath.row];
    }
    if (indexPath.row == 1) {
        self.bXTextField = [[BXTextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cell.titleLabel.frame), 0, SCREEN_WIDTH - CGRectGetMaxX(cell.titleLabel.frame)-15, WidthScaleSize_H(50))];
        self.bXTextField.placeholder = self.placeholerArr[indexPath.row];
        self.bXTextField.font = FONT(14);
        self.bXTextField.delegate = self;
        self.bXTextField.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:self.bXTextField];
        cell.inputTextField.enabled = NO;
        
    }
    return cell;
    
}

@end
