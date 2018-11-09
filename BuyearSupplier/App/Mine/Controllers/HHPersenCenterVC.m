//
//  PersenCenterVC.m
//  CredictCard
//
//  Created by User on 2017/12/12.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHPersenCenterVC.h"
#import "HXMineHeadView.h"
#import "HHCommentSection.h"
#import "HXTeacherCenterCell.h"
#import "HHAccontInfoVC.h"
#import "HHMyOrderVC.h"
#import "HHMyWalletVC.h"
#import "HHStoreSubsidyVC.h"
#import "HHMyOrderVC.h"
#import "HHStoreQuotaVC.h"
#import "HHLoginVC.h"
#import "HHStoreQRVC.h"
#import "HHModifyInfoVC.h"
#import "HHSettlementCodeAlertView.h"
#import "HHRatifyAccordSuperVC.h"
#import "HHFillLogisticsVC.h"
#import "HHSecKillQuotaVC.h"
#import "HHShareCountVC.h"
#import "HHPrimeContractVC.h"

@interface HHPersenCenterVC ()<HXTeacherCenterCellProtocol>
@property(nonatomic,strong) HXMineHeadView *mineHeadView;
@property(nonatomic,strong) HHMineModel  *mineModel;
@end
@implementation HHPersenCenterVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //是否登录
    HJUser *user = [HJUser sharedUser];
    if (user.token.length == 0) {
        //未登录
        HHLoginVC *vc = [[HHLoginVC alloc] initWithNibName:@"HHLoginVC" bundle:nil];
        vc.tabBarVC = (HJTabBarController *)self.tabBarController;
        vc.tabSelectIndex = 3;
        HJNavigationController *nav = [[HJNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        
    }else{
        [self getDatas];
    }
}
- (void)acceptNotice:(NSNotification *)noti{
       //获取数据
       [self getDatas];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptNotice:) name:kNotificationModifySuccess object:nil];
    
    [self.tableV registerClass:[HXTeacherCenterCell class] forCellReuseIdentifier:@"HXTeacherCenterCell"];

      self.mineHeadView.nameLabel.text = @"";
      self.mineHeadView.IDLabel.text = @"";
    NSArray *titiles = @[@"现金积分",@"购物积分",@"S积分",@"提货积分"];
    NSArray *counts = @[@"0",@"0",@"0",@"0"];
    for(NSInteger i = 0 ;i<4;i++){
    NSInteger row = i/2;
    NSInteger line = i%2;
    CGFloat height = WidthScaleSize_H(75);
    CGFloat width = SCREEN_WIDTH/2 - 1;
    CGFloat section_x = line*width;
    CGFloat section_y = row*height;
     HHCommentSection  *section = [[HHCommentSection alloc]initWithFrame:CGRectMake(section_x,section_y, width, height)];
        section.userInteractionEnabled = YES;
        section.tag = i+10000;
        section.titleLabel.text = counts[i];
        section.countLabel.text = titiles[i];
        section.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.mineHeadView.bottomView addSubview:section];
    }
    UIView *vertiLine = [UIView lh_viewWithFrame:CGRectMake(SCREEN_WIDTH/2 - 1, 0, 1, WidthScaleSize_H(150)) backColor:[UIColor colorWithHexString:@"#382c59"]];
    UIView *horizLine = [UIView lh_viewWithFrame:CGRectMake(0, WidthScaleSize_H(75), ScreenW, 1) backColor:[UIColor colorWithHexString:@"#382c59"]];
    [self.mineHeadView.bottomView addSubview:vertiLine];
    [self.mineHeadView.bottomView addSubview:horizLine];
    
    self.tableV.tableHeaderView = self.mineHeadView;
    UIButton *rightBtn = [UIButton lh_buttonWithFrame:CGRectMake(0, 20, 40, 44) target:self action:@selector(setBtnAction) image:[UIImage imageNamed:@"icon_set_user_default"]];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -15)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    [self addHeadRefresh];
}
- (void)addHeadRefresh{
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDatas];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    self.tableV.mj_header = refreshHeader;
}
- (void)setBtnAction{
    
    HHModifyInfoVC *vc = [HHModifyInfoVC new];
    vc.phoneNum = self.mineModel.mobile;
    vc.userIcon = self.mineModel.usericon;
    [self.navigationController pushVC:vc];

}
- (void)getDatas{
    
    NetworkClient *netWorkClient = [[HHMineAPI GetUserDetail] netWorkClient];
    
    dispatch_semaphore_t  semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    
    dispatch_group_async(group, globalQueue, ^{
        
        netWorkClient.manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataDontLoad;
        
        [netWorkClient getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
            if ([self.tableV.mj_header isRefreshing]) {
                [self.tableV.mj_header endRefreshing];
            }
            if (!error) {
                if (api.code == 0) {
                    
                    self.mineModel = [HHMineModel mj_objectWithKeyValues:api.data];
                    //现金积分
                    HHCommentSection  *section0 = [self.view viewWithTag:10000];
                    section0.titleLabel.text =  self.mineModel.money_integral;
                    //购物积分
                    HHCommentSection  *section1 = [self.view viewWithTag:10001];
                    section1.titleLabel.text = self.mineModel.shopping_integral;
                    //S积分
                    HHCommentSection  *section2 = [self.view viewWithTag:10002];
                    section2.titleLabel.text = self.mineModel.s_integral;
                    
                    //提货积分
                    HHCommentSection  *section3 = [self.view viewWithTag:10003];
                    section3.titleLabel.text = self.mineModel.picking_integral;
                    
                    //姓名
                    self.mineHeadView.nameLabel.text = self.mineModel.username;
                    //ID
                    self.mineHeadView.IDLabel.text = self.mineModel.userid?[NSString stringWithFormat:@"ID:%@",self.mineModel.userid]:@"";
                    [self.mineHeadView.teacherImageIcon sd_setImageWithURL:[NSURL URLWithString:self.mineModel.usericon]];
                    self.mineHeadView.signRight_value_Label.text =   self.mineModel.options?[NSString stringWithFormat:@"%.2lf",self.mineModel.options.doubleValue]:@"0.00";

                    if ([self.mineModel.level isEqualToString:@"3"]) {
                        //体验店
                        [self setGroups];
                        [self.tableV reloadData];
                    }else  {
                        //
                        [self setGroups];
                        [self.tableV reloadData];
                    }
                    HJUser *user = [HJUser sharedUser];
                    user.level = self.mineModel.level;
                    user.is_login_shop = self.mineModel.is_login_shop;
                    user.login_userid = self.mineModel.login_userid;
                    user.login_username = self.mineModel.login_username;
                    user.ship_channel = self.mineModel.ship_channel;
                    [user write];
                    
                    dispatch_semaphore_signal(semaphore);
                    
                }else if (api.code == 2){
                    //未登录
                    HHLoginVC *vc = [[HHLoginVC alloc] initWithNibName:@"HHLoginVC" bundle:nil];
                    vc.tabBarVC = (HJTabBarController *)self.tabBarController;
                    vc.tabSelectIndex = 3;
                    HJNavigationController *nav = [[HJNavigationController alloc] initWithRootViewController:vc];
                    [self presentViewController:nav animated:YES completion:nil];
                    dispatch_semaphore_signal(semaphore);

                }else{
                    [SVProgressHUD showInfoWithStatus:api.msg];
                    dispatch_semaphore_signal(semaphore);

                }
            }else{
                if ([error.localizedDescription isEqualToString:@"似乎已断开与互联网的连接。"]||[error.localizedDescription  containsString:@"请求超时"]) {
                    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                    [SVProgressHUD showInfoWithStatus:@"网络竟然崩溃了～"];
                }
                dispatch_semaphore_signal(semaphore);
            }
        }];
    });
    
    dispatch_group_notify(group, globalQueue, ^{
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            netWorkClient.manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
            
            [netWorkClient getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
                
                if ([self.tableV.mj_header isRefreshing]) {
                    [self.tableV.mj_header endRefreshing];
                }
                if (!error) {
                    if (api.code == 0) {
                        self.mineModel = [HHMineModel mj_objectWithKeyValues:api.data];
                        //现金积分
                        HHCommentSection  *section0 = [self.view viewWithTag:10000];
                        section0.titleLabel.text =  self.mineModel.money_integral;
                        //购物积分
                        HHCommentSection  *section1 = [self.view viewWithTag:10001];
                        section1.titleLabel.text = self.mineModel.shopping_integral;
                        //S积分
                        HHCommentSection  *section2 = [self.view viewWithTag:10002];
                        section2.titleLabel.text = self.mineModel.s_integral;
                        //提货积分
                        HHCommentSection  *section3 = [self.view viewWithTag:10003];
                        section3.titleLabel.text = self.mineModel.picking_integral;
                        //姓名
                        self.mineHeadView.nameLabel.text = self.mineModel.username;
                        //ID
                        self.mineHeadView.IDLabel.text = [NSString stringWithFormat:@"ID:%@",self.mineModel.userid];
                        [self.mineHeadView.teacherImageIcon sd_setImageWithURL:[NSURL URLWithString:self.mineModel.usericon]];
                        
                        if ([self.mineModel.level isEqualToString:@"3"]) {
                            //体验店
                            [self setGroups];
                            [self.tableV reloadData];
                        }else  {
                            //
                            [self setGroups];
                            [self.tableV reloadData];
                        }
                        HJUser *user = [HJUser sharedUser];
                        user.level = self.mineModel.level;
                        user.is_login_shop = self.mineModel.is_login_shop;
                        user.login_userid = self.mineModel.login_userid;
                        user.login_username = self.mineModel.login_username;
                        user.ship_channel = self.mineModel.ship_channel;
                        [user  write];
                        
                    }else if (api.code == 2){
                        //未登录
                        HHLoginVC *vc = [[HHLoginVC alloc] initWithNibName:@"HHLoginVC" bundle:nil];
                        vc.tabBarVC = (HJTabBarController *)self.tabBarController;
                        vc.tabSelectIndex = 3;
                        HJNavigationController *nav = [[HJNavigationController alloc] initWithRootViewController:vc];
                        [self presentViewController:nav animated:YES completion:nil];
                        
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
            
        });
        
    });

}

//签署协议
- (void)pushRatifyAccord{

    HHRatifyAccordSuperVC *vc = [HHRatifyAccordSuperVC new];
    [self.navigationController pushVC:vc];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
    
      HXTeacherCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HXTeacherCenterCell"];
        cell.nav = self.navigationController;
        cell.delegate = self;
        return cell;
        
    }else{
        
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0){
        
        CGFloat imagW = (SCREEN_WIDTH)/3 - WidthScaleSize_W(2);
        CGFloat imagH = 75;
        
        return 2*imagH + WidthScaleSize_H(12);
        
    }else{
        
        return WidthScaleSize_H(50);
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            HHAccontInfoVC *vc = [HHAccontInfoVC new];
            [self.navigationController pushVC:vc];
        }else if(indexPath.row == 1){
            
            HHMyOrderVC *vc = [HHMyOrderVC new];
            [self.navigationController pushVC:vc];
            
        }else if(indexPath.row == 2){
            HHMyWalletVC *vc = [HHMyWalletVC new];
            vc.userid = self.mineModel.userid;
            [self.navigationController pushVC:vc];
        }else if(indexPath.row == 3){
            //分享成功数量
            HHShareCountVC *vc = [HHShareCountVC new];
            vc.referrer_count = self.mineModel.referrer_count;
            vc.titleStr = @"分享成功数量";
            [self.navigationController pushVC:vc];
        }else if(indexPath.row == 4){
            if ([self.mineModel.level isEqualToString:@"3"]) {
                //体验店   促销限购资格数
                HHShareCountVC *vc = [HHShareCountVC new];
                vc.referrer_count = self.mineModel.buy_group_pro_count;
                vc.titleStr = @"促销限购资格数";
                [self.navigationController pushVC:vc];
            }else{
                //秒杀配额
                HHSecKillQuotaVC *vc = [HHSecKillQuotaVC new];
                [self.navigationController pushVC:vc];
            }
        }else if(indexPath.row == 5){
            //秒杀配额
            HHSecKillQuotaVC *vc = [HHSecKillQuotaVC new];
            [self.navigationController pushVC:vc];
        }
    }else{
        
        if ([self.mineModel.level isEqualToString:@"3"]) {
            //体验店
            if(indexPath.row == 0){
                //体验店店补
                HHStoreSubsidyVC *vc = [HHStoreSubsidyVC new];
                [self.navigationController pushVC:vc];
                
            }else if(indexPath.row == 1){
                //            体验店配额
                HHStoreQuotaVC *vc = [HHStoreQuotaVC new];
                [self.navigationController pushVC:vc];
                
            }else if (indexPath.row == 2){
                //体验店二维码
                HHStoreQRVC *vc = [HHStoreQRVC new];
                vc.qrcode_url = self.mineModel.qrcode_url;
                [self.navigationController pushVC:vc];
            }else if (indexPath.row == 3){
                //充值签约额
                HHPrimeContractVC *vc = [HHPrimeContractVC new];
                vc.is_entity_shop = self.mineModel.is_entity_shop;
                vc.userid = self.mineModel.userid;
                [self.navigationController pushVC:vc];
            }
        }else{
            if(indexPath.row == 0){
               //充值签约额
                HHPrimeContractVC *vc = [HHPrimeContractVC new];
                vc.is_entity_shop = self.mineModel.is_entity_shop;
                [self.navigationController pushVC:vc];
            }
        }

      
    }
    
}
- (NSArray *)groupTitles{
    
    if ([self.mineModel.level isEqualToString:@"3"]) {
        //体验店
        return @[@[@""],@[@"账户信息",@"我的订单",@"我的钱包",@"成功分享数量",@"促销限购资格数",@"配额数量"],@[@"体验店店补",@"体验店配额",@"体验店二维码",@"签约权"]];
          }else{
        return @[@[@""],@[@"账户信息",@"我的订单",@"我的钱包",@"成功分享数量",@"配额数量"],@[@"签约权"]];
            }
        return @[@[@""],@[@"账户信息",@"我的订单",@"我的钱包",@"成功分享数量",@"促销限购资格数",@"配额数量"],@[@"体验店店补",@"体验店配额",@"体验店二维码",@"签约权"]];
    
}
- (NSArray *)groupIcons {
    
    if ([self.mineModel.level isEqualToString:@"3"]) {
        //体验店
        return @[@[@""],@[@"icon_users_user_default",@"icon_lists_user_default",@"icon_wallet_user_default",@"icon_lshare_user_default",@"qualification",@"icon_clock_user_default"],@[@"icon_shops_user_default",@"icon_allot_user_default",@"icon_qrcodes_user_default",@"primeContract"]];

    }else  {
        //
        return @[@[@""],@[@"icon_users_user_default",@"icon_lists_user_default",@"icon_wallet_user_default",@"icon_lshare_user_default",@"icon_clock_user_default"],@[@"primeContract"]];

    }
    
    return @[@[@""],@[@"icon_users_user_default",@"icon_lists_user_default",@"icon_wallet_user_default",@"icon_lshare_user_default",@"qualification",@"icon_clock_user_default",@"primeContract"]];

}
- (NSArray *)groupDetials{
    
    if ([self.mineModel.level isEqualToString:@"3"]) {
        //体验店
        return @[@[@""],@[@"",@"",@"",@"",@"",@""],@[@"",@"",@"",@""]];
        
    }else  {
        //
        return @[@[@""],@[@"",@"",@"",@"",@""],@[@""]];
        
    }
    return @[@[@""],@[@"",@"",@"",@"",@"",@""],@[@"",@"",@"",@""]];

}
- (HXMineHeadView *)mineHeadView {
    
    if (!_mineHeadView) {
        _mineHeadView = [[HXMineHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  WidthScaleSize_H(20)+WidthScaleSize_W(100)+5+WidthScaleSize_H(50)+WidthScaleSize_H(150))];
    }
    
    return _mineHeadView;
}



@end
