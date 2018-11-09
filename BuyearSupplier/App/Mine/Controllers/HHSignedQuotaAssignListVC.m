//
//  HHRechargeRecordVC.m
//  Store
//
//  Created by User on 2018/1/8.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHSignedQuotaAssignListVC.h"
#import "HHRechargeRecordCell.h"
#import "HHWithDrawCell.h"

@interface HHSignedQuotaAssignListVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>{
    
}
@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, strong)   NSMutableArray *datas;
@property(nonatomic,assign)   BOOL  isLoading;

@end

@implementation HHSignedQuotaAssignListVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    self.datas = [NSMutableArray array];
    
    self.title = @"分配记录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT - 64;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHRechargeRecordCell" bundle:nil] forCellReuseIdentifier:@"HHRechargeRecordCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HHWithDrawCell" bundle:nil] forCellReuseIdentifier:@"HHWithDrawCell"];
    
    
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    [self addHeadRefresh];
    
    [self getDatas];
    
}
- (void)getDatas{
    
        [[[HHMineAPI GetSignedQuotaAssignListWithpage:@(self.page) userid:nil] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            self.isLoading  = YES;
            if (!error) {
                if (api.code == 0) {
                    
                    [self addFootRefresh];
                    
                    [self loadDataFinish:api.data[@"list"]];
                }else{
                    [SVProgressHUD showInfoWithStatus:api.msg];
                }
                
            }
            
        }];
    
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.isLoading) {
        return [UIImage imageNamed:@"img_list_disable"];
        
    }else{
        return [UIImage imageNamed:@""];
    }
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *aStr;
    if (self.isLoading) {
        aStr = @"您还没有相关的记录～";
    }else{
        aStr = @"";
    }
    return [[NSAttributedString alloc] initWithString:aStr attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:APP_purple_Color}];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    CGFloat offset = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    offset += CGRectGetHeight(self.navigationController.navigationBar.frame);
    return -offset;
    
}


- (void)addHeadRefresh{
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.datas removeAllObjects];
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
    
    [self.datas addObjectsFromArray:arr];
    
    if (self.datas.count == 0) {
        self.tableView.mj_footer.hidden = YES;
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
    
    UITableViewCell *gridcell;
        HHWithDrawCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHWithDrawCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.signedQuotaModel = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.row]];
        cell.view = self.view;
        cell.vc = self;
        gridcell = cell;
    return gridcell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     return  [UITableViewCell whc_CellHeightForIndexPath:indexPath tableView:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    
    return 0.01;
    
}


@end
