
//
//  HXBonusLogCell.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHStoreSubsidyCell.h"

@implementation HHStoreSubsidyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setStoreSubsidyModel:(HHMineModel *)storeSubsidyModel{
    _storeSubsidyModel = storeSubsidyModel;
    self.datetimeLabel.text = [NSString stringWithFormat:@"发放时间：%@",storeSubsidyModel.datetime?storeSubsidyModel.datetime:@""];
    self.statusLabel.text = [NSString stringWithFormat:@"审核状态：%@",storeSubsidyModel.status?storeSubsidyModel.status:@"0"];
    self.reward_totalLabel.text = [NSString stringWithFormat:@"体验店店补奖金：%@",storeSubsidyModel.reward_total?storeSubsidyModel.reward_total:@"0"];
    self.platform_integralLabel.text = [NSString stringWithFormat:@"平台综合消费：%@",storeSubsidyModel.platform_integral?storeSubsidyModel.platform_integral:@"0"];
    self.shopping_integralLabel.text = [NSString stringWithFormat:@"转购物积分：%@",storeSubsidyModel.shopping_integral?storeSubsidyModel.shopping_integral:@""];
    self.money_integralLabel.text = [NSString stringWithFormat:@"实发现金积分：%@",storeSubsidyModel.money_integral?storeSubsidyModel.money_integral:@"0"];
    self.remarkLabel.text = [NSString stringWithFormat:@"审核备注：%@",storeSubsidyModel.remark?storeSubsidyModel.remark:@""];
}
@end
