//
//  HHHomePageVC.m
//  Store
//
//  Created by User on 2018/1/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHHomePageVC.h"
#import "HHCollectionReusableHead.h"
#import "HXCollectionLevelHead.h"
#import "HXHomeCollectionCell.h"
#import "HXCollectionFootView.h"
#import "HHGoodBaseViewController.h"
#import "HHAddressAPI.h"
#import "HHGoodListVC.h"
#import "HHCurrentStoreVC.h"
#import "HHSelectChannelAlertView.h"
#import "HHSecKillAPI.h"
#import "HHSecKillModel.h"
#import "HHUrlModel.h"



@interface HHHomePageVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>
{
    UIView *nav;
}
@property (nonatomic, strong)   UICollectionView *collectionView;
@property (nonatomic, strong)   NSArray *levelArr;
@property (nonatomic, strong)   HHHomeModel *model;
@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, strong)   NSMutableArray *shufflingLists;
@property (nonatomic, strong)   NSMutableArray *shufflingModelLists;
@property(nonatomic,strong)    HHSelectChannelAlertView *alertView;
@property(nonatomic,strong)    HHSecKillModel *secKill_model;
@property(nonatomic,strong)     UILabel *channel_label;



@end

@implementation HHHomePageVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBarHidden = YES;
    
    //注册一个通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFY_ACT_INFO object:nil];
    
    //多个请求顺序执行
    [self requestSequenceExe];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBarHidden = NO;

}
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.datas = [NSMutableArray array];
    
    self.shufflingLists = [NSMutableArray array];
    
    self.shufflingModelLists = [NSMutableArray array];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    [self setNeedsStatusBarAppearanceUpdate];
    
    CGFloat h = Status_HEIGHT+44;
    CGFloat y = Status_HEIGHT;

    nav = [[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenW, h)];
    nav.backgroundColor = kWhiteColor;
    [self.view addSubview:nav];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0,y, 100, 44)];
    titleLab.textColor = kBlackColor;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = FONT(18);
    titleLab.text = @"百业惠";
    titleLab.centerX = nav.centerX;
    [nav addSubview:titleLab];
    //切换
    [self addExchangeView];
    //搜索
    XYQButton *searchBtn = [XYQButton ButtonWithFrame:CGRectMake(0,y, 40, 40) imgaeName:@"shousuo" titleName:@"搜索" contentType:TopImageBottomTitle buttonFontAttributes:[FontAttributes fontAttributesWithFontColor:KLightTitleColor fontsize:8] title_image_padding:5 tapAction:^(XYQButton *button) {
        [self searchAction];
    }];
    searchBtn.centerX = ScreenW - 15;

    [nav addSubview:searchBtn];
    
    //collectionView
    self.collectionView.backgroundColor = KVCBackGroundColor;
    [self.view addSubview:self.collectionView];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HXHomeCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"HXHomeCollectionCell"];
    
    [self.collectionView registerClass:[HHCollectionReusableHead class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HHCollectionReusableHead"];
    
    [self.collectionView registerClass:[HXCollectionLevelHead class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HXCollectionLevelHead"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HXCollectionFootView" bundle:nil]  forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HXCollectionFootView"];
    
    self.levelArr = @[@"2F · 鞋镜箱包",@"3F · 珠宝首饰",@"4F · 服装配饰",@"5F · 布艺家纺",@"6F · 餐厨日用",@"7F · 食品健康",];
    
    [self addHeadRefresh];

}
- (void)addExchangeView{
    
    UIView *exchangeView = [[UIView alloc] initWithFrame:CGRectMake(0, Status_HEIGHT, 80, 44)];
    exchangeView.userInteractionEnabled = YES;
    [nav addSubview:exchangeView];

    self.channel_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 80, 14)];
    self.channel_label.font = BoldFONT(9);
    self.channel_label.textColor = KLightTitleColor;
    self.channel_label.textAlignment = NSTextAlignmentCenter;
    self.channel_label.text = @"总部";
    [exchangeView addSubview:self.channel_label];
    
    UILabel *exchange_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, 80, 14)];
    exchange_label.text = @"[切换]";
    exchange_label.font = BoldFONT(9);
    exchange_label.textColor = KLightTitleColor;
    exchange_label.textAlignment = NSTextAlignmentCenter;
    [exchangeView addSubview:exchange_label];
    //切换
    [exchangeView setTapActionWithBlock:^{
        [self swapAction];
    }];
}
//程序进来选择发货渠道
- (void)defaultSelectChannel{
    
    HJUser *user = [HJUser sharedUser];
    if (user.token.length == 0) {
        [self getDatas];
    }else{
    NSString *channel;
    if ([user.ship_channel isEqualToString:@"1"]) {
        //体验店
        channel = @"1";
        self.channel_label.text = @"体验店";
    }else{
        channel = @"0";
        self.channel_label.text = @"总部";
    }
    [[[HHLoginAPI postSelectChannelWithchannel:channel] netWorkClient] postRequestInView:nil finishedBlock:^(HHLoginAPI *api, NSError *error) {
        if (!error) {
            if (api.code == 0) {
                [self getDatas];
            }
        }
     }];
   }
}
//搜索
- (void)searchAction{
    
    HHGoodListVC *vc = [HHGoodListVC new];
    vc.enter_Type = HHenter_home_Type;
    [self.navigationController pushVC:vc];
    
}
//切换
- (void)swapAction{
    HJUser *user = [HJUser sharedUser];
    if (user.token.length == 0) {
        HHLoginVC *vc = [[HHLoginVC alloc] initWithNibName:@"HHLoginVC" bundle:nil];
        HJNavigationController *nav = [[HJNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        
        self.alertView = [[HHSelectChannelAlertView alloc]init];
        self.alertView.close_btn.hidden = NO;
        if ([user.ship_channel isEqualToString:@"1"]) {
            //体验店
            UIButton *btn = [self.alertView viewWithTag:10001];
            [self.alertView headquartersbtnAction:btn];
        }else{
            
            UIButton *btn = [self.alertView viewWithTag:10000];
            [self.alertView headquartersbtnAction:btn];

        }
        [self.alertView showAnimated:NO];
        
        WEAK_SELF();
        self.alertView.commitBlock = ^(NSString  *channel) {
            HJUser *user1 = [HJUser sharedUser];
            user1.ship_channel = channel;
            [user1 write];
            if ([channel isEqualToString:@"1"]) {
                weakSelf.channel_label.text = @"体验店";
            }else{
                weakSelf.channel_label.text = @"总部";
            }
            //刷新数据
            [weakSelf.datas removeAllObjects];
            [weakSelf getDatas];
            [weakSelf.alertView hideWithCompletion:nil];
        };
    }
}
- (void)addHeadRefresh{
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        //多个请求顺序执行
        [self requestSequenceExe];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFY_ACT_INFO object:nil];

    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    self.collectionView.mj_header = refreshHeader;
}
#pragma mark - 网络请求

//多个请求顺序执行
- (void)requestSequenceExe{

        //获取配额秒杀信息
        [self GetActInfoWithsemaphore:nil];
    
        //获取选择渠道数据
        [self defaultSelectChannel];
        //轮播图
        [self GetHomeImg];
}
//配额秒杀数据
-(void)GetActInfoWithsemaphore:(dispatch_semaphore_t)semaphore{
    
    [[[HHSecKillAPI GetSeckillInfo] netWorkClient] getRequestInView:nil finishedBlock:^(HHSecKillAPI *api, NSError *error) {
        if (!error) {
            if (api.code == 0) {
                self.secKill_model = [HHSecKillModel mj_objectWithKeyValues:api.data];
//                dispatch_semaphore_signal(semaphore);
            }else{
                [SVProgressHUD showInfoWithStatus:api.msg];
//                dispatch_semaphore_signal(semaphore);
            }
        }else{
//          dispatch_semaphore_signal(semaphore);

        }
    }];
}

//首页数据
- (void)getDatas{
    
    NetworkClient *netWorkClient = [[HHHomeAPI getCategoryProductListWithtype:nil isExperience:nil] netWorkClient];
    
    dispatch_semaphore_t  semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    
    dispatch_group_async(group, globalQueue, ^{

        netWorkClient.manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataDontLoad;
        
        [netWorkClient getRequestInView:nil finishedBlock:^(HHHomeAPI *api, NSError *error) {
            if ([self.collectionView.mj_header isRefreshing]) {
                [self.collectionView.mj_header endRefreshing];
            }
            if (!error) {
                if (api.code == 0) {
                    
                    NSArray *arr = api.data;
                    self.datas = arr.mutableCopy;
                    dispatch_semaphore_signal(semaphore);
                }else{
                    [SVProgressHUD showInfoWithStatus:api.msg];
                    dispatch_semaphore_signal(semaphore);
                }
            }else{
                dispatch_semaphore_signal(semaphore);
                //请求超时
                [self showlocalizedDescriptionWitherror:error];
            }
        }];
    });
    
    dispatch_group_notify(group, globalQueue, ^{
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            netWorkClient.manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
            
            [netWorkClient getRequestInView:nil finishedBlock:^(HHHomeAPI *api, NSError *error) {
                
                if ([self.collectionView.mj_header isRefreshing]) {
                    [self.collectionView.mj_header endRefreshing];
                }
                if (!error) {
                    if (api.code == 0) {
                        
                        NSArray *arr = api.data;
                        self.datas = arr.mutableCopy;
                        [UIView animateWithDuration:0.25 animations:^{
                            [self.collectionView reloadData];
                        }];
                    }else{
                        [SVProgressHUD showInfoWithStatus:api.msg];
                    }
                }else{
                    //请求超时
                    [self showlocalizedDescriptionWitherror:error];
                }
            }];
        });
    });
}
//请求超时
- (void)showlocalizedDescriptionWitherror:(NSError *)error{
    
    if ([error.localizedDescription isEqualToString:@"似乎已断开与互联网的连接。"]||[error.localizedDescription  containsString:@"请求超时"]) {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showInfoWithStatus:@"网络竟然崩溃了～"];
    }
}
- (void)GetHomeImg{

    NetworkClient *netWorkClient = [[HHHomeAPI GetHomeImg] netWorkClient];
    
    dispatch_semaphore_t  semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    
    dispatch_group_async(group, globalQueue, ^{
        
        netWorkClient.manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataDontLoad;
        
        [netWorkClient getRequestInView:nil finishedBlock:^(HHHomeAPI *api, NSError *error) {
            if ([self.collectionView.mj_header isRefreshing]) {
                [self.collectionView.mj_header endRefreshing];
            }
            
            if (!error) {
                if (api.code == 0) {
                    [self.shufflingLists removeAllObjects];
                    [self.shufflingModelLists removeAllObjects];
                    NSArray *arr = api.data;
                    [arr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        HHHomeModel *model = [HHHomeModel mj_objectWithKeyValues:obj];
                        [self.shufflingLists addObject:model.url];
                        [self.shufflingModelLists addObject:model];
                        *stop = NO;
                    }];
                    dispatch_semaphore_signal(semaphore);

                }else{
                    [self.shufflingLists removeAllObjects];
                    [self.shufflingModelLists removeAllObjects];
                    dispatch_semaphore_signal(semaphore);

                }
            }else{
                [self.shufflingLists removeAllObjects];
                [self.shufflingModelLists removeAllObjects];
                dispatch_semaphore_signal(semaphore);
            }
            
        }];
        
    });
    
    dispatch_group_notify(group, globalQueue, ^{
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            netWorkClient.manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
            
            [netWorkClient getRequestInView:nil finishedBlock:^(HHHomeAPI *api, NSError *error) {
                if ([self.collectionView.mj_header isRefreshing]) {
                    [self.collectionView.mj_header endRefreshing];
                }
                if (!error) {
                    if (api.code == 0) {
                        
                        [self.shufflingLists removeAllObjects];
                        [self.shufflingModelLists removeAllObjects];
                        NSArray *arr = api.data;
                        [arr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            HHHomeModel *model = [HHHomeModel mj_objectWithKeyValues:obj];
                            [self.shufflingLists addObject:model.url];
                            [self.shufflingModelLists addObject:model];
                            *stop = NO;
                        }];
                        
                    }
                }
                
            }];
            
        });
        
    });
}
#pragma  mark - collectionView Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HXHomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HXHomeCollectionCell" forIndexPath:indexPath];
    if (self.datas.count>0) {
        HHHomeModel *model = [HHHomeModel  mj_objectWithKeyValues:self.datas[indexPath.section]];
        cell.productsModel =  model.product[indexPath.row];
    }
    
    [cell.product_supplier_name_btn addTarget:self action:@selector(product_supplier_nameAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.datas.count>0) {
        HHHomeModel *model = [HHHomeModel  mj_objectWithKeyValues:self.datas[section]];
        if (model.product.count>0&&model.product.count<5) {
            NSInteger count = model.product.count;
            return  count;
        }else if(model.product.count>=5){
            return 4;
        }
    }
    return 0;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.datas.count?self.datas.count:1;

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
        return CGSizeMake((SCREEN_WIDTH-2)/2 , 100+2+(SCREEN_WIDTH - 2)/2);
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(1, 1, 1, 0);
    
}
// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
//      CGFloat imagW = (SCREEN_WIDTH)/3;
        CGFloat imagH = 95;
        
        CGFloat height;
        
        height  =  2*imagH+WidthScaleSize_H(70)+SCREEN_WIDTH/2+20+10;
 
      //secondsKill 秒杀模块 WidthScaleSize_H(140)
        if ([self.secKill_model.status isEqual:@0]) {
            height  =  2*imagH+WidthScaleSize_H(70)+SCREEN_WIDTH/2+20+10;
        }else{
            height =  2*imagH+WidthScaleSize_H(70)+SCREEN_WIDTH/2+20+10+WidthScaleSize_H(140);
        }
        return  CGSizeMake(SCREEN_WIDTH,height);
        
    }else{
        
        return  CGSizeMake(SCREEN_WIDTH, WidthScaleSize_H(70));
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
        return  CGSizeMake(0.001, 0.001);

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HHGoodBaseViewController *vc = [HHGoodBaseViewController new];
    HHHomeModel *model = [HHHomeModel mj_objectWithKeyValues:self.datas[indexPath.section]];
    HHhomeProductsModel *productsModel = model.product[indexPath.row];
    vc.Id = productsModel.product_id;
    [self.navigationController pushVC:vc];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind  == UICollectionElementKindSectionHeader) {
        
        if (indexPath.section == 0) {
        HHCollectionReusableHead   *head1 = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HHCollectionReusableHead" forIndexPath:indexPath];

            if (self.datas.count>0) {
                HHHomeModel *model =  [HHHomeModel mj_objectWithKeyValues:self.datas[indexPath.section]];
                head1.levelBgLab.text =  [NSString stringWithFormat:@"%@",model.category_name];
            }
            head1.cycleScrollView.imageURLStringsGroup = self.shufflingLists;
            head1.cycleScrollView.delegate = self;
            head1.nav = self.navigationController;
            head1.vc = self;
            head1.setHead_height_model = self.secKill_model;

            return head1;
            
        }else {
            
            HXCollectionLevelHead *head2 =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HXCollectionLevelHead" forIndexPath:indexPath];
              if (self.datas.count>0) {
            HHHomeModel *model =  [HHHomeModel mj_objectWithKeyValues:self.datas[indexPath.section]];
            head2.levelBgLab.text = [NSString stringWithFormat:@"%@",model.category_name];
              }
            return head2;
        }
        
    }else if(kind == UICollectionElementKindSectionFooter){
        
        HXCollectionFootView *footSec0 = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HXCollectionFootView" forIndexPath:indexPath];
        footSec0.userInteractionEnabled = YES;

        return footSec0;
        
    }
    return nil;
}
- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowout = [[UICollectionViewFlowLayout alloc]init];
        
        CGFloat y = Status_HEIGHT+44;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT - Status_HEIGHT-44-49) collectionViewLayout:flowout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        
    }
    return _collectionView;
}
#pragma mark - SDCycleScrollView delegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    HHHomeModel * model = self.shufflingModelLists[index];
    if ([model.redirect containsString:@"http"]||[model.redirect containsString:@"https"]) {
        if ([model.redirect containsString:@"ProductDetail"]) {
            HHGoodBaseViewController *vc = [HHGoodBaseViewController new];
            HHUrlModel *url_model = [HHUrlModel mj_objectWithKeyValues:[model.redirect lh_parametersKeyValue]];
            vc.Id = url_model.Id;
            [self.navigationController pushVC:vc];

        }else  if ([model.redirect containsString:@"ProductList"]) {

            HHGoodListVC *vc = [HHGoodListVC new];
            HHUrlModel *url_model = [HHUrlModel mj_objectWithKeyValues:[model.redirect lh_parametersKeyValue]];
            vc.type = url_model.type;
            vc.categoryId = url_model.categoryId;
            vc.name = nil;
            vc.orderby = nil;
            vc.enter_Type = HHenter_itself_Type;
            [self.navigationController pushVC:vc];
        }
    }
}
- (void)product_supplier_nameAction:(UIButton *)btn{
    
    HXHomeCollectionCell *cell = (HXHomeCollectionCell *)[[btn superview] superview];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    HHHomeModel *model = [HHHomeModel  mj_objectWithKeyValues:self.datas[indexPath.section]];
    HHhomeProductsModel  *productsModel =  model.product[indexPath.row];
    HHGoodListVC *vc = [HHGoodListVC new];
    vc.enter_Type = HHenter_itself_Type;
    vc.supplierId = productsModel.product_supplier_id;
    
    [self.navigationController pushVC:vc];
    
}
@end
