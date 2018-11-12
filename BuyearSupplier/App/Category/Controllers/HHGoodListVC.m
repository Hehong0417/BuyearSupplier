//
//  HHGoodListVC.m
//  Store
//
//  Created by User on 2018/1/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHGoodListVC.h"
#import "HXHomeCollectionCell.h"
#import "HHSGSegmentedControl.h"
#import "SearchView.h"
#import "SearchDetailViewController.h"
#import "HHGoodBaseViewController.h"
#import "HHCategoryVC.h"
#import "HHSupplierListVC.h"

@interface HHGoodListVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HHSGSegmentedControlDelegate,SearchViewDelegate,SearchDetailViewControllerDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    SearchView *searchView;
    
}
@property (nonatomic, strong)   UICollectionView *collectionView;
@property(nonatomic,strong)     HHSGSegmentedControl *SG;
@property (nonatomic, strong)   NSMutableArray *title_arr;
@property(nonatomic,assign)    NSInteger page;
@property(nonatomic,assign)   NSInteger pageSize;
@property(nonatomic,strong)   NSMutableArray *datas;
@property(nonatomic,assign)   BOOL  orderPrice;
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;
@property(nonatomic,assign)   BOOL  isHeadRefresh;
@property(nonatomic,assign)   BOOL  isLoading;
@property(nonatomic,assign)   BOOL  isWlan;
@property (strong , nonatomic) NSURLSessionDataTask *sessionTask;
@property(nonatomic,assign)   NSInteger  segment_type;


@end

@implementation HHGoodListVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    searchView.hidden = NO;
}
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    //商品列表
    self.page = 1;
    self.pageSize = 14;
    
    
    //collectionView
    self.collectionView.backgroundColor = KVCBackGroundColor;
    [self.view addSubview:self.collectionView];
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HXHomeCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"HXHomeCollectionCell"];
    
    self.isHeadRefresh = NO;
    
    //搜索
    [self setupSGSegmentedControl];

    [self setupSearchView];

    [self addHeadRefresh];
    
}
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (void)setupSGSegmentedControl{
    
    self.title_arr = [NSMutableArray arrayWithArray:@[@"默认",@"价格",@"筛选"]];
    
    if (self.title_arr.count < 5) {
        self.SG = [HHSGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) delegate:self segmentedControlType:(SGSegmentedControlTypeStatic) titleArr:self.title_arr];
    }else{
        
        self.SG = [HHSGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) delegate:self segmentedControlType:(SGSegmentedControlTypeScroll) titleArr:self.title_arr];
    }
    self.SG.titleColorStateNormal = APP_COMMON_COLOR;
    self.SG.titleColorStateSelected = APP_COMMON_COLOR;
    self.SG.title_fondOfSize  = FONT(14);
    //  self.SG.showsBottomScrollIndicator = YES;
    self.SG.backgroundColor = kWhiteColor;
    self.SG.indicatorColor = APP_COMMON_COLOR;
    self.SG.SearchBtnHidden = YES;
    [self.view addSubview:_SG];
    
    self.collectionView.emptyDataSetDelegate = self;
    self.collectionView.emptyDataSetSource = self;
    
}
#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{

    if (self.isLoading) {
        if (self.isWlan) {
            return [UIImage imageNamed:@"img_list_disable"];
        }else{
            return [UIImage imageNamed:@"img_network_disable"];
        }
    }else{
        //没加载过
        return [UIImage imageNamed:@""];
    }

}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    NSString *attr;
    if (self.isLoading) {
        if (self.isWlan) {
            attr = @"还没有相关的宝贝，先看看其他的吧～";
        }else{
            attr = @"网络竟然崩溃了～";
        }
    }else{
        //没加载过
        attr = @"";
    }
    
    return [[NSAttributedString alloc] initWithString:attr attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:KACLabelColor}];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    CGFloat offset = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    offset += CGRectGetHeight(self.navigationController.navigationBar.frame);
    return -offset;
    
}
- (void)getDatas{
    UIView *mask_view = [UIView lh_viewWithFrame:self.view.bounds backColor:kClearColor];
    UIView *hud =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    hud.backgroundColor = kClearColor;
    if (!self.isHeadRefresh) {
        self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        self.activityIndicator.frame= CGRectMake(0, 0, 50, 50);
        self.activityIndicator.color = KACLabelColor;
        [hud addSubview:self.activityIndicator];
        hud.centerX = self.view.centerX;
        hud.centerY = self.view.centerY - 50;
        [self.view addSubview:mask_view];
        [mask_view addSubview:hud];
        self.activityIndicator.hidesWhenStopped = YES;
    }

    [self.activityIndicator startAnimating];
    
  self.sessionTask = [[[HHCategoryAPI GetProductListWithType:self.type categoryId:self.categoryId name:self.name orderby:self.orderby page:@(self.page) pageSize:@(self.pageSize) supplierId:self.supplierId] netWorkClient] getRequestInView:nil finishedBlock:^(HHCategoryAPI *api, NSError *error) {
        
        if (!error) {
            if (api.code == 0) {
                
                [self.activityIndicator  stopAnimating];
                [hud removeFromSuperview];
                [mask_view removeFromSuperview];
                self.isLoading = YES;
                self.isWlan = YES;
                [self addFootRefresh];
//                [self.collectionView reloadEmptyDataSet];
                [self loadDataFinish:api.data[@"list"]];
            }else{
                [self.activityIndicator  stopAnimating];
                [hud removeFromSuperview];
                [mask_view removeFromSuperview];
                self.isLoading = YES;
                self.isWlan = YES;
                [self loadDataFinish:@[]];
                [self.collectionView reloadEmptyDataSet];
                [SVProgressHUD showInfoWithStatus:api.msg];
            }
            
        }else{
            
            [self.activityIndicator  stopAnimating];
            hud.hidden = YES;
            mask_view.hidden = YES;
            self.isLoading = YES;
            self.isWlan = NO;
            [self loadDataFinish:@[]];
            [self.collectionView reloadEmptyDataSet];
            self.activityIndicator.hidden = YES;

        }
    }];
    
}
- (void)addHeadRefresh{
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.name = nil;
        [self.datas removeAllObjects];
        self.isHeadRefresh = YES;

        [self getDatas];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    self.collectionView.mj_header = refreshHeader;
    
}
- (void)addFootRefresh{
    
    MJRefreshAutoNormalFooter *refreshfooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        self.isHeadRefresh = YES;
        [self getDatas];
    }];
    self.collectionView.mj_footer = refreshfooter;
    
}
/**
 *  加载数据完成
 */
- (void)loadDataFinish:(NSArray *)arr {
    
    [self.datas addObjectsFromArray:arr];
    
    if(self.datas.count<6){
        
        self.collectionView.mj_footer.hidden = YES;

    }
    if (arr.count < self.pageSize) {
        
        [self endRefreshing:YES];
        
    }else{
        [self endRefreshing:NO];
    }
    
}

/**
 *  结束刷新
 */
- (void)endRefreshing:(BOOL)noMoreData {
    // 取消刷新
    
    if (noMoreData) {
        if (self.datas.count == 0) {
            self.collectionView.mj_footer.hidden = YES;
        }else {
            [self.collectionView.mj_footer setState:MJRefreshStateNoMoreData];
        }
    }else{
        
        [self.collectionView.mj_footer setState:MJRefreshStateIdle];
        
    }
    
    if (self.collectionView.mj_header.isRefreshing) {
        [self.collectionView.mj_header endRefreshing];
    }
    
    if (self.collectionView.mj_footer.isRefreshing) {
        [self.collectionView.mj_footer endRefreshing];
    }
    //刷新界面
    [self.collectionView reloadData];
    
}

#pragma mark - SearchView

- (void)setupSearchView {
    searchView = [[SearchView alloc] initWithFrame:CGRectMake(10, 3, self.view.frame.size.width-20, 30)];
    searchView.textField.text = @"";
    searchView.delegate = self;
    searchView.userInteractionEnabled = YES;

    UIButton *backBtn = [UIButton lh_buttonWithFrame:CGRectMake(-15, 3, 30, 30) target:self action:@selector(backAction) backgroundColor:kClearColor];
    backBtn.highlighted = NO;
    [searchView addSubview:backBtn];
    [self.navigationController.navigationBar addSubview:searchView];
    
    if (self.enter_Type == HHenter_home_Type) {
        
        [self searchButtonWasPressedForSearchView:searchView];
        
    }else if (self.enter_Type == HHenter_category_Type) {
        
        [self searchButtonWasPressedForSearchView:searchView];

    }else{
        
    }
    
}
- (void)backAction{

    [self.navigationController popVC];
}
#pragma mark - SearchViewDelegate

- (void)searchButtonWasPressedForSearchView:(SearchView *)searchView {
    
    SearchDetailViewController *searchViewController = [[SearchDetailViewController alloc] init];
    searchViewController.textFieldText = self.name;
    searchViewController.placeHolderText = searchView.textField.text;
    searchViewController.delegate = self;
    searchViewController.enter_Type = self.enter_Type;
    
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:navigationController
                       animated:NO
                     completion:nil];
    
}
#pragma mark - SearchDetailViewControllerDelegate

- (void)tagViewButtonDidSelectedForTagTitle:(NSString *)title segment_type:(NSInteger)segment_type{
    
    if (segment_type == 0) {
        //全部
        if (title.length>0) {
            [searchView.search_placeholderBtn setTitle:title forState:UIControlStateNormal];
            
        }else{
            [searchView.search_placeholderBtn setTitle:@"搜索想要的宝贝" forState:UIControlStateNormal];
        }
        //热门搜索/历史搜索标题
        self.name = title;
        [self.datas removeAllObjects];
        [self getDatas];
        
    }else{
        //供应商
        
        HHSupplierListVC *supp_vc = [HHSupplierListVC new];
        supp_vc.name = title;
        [self.navigationController pushVC:supp_vc];
    }
}
- (void)dismissButtonWasPressedForSearchDetailView:(id)searchView{
    
    [self.navigationController popToRootVC];
    
}
#pragma mark - SGSegmentedControlDelegate

- (void)SGSegmentedControl:(HHSGSegmentedControl *)segmentedControl didSelectBtnAtIndex:(NSInteger)index{
    
    [self.sessionTask cancel];

    [self.datas removeAllObjects];
    
    if (index == 0){
        //默认
        self.orderby = nil;
        [self getDatas];

    }else if (index == 1){
        //价格
        self.page = 1;
        self.orderPrice = !self.orderPrice;
        if (self.orderPrice) {
            self.orderby = @1;
            [self getDatas];
        }else{
            self.orderby = @2;
            [self getDatas];
        }
        
    }else if (index == 2){
        //筛选
        HHCategoryVC *vc = [HHCategoryVC new];
        [self.navigationController pushVC:vc];
    }
    
}
- (void)SGSegmentedControlSearchBtnSelected{
    
    
}
#pragma  mark - collectionView Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    HXHomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HXHomeCollectionCell" forIndexPath:indexPath];
    if (self.datas.count>0) {
        cell.goodsModel = [HHCategoryModel mj_objectWithKeyValues:self.datas[indexPath.row]];
    }
    [cell.product_supplier_name_btn addTarget:self action:@selector(product_supplier_nameAction:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.datas.count;
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
    
    return  CGSizeMake(0.001, 0.001);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
     
    return  CGSizeMake(0.001, 0.001);
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HHGoodBaseViewController *vc = [HHGoodBaseViewController new];
    if (self.datas.count>0) {
        HHCategoryModel *goodsModel = [HHCategoryModel mj_objectWithKeyValues:self.datas[indexPath.row]];
        vc.Id = goodsModel.product_id;
    }
    [self.navigationController pushVC:vc];
}
- (void)product_supplier_nameAction:(UIButton *)btn{
    
    HXHomeCollectionCell *cell = (HXHomeCollectionCell *)[[btn superview] superview];
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    HHCategoryModel *model = [HHCategoryModel mj_objectWithKeyValues:self.datas[indexPath.row]];
    HHGoodListVC *vc = [HHGoodListVC new];
    vc.enter_Type = HHenter_itself_Type;
    vc.supplierId = model.product_supplier_id;
    [self.navigationController pushVC:vc];

}

- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - 64 -50) collectionViewLayout:flowout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        
    }
    return _collectionView;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    searchView.hidden = YES;
}
@end
