//
//  HXTeacherCenterCell.m
//  mengyaProject
//
//  Created by n on 2017/8/8.
//  Copyright © 2017年 n. All rights reserved.
//

#import "HXTeacherCenterCell.h"
#import "HHAccountRechargeVC.h"
#import "HHWithDrawVC.h"
#import "HHIntegralTransferVC.h"
#import "HHTeamListVC.h"
#import "HHRatifyAccordSuperVC.h"
#import "HHSettlementCodeAlertView.h"
#import "HHBonusLogSuperVC.h"

@implementation HXTeacherCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        NSArray *models = @[@[@"icon_recharge_user_default",@"icon_cash_user_default",@"icon_transfer_user_default"],@[@"icon_manage_user_default",@"icon_bonus_user_default",@"icon_protocol_user_default"]];
        NSArray *modelsNames = @[@[@"充值",@"提现",@"转账"],@[@"签约单管理",@"奖金日志",@"签署协议"]];
        CGFloat imagW = 85;
        CGFloat imagH = 75;
        CGFloat margin = (ScreenW-3*imagW)/4;
        
        for (NSInteger i = 0; i < 6; i++) {

            NSInteger line = i%3;
            NSInteger row = i/3;
            CGFloat imageX = line*(imagW+margin)+margin+margin/3;
            CGFloat imageY = row*imagH;
            self.modelBtn = [XYQButton ButtonWithFrame:CGRectMake(imageX, imageY, imagW, imagH) imgaeName:models[row][line] titleName:modelsNames[row][line] contentType:TopImageBottomTitle buttonFontAttributes:[FontAttributes fontAttributesWithFontColor:APP_COMMON_COLOR fontsize:12] title_image_padding:10 tapAction:^(XYQButton *button) {
                if (i == 0) {
                    HHAccountRechargeVC *vc = [HHAccountRechargeVC new];
                    [self.nav pushVC:vc];
                    
                }else if (i == 1){
                    HHWithDrawVC *vc = [HHWithDrawVC new];
                    [self.nav pushVC:vc];
                    
                }else if (i == 2){
                    HHIntegralTransferVC *vc = [HHIntegralTransferVC new];
                    [self.nav pushVC:vc];
                    
                }else if (i == 3){
                    HHTeamListVC *vc = [HHTeamListVC new];
                    [self.nav pushVC:vc];
                    
                }else if (i == 4){
                //结算码
                    HHBonusLogSuperVC *vc = [HHBonusLogSuperVC new];
                    [self.nav pushVC:vc];
                    
                }else if (i == 5){
                    
                    if (self.delegate&&[self.delegate respondsToSelector:@selector(pushRatifyAccord)]) {
                        
                        [self.delegate pushRatifyAccord];
                    }
                }
                
            }];
            self.modelBtn.tag = i+1000;
            [self.modelBtn setTitleColor:APP_purple_Color forState:UIControlStateNormal];
            self.modelBtn.backgroundColor = kWhiteColor;
//            self.contentView.backgroundColor = KVCBackGroundColor;
            self.contentView.backgroundColor = kWhiteColor;

            [self.contentView addSubview:self.modelBtn];
            
        }
        
    }

    return self;
}

@end
