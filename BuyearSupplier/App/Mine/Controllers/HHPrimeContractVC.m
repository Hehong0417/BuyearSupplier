//
//  HHPrimeContractVC.m
//  Store
//
//  Created by User on 2018/7/28.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHPrimeContractVC.h"
#import "HHDistributionUserVC.h"
#import "HHSignedQuotaAssignListVC.h"

@interface HHPrimeContractVC ()

@end

@implementation HHPrimeContractVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"签约权";
    
    [self GetSignedQuota];
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180) backColor:KVCBackGroundColor];
    
    if ([self.is_entity_shop isEqualToString:@"1"]) {
        UIButton *saveBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 45, SCREEN_WIDTH-60, 45) target:self action:@selector(saveBtnAction) image:nil];
        [saveBtn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
        [saveBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
        [saveBtn setTitle:@"签约权分配记录" forState:UIControlStateNormal];
        [saveBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [footView addSubview:saveBtn];
        self.tableV.tableFooterView =  footView;
    }
 }
- (void)saveBtnAction{

    HHSignedQuotaAssignListVC  *vc = [HHSignedQuotaAssignListVC new];
    vc.userid = self.userid;
    [self.navigationController pushVC:vc];
    
}
- (void)GetSignedQuota{
    
    [[[HHMineAPI GetSignedQuota] netWorkClient] getRequestInView: self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.code == 0) {
                HHMineModel *model = [HHMineModel mj_objectWithKeyValues:api.data];
                if ([self.is_entity_shop isEqualToString:@"1"]) {
                HJSettingItem *item1_0 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                item1_0.detailTitle = model.usable_quota;
                }else{
                    HJSettingItem *item1_0 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    item1_0.detailTitle = model.usable_quota;
                }
                [self.tableV reloadData];
            }else{
                [SVProgressHUD showInfoWithStatus:api.msg];
            }
        }
    }];
    
}
- (NSArray *)groupTitles{
    
    if ([self.is_entity_shop isEqualToString:@"1"]) {
        return @[@[@"分配签约权"],@[@"可用签约权"]];
    }else{
        return @[@[@"可用签约权"]];
    }
}
- (NSArray *)groupIcons {
    
    if ([self.is_entity_shop isEqualToString:@"1"]) {
        return @[@[@""],@[@""]];
    }else{
        return @[@[@""]];
    }
}
- (NSArray *)groupDetials{
    
    if ([self.is_entity_shop isEqualToString:@"1"]) {
        return @[@[@""],@[@""]];
    }else{
        return @[@[@""]];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if ([self.is_entity_shop isEqualToString:@"1"]) {
          HHDistributionUserVC *vc = [HHDistributionUserVC new];
          vc.distrb_type = HHdistribe_type_sign;
          [self.navigationController pushVC:vc];
        }
    }
    
}
@end
