//
//  HHStoreQuotaVC.m
//  Store
//
//  Created by User on 2018/1/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHStoreQuotaVC.h"
#import "HHDistributionUserVC.h"

@interface HHStoreQuotaVC (){
    MBProgressHUD  *hud ;
}
@property (nonatomic, strong)   NSString *shop_id;
@property (nonatomic, strong)   HHMineModel *model;
@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, strong)   HXCommonPickView *pickView;
@property (nonatomic, strong)   NSMutableArray *title_arr;
@property (nonatomic, strong)   NSMutableArray *Ids_Arr;
@end

@implementation HHStoreQuotaVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //获取数据
    [self getShopBorrowLimit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"体验店配额";
    self.datas = [NSMutableArray array];
    
}

- (void)getShopBorrowLimit{
    
    [[[HHMineAPI GetShopBorrowLimitWithshopid:nil] netWorkClient] getRequestInView: self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        [hud hideAnimated:YES];
        if (!error) {
            if (api.code == 0) {
                self.model = [HHMineModel mj_objectWithKeyValues:api.data];
                HJSettingItem *item1_0 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                item1_0.detailTitle = self.model.total;
                HJSettingItem *item1_1 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                item1_1.detailTitle = self.model.surplus_total;
                HJSettingItem *item1_2 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
                item1_2.detailTitle = self.model.real_newuser_count;
                HJSettingItem *item1_3 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
                item1_3.detailTitle = self.model.newuser_count;
                HJSettingItem *item1_4 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]];
                item1_4.detailTitle = self.model.used_newuser_count;
                HJSettingItem *item1_5 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:5 inSection:1]];
                item1_5.detailTitle = self.model.seckill_count;
                HJSettingItem *item1_6 = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:6 inSection:1]];
                item1_6.detailTitle = self.model.used_seckill_count;
                [self.tableV reloadData];
            }else{
                [SVProgressHUD showInfoWithStatus:api.msg];
            }
        }
    }];
    
}
- (NSArray *)groupTitles{
    
    return @[@[@"分配用户"],@[@"总配额数",@"剩余配额数",@"实际奖励配额数",@"奖励配额数",@"已使用奖励配额数",@"秒抢配额数",@"已使用秒抢配额数"]];
    
}
- (NSArray *)groupIcons {
    
   return @[@[@""],@[@"",@"",@"",@"",@"",@"",@""]];

}
- (NSArray *)groupDetials{
    
     return @[@[@""],@[@"",@"",@"",@"",@"",@"",@""]];
    
}
- (NSArray *)indicatorIndexPaths{
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:0 inSection:0]];
    
    return indexPaths;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        HHDistributionUserVC *vc = [HHDistributionUserVC new];
        vc.distrb_type = HHdistribe_type_user;
        [self.navigationController pushVC:vc];
    }
    
}
@end
