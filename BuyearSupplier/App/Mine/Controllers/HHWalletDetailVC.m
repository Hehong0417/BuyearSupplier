//
//  HHWalletDetailVC.m
//  Store
//
//  Created by User on 2018/3/6.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHWalletDetailVC.h"

@interface HHWalletDetailVC ()

@end

@implementation HHWalletDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"详情";

    //加阴影
    
    self.integral_type_lab.text = self.myWalletModel.integral_type;
    self.money_lab.text = self.myWalletModel.money;
    self.userid_lab.text = [NSString stringWithFormat:@"用户账号：%@",self.userid];
    
    switch (self.myWalletModel.action_type.integerValue) {
        case 0:{
            //商城购物
            self.oneName_lab.text = @"时间";
            self.one_info_lab.text = self.myWalletModel.datetime;
            self.twoName_lab.text = @"订单号";
            self.two_info_lab.text = self.myWalletModel.number;
            self.three_lab.text = @"总金额";
//          self.three_info_lab.text = @"";

            if ([self.myWalletModel.integral_type isEqualToString:@"提货积分"]) {
                self.four_lab.text = @"扣提货积分";
                self.four_info_lab.text = self.myWalletModel.money;
                self.five_lab.text = @"";
                self.six_lab.text = @"";
                self.five_info_lab.text = @"";
                self.six_info_lab.text = @"";
            }else if ([self.myWalletModel.integral_type isEqualToString:@"S积分"]) {
                self.four_lab.text = @"扣现金积分";
                self.five_lab.text = @"扣购物积分";
                self.six_lab.text = @"加S积分";
                self.six_info_lab.text = self.myWalletModel.money;
            }else if ([self.myWalletModel.integral_type isEqualToString:@"现金积分"]) {
                self.four_lab.text = @"扣现金积分";
                self.five_lab.text = @"扣购物积分";
                self.six_lab.text = @"加S积分";
                self.four_info_lab.text = self.myWalletModel.money;
                self.five_info_lab.text = @"";
                self.six_info_lab.text = @"";
                
            }else if ([self.myWalletModel.integral_type isEqualToString:@"购物积分"]) {
                self.four_lab.text = @"扣现金积分";
                self.five_lab.text = @"扣购物积分";
                self.six_lab.text = @"加S积分";
                self.four_info_lab.text = @"";
                self.five_info_lab.text = self.myWalletModel.money;
                self.six_info_lab.text = @"";
                
            }
        }
            break;
        case 1:{
     //   商城退货用户通过
            self.oneName_lab.text = @"时间";
            self.twoName_lab.text = @"订单号";
            self.three_lab.text = @"总金额";
            self.one_info_lab.text = self.myWalletModel.datetime;
            self.two_info_lab.text = self.myWalletModel.number;
            //总金额
            self.three_info_lab.text = @"";
            
            
            if ([self.myWalletModel.integral_type isEqualToString:@"现金积分"]) {
                self.four_lab.text = @"扣S积分";
                self.five_lab.text = @"加现金积分";
                //扣S积分
                self.four_info_lab.text = @"0.00";
                //加现金积分
                self.five_info_lab.text = self.myWalletModel.money;
                
            }else if ([self.myWalletModel.integral_type isEqualToString:@"S积分"]){
                self.four_lab.text = @"扣S积分";
                self.five_lab.text = @"加现金积分";
                //扣S积分
                self.four_info_lab.text = self.myWalletModel.money;
                //加现金积分
                self.five_info_lab.text = @"0.00";
            }else if ([self.myWalletModel.integral_type isEqualToString:@"提货积分"]){

                self.four_lab.text = @"加提货积分";
                self.four_info_lab.text = self.myWalletModel.money;
                self.five_lab.text = @"";
                self.five_info_lab.text = @"";
            }
        }
            break;
        case 2:{
            //   用户退货通过
            self.oneName_lab.text = @"时间";
            self.twoName_lab.text = @"订单号";
            self.three_lab.text = @"总金额";
            self.one_info_lab.text = self.myWalletModel.datetime;
            self.two_info_lab.text = self.myWalletModel.number;
            //总金额
            self.three_info_lab.text = @"";
            
            
            if ([self.myWalletModel.integral_type isEqualToString:@"现金积分"]) {
                self.four_lab.text = @"扣S积分";
                self.five_lab.text = @"加现金积分";
                //扣S积分
                self.four_info_lab.text = @"0.00";
                //加现金积分
                self.five_info_lab.text = self.myWalletModel.money;
                
            }else if ([self.myWalletModel.integral_type isEqualToString:@"S积分"]){
                self.four_lab.text = @"扣S积分";
                self.five_lab.text = @"加现金积分";
                //扣S积分
                self.four_info_lab.text = self.myWalletModel.money;
                //加现金积分
                self.five_info_lab.text = @"0.00";
            }else if ([self.myWalletModel.integral_type isEqualToString:@"提货积分"]){
                
                self.four_lab.text = @"加提货积分";
                self.four_info_lab.text = self.myWalletModel.money;
                self.five_lab.text = @"";
                self.five_info_lab.text = @"";
            }
    }
            
            break;
        case 3:{
            //   会员退货通过
            self.oneName_lab.text = @"时间";
            self.twoName_lab.text = @"订单号";
            self.three_lab.text = @"总金额";
            self.one_info_lab.text = self.myWalletModel.datetime;
            self.two_info_lab.text = self.myWalletModel.number;
            //总金额
            self.three_info_lab.text = @"";
            
            
            if ([self.myWalletModel.integral_type isEqualToString:@"现金积分"]) {
                self.four_lab.text = @"扣S积分";
                self.five_lab.text = @"加现金积分";
                //扣S积分
                self.four_info_lab.text = @"0.00";
                //加现金积分
                self.five_info_lab.text = self.myWalletModel.money;
                
            }else if ([self.myWalletModel.integral_type isEqualToString:@"S积分"]){
                self.four_lab.text = @"扣S积分";
                self.five_lab.text = @"加现金积分";
                //扣S积分
                self.four_info_lab.text = self.myWalletModel.money;
                //加现金积分
                self.five_info_lab.text = @"0.00";
            }else if ([self.myWalletModel.integral_type isEqualToString:@"提货积分"]){
                
                self.four_lab.text = @"加提货积分";
                self.four_info_lab.text = self.myWalletModel.money;
                self.five_lab.text = @"";
                self.five_info_lab.text = @"";
            }
        }
            
            break;
        case 4:{
            self.oneName_lab.text = @"时间";
            self.twoName_lab.text = @"订单号";
            self.three_lab.text = @"扣S积分";
            self.four_lab.text = @"";
            self.five_lab.text = @"";
            self.six_lab.text = @"";
            self.one_info_lab.text = self.myWalletModel.datetime;
            self.two_info_lab.text = self.myWalletModel.number;
            self.three_info_lab.text = self.myWalletModel.money;
            self.four_info_lab.text = @"";
            self.five_info_lab.text = @"";
            self.six_info_lab.text = @"";
        }
            
            break;
        case 5:{
            //消费分类
            self.oneName_lab.text = @"时间";
            self.twoName_lab.text = @"签约单号";
            self.three_lab.text = @"综合积分";
            self.four_lab.text = @"加现金积分";
            self.five_lab.text = @"加购物积分";
            self.one_info_lab.text = self.myWalletModel.datetime;
            self.two_info_lab.text = self.myWalletModel.number;
            //综合积分
            self.three_info_lab.text = @"";
            if ([self.myWalletModel.integral_type isEqualToString:@"现金积分"]) {
                //现金积分
                self.four_info_lab.text = self.myWalletModel.money;
                //购物积分
                self.five_info_lab.text = @"";
            }else if ([self.myWalletModel.integral_type isEqualToString:@"购物积分"]){
                //现金积分
                self.four_info_lab.text = @"";
                //购物积分
                self.five_info_lab.text = self.myWalletModel.money;
            }
            //平台综合费
            self.six_lab.text = @"";
        }
            break;
        case 6:{
            //还S积分>本金
            self.oneName_lab.text = @"时间";
            self.twoName_lab.text = @"签约单号";
            self.three_lab.text = @"本期应还总额";
            self.four_lab.text = @"扣本金现金积分";
            self.five_lab.text = @"扣手续费现金积分";
            self.one_info_lab.text = self.myWalletModel.datetime;
            self.two_info_lab.text = self.myWalletModel.number;
           //本期应还总额
            self.three_info_lab.text = @"";
            
            if ([self.myWalletModel.integral_type isEqualToString:@"现金积分"]) {
                //本金现金积分
                self.four_info_lab.text = self.myWalletModel.money;
                //手续费现金积分
                self.five_info_lab.text = @"";
            }
            //
            self.six_lab.text = @"";
            self.six_info_lab.text = @"";

        }
            break;
        case 7:{
            //还借S积分手续费
            self.oneName_lab.text = @"时间";
            self.twoName_lab.text = @"签约单号";
            self.three_lab.text = @"本期应还总额";
            self.four_lab.text = @"扣本金现金积分";
            self.five_lab.text = @"扣手续费现金积分";
            self.one_info_lab.text = self.myWalletModel.datetime;
            self.two_info_lab.text = self.myWalletModel.number;
            //本期应还总额
            self.three_info_lab.text = @"";
            
            if ([self.myWalletModel.integral_type isEqualToString:@"现金积分"]) {
                //本金现金积分
                self.four_info_lab.text = @"";
                //手续费现金积分
                self.five_info_lab.text = self.myWalletModel.money;
            }
            //
            self.six_lab.text = @"";
            self.six_info_lab.text = @"";
        }
            
            break;
        case 8:
        {
            //A奖
            self.oneName_lab.text = @"时间";
            self.twoName_lab.text = @"签约单号";
            self.three_lab.text = @"A奖总额";
            self.four_lab.text = @"加现金积分";
            self.five_lab.text = @"加购物积分";
            self.one_info_lab.text = self.myWalletModel.datetime;
            self.two_info_lab.text = self.myWalletModel.number;
            //A奖总额
            self.three_info_lab.text = @"";
            if ([self.myWalletModel.integral_type isEqualToString:@"现金积分"]) {
                //现金积分
                self.four_info_lab.text = self.myWalletModel.money;
                //购物积分
                self.five_info_lab.text = @"";
            }else if ([self.myWalletModel.integral_type isEqualToString:@"购物积分"]){
                //现金积分
                self.four_info_lab.text = @"";
                //购物积分
                self.five_info_lab.text = self.myWalletModel.money;
            }
            //平台综合费
            self.six_lab.text = @"";

        }
            break;
        case 9:{
            //B奖
            self.oneName_lab.text = @"时间";
            self.twoName_lab.text = @"签约单号";
            self.three_lab.text = @"B奖总额";
            self.four_lab.text = @"加现金积分";
            self.five_lab.text = @"加购物积分";
            self.six_lab.text = @"加平台综合费";
            
            self.one_info_lab.text = self.myWalletModel.datetime;
            self.two_info_lab.text = self.myWalletModel.number;
            
            //A奖总额
            self.three_info_lab.text = @"";
            
            if ([self.myWalletModel.integral_type isEqualToString:@"现金积分"]) {
                //现金积分
                self.four_info_lab.text = self.myWalletModel.money;
                //购物积分
                self.five_info_lab.text = @"";
            }else if ([self.myWalletModel.integral_type isEqualToString:@"购物积分"]){
                //现金积分
                self.four_info_lab.text = @"";
                //购物积分
                self.five_info_lab.text = self.myWalletModel.money;
            }
            //平台综合费
            self.six_info_lab.text = @"";
        }
            
            break;
        case 10:{
            //分享推广奖
            self.oneName_lab.text = @"时间";
            self.twoName_lab.text = @"签约单号";
            self.three_lab.text = @"分享推广总额";
            self.four_lab.text = @"加现金积分";
            self.five_lab.text = @"加购物积分";
            self.six_lab.text = @"加平台综合费";

            self.one_info_lab.text = self.myWalletModel.datetime;
            self.two_info_lab.text = self.myWalletModel.number;
            
            //分享推广总额
            self.three_info_lab.text = @"";
            
            if ([self.myWalletModel.integral_type isEqualToString:@"现金积分"]) {
                //现金积分
                self.four_info_lab.text = self.myWalletModel.money;
                //购物积分
                self.five_info_lab.text = @"";
                
            }else if ([self.myWalletModel.integral_type isEqualToString:@"购物积分"]){
                //现金积分
                self.four_info_lab.text = @"";
                //购物积分
                self.five_info_lab.text = self.myWalletModel.money;
            }
            //平台综合费
            self.six_info_lab.text = @"";
            
        }
            
            break;
        case 11:{
            //店补
            self.oneName_lab.text = @"时间";
            self.twoName_lab.text = @"签约单号";
            self.three_lab.text = @"店补总额";
            self.four_lab.text = @"加现金积分";
            self.five_lab.text = @"加购物积分";
            self.one_info_lab.text = self.myWalletModel.datetime;
            self.two_info_lab.text = self.myWalletModel.number;
            //店补总额
            self.three_info_lab.text = @"";
            if ([self.myWalletModel.integral_type isEqualToString:@"现金积分"]) {
                //现金积分
                self.four_info_lab.text = self.myWalletModel.money;
                //购物积分
                self.five_info_lab.text = @"";
            }else if ([self.myWalletModel.integral_type isEqualToString:@"购物积分"]){
                //现金积分
                self.four_info_lab.text = @"";
                //购物积分
                self.five_info_lab.text = self.myWalletModel.money;
            }
            //平台综合费
            self.six_lab.text = @"";
        }
            
            break;
        case 12:{
            self.oneName_lab.text = @"时间";
            self.twoName_lab.text = @"签约单号";
            self.three_lab.text = @"加现金积分";
            self.four_lab.text = @"";
            self.five_lab.text = @"";
            self.six_lab.text = @"";
            self.one_info_lab.text = self.myWalletModel.datetime;
            self.two_info_lab.text = self.myWalletModel.number;
            self.three_info_lab.text = self.myWalletModel.money;
            self.four_info_lab.text = @"";
            self.five_info_lab.text = @"";
            self.six_info_lab.text = @"";
        }
            
            break;
        case 13:{
              //转帐>转入
            self.oneName_lab.text = @"时间";
            self.twoName_lab.text = @"签约单号";
            self.three_lab.text = @"加现金积分";
            self.four_lab.text = @"";
            self.five_lab.text = @"";
            self.one_info_lab.text = self.myWalletModel.datetime;
            self.two_info_lab.text = self.myWalletModel.number;
            
            if ([self.myWalletModel.integral_type isEqualToString:@"现金积分"]) {
                //                扣现金积分
                self.three_info_lab.text = self.myWalletModel.money;
                
                self.four_info_lab.text = @"";
                self.five_info_lab.text = @"";
            }
            //
            self.six_lab.text = @"";
            self.six_info_lab.text = @"";
        }
            break;
        case 14:{
            //转帐>转出
            self.oneName_lab.text = @"时间";
            self.twoName_lab.text = @"签约单号";
            self.three_lab.text = @"扣现金积分";
            self.four_lab.text = @"";
            self.five_lab.text = @"";
            self.one_info_lab.text = self.myWalletModel.datetime;
            self.two_info_lab.text = self.myWalletModel.number;
            
            if ([self.myWalletModel.integral_type isEqualToString:@"现金积分"]) {
                //                扣现金积分
                self.three_info_lab.text = self.myWalletModel.money;
                
                self.four_info_lab.text = @"";
                self.five_info_lab.text = @"";
            }
            //
            self.six_lab.text = @"";
            self.six_info_lab.text = @"";
        }
            break;
        case 15:{
            //还借S积分手续费
            self.oneName_lab.text = @"时间";
            self.twoName_lab.text = @"签约单号";
            self.three_lab.text = @"扣现金积分";
            self.four_lab.text = @"";
            self.five_lab.text = @"";
            self.one_info_lab.text = self.myWalletModel.datetime;
            self.two_info_lab.text = self.myWalletModel.number;
            
            if ([self.myWalletModel.integral_type isEqualToString:@"现金积分"]) {
//                扣现金积分
                self.three_info_lab.text = self.myWalletModel.money;

                self.four_info_lab.text = @"";
                self.five_info_lab.text = @"";
            }
            //
            self.six_lab.text = @"";
            self.six_info_lab.text = @"";
        }
            break;
        case 16:{
            //还借S积分手续费
            self.oneName_lab.text = @"时间";
            self.twoName_lab.text = @"签约单号";
            self.three_lab.text = @"扣现金积分";
            self.four_lab.text = @"";
            self.five_lab.text = @"";
            self.one_info_lab.text = self.myWalletModel.datetime;
            self.two_info_lab.text = self.myWalletModel.number;
            
            if ([self.myWalletModel.integral_type isEqualToString:@"现金积分"]) {
                //                扣现金积分
                self.three_info_lab.text = self.myWalletModel.money;
                
                self.four_info_lab.text = @"";
                self.five_info_lab.text = @"";
            }
            //
            self.six_lab.text = @"";
            self.six_info_lab.text = @"";
        }
            
            break;
        case 17:
        {
            //兑换提货积分
            self.oneName_lab.text = @"时间";
            self.one_info_lab.text = self.myWalletModel.datetime;
            self.twoName_lab.text = @"账户";
            self.three_lab.text = @"扣现金积分";
            self.four_lab.text = @"加提货积分";
            self.five_lab.text = @"加S积分";
            if ([self.myWalletModel.integral_type isEqualToString:@"S积分"]) {
                self.five_info_lab.text = self.myWalletModel.money;
                self.three_info_lab.text = @"0.00";
                self.four_info_lab.text = @"0.00";
            }else if ([self.myWalletModel.integral_type isEqualToString:@"提货积分"]){
                self.four_info_lab.text = self.myWalletModel.money;
                self.three_info_lab.text = @"0.00";
                self.five_info_lab.text = @"0.00";
            }else if ([self.myWalletModel.integral_type isEqualToString:@"现金积分"]){
                self.three_info_lab.text = self.myWalletModel.money;
                self.four_info_lab.text = @"0.00";
                self.five_info_lab.text = @"0.00";
            }
        }
            break;
        case 18:{
            //现金积分扣款
            self.oneName_lab.text = @"时间";
            self.twoName_lab.text = @"签约单号";
            self.three_lab.text = @"扣现金积分";
            self.four_lab.text = @"";
            self.five_lab.text = @"";
            self.one_info_lab.text = self.myWalletModel.datetime;
            self.two_info_lab.text = self.myWalletModel.number;
            
            if ([self.myWalletModel.integral_type isEqualToString:@"现金积分"]) {
                //                扣现金积分
                self.three_info_lab.text = self.myWalletModel.money;
                
                self.four_info_lab.text = @"";
                self.five_info_lab.text = @"";
            }
            //
            self.six_lab.text = @"";
            self.six_info_lab.text = @"";
        }
            
            break;
        default:
            break;
    }
    
        [self.walletView addShadowToView:self.walletView withOpacity:0.15 shadowRadius:5 andCornerRadius:5 shadowColor:APP_purple_Color layer_w:ScreenW - 60 layer_h:340-10 layer_y:ScreenH*150/667-26];
    
}

@end
