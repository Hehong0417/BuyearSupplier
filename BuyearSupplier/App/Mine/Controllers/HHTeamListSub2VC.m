//
//  HHTeamListSubVC.m
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHTeamListSub2VC.h"
#import "HHTeamListSubCell.h"

@interface HHTeamListSub2VC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, assign)   BOOL isLoading;

@end

@implementation HHTeamListSub2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"团队列表";
    self.page = 1;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT - 64-50;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,50, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHTeamListSubCell" bundle:nil] forCellReuseIdentifier:@"HHTeamListSubCell"];
    
    //获取数据
    self.datas = [NSMutableArray array];
    [self addHeadRefresh];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    //headView
    UIView *headView = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 50) backColor:KVCBackGroundColor];
    [self.view addSubview:headView];
    
    UIButton *btn1 = [UIButton lh_buttonWithFrame:CGRectMake(ScreenW/2-10-80, 0, 80, 30) target:self action:@selector(btn1Action:) image:nil title:@"向上" titleColor:kWhiteColor font:FONT(14)];
    btn1.centerY = headView.centerY;
    btn1.backgroundColor = kBlueColor;
    [btn1 lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    
    UIButton *btn2 = [UIButton lh_buttonWithFrame:CGRectMake(CGRectGetMaxX(btn1.frame)+20, 0, 80, 30) target:self action:@selector(btn2Action:) image:nil title:@"团队列表" titleColor:kWhiteColor font:FONT(14)];
    btn2.centerY = headView.centerY;
    
    btn2.backgroundColor = kRedColor;
    
    [btn2 lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    
    [headView addSubview:btn1];
    [headView addSubview:btn2];
    
    //抓取返回按钮
    UIButton *backBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [backBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self getDatas];

}
//返回到签约单管理的第一个界面
- (void)backBtnAction{
    
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^( UIViewController * vc, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 1) {
            [self.navigationController popToVC:vc];
        }
    }];
}
//返回上一级
- (void)btn1Action:(UIButton *)btn{
    
    [self.navigationController popVC];
}
//返回第一级
- (void)btn2Action:(UIButton *)btn{
    
    [self.navigationController.viewControllers enumerateObjectsUsingBlock:^( UIViewController * vc, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 3) {
            [self.navigationController popToVC:vc];
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
- (void)getDatas{
    
    [[[HHMineAPI GetChildTeamsWithsignno:self.signno userid:self.userid page:@(self.page)] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        
        if (!error) {
            
            if (api.code == 0) {
                self.isLoading = YES;
                [self addFootRefresh];
                
                [self loadDataFinish:api.data[@"list"]];
            }else{
                [SVProgressHUD showInfoWithStatus:api.msg];
            }
        }
    }];
    
}

#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHTeamListSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHTeamListSubCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HHMineModel *model = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.row]];
    cell.childTeamsModel = model;
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHTeamListSub2VC *vc = [HHTeamListSub2VC new];
    HHMineModel *model = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.row]];
    vc.signno = model.sign_no;
    vc.userid = model.userid;
    [self.navigationController pushVC:vc];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}
@end

