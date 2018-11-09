//
//  HHContractManagerVCTableViewController.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHContractManagerVC.h"
#import "HHShareEntrepreneurshipVC.h"
#import "HHTeamListSubVC.h"


@interface HHContractManagerVC()

@property (nonatomic,strong) HHMineModel *contractModel;

@end

@implementation HHContractManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"签约单管理";

    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200) backColor:KVCBackGroundColor];
    
    UIButton *saveBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 45, SCREEN_WIDTH-60, 45) target:self action:@selector(saveBtnAction) image:nil];
    [saveBtn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
    [saveBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [saveBtn setTitle:@"分享创业额" forState:UIControlStateNormal];
    [saveBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [footView addSubview:saveBtn];
    
    UIButton *listBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, CGRectGetMaxY(saveBtn.frame)+20, SCREEN_WIDTH-60, 45) target:self action:@selector(listBtnAction) image:nil];
    [listBtn lh_setCornerRadius:5 borderWidth:1 borderColor:APP_COMMON_COLOR];
    [listBtn setTitle:@"团队列表" forState:UIControlStateNormal];
    [listBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [listBtn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
    [footView addSubview:listBtn];
    
    self.tableV.tableFooterView = footView;
    
    //获取数据
    [self getDatas];

}
- (void)getDatas{
    
    [[[HHMineAPI GetUserSignDetailWithsignno:self.signno] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
       
        if (!error) {
            
            if (api.code == 0) {
                
                self.contractModel = [HHMineModel mj_objectWithKeyValues:api.data];
                //账户
                HJSettingItem *item0_0 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                item0_0.title = self.contractModel.display_no;
                item0_0.detailTitle = self.contractModel.username;
                //协议日期
                HJSettingItem *item1_0 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                item1_0.detailTitle = self.contractModel.datetime;
                //资质
                HJSettingItem *item1_1 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                item1_1.detailTitle = self.contractModel.sign_type;
                //服务经理
                HJSettingItem *item1_2 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
                item1_2.detailTitle =  [NSString stringWithFormat:@"%@，%@",self.contractModel.parent_username,self.contractModel.parent_name];
                //归属体验店编号
                HJSettingItem *item1_3 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
                item1_3.detailTitle = self.contractModel.parent_shopno;
                //体验店编号
                HJSettingItem *item1_4 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]];
                item1_4.detailTitle = self.contractModel.shopno;
     
                
                //身份
                HJSettingItem *item2_0 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
                item2_0.detailTitle = self.contractModel.sign_level;
                //已发放消费分利
                HJSettingItem *item2_1 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
                item2_1.detailTitle = self.contractModel.grant_signprofit;
                //个人分享创业额
                HJSettingItem *item2_2 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]];
                item2_2.detailTitle = self.contractModel.reward_ach_total;
                //团队总分享创业额
                HJSettingItem *item2_3 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:3 inSection:2]];
                item2_3.detailTitle = self.contractModel.ach_total;
                //已发分享创业收益A
                HJSettingItem *item2_4 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:4 inSection:2]];
                item2_4.detailTitle = self.contractModel.grant_a_profit;
                //已发分享创业收益B
                HJSettingItem *item2_5 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:5 inSection:2]];
                item2_5.detailTitle = self.contractModel.grant_b_profit;
                [self.tableV reloadData];
            }
        }
    }];
    
    
}
- (void)saveBtnAction{
    
    HHShareEntrepreneurshipVC  *vc = [HHShareEntrepreneurshipVC new];
    vc.signno = self.contractModel.sign_no;
    vc.reward_ach_total  = self.contractModel.reward_ach_total;
    [self.navigationController pushVC:vc];
    
}
- (void)listBtnAction{
    
    HHTeamListSubVC *vc = [HHTeamListSubVC new];
    vc.signno = self.contractModel.sign_no;
    vc.userid = self.contractModel.userid;
    [self.navigationController pushVC:vc];

}
- (NSArray *)groupTitles{
    
    return @[@[@""],@[@"协议日期",@"资质",@"服务经理",@"归属体验店编号",@"体验店编号"],@[@"身份",@"已发消费分利",@"个人分享创业额",@"团队总分享创业额",@"已发分享创业收益A",@"已发分享创业收益B"]];
    
}
- (NSArray *)groupIcons {
    
    return @[@[@"icon_sign_username_default"],@[@"",@"",@"",@"",@""],@[@"",@"",@"",@"",@"",@""]];

}
- (NSArray *)groupDetials{
    
    return @[@[@""],@[@"",@"",@"",@"",@""],@[@"",@"",@"",@"",@"",@""]];
}

@end
