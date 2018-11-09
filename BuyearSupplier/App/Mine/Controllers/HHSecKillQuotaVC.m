//
//  HHSecKillQuotaVC.m
//  Store
//
//  Created by User on 2018/4/20.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHSecKillQuotaVC.h"

@interface HHSecKillQuotaVC ()
@property (nonatomic, strong)   HHMineModel *model;

@end

@implementation HHSecKillQuotaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"配额数量";
   
    [self getSecKillQuotaData];
}
- (void)getSecKillQuotaData{
    
    [[[HHMineAPI GetShopBorrowLimitWithshopid:nil] netWorkClient] getRequestInView: self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.code == 0) {
                self.model = [HHMineModel mj_objectWithKeyValues:api.data];
                HJSettingItem *item1_0 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                item1_0.detailTitle = self.model.total;
                HJSettingItem *item1_1 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                item1_1.detailTitle = self.model.surplus_total;
                HJSettingItem *item1_3 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                item1_3.detailTitle = self.model.newuser_count;
                HJSettingItem *item1_4 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                item1_4.detailTitle = self.model.used_newuser_count;
                HJSettingItem *item1_5 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                item1_5.detailTitle = self.model.seckill_count;
                HJSettingItem *item1_6 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
                item1_6.detailTitle = self.model.used_seckill_count;
                [self.tableV reloadData];
            }else{
                [SVProgressHUD showInfoWithStatus:api.msg];
            }
        }
    }];

}
- (NSArray *)groupTitles{
    
            return @[@[@"总配额数",@"剩余配额数",@"奖励配额数",@"已使用奖励配额数",@"秒抢配额数",@"已使用秒抢配额数"]];
//        return @[@[@"秒抢配额",@"奖励配额"]];
}
- (NSArray *)groupIcons {
    
  return @[@[@"",@"",@"",@"",@"",@""]];
}
- (NSArray *)groupDetials{
    
    return @[@[@"",@"",@"",@"",@"",@""]];

}
@end
