//
//  HHPhoneVerifyVC.m
//  CredictCard
//
//  Created by User on 2017/12/18.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHPhoneVerifyVC.h"
#import "HHTextfieldcell.h"
@interface HHPhoneVerifyVC ()<UITextFieldDelegate>
@property (nonatomic, strong)   NSArray *placeHolders;

@end

@implementation HHPhoneVerifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"手机验证";
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) backColor:kClearColor];
    
    UIButton *finishBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 50, SCREEN_WIDTH - 60, 45) target:self action:@selector(finishBtnAction:) backgroundImage:nil title:@"提交"  titleColor:kWhiteColor font:FONT(14)];
    finishBtn.backgroundColor = APP_COMMON_COLOR;
    [finishBtn lh_setRadii:5 borderWidth:0 borderColor:nil];
    
    [footView addSubview:finishBtn];
    
    self.tableV.tableFooterView = footView;
    
    self.placeHolders = @[@"点击编辑新手机号",@"点击编辑验证码"];
    
}

//
- (void)finishBtnAction:(UIButton *)btn{
    
    UITableViewCell *cell0_0 = [self.tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *mobileStr;
    for (UIView *view in cell0_0.contentView.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *field = (UITextField *)view;
            mobileStr = field.text;
        }
    }
    UITableViewCell *cell0_1 = [self.tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *verificationCodeStr;
    for (UIView *view in cell0_1.contentView.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *field = (UITextField *)view;
            verificationCodeStr = field.text;
        }
    }
    
    NSString *validStr = [self validWithmobile:mobileStr verificationCode:verificationCodeStr];
    if (!validStr) {
        //修改手机号
        [self.navigationController popVC];
        
    }else{
        
        [SVProgressHUD showInfoWithStatus:validStr];
    }
    
}
- (NSString *)validWithmobile:(NSString *)mobile verificationCode:(NSString *)verificationCode {
    
    if (mobile.length == 0) {
        return @"请填写手机号！";
    }else  if (verificationCode.length == 0) {
        return @"请填写验证码！";
    }
    return nil;
    
}
#pragma mark - textfieldDelegate限制手机号为11位

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > 11 && range.length!=1){
        textField.text = [toBeString substringToIndex:11];
        return NO;
    }
    
    return YES;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    UITextField *textField = [UITextField lh_textFieldWithFrame:CGRectMake(80, 0, ScreenW-80, WidthScaleSize_H(44)) placeholder:self.placeHolders[indexPath.row] font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    textField.delegate = self;
    [cell.contentView addSubview:textField];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

}
- (NSArray *)groupTitles{
    
    return @[@[@"新手机号",@"验证码"]];
    
}
- (NSArray *)groupIcons {
    
    return @[@[@"",@""]];
}
- (NSArray *)groupDetials{
    
    return @[@[@"",@""]];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
    
}
@end

