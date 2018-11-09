//
//  HHMyWalletCell.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHMyWalletCell.h"

@implementation HHMyWalletCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.action_nameLabel.font = FONT(12);
    self.infoLabel.font = FONT(11);
    self.moneyLabel.font = FONT(12);
    self.datetimeLabel.font = FONT(12);
    self.timeLabel.font = FONT(12);
    self.integral_typeLabel.titleLabel.font = FONT(11);
    self.w_constraint.constant = WidthScaleSize_H(65);
    self.date_w_constraint.constant = WidthScaleSize_H(73);
    self.time_w_constraint.constant = WidthScaleSize_H(73);
}
- (void)setMyWalletModel:(HHMineModel *)myWalletModel{
    _myWalletModel = myWalletModel;
    
    self.action_nameLabel.text = [NSString stringWithFormat:@"%@",myWalletModel.action_name?myWalletModel.action_name:@""];
    self.moneyLabel.text = myWalletModel.money;
   self.infoLabel.text = myWalletModel.info;
    [self.integral_typeLabel setTitle:myWalletModel.integral_type forState:UIControlStateNormal];
    NSArray *idatetimeArr = [myWalletModel.datetime componentsSeparatedByString:@" "];
    if (idatetimeArr.count >= 2) {
      self.datetimeLabel.text = idatetimeArr[0];
      self.timeLabel.text = idatetimeArr[1];
     }
    if ([myWalletModel.action_type isEqualToString:@"0"]||[myWalletModel.type isEqualToString:@"1"]||[myWalletModel.type isEqualToString:@"2"]||[myWalletModel.type isEqualToString:@"3"]) {
        self.icon_img.image = [UIImage imageNamed:@"icon_shopping_user_default"];
    }else if ([myWalletModel.action_type containsString:@"4"]||[myWalletModel.action_type containsString:@"6"]||[myWalletModel.action_type containsString:@"7"]||[myWalletModel.action_type containsString:@"17"]||[myWalletModel.action_type containsString:@"18"]){
        self.icon_img.image = [UIImage imageNamed:@"icon_integral_user_default"];
    }else {
        self.icon_img.image = [UIImage imageNamed:@"icon_bouns_user_default"];
    }
}
@end
