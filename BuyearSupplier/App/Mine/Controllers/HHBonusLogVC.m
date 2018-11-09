//
//  HXChooseCouponVC.m
//  mengyaProject
//
//  Created by n on 2017/6/30.
//  Copyright © 2017年 n. All rights reserved.
//

#import "HHBonusLogVC.h"
#import "HHBonusLogCell.h"

@interface HHBonusLogVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>{
    
}
@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, strong)   NSMutableArray *datas;
@property(nonatomic,assign)   BOOL  isLoading;

@end

@implementation HHBonusLogVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"奖金日志";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.page = 1;
    self.datas = [NSMutableArray array];
    
    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT - 64-30-5;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,44+5, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHBonusLogCell" bundle:nil] forCellReuseIdentifier:@"HHBonusLogCell"];

    [self addHeadRefresh];

    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    //获取数据
    [self getDatas];
    
}
- (void)getDatas{
    
    if (self.chooseIndex == 0) {
        [[[HHMineAPI getReward_ShareWithpage:@(self.page)]netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            
            if (!error) {
                if (api.code == 0) {
                    [self addFootRefresh];
                    self.isLoading = YES;
                    [self loadDataFinish:api.data[@"list"]];
                }
            }
        }];
    }else if (self.chooseIndex == 1){
        [self getCommonDatasWithType:@0];
    }else if (self.chooseIndex == 2){
        [self getCommonDatasWithType:@1];
    }else if (self.chooseIndex == 3){
        [self getCommonDatasWithType:@2];
    }
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
    NSString *astr;
    if (self.isLoading) {
        astr = @"您还没有相关的奖金日志～";
    }else{
        astr = @"";
    }
    return [[NSAttributedString alloc] initWithString:astr attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:APP_purple_Color}];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    CGFloat offset = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    offset += CGRectGetHeight(self.navigationController.navigationBar.frame);
    return -offset;
    
}
- (void)getCommonDatasWithType:(NSNumber *)type{
    
    [[ [HHMineAPI getReward_BonusWithtype:type page:@(self.page)] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        
        if (!error) {
            if (api.code == 0) {
                [self addFootRefresh];
                self.isLoading = YES;
                [self loadDataFinish:api.data[@"list"]];
            }
        }
    }];
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
    
    if (self.datas.count <20) {
        self.tableView.mj_footer.hidden = YES;
    }
    if (arr.count < 20) {
        
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
    
    HHBonusLogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHBonusLogCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.chooseIndex == 0) {
        HHMineModel *model = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.section]];
        cell.share_rewardModel = model;
    }else if (self.chooseIndex == 1){
        HHMineModel *model = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.section]];
        cell.blendModel = model;
    }else if (self.chooseIndex == 2){
        HHMineModel *model = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.section]];
        cell.a_bonus_totalModel = model;
    }else if (self.chooseIndex == 3){
        HHMineModel *model = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.section]];
        cell.b_bonus_totalModel = model;
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
    head.backgroundColor = kWhiteColor;
    UIImageView  *imagV = [UIImageView lh_imageViewWithFrame:CGRectMake(0, 0, 40, 40) image:[UIImage imageNamed:@"icon_log_-default"]];
    imagV.contentMode = UIViewContentModeCenter;
    [head addSubview:imagV];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imagV.frame), 0, ScreenW - 40, 40)];
    lab.font = FONT(14);
    HHMineModel *model = [HHMineModel mj_objectWithKeyValues:self.datas[section]];
    lab.text = model.sign_name;
    [head addSubview:lab];
    return head;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.datas.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;

}


@end
