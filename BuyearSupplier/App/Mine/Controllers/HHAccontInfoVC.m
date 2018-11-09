//
//  HHAccontInfoVC.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHAccontInfoVC.h"
#import "HHShippingAddressVC.h"
#import "HHMyBankCardVC.h"
#import "HHModifyPdSuperVC.h"
#import "HHModifyPdSuperVC.h"
#import "HHAuthenticationSuperVC.h"
#import "HHCashIntegralTranferVC.h"
#import "HHCurrentStoreVC.h"

@interface HHAccontInfoVC ()
{
    HHMineModel *model;
}
@end

@implementation HHAccontInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"账户信息";
    
    [self getDatas];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptNoti) name:kNotificationCertified object:nil];
    
}
- (void)acceptNoti{
    
    [self getDatas];

}
- (void)getDatas{
    
    [[[HHMineAPI GetUserDetail] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
       
        if (!error) {
            if (api.code == 0) {
                model = [HHMineModel mj_objectWithKeyValues:api.data];
                HJSettingItem *item0_0 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                item0_0.title = model.userid;
                item0_0.detailTitle = model.username;
                
                HJSettingItem *item1_0 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                item1_0.detailTitle = [NSString stringWithFormat:@"%@,%@",model.parent_userid,model.parent_username];
                HJSettingItem *item1_1 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                item1_1.detailTitle = model.email?model.email:@"未填写";

                HJSettingItem *item1_2 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
                item1_2.detailTitle =  model.mobile?model.mobile:@"";

                HJSettingItem *item1_3 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
                item1_3.detailTitle = model.idcard?model.idcard:@"";

                [self.tableV reloadData];
            }else{
                [SVProgressHUD showInfoWithStatus:api.msg];
            }
        }else{
            if ([error.localizedDescription isEqualToString:@"似乎已断开与互联网的连接。"]||[error.localizedDescription  containsString:@"请求超时"]) {
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showInfoWithStatus:@"网络竟然崩溃了～"];
                
            }
        }
    }];
    
    
}
- (void)saveBtnAction{
    
    
    
}
- (NSArray *)groupTitles{
    
    HJUser *user = [HJUser sharedUser];
    NSString * consumptionSource=@"消费来源";
    if ([user.level isEqualToString:@"0"]) {
        consumptionSource=@"消费来源";
    }else{
        consumptionSource=@"折扣来源";
    }
    return @[@[@""],@[consumptionSource,@"电子邮件",@"电话",@"证件号"],@[@"管理收货地址",@"管理银行卡",@"修改密码",@"实名认证",@"现金积分兑换",@"当前店长账号"]];
    
}
- (NSArray *)groupIcons {
    
    return @[@[@"icon_sign_username_default"],@[@"",@"",@"",@""],@[@"",@"",@"",@"",@"",@""]];

}
- (NSArray *)groupDetials{
    
    return @[@[@""],@[@"",@"未填写",@"",@""],@[@"",@"",@"",@"",@"",@""]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.textLabel.textColor = APP_purple_Color;
    }else if (indexPath.section == 1){
        if (indexPath.row == 2) {
            //
            cell.detailTextLabel.textColor = APP_purple_Color;
        }
    }
        
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
          //管理收货地址
            HHShippingAddressVC *vc = [HHShippingAddressVC new];
            [self.navigationController pushVC:vc];
            
        }else if (indexPath.row == 1){
         //管理银行卡
            HHMyBankCardVC *vc = [HHMyBankCardVC new];
            vc.useridStr = model.userid;
            [self.navigationController pushVC:vc];
            
        }else if (indexPath.row == 2){
          //修改密码
            HHModifyPdSuperVC *vc = [HHModifyPdSuperVC new];
            [self.navigationController pushVC:vc];
            
        }else if (indexPath.row == 3){
          //实名认证
            HHAuthenticationSuperVC *vc = [HHAuthenticationSuperVC new];
            vc.status = model.status;
            [self.navigationController pushVC:vc];
        }else if (indexPath.row ==4){
            //积分兑换
            HHCashIntegralTranferVC *vc = [HHCashIntegralTranferVC new];
            vc.mineModel = model;
            [self.navigationController pushVC:vc];
        }else if (indexPath.row ==5){
            //当前体验店
            HHCurrentStoreVC *vc = [HHCurrentStoreVC new];
            vc.store_num =  model.login_userid;
            [self.navigationController pushVC:vc];
        }
        
    }
    
}
@end
