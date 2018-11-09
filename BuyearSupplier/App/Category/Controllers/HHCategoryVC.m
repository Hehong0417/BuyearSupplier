//
//  CategoryVC.m
//  CredictCard
//
//  Created by User on 2017/12/12.
//  Copyright © 2017年 User. All rights reserved.
//

#define tableViewH  WidthScaleSize_W(95)

/** 顶部Nav高度+指示器 */
#define DCTopNavH  44
#import "HHCategoryVC.h"
#import "HHSGSegmentedControl.h"
#import "DCClassCategoryCell.h"
#import "HHClassCategoryCell.h"
#import "DCClassGoodsItem.h"
#import "HHCategoryCollectionHead.h"
#import "HHGoodListVC.h"

@interface HHCategoryVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,HHSGSegmentedControlDelegate>

@property(nonatomic,strong)   HHSGSegmentedControl *SG;
@property (nonatomic, strong)   NSMutableArray *title_arr;

/* tableView */
@property (strong , nonatomic)UITableView *tableView;
/* collectionView */
@property (strong , nonatomic)UICollectionView  *collectionView;

/* 左边数据 */
@property (strong , nonatomic)NSMutableArray<DCClassGoodsItem *> *titleItem;
/* 右边数据 */
@property (strong , nonatomic)NSMutableArray<HHsubGoodsItem *> *mainItem;

@property (strong , nonatomic)NSNumber *type;

@property (strong , nonatomic) NSURLSessionDataTask *sessionTask;

@property (strong , nonatomic) NSString *tip;

@end


static NSString *const DCClassCategoryCellID = @"DCClassCategoryCell";
static NSString *const DCGoodsSortCellID = @"HHClassCategoryCell";

@implementation HHCategoryVC

#pragma mark - LifeCycle

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //
    [self configNetWork];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    [self setUpTab];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
//  [self setUpData];
    HJUser *user = [HJUser sharedUser];
    user.category_selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [user write];
    
    [self setUpSGSegmentedControl];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    HJUser *user = [HJUser sharedUser];
    user.is_currentPage = NO;
    [user write];
}

- (void)configNetWork{
    
    HJUser *user = [HJUser sharedUser];
    if(user.store_selectIndex == 0){
        //全部
        [user write];
        UIButton *title_btn =  (UIButton *)[self.SG viewWithTag:999];
        [self.SG buttonAction:title_btn];
        user.is_currentPage = YES;
        [user write];
        [self getDatasWithType:nil];
    }else if(user.store_selectIndex == 1){
        //百业惠
        [user write];
        UIButton *title_btn =  (UIButton *)[self.SG viewWithTag:1000];
        [self.SG buttonAction:title_btn];
        user.is_currentPage = YES;
        [user write];
        [self getDatasWithType:@0];
        
    }else if (user.store_selectIndex == 2){
        //惠万家
        [user write];
        UIButton *title_btn =  (UIButton *)[self.SG viewWithTag:1001];
        [self.SG buttonAction:title_btn];
        user.is_currentPage = YES;
        [user write];
        [self getDatasWithType:@1];
    }
}
#pragma mark - UI

- (void)setUpSGSegmentedControl{
    
    self.title_arr = [NSMutableArray arrayWithArray:@[@"全部",@"百业惠",@"惠万家"]];
    if (self.title_arr.count < 5) {
        
        self.SG = [HHSGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) delegate:self segmentedControlType:(SGSegmentedControlTypeStatic) titleArr:self.title_arr];
    }else{
        
        self.SG = [HHSGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) delegate:self segmentedControlType:(SGSegmentedControlTypeScroll) titleArr:self.title_arr];
    }
    self.SG.titleColorStateNormal = APP_purple_Color;
    self.SG.titleColorStateSelected = APP_purple_Color;
    self.SG.title_fondOfSize  = BoldFONT(14);
    // self.SG.showsBottomScrollIndicator = YES;
    self.SG.backgroundColor = kWhiteColor;
    self.SG.indicatorColor = APP_purple_Color;
    [self.view addSubview:_SG];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.SG.height - 1, SCREEN_WIDTH, 1)];
    line.backgroundColor = LineLightColor ;
    [self.SG addSubview:line];
    
}
- (void)setUpTab
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
}
#pragma mark - NetWork
- (void)setUpData
{
    //获取数据
     [self getDatasWithType:nil];
    
}
- (void)getDatasWithType:(NSNumber *)type{
    
    [self.titleItem removeAllObjects];
    
    NetworkClient *netWorkClient = [[HHCategoryAPI GetCategoryListWithType:type] netWorkClient];
    
    dispatch_semaphore_t  semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    
    dispatch_group_async(group, globalQueue, ^{
        
        netWorkClient.manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataDontLoad;
        
      self.sessionTask =  [netWorkClient getRequestInView:nil finishedBlock:^(HHCategoryAPI *api, NSError *error) {
            if (!error) {
                if (api.code == 0) {
                    
                    NSArray *arr = api.data[@"list"];
                    self.titleItem = [DCClassGoodsItem mj_objectArrayWithKeyValuesArray:arr];
                    
                    self.tip = api.data[@"tip"];
                    
                    [self.tableView reloadData];
                    //默认选择第一行（注意一定要在加载完数据之后）
                    HJUser *user = [HJUser sharedUser];
                    if (self.titleItem.count>0) {
                        DCClassGoodsItem *item = self.titleItem[user.category_selectIndexPath.row];
                        self.mainItem =  [HHsubGoodsItem mj_objectArrayWithKeyValuesArray:item.sub_category];
                        [self.collectionView reloadData];
                    }
                    
                    [_tableView selectRowAtIndexPath:user.category_selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];

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
            
         self.sessionTask =  [netWorkClient getRequestInView:nil finishedBlock:^(HHCategoryAPI *api, NSError *error) {
                if (!error) {
                    if (api.code == 0) {
                        
                        NSArray *arr = api.data[@"list"];
                        self.titleItem = [DCClassGoodsItem mj_objectArrayWithKeyValuesArray:arr];
                        self.tip = api.data[@"tip"];

                        [self.tableView reloadData];
                        //默认选择第一行（注意一定要在加载完数据之后）
                        HJUser *user = [HJUser sharedUser];
                        
                        if (self.titleItem.count>0) {
                            DCClassGoodsItem *item = self.titleItem[user.category_selectIndexPath.row];
                            if ([item.category_name hasPrefix:@"HK"]&&self.tip.length>0) {
                                [self alertMessageWithTip];
                            }
                            self.mainItem =  [HHsubGoodsItem mj_objectArrayWithKeyValuesArray:item.sub_category];
                            [self.collectionView reloadData];
                        }
                        
                        [_tableView selectRowAtIndexPath:user.category_selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];

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

#pragma mark - LazyLoad

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.frame = CGRectMake(0, DCTopNavH, tableViewH, SCREEN_HEIGHT - DCTopNavH-64);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        
        [_tableView registerClass:[DCClassCategoryCell class] forCellReuseIdentifier:DCClassCategoryCellID];
    }
    return _tableView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 3; //X
        layout.minimumLineSpacing = 5;  //Y
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.frame = CGRectMake(tableViewH + 5, DCTopNavH, SCREEN_WIDTH - tableViewH - DCMargin, SCREEN_HEIGHT - DCTopNavH-64-64);
        [self.view addSubview:_collectionView];

        //注册Cell
        [_collectionView registerNib:[UINib nibWithNibName:@"HHClassCategoryCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"HHClassCategoryCell"];
        //        //注册Header
        [_collectionView registerClass:[HHCategoryCollectionHead class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HHCategoryCollectionHead"];
    }
    return _collectionView;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleItem.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCClassCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:DCClassCategoryCellID forIndexPath:indexPath];
    if (self.titleItem.count>0) {
        cell.titleItem = self.titleItem[indexPath.row];
    }
    return cell;
}
#pragma mark - SGSegmentedControlDelegate

- (void)SGSegmentedControl:(HHSGSegmentedControl *)segmentedControl didSelectBtnAtIndex:(NSInteger)index{
    
    [self.sessionTask cancel];
    
    HJUser *user = [HJUser sharedUser];
    user.store_selectIndex = index;
    if (user.is_currentPage) {
        user.category_selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    [user write];
    if (index == 0) {
        [self getDatasWithType:nil];
        self.type = nil;
    }else if (index == 1){
        [self getDatasWithType:@0];
        self.type = @0;
    }else if (index == 2){
        [self getDatasWithType:@1];
        self.type = @1;
    }
}
//搜索
- (void)SGSegmentedControlSearchBtnSelected{
    
    HHGoodListVC *vc = [HHGoodListVC new];
    vc.type = self.type;
    vc.categoryId = nil;
    vc.name = nil;
    vc.orderby = nil;
    vc.enter_Type = HHenter_category_Type;
    [self.navigationController pushVC:vc];
    
}
#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCClassGoodsItem *item = self.titleItem[indexPath.row];
    
    //HK香港区域商品
    if ([item.category_name hasPrefix:@"HK"]&&self.tip.length>0) {
        
        [self alertMessageWithTip];
    }
    self.mainItem =  [HHsubGoodsItem mj_objectArrayWithKeyValuesArray:item.sub_category];

    HJUser *user = [HJUser sharedUser];
    user.category_selectIndexPath = indexPath;
    [user write];
    [self.collectionView reloadData];
    
}
- (void)alertMessageWithTip{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"注意" message:self.tip preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:action1];
    [self presentViewController:alertC animated:YES completion:nil];
    
}
#pragma mark - <UICollectionViewDelegate>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.mainItem.count;
}

#pragma mark - <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
        HHClassCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DCGoodsSortCellID forIndexPath:indexPath];
        HHsubGoodsItem *subItem = self.mainItem[indexPath.row];
        cell.titleLab.text = subItem.category_name;
        [cell.goodIcon sd_setImageWithURL:[NSURL URLWithString:subItem.category_image] placeholderImage:[UIImage imageNamed:KPlaceImageName]];
        return cell;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake((SCREEN_WIDTH - tableViewH - DCMargin*3)/2, 115);

}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_WIDTH, WidthScaleSize_H(45));
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        
        HHCategoryCollectionHead *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HHCategoryCollectionHead" forIndexPath:indexPath];

        reusableview = headerView;
    }
    return reusableview;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
    HHGoodListVC *vc = [HHGoodListVC new];
    vc.type = self.type;
    HHsubGoodsItem *item = self.mainItem[indexPath.row];
    vc.categoryId = item.category_id;
    vc.name = item.category_name;
    vc.orderby = nil;
    vc.enter_Type = HHenter_itself_Type;

    [self.navigationController pushVC:vc];
}

@end
