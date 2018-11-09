//
//  HHTeamListVC.m
//  CredictCard
//
//  Created by User on 2017/12/16.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHTeamListVC.h"
#import "HHContractManagerVC.h"
#import "HHSignListCell.h"

@interface HHTeamListVC ()<UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchResultsUpdating,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic,retain) UISearchController *searchController;
//数据源
@property (nonatomic,strong) NSMutableArray *dataListArry;
@property (nonatomic,strong) NSMutableArray *searchListArry;
@property (nonatomic,strong) NSString *signno;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) BOOL  isSeachActive;
@property(nonatomic,assign)   BOOL  isLoading;

@end

@implementation HHTeamListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //签约单管理1
    self.title = @"签约单管理";
    
    self.page = 1;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.dataListArry = [NSMutableArray array];
    self.searchListArry = [NSMutableArray array];
    
    
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.barTintColor = KVCBackGroundColor;
    self.searchController.searchBar.placeholder = @"子单名";
    self.searchController.searchBar.backgroundImage = [UIImage imageWithColor:KVCBackGroundColor];
    self.definesPresentationContext = YES;

    //搜索时，背景变暗色
    self.searchController.dimsBackgroundDuringPresentation = NO;
    //搜索时，背景变模糊
//     self.searchController.obscuresBackgroundDuringPresentation = NO;
  
    //点击搜索的时候,是否隐藏导航栏
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    //位置
    self.searchController.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);

    [self.searchController.searchBar setImage:[UIImage imageNamed:@"mind_icon_search_default"] forSearchBarIcon:(UISearchBarIconSearch) state:UIControlStateNormal];

    // 添加 searchbar 到 headerview
    
    [self.view addSubview:self.searchController.searchBar];
    
    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT - self.searchController.searchBar.mj_h - 64;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,60, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHSignListCell" bundle:nil] forCellReuseIdentifier:@"HHSignListCell"];
    
    [self addHeadRefresh];
    
    //    self.tableView.tableHeaderView = self.searchController.searchBar;

    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    //获取数据
    [self getDatas];
    
    
    //抓取返回按钮
    UIButton *backBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [backBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)backBtnAction{
    
    [self.navigationController popToRootVC];
    
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.isLoading) {
        return [UIImage imageNamed:@"img_list_disable"];
    }else{
        //没加载过
        return [UIImage imageNamed:@""];
    }
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    NSString *attr;

    if (self.isLoading) {
        attr = @"您还没有相关的记录～";
    }else{
        //没加载过
        attr = @"";
    }
    return [[NSAttributedString alloc] initWithString:attr attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:APP_purple_Color}];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    CGFloat offset = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    offset += CGRectGetHeight(self.navigationController.navigationBar.frame);
    return -offset;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.searchController.searchBar resignFirstResponder];
}
- (void)getDatas{
    
    [[[HHMineAPI GetUserSignListWithsignno:self.signno page:@(self.page)] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
       
        if (!error) {
            
            if (api.code == 0) {
                [self addFootRefresh];

                [self loadDataFinish:api.data[@"list"]];
            }else{
                [SVProgressHUD showInfoWithStatus:api.msg];
            }
        }else{
            
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
            
            if (self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_footer endRefreshing];
            }
            
        }
    }];
    
}
- (void)addHeadRefresh{
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataListArry removeAllObjects];
        [self.searchListArry removeAllObjects];
        self.page = 1;
        [self getDatas];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    self.tableView.mj_header = refreshHeader;
    
}
- (void)addFootRefresh{
    
    MJRefreshAutoNormalFooter *refreshfooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        
        [self getDatas];
    }];
    self.tableView.mj_footer = refreshfooter;
    
}
/**
 *  加载数据完成
 */
- (void)loadDataFinish:(NSArray *)arr {
    
    if(self.isSeachActive){
        
        [self.searchListArry addObjectsFromArray:arr];
        
    }else{
        [self.dataListArry addObjectsFromArray:arr];
        
        if (self.dataListArry.count == 0) {
            self.tableView.mj_footer.hidden = YES;
        }
    }
    
    if (arr.count < 10) {
        
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
        
        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
    }else{
        
        [self.tableView.mj_footer setState:MJRefreshStateIdle];
        
    }
    
    if (self.tableView.mj_header.isRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    
    if (self.tableView.mj_footer.isRefreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
    //刷新界面
    [self.tableView reloadData];
    
}
#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHSignListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHSignListCell"];

    if (self.searchController.active) {
        if (self.searchListArry.count>0) {
            HHMineModel *model = [HHMineModel mj_objectWithKeyValues:self.searchListArry[indexPath.row]];
            cell.signModel = model;
        }
    }
    else{
        if (self.dataListArry.count>0) {
            HHMineModel *model = [HHMineModel mj_objectWithKeyValues:self.dataListArry[indexPath.row]];
            cell.signModel = model;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.searchController.active) {
        
        return [self.searchListArry count];
    }
    else{
        
        return  [self.dataListArry count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHContractManagerVC *vc = [HHContractManagerVC new];
    if (self.isSeachActive) {
        HHMineModel *model = [HHMineModel mj_objectWithKeyValues:self.searchListArry[indexPath.row]];
        vc.signno = model.sign_no;
        
        [self.navigationController pushVC:vc];

    }
    else{
        HHMineModel *model = [HHMineModel mj_objectWithKeyValues:self.dataListArry[indexPath.row]];
        vc.signno = model.sign_no;
        
        [self.navigationController pushVC:vc];

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}
//谓词搜索过滤
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    searchController.searchResultsController.view.hidden = NO;
    
    [self.searchListArry removeAllObjects];
    
    self.isSeachActive = YES;
    
    NSString *searchString = [self.searchController.searchBar text];

    if (searchString.length == 0) {
        self.signno = nil;
        [self getDatas];
        
    }else{
        self.signno = searchString;
        [self.searchListArry removeAllObjects];
        self.page = 1;
        [self getDatas];
        
    }
    
}

#pragma mark - UISearchControllerDelegate代理,可以省略,主要是为了验证打印的顺序
//测试UISearchController的执行过程

- (void)willPresentSearchController:(UISearchController *)searchController
{
    self.tableView.height = SCREEN_HEIGHT - 64;
    NSLog(@"willPresentSearchController");
    
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    self.signno = nil;
    NSLog(@"didPresentSearchController");

    //    [self.view addSubview:self.searchController.searchBar];
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"willDismissSearchController");
    searchController.searchBar.frame = CGRectMake(0, 20, ScreenW, 50);
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"didDismissSearchController");
    self.isSeachActive = NO;
    self.tableView.height = SCREEN_HEIGHT - 50- 64;

}

- (void)presentSearchController:(UISearchController *)searchController
{
    NSLog(@"presentSearchController");
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchController.searchBar resignFirstResponder];
  
}

@end
