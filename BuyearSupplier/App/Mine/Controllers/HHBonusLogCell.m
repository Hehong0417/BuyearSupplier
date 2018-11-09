
//
//  HXBonusLogCell.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHBonusLogCell.h"

@implementation HHBonusLogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.createdateLabel.font = FONT(14);
    self.statusLabel.font = FONT(14);
    self.from_useridLabel.font = FONT(14);
    self.share_rewardLabel.font = FONT(14);
    self.platform_integralLabel.font = FONT(14);
    self.shopping_integralLabel.font = FONT(14);
    self.money_integralLabel.font = FONT(14);
}
//消费分利
- (void)setBlendModel:(HHMineModel *)blendModel{
    _blendModel = blendModel;
    self.createdateLabel.text = [NSString stringWithFormat:@"发放时间：%@",blendModel.createdate];
    self.statusLabel.text = [NSString stringWithFormat:@"审核状态：%@",blendModel.status];
    self.from_useridLabel.text = [NSString stringWithFormat:@"期数：%@",blendModel.periods];
    self.share_rewardLabel.text = [NSString stringWithFormat:@"消费分利：%@",blendModel.blend_integral];
    self.platform_integralLabel.text = [NSString stringWithFormat:@"平台综合消费：%@",blendModel.platform_integral];
    self.shopping_integralLabel.text = [NSString stringWithFormat:@"转购物积分：%@",blendModel.shopping_integral];
    self.money_integralLabel.text = [NSString stringWithFormat:@"实发现金积分：%@",blendModel.money_integral];
    
}
//A奖
- (void)setA_bonus_totalModel:(HHMineModel *)a_bonus_totalModel{
    
    _a_bonus_totalModel = a_bonus_totalModel;
    self.createdateLabel.text = [NSString stringWithFormat:@"发放时间：%@",a_bonus_totalModel.createdate];
    self.statusLabel.text = [NSString stringWithFormat:@"审核状态：%@",a_bonus_totalModel.status];
    self.from_useridLabel.text = [NSString stringWithFormat:@"分享收益A：%@",a_bonus_totalModel.blend_integral];
    self.share_rewardLabel.text = [NSString stringWithFormat:@"平台综合消费：%@",a_bonus_totalModel.platform_integral];
    self.platform_integralLabel.text = [NSString stringWithFormat:@"转购物积分：%@",a_bonus_totalModel.shopping_integral];
    self.shopping_integralLabel.text = [NSString stringWithFormat:@"实发现金积分：%@",a_bonus_totalModel.money_integral];
    self.money_integralLabel.text = @"";
    
}

//B奖
- (void)setB_bonus_totalModel:(HHMineModel *)b_bonus_totalModel{
    _b_bonus_totalModel = b_bonus_totalModel;
    self.createdateLabel.text = [NSString stringWithFormat:@"发放时间：%@",b_bonus_totalModel.createdate];
    self.statusLabel.text = [NSString stringWithFormat:@"审核状态：%@",b_bonus_totalModel.status];
    self.from_useridLabel.text = [NSString stringWithFormat:@"分享收益B：%@",b_bonus_totalModel.blend_integral];
    self.share_rewardLabel.text = [NSString stringWithFormat:@"平台综合消费：%@",b_bonus_totalModel.platform_integral];
    self.platform_integralLabel.text = [NSString stringWithFormat:@"转购物积分：%@",b_bonus_totalModel.shopping_integral];
    self.shopping_integralLabel.text = [NSString stringWithFormat:@"实发现金积分：%@",b_bonus_totalModel.money_integral];
    self.money_integralLabel.text = @"";
    
    
}

//分享推广
- (void)setShare_rewardModel:(HHMineModel *)share_rewardModel{
    _share_rewardModel = share_rewardModel;
    
    self.createdateLabel.text = [NSString stringWithFormat:@"发放时间：%@",share_rewardModel.createdate];
    self.statusLabel.text = [NSString stringWithFormat:@"审核状态：%@",share_rewardModel.status];
    self.from_useridLabel.text = [NSString stringWithFormat:@"订单来源：%@",share_rewardModel.from_userid];
    self.share_rewardLabel.text = [NSString stringWithFormat:@"分享推广奖：%@",share_rewardModel.share_reward];
    self.platform_integralLabel.text = [NSString stringWithFormat:@"平台综合消费：%@",share_rewardModel.platform_integral];
    self.shopping_integralLabel.text = [NSString stringWithFormat:@"转购物积分：%@",share_rewardModel.shopping_integral];
    self.money_integralLabel.text = [NSString stringWithFormat:@"实发现金积分：%@",share_rewardModel.money_integral];

}
- (void)setCashExchangeRecordModel:(HHMineModel *)cashExchangeRecordModel{
    _cashExchangeRecordModel = cashExchangeRecordModel;
    
    self.createdateLabel.text = [NSString stringWithFormat:@"时间：%@",cashExchangeRecordModel.datetime];
    self.statusLabel.text = [NSString stringWithFormat:@"兑换现金积分：%@",cashExchangeRecordModel.money_integral];
    self.from_useridLabel.text = [NSString stringWithFormat:@"获得提货积分：%@",cashExchangeRecordModel.picking_integral];
    self.share_rewardLabel.text = [NSString stringWithFormat:@"获得S积分：%@",cashExchangeRecordModel.s_integral];
    self.platform_integralLabel.text = [NSString stringWithFormat:@"归属体验店：%@",cashExchangeRecordModel.shopid.length?cashExchangeRecordModel.shopid:@"无"];
    self.shopping_integralLabel.text = [NSString stringWithFormat:@"归属体验店店长：%@",cashExchangeRecordModel.shop_username.length?cashExchangeRecordModel.shop_username:@"无"];
    
}

@end
