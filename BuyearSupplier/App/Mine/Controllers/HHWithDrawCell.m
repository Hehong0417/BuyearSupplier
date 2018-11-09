//
//  HHWithDrawCell.m
//  Store
//
//  Created by User on 2018/4/10.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHWithDrawCell.h"

@implementation HHWithDrawCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bankName.font = FONT(14);
    self.bankNo.font = FONT(14);
    self.money.font = FONT(12);
    self.dateTime.font = FONT(12);
    self.status.font = FONT(13);
    self.title1.font = FONT(14);
    self.title2.font = FONT(14);
    [self.cancel_withDrawBtn lh_setCornerRadius:5 borderWidth:1 borderColor:APP_COMMON_COLOR];
    
    self.whc_CellBottomOffset = 10;
    self.whc_CellBottomView = self.dateTime;
}
- (void)setWithDrawModel:(HHMineModel *)withDrawModel{
    
    _withDrawModel = withDrawModel;
    if([withDrawModel.status_code isEqual:@0]){
        self.cancel_withDrawBtn.hidden = NO;
        self.cancelBtn_constant.constant = 69;
    }else{
        self.cancel_withDrawBtn.hidden = YES;
        self.cancelBtn_constant.constant = 0;
    }
    self.bankName.text =  withDrawModel.bank_name?withDrawModel.bank_name:@"";
    self.bankNo.text = withDrawModel.bank_cardno?withDrawModel.bank_cardno:@"";
    self.dateTime.text  = withDrawModel.datetime;
    self.money.text  =  [NSString stringWithFormat:@"%@(%@)",withDrawModel.real_money,withDrawModel.apply_money];
    self.status.text = withDrawModel.status;
    self.rejectReasonStatus.text = withDrawModel.remark;
}
- (void)setSignedQuotaModel:(HHMineModel *)signedQuotaModel{
    _signedQuotaModel = signedQuotaModel;
    self.cancel_withDrawBtn.hidden = YES;
    self.cancelBtn_constant.constant = 0;
    self.title1.text = @"用户姓名";
    self.bankName.text =  signedQuotaModel.username?signedQuotaModel.username:@"";
    self.title2.text = @"用户账号";
    self.bankNo.text = signedQuotaModel.userid?signedQuotaModel.userid:@"";
    self.dateTime.text  = signedQuotaModel.datetime;
    self.money.text  =  [NSString stringWithFormat:@"%@",signedQuotaModel.value];
    self.money.textAlignment = NSTextAlignmentCenter;
    self.status.text = @"";
    if (signedQuotaModel.remarks.length == 0) {
        self.dateTime_constant.constant = -15;
    }else{
        self.dateTime_constant.constant = 1;
    }
    self.rejectReasonStatus.text = [NSString stringWithFormat:@"%@",signedQuotaModel.remarks];

}
- (IBAction)cancelBtnAction:(UIButton *)sender {
    sender.enabled = NO;
    
    [self commitCancelWithBtn:sender];
    
}
- (void)commitCancelWithBtn:(UIButton *)btn{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"确定要取消提现吗？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        btn.enabled = NO;
        [[[HHMineAPI postCancelWithdrawalsWithIds:@[_withDrawModel.Id]] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            btn.enabled = YES;
            if (!error) {
                if (api.code == 0) {
                    if (self.cancel_btnBlock) {
                        self.cancel_btnBlock();
                    }
                }else{
                    [SVProgressHUD showInfoWithStatus:api.msg];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:error.localizedDescription];
            }
        }];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alertC dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertC addAction:action1];
    [alertC addAction:action2];
    [self.vc presentViewController:alertC animated:YES completion:nil];
    
}
@end
