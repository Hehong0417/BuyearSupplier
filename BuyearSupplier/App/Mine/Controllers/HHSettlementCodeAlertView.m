//
//  HHSettlementCodeAlertView.m
//  Store
//
//  Created by User on 2018/1/11.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHSettlementCodeAlertView.h"
#import "HHSettlementCodeView.h"

@implementation HHSettlementCodeAlertView

- (UIView *)alertViewContentView{
    
    
    UIView *alertContentView = [[UIView alloc]initWithFrame:CGRectMake(45, 0, ScreenW-90, 250)];

    alertContentView.backgroundColor = kClearColor;
    
    alertContentView.centerY = (ScreenH - 49 - 64)/2;
    
    UIButton *closeBtn = [UIButton lh_buttonWithFrame:CGRectMake(alertContentView.mj_w-40, 0, 40, 40) target:self action:@selector(closeAction) image:[UIImage imageNamed:@"icon_close_user_default"]];
    
    
    CodeView = [[[NSBundle mainBundle] loadNibNamed:@"HHSettlementCodeView" owner:self options:nil] lastObject];
    CodeView.frame = CGRectMake(0, 40, alertContentView.mj_w, 210);
    
    [alertContentView addSubview:closeBtn];
    [alertContentView addSubview:CodeView];
    
    return alertContentView;
}

- (void)setUserName:(NSString *)userName{
    
    _userName = userName;
    
}
- (void)setSettlementCode:(NSString *)settlementCode{
    _settlementCode = settlementCode;
    
}
- (void)layoutSubviews{
    CodeView.userNameLabel.text = self.userName;
    CodeView.SettlementCodeLabel.text = self.settlementCode;

}
- (void)closeAction{
    
    [self hideWithCompletion:^{
        
    }];
}
@end
