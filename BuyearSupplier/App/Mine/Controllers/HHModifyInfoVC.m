//
//  HHModifyInfoVC.m
//  CredictCard
//
//  Created by User on 2017/12/18.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHModifyInfoVC.h"
//#import "HHUserInfoModel.h"
#import "HHLoginVC.h"
#import "HHAboutUsVC.h"

@interface HHModifyInfoVC ()<UITextFieldDelegate>

@end

@implementation HHModifyInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) backColor:kClearColor];
    
    UIButton *finishBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 50, SCREEN_WIDTH - 60, 45) target:self action:@selector(saveAction:) backgroundImage:nil title:@"退出登录"  titleColor:kWhiteColor font:FONT(14)];
    finishBtn.backgroundColor = kRedColor;
    [finishBtn lh_setRadii:5 borderWidth:0 borderColor:nil];
    
    [footView addSubview:finishBtn];
    
    self.tableV.tableFooterView = footView;
    
    
    NSInteger size = [[SDImageCache sharedImageCache] getSize];
    CGFloat M = size/1024/1024;
    HJSettingItem *item = [self settingItemInIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    item.detailTitle = [NSString stringWithFormat:@"%.2fM",M];

}

//退出登录
- (void)saveAction:(UIButton *)btn{
    btn.enabled = NO;
    [btn lh_setBackgroundColor:KA0LabelColor forState:UIControlStateNormal];
    MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = KA0LabelColor;
    hud.detailsLabelText = @"注销中...";
    hud.detailsLabelColor = kWhiteColor;
    hud.detailsLabelFont = FONT(14);
    hud.activityIndicatorColor = kWhiteColor;
    [hud show:YES];
    
    [[[HHMineAPI UserLogout] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        btn.enabled = YES;
        [btn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
        [hud hideAnimated:YES];
        if (!error) {
            if (api.code == 0) {
                
                [self logoutSuccess];
                
            }else{
                
                [SVProgressHUD showInfoWithStatus:api.msg];
            }
        }else{
            
            if ([error.localizedDescription isEqualToString:@"似乎已断开与互联网的连接。"]||[error.localizedDescription  containsString:@"请求超时"]) {
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showInfoWithStatus:@"网络不可用，请稍后重试～"];
                
            }
            
        }
        
    }];
 
}
- (void)logoutSuccess{
    
    HJUser *user = [HJUser sharedUser];
    user.token = @"";
    [user write];
    [self.navigationController popToRootVC];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.cellHeadImageView sd_setImageWithURL:[NSURL URLWithString:self.userIcon]];

    return [super tableView:tableView cellForRowAtIndexPath:indexPath];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [super tableView:tableView didSelectRowAtIndexPath:indexPath];

        }else if (indexPath.row == 1){
            //手机号码
            
        }else if (indexPath.row == 2){
            //关于我们
            HHAboutUsVC *vc = [HHAboutUsVC new];
            [self.navigationController pushVC:vc];
        }
    }else if (indexPath.section == 1) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"确定清除缓存吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            HJSettingItem *item = [self settingItemInIndexPath:indexPath];
            [[SDImageCache sharedImageCache] clearMemory];
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
            item.detailTitle = [NSString stringWithFormat:@"0.00M"];
            [self.tableV reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [alertC dismissViewControllerAnimated:YES completion:nil];
            
        }];
        [alertC addAction:action1];
        [alertC addAction:action2];
        [self presentViewController:alertC animated:YES completion:nil];
        
    }
}
- (NSArray *)groupTitles{
    
    return @[@[@"头像",@"手机号码",@"关于我们"],@[@"清除缓存"]];
    
}
- (NSArray *)groupIcons {
    
    return @[@[@"",@"",@""],@[@""]];
}
- (NSArray *)groupDetials{
    
    return @[@[@"",self.phoneNum?self.phoneNum:@"",@""],@[@""]];

}

- (NSIndexPath *)headImageCellIndexPath{
    
    return [NSIndexPath indexPathForRow:0 inSection:0];
}
- (NSArray *)indicatorIndexPaths{
    
    NSArray *indexsPaths = @[[NSIndexPath indexPathForRow:1 inSection:0],[NSIndexPath indexPathForRow:2 inSection:0],[NSIndexPath indexPathForRow:0 inSection:1]];
    return indexsPaths;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0&&indexPath.row == 0) {
        return WidthScaleSize_H(75);
    }
    
    return 44;
    
}
@end
