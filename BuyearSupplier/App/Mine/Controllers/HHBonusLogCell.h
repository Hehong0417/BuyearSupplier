//
//  HXBonusLogCell.h
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHBonusLogCell : UITableViewCell

//消费分利
@property(nonatomic,strong) HHMineModel *blendModel;
//A奖
@property(nonatomic,strong) HHMineModel *a_bonus_totalModel;

//B奖
@property(nonatomic,strong) HHMineModel *b_bonus_totalModel;

//分享推广奖
@property(nonatomic,strong) HHMineModel *share_rewardModel;

//现金积分兑换记录
@property(nonatomic,strong) HHMineModel *cashExchangeRecordModel;


@property (weak, nonatomic) IBOutlet UILabel *createdateLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *from_useridLabel;
@property (weak, nonatomic) IBOutlet UILabel *share_rewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *platform_integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopping_integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *money_integralLabel;

@end
