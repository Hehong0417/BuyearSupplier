//
//  HHMyOrderVC.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHMyOrderVC.h"
#import "SGSegmentedControl.h"
#import "HJOrderCell.h"
#import "HJOrderOneCell.h"
#import "HHOrderTwoCell.h"
#import "HHLogisticsVC.h"
#import "HHSubmitOrdersVC.h"
#import "HHOrderDetailVC.h"
#import "HHReturnGoodsVC.h"
#import "HHCategoryVC.h"
#import "HHPaySucessVC.h"
#import "HHFillLogisticsVC.h"
#import "HHMyOrderItem.h"

@interface HHMyOrderVC ()<UIScrollViewDelegate,SGSegmentedControlDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic,strong)   SGSegmentedControl *SG;
@property (nonatomic, strong)   NSArray *title_arr;
@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, assign)   NSInteger sg_selectIndex;
@property (nonatomic, assign)   BOOL isFooterRefresh;
@property(nonatomic,assign)   BOOL  isLoading;
@property(nonatomic,assign)   BOOL  isWlan;

@end

@implementation HHMyOrderVC

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的订单";
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.page = 1;
    self.datas = [NSMutableArray array];
    self.title_arr = @[@"全部",@"待付款",@"待发货",@"待收货",@"交易成功"];
    //UI
    [self setUI];
    self.isFooterRefresh = NO;

    //全部
    [self getDatasWithIndex:nil];
    
}
#pragma mark - UI
- (void)setUI{
    
    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT - 64 - 44 - 10;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,44+8, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    [self.view addSubview:self.tableView];
    
    //registerCell
    [self.tableView registerNib:[UINib nibWithNibName:@"HHOrderTwoCell" bundle:nil] forCellReuseIdentifier:@"HHOrderTwoCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HJOrderCell" bundle:nil] forCellReuseIdentifier:@"HJOrderCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HJOrderOneCell" bundle:nil] forCellReuseIdentifier:@"HJOrderOneCell"];
    
    //SG
    self.SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) delegate:self segmentedControlType:(SGSegmentedControlTypeStatic) titleArr:self.title_arr];
    self.SG.title_fondOfSize = FONT(14);
    self.SG.titleColorStateNormal = APP_COMMON_COLOR;
    self.SG.titleColorStateSelected = APP_COMMON_COLOR;
    self.SG.indicatorColor = APP_COMMON_COLOR;
    [self.view addSubview:_SG];
    
    //headdRefresh
    [self addHeadRefresh];
    
}
- (void)addHeadRefresh{
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.isFooterRefresh = YES;
        [self.datas removeAllObjects];
        if (self.sg_selectIndex == 0) {
            [self getDatasWithIndex:nil];
        }else{
            [self getDatasWithIndex:@(self.sg_selectIndex-1)];
        }
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    self.tableView.mj_header = refreshHeader;
}
- (void)addFootRefresh{
    
    MJRefreshAutoNormalFooter *refreshfooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        self.isFooterRefresh = YES;
        if (self.sg_selectIndex == 0) {
            [self getDatasWithIndex:nil];
        }else{
            [self getDatasWithIndex:@(self.sg_selectIndex-1)];
        }
    }];
    self.tableView.mj_footer = refreshfooter;
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
    
    NSString *titleStr;
    if (self.isLoading) {
        if (self.isWlan) {
        titleStr = @"订单是空的";
        }else{
        titleStr = @"";
        }
    }else{
        //没加载过
        titleStr = @"";
    }
    return [[NSAttributedString alloc] initWithString:titleStr attributes:@{NSFontAttributeName:FONT(18),NSForegroundColorAttributeName:APP_purple_Color}];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    
    NSString *titleStr;
    if (self.isLoading) {
        if (self.isWlan) {
            titleStr = @"赶紧把你喜欢的宝贝带回家";
        }else{
            titleStr = @"网络竟然崩溃了～";
        }
     }else{
        //没加载过
        titleStr = @"";
    }
    return [[NSAttributedString alloc] initWithString:titleStr attributes:@{NSFontAttributeName:FONT(12),NSForegroundColorAttributeName:KACLabelColor}];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    
    NSString *titleStr;
    if (self.isLoading) {
        if (self.isWlan) {
        titleStr = @"去下单";
        }else{
        titleStr = @"刷新试试";
        }
    }else{
        //没加载过
        titleStr = @"";
    }
    return [[NSAttributedString alloc] initWithString:titleStr attributes:@{NSFontAttributeName:BoldFONT(18),NSForegroundColorAttributeName:kWhiteColor}];
    
}
- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    UIEdgeInsets capInsets = UIEdgeInsetsMake(22.0, 22.0, 22.0, 22.0);
    UIEdgeInsets   rectInsets = UIEdgeInsetsMake(0.0, -30, 0.0, -30);
    
    UIImage *image = [UIImage imageWithColor:APP_COMMON_COLOR redius:5 size:CGSizeMake(ScreenW-60, 40)];
    
    return [[image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    CGFloat offset = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    offset += CGRectGetHeight(self.navigationController.navigationBar.frame);
    return -offset;
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    return 20;
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    if (self.isWlan) {
     HHCategoryVC *vc = [HHCategoryVC new];
     [self.navigationController pushVC:vc];
    }else{
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - NetWork

- (void)getDatasWithIndex:(NSNumber *)index{
    
    [[[HHMineAPI GetOrderListWithstatus:index page:@(self.page)] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        
        self.isLoading = YES;
        if (!error) {
            if (api.code == 0) {
                [self addFootRefresh];
                self.isWlan = YES;
                [self loadDataFinish:api.data[@"list"]];
            }else{
                self.isWlan = YES;
                [SVProgressHUD showInfoWithStatus:api.msg];
                [self.tableView.mj_header endRefreshing];
                self.tableView.mj_footer.hidden = YES;
                [self.tableView reloadData];
            }
        }else{
                self.isWlan = NO;
                self.tableView.mj_footer.hidden = YES;
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
        }
    }];
}

/**
 *  加载数据完成
 */
- (void)loadDataFinish:(NSArray *)arr {

    [self.datas addObjectsFromArray:arr];
    
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
        if (self.datas.count == 0) {
            self.tableView.mj_footer.hidden = YES;
        }else {
            [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
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
#pragma mark --- SGSegmentedControl delegate

- (void)SGSegmentedControl:(SGSegmentedControl *)segmentedControl didSelectBtnAtIndex:(NSInteger)index {
    
    self.isFooterRefresh = YES;
    self.sg_selectIndex = index;
    [self.tableView.mj_header beginRefreshing];

//    self.page = 1;
//    [self.datas removeAllObjects];
//      self.sg_selectIndex = index;
//    if (index == 0) {
//        [self getDatasWithIndex:nil];
//    }else{
//        [self getDatasWithIndex:@(index-1)];
//    }
}

#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[indexPath.section]];
    UITableViewCell *grideCell;
    if (indexPath.row == model.products.count){
        //赠送积分
        HJOrderOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HJOrderOneCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orderModel = model;
        grideCell = cell;

    }else if (indexPath.row == model.products.count+1){
        //订单总计
        HHOrderTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHOrderTwoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orderTotalModel = model;
        grideCell = cell;
        
    }else if (indexPath.row == model.products.count+2){
        //物流单号
        HHOrderTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHOrderTwoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orderModel = model;
        grideCell = cell;
    }else{
        //商品
            HJOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HJOrderCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.productModel =  model.products[indexPath.row];
        grideCell = cell;
    }
    grideCell.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
    
    return grideCell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60) backColor:kWhiteColor];
    
    UIButton *oneBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH-160-20, 10, 80, 30) target:self action:@selector(oneAction:) title:@"" titleColor:APP_COMMON_COLOR font:FONT(14) backgroundColor:kWhiteColor];
    oneBtn.tag = section+100;
    [oneBtn lh_setCornerRadius:5 borderWidth:1 borderColor:APP_COMMON_COLOR];
    [footView addSubview:oneBtn];

    UIButton *twoBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH-90, 10, 80, 30) target:self action:@selector(twoAction:) title:@"去支付" titleColor:kWhiteColor font:FONT(14) backgroundColor:APP_COMMON_COLOR];
    twoBtn.tag = section+1000;
    [twoBtn lh_setCornerRadius:5 borderWidth:1 borderColor:APP_COMMON_COLOR];
    [footView addSubview:twoBtn];
    
    //最左边按钮
    UIButton *leftBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH-160-20-90, 10, 80, 30) target:self action:@selector(leftBtnAction:) title:@"填写物流" titleColor:APP_COMMON_COLOR font:FONT(14) backgroundColor:kWhiteColor];
    leftBtn.tag = section+1001;
    [leftBtn lh_setCornerRadius:5 borderWidth:1 borderColor:APP_COMMON_COLOR];
    [footView addSubview:leftBtn];
    leftBtn.hidden = YES;
    
    //分割线Y坐标
    CGFloat down_y = 52;
    if (self.datas.count>0) {
        HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[section]];
        NSString *status = model.status_code;
        if ([status isEqualToString:@"0"]) {
            //待付款
            down_y = 52;
            //oneBtn
            [self setBtnAttrWithBtn:oneBtn Title:@"取消订单" CornerRadius:5 borderColor:APP_COMMON_COLOR titleColor:APP_COMMON_COLOR backgroundColor:kWhiteColor];
            //twoBtn
            [self setBtnAttrWithBtn:twoBtn Title:@"去支付" CornerRadius:5 borderColor:APP_COMMON_COLOR titleColor:kWhiteColor backgroundColor:APP_COMMON_COLOR];
        }else if([status isEqualToString:@"1"]){
            //待发货
            if ([model.ship_channel isEqualToString:@"1"]) {
                down_y = 0;
                //体验店
                oneBtn.hidden = YES;
                twoBtn.hidden = YES;
            }else{
             down_y = 52;
            //oneBtn
            oneBtn.hidden = YES;
            //twoBtn
            twoBtn.hidden = NO;
            [self setBtnAttrWithBtn:twoBtn Title:@"申请退款" CornerRadius:5 borderColor:APP_COMMON_COLOR titleColor:APP_COMMON_COLOR backgroundColor:kWhiteColor];
            }
        }else if([status isEqualToString:@"2"]){
            //待收货
            down_y = 52;
            if ([model.is_exist_reeturn_goods_Express isEqualToString:@"1"]) {
                
                [leftBtn setTitle:@"退货物流" forState:UIControlStateNormal];
            }else{
                [leftBtn setTitle:@"填写物流" forState:UIControlStateNormal];
            }
            //oneBtn
            if ([model.ship_channel isEqualToString:@"1"]) {
                //体验店
                oneBtn.hidden = YES;
                leftBtn.hidden = YES;
                
            }else if([model.ship_channel isEqualToString:@"0"]){
                //总部
                if ([model.refund_status isEqualToString:@"0"]) {
                    [self setBtnAttrWithBtn:oneBtn Title:@"申请退货" CornerRadius:5 borderColor:APP_COMMON_COLOR titleColor:APP_COMMON_COLOR backgroundColor:kWhiteColor];
                    oneBtn.hidden = NO;
                    if ([model.is_agree_return_goods isEqualToString:@"1"]) {
                    leftBtn.hidden = NO;
                    }else{
                    leftBtn.hidden = YES;
                    }
                }else{
                    //全部退货----第一个改成“填写物流”
                    leftBtn.hidden = YES;
                    if ([model.is_agree_return_goods isEqualToString:@"1"]) {
                        oneBtn.hidden = NO;
                    }else{
                        oneBtn.hidden = YES;
                    }
                    if ([model.is_exist_reeturn_goods_Express isEqualToString:@"1"]) {
                        [self setBtnAttrWithBtn:oneBtn Title:@"退货物流" CornerRadius:5 borderColor:APP_COMMON_COLOR titleColor:APP_COMMON_COLOR backgroundColor:kWhiteColor];
                    }else{
                        
                        [self setBtnAttrWithBtn:oneBtn Title:@"填写物流" CornerRadius:5 borderColor:APP_COMMON_COLOR titleColor:APP_COMMON_COLOR backgroundColor:kWhiteColor];
                    }
                }
            }
            //twoBtn
            [self setBtnAttrWithBtn:twoBtn Title:@"确认收货" CornerRadius:5 borderColor:APP_COMMON_COLOR titleColor:APP_COMMON_COLOR backgroundColor:kWhiteColor];
            
        }else if([status isEqualToString:@"3"]){
            //交易成功
            down_y = 0;
            //oneBtn
            oneBtn.hidden = YES;
            //twoBtn
            twoBtn.hidden = YES;
            
        }else if([status isEqualToString:@"4"]){
            // @"已退款";
            down_y = 0;
            oneBtn.hidden = YES;
            twoBtn.hidden = YES;
            
        }else if([status isEqualToString:@"5"]){
            // @"已退货";
            down_y = 0;
            oneBtn.hidden = YES;
            twoBtn.hidden = YES;
            
        }else if([status isEqualToString:@"6"]){
            //订单关闭
            down_y = 0;
            //oneBtn
            oneBtn.hidden = YES;
            twoBtn.hidden = YES;
            
        }
    }
    UIView *downLine = [UIView lh_viewWithFrame:CGRectMake(0, down_y, SCREEN_WIDTH, 8) backColor:KVCBackGroundColor];
    [footView addSubview:downLine];

    return footView;
    
}
- (void)setBtnAttrWithBtn:(UIButton *)btn Title:(NSString *)title CornerRadius:(NSInteger)cornerRadius borderColor:(UIColor *)borderColor titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor{
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn lh_setCornerRadius:cornerRadius borderWidth:1 borderColor:borderColor];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setBackgroundColor:backgroundColor];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[indexPath.section]];

    if (indexPath.row == model.products.count){
        //赠送积分
        
    }else if (indexPath.row == model.products.count+1){
        //订单总计
        
    }else if (indexPath.row == model.products.count+2){
        //发货物流信息
        HHLogisticsVC *vc = [HHLogisticsVC new];
        HHCartModel *orderModel = [HHCartModel mj_objectWithKeyValues:self.datas[indexPath.section]];
        vc.orderid = orderModel.orderid;
        vc.express_order = orderModel.express_order;
        vc.express_name = orderModel.express_name;
        vc.type = @0;
        [self.navigationController pushVC:vc];
        
    }else{
        //商品
        HHOrderDetailVC *vc = [HHOrderDetailVC new];
        HHCartModel *orderModel = [HHCartModel mj_objectWithKeyValues:self.datas[indexPath.section]];
        vc.orderid = orderModel.orderid;
        [self.navigationController pushVC:vc];
        
    }

}
- (void)oneAction:(UIButton *)btn{
    NSInteger section = btn.tag - 100;
    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[section]];
    NSString *status = model.status_code;
    if ([status isEqualToString:@"0"]) {
        //待付款--->取消订单
        [self closeOrderWithorderid:model.orderid status:nil btn:btn];
        
    }else if([status isEqualToString:@"1"]){
        //待发货-->申请退款
        
    }else if([status isEqualToString:@"2"]){
        //待收货--->申请退货
        if ([model.refund_status isEqualToString:@"0"]) {
            //申请退货
            //oneBtn
            HHReturnGoodsVC *vc = [HHReturnGoodsVC new];
            vc.titleStr = @"申请退货";
            vc.orderid = model.orderid;
            vc.returnBlock = ^{
                self.page = 1;
                self.sg_selectIndex = 3;
                [self.datas removeAllObjects];
                [self getDatasWithIndex:@2];
            };
            [self.navigationController pushVC:vc];
            
        }else{
            if ([model.is_exist_reeturn_goods_Express isEqualToString:@"1"]) {
                //查看退货物流
                HHLogisticsVC *vc = [HHLogisticsVC new];
                vc.orderid = model.orderid;
                vc.express_order = model.return_goods_express_order;
                vc.express_name = model.return_goods_express_name;
                vc.type = @1;
                [self.navigationController pushVC:vc];
            }else{
                //填写物流
                HHFillLogisticsVC *vc = [HHFillLogisticsVC new];
                vc.orderid = model.orderid;
                vc.return_goods_express_code = model.return_goods_express_code;
                vc.return_goods_express_order = model.return_goods_express_order;
                vc.return_numb_block = ^(NSNumber *result) {
                    self.page = 1;
                    [self.datas removeAllObjects];
                    [self getDatasWithIndex:@(self.sg_selectIndex-1)];
                };
                [self.navigationController pushVC:vc];
            }
        }
    }else if([status isEqualToString:@"3"]){
        //交易成功-->不做处理
//        483193862886  zhongtong
    }
}
//取消订单
- (void)closeOrderWithorderid:(NSString *)orderid status:(NSNumber *)status btn:(UIButton *)btn{
    
        btn.enabled = NO;
    [btn lh_setBackgroundColor:KA0LabelColor forState:UIControlStateNormal];

    [[[HHMineAPI postOrder_CloseWithorderid:orderid] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        btn.enabled = YES;
        [btn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];

        if (!error) {
            if (api.code == 0) {
                [self.datas removeAllObjects];
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD showSuccessWithStatus:@"取消订单成功！"];
                if (self.sg_selectIndex == 0) {
                    [self getDatasWithIndex:nil];
                }else{
                    [self getDatasWithIndex:@(self.sg_selectIndex-1)];
                }
            }else{
               
                [SVProgressHUD showInfoWithStatus:api.msg];
            }
        }
    }];

}
//支付订单
- (void)payOrderWithorderid:(NSString *)orderid btn:(UIButton *)btn{
    
    MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = KA0LabelColor;
    hud.detailsLabelText = @"付款中...";
    hud.detailsLabelColor = kWhiteColor;
    hud.detailsLabelFont = FONT(14);
    hud.activityIndicatorColor = kWhiteColor;
    [hud showAnimated:YES];
    btn.enabled = NO;
    [[[HHMineAPI postPayOrderWithorderid:orderid] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        btn.enabled = YES;

        if (!error) {
            if (api.code == 0) {
                //-->支付成功
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    HHPaySucessVC *vc = [HHPaySucessVC new];
                    [self.navigationController pushVC:vc];
                    [hud hideAnimated:YES];
                });
            }else{
                [hud hideAnimated:YES];

                [SVProgressHUD showInfoWithStatus:api.msg];
            }
        }else{
            [hud hideAnimated:YES];
        }
    }];
}
//确认收货
- (void)commitOrderWithorderid:(NSString *)orderid status:(NSNumber *)status btn:(UIButton *)btn{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"确认收货吗？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        btn.enabled = NO;
        [btn lh_setBackgroundColor:KA0LabelColor forState:UIControlStateNormal];

        [[[HHMineAPI postConfirmOrderWithorderid:orderid]netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            btn.enabled = YES;
            [btn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];

            if (!error) {
                if (api.code == 0) {
                    
                    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                    [SVProgressHUD showSuccessWithStatus:@"确认收货成功！"];
                    self.page = 1;
                    [self.datas removeAllObjects];
                    [self getDatasWithIndex:status];
                }else{
                    [SVProgressHUD showInfoWithStatus:api.msg];
                }
            }else {
                
                [SVProgressHUD showInfoWithStatus:api.msg];
                
            }
        }];
    }];

    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alertC dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertC addAction:action1];
    [alertC addAction:action2];
    [self presentViewController:alertC animated:YES completion:nil];

}
- (void)twoAction:(UIButton *)btn{
    
    NSInteger section = btn.tag - 1000;
    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[section]];
    NSString *status = model.status_code;
    
    if ([status isEqualToString:@"0"]) {
        //待付款--->去支付
        [self payOrderWithorderid:model.orderid btn:btn];
        
    }else if([status isEqualToString:@"1"]){
        //待发货-->申请退款
        HHReturnGoodsVC *vc = [HHReturnGoodsVC new];
        vc.titleStr = @"申请退款";
        vc.orderid = model.orderid;
        vc.returnBlock = ^{
            self.page = 1;
            self.sg_selectIndex = 3;
            [self.datas removeAllObjects];
            [self getDatasWithIndex:@1];
        };
        [self.navigationController pushVC:vc];
        
    }else if([status isEqualToString:@"2"]){
        //待收货--->确认收货
        if (self.sg_selectIndex == 0) {
            [self commitOrderWithorderid:model.orderid status:nil btn:btn];
        }else{
            [self commitOrderWithorderid:model.orderid status:@(self.sg_selectIndex-1) btn:btn];
        }
        
    }else if([status isEqualToString:@"3"]){
        //交易成功-->不做处理
//        [self closeOrderWithorderid:model.orderid status:nil];

    }

}
//填写物流
- (void)leftBtnAction:(UIButton *)btn{
    NSInteger section = btn.tag - 1001;
    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[section]];
    if ([model.is_exist_reeturn_goods_Express isEqualToString:@"1"]) {
        //查看退货物流
        HHLogisticsVC *vc = [HHLogisticsVC new];
        vc.orderid = model.orderid;
        vc.express_order = model.return_goods_express_order;
        vc.express_name = model.return_goods_express_name;
        vc.type = @1;
        [self.navigationController pushVC:vc];
    }else{
        //填写物流
        HHFillLogisticsVC *vc = [HHFillLogisticsVC new];
        vc.orderid = model.orderid;
        vc.return_goods_express_code = model.return_goods_express_code;
        vc.return_goods_express_order = model.return_goods_express_order;
        vc.return_numb_block = ^(NSNumber *result) {
            self.page = 1;
            [self.datas removeAllObjects];
            [self getDatasWithIndex:@(self.sg_selectIndex-1)];
        };
        [self.navigationController pushVC:vc];
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[section]];
    
    UIView *headView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) backColor:kWhiteColor];
    
    NSString *status =  [HHMyOrderItem shippingLogisticsStateWithStatus_code:model.status_code.integerValue];

    UILabel *textLabel = [UILabel lh_labelWithFrame:CGRectMake(15, 0, 60, 40) text:status textColor:kRedColor font:[UIFont boldSystemFontOfSize:14] textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    [headView addSubview:textLabel];
    UIView *downLine = [UIView lh_viewWithFrame:CGRectMake(CGRectGetMaxX(textLabel.frame)+5, 0,1, 40) backColor:KVCBackGroundColor];
    [headView addSubview:downLine];

    UILabel *orderLabel = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(textLabel.frame)+20, 0,200 , 40) text: [NSString stringWithFormat:@"订单号:%@",model.orderid] textColor:kBlackColor font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    [headView addSubview:orderLabel];
    return headView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.datas.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[section]];
    if (model.express_order.length == 0) {
        return model.products.count+2;
    }else{
        return model.products.count+3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[indexPath.section]];
    
    CGFloat height = 0.01;
    
    height = [HHMyOrderItem rowHeightWithRow:indexPath.row Products_count:model.products.count];
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    HHCartModel *model = [HHCartModel mj_objectWithKeyValues:self.datas[section]];
                
    return model.footHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}
@end
