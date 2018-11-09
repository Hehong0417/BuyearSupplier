//
//  HHMyWalletVC.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHMyWalletVC.h"
#import "HHMyWalletCell.h"
#import "HHWalletDetailVC.h"

@interface HHMyWalletVC ()<UIScrollViewDelegate,SGSegmentedControlDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property(nonatomic,strong)   SGSegmentedControl *SG;
@property (nonatomic, strong)   NSArray *title_arr;
@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, strong)   NSString *isTime1;
@property (nonatomic, assign)   NSInteger  page;
@property (nonatomic, strong)   NSString *time1Str;
@property (nonatomic, strong)   NSString *time2Str;
@property (nonatomic, strong)   NSNumber *type;
@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic,strong)  HHMineModel  *mineModel;
@property (nonatomic, assign)   BOOL isFooterRefresh;
@property (nonatomic, assign)   BOOL isLoading;

@end

@implementation HHMyWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的钱包";
    
    self.type = nil;
    
    self.page = 1;
    
    [self setUpTimePickerView];
 
    
    [self setUpTableView];

    [self setUpSGSegmentedControl];

    [self addHeadRefresh];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

//积分赋值
-(void)setIntegralData{
    
    //85
    NSString *content =  [NSString stringWithFormat:@"现金: %.2f 购物: %.2f 提货: %.2f",self.mineModel.money_integral.floatValue,self.mineModel.shopping_integral.floatValue,self.mineModel.picking_integral.floatValue];
    CGFloat width = [content lh_sizeWithFont:FONT(14) constrainedToSize:CGSizeMake(MAXFLOAT, 45)].width;
    UILabel *headLab = [UILabel lh_labelWithFrame:CGRectMake(10, 0, width+10, 45) text:@"" textColor:APP_COMMON_COLOR font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:KVCBackGroundColor];
    [self.view addSubview:headLab];
    
    NSMutableAttributedString *attrStr = [self lh_attriStrWithAttrStr1:@"现金:" content:content attrStr2:@"购物:" attrStr3:@"提货:" protocolStrColor:APP_purple_Color contentColor:kRedColor];
    headLab.attributedText = attrStr;
    
    NSString *s_integral =  [NSString stringWithFormat:@"积分:%.2f",self.mineModel.s_integral.floatValue];
    CGFloat btn_width = [s_integral lh_sizeWithFont:FONT(14) constrainedToSize:CGSizeMake(MAXFLOAT, 45)].width;
    UIButton *s_integralBtn = [UIButton lh_buttonWithFrame:CGRectMake(width+10, 0, btn_width+10, 45) target:self action:nil image:[UIImage imageNamed:@"icon_integral_default"]];
    NSMutableAttributedString *s_integralStr = [NSString lh_attriStrWithprotocolStr:@"积分:" content:s_integral protocolStrColor:APP_purple_Color contentColor:kRedColor];
    [s_integralBtn setAttributedTitle:s_integralStr forState:UIControlStateNormal];
    [self.view addSubview:s_integralBtn];
    
}
//日期筛选
- (void)setUpTimePickerView{
    
    HXCommonPickView *pickView = [[HXCommonPickView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    
    self.title_arr = @[@"全部",@"现金积分",@"购物积分",@"提货积分",@"积分"];

    //选择时间
    UIView *timeView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) backColor:kWhiteColor];
    [self.view addSubview:timeView];
    
    UILabel *timeLab = [UILabel lh_labelWithFrame:CGRectMake(10, 0, 70, 40) text:@"日期筛选" textColor:KACLabelColor font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    [timeView addSubview:timeLab];
    
    UILabel *timeLab2 = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(timeLab.frame)+10, 0, 120, 40) text:@"开始日期     ～" textColor:KA0LabelColor font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    [timeView addSubview:timeLab2];
    
    UILabel *timeLab3 = [UILabel lh_labelWithFrame:CGRectMake(CGRectGetMaxX(timeLab2.frame), 0, 100, 40) text:@"结束日期" textColor:KA0LabelColor font:FONT(14) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
    [timeView addSubview:timeLab3];
    
    UIImageView *arrow = [UIImageView lh_imageViewWithFrame:CGRectMake(SCREEN_WIDTH - 60, 0, 40, 40) image: [UIImage imageNamed:@"icon_skips_user_default"]];
    arrow.contentMode = UIViewContentModeCenter;
    [timeView addSubview:arrow];
    timeLab2.userInteractionEnabled = YES;
    [timeLab2 setTapActionWithBlock:^{
        
        //前一个日期
        self.page = 1;
        self.isTime1 = @"yes";
        [pickView setStyle:HXCommonPickViewStyleDate minimumDate:nil maximumDate:[NSDate date] titleArr:nil];
        [pickView showPickViewAnimation:YES];
        
    }];
    timeLab3.userInteractionEnabled = YES;
    [timeLab3 setTapActionWithBlock:^{
        //后一个日期
        self.isTime1 = @"no";
        [pickView setStyle:HXCommonPickViewStyleDate minimumDate:nil maximumDate:[NSDate date] titleArr:nil];
        [pickView showPickViewAnimation:YES];
        
    }];
    
    pickView.completeBlock2 = ^(NSDate *date) {
        
        if ([self.isTime1 isEqualToString:@"yes"]) {
            timeLab2.text = [NSString stringWithFormat:@"%@  ～",[date lh_string_yyyyMMdd]];
            self.time1Str = [date lh_string_yyyyMMdd];
            if (self.time2Str.length>0) {
                [self timeSort];
            }
            
        }else{
            timeLab3.text = [NSString stringWithFormat:@"%@",[date lh_string_yyyyMMdd]];
            self.time2Str = [date lh_string_yyyyMMdd];
            if (self.time1Str.length>0) {
                [self timeSort];
            }
        }
    } ;
    
}
//日期筛选
- (void)timeSort{
    
    [self.datas removeAllObjects];
    int  i = [NSDate compareDate:self.time1Str withDate:self.time2Str];
    
    if (i == -1) {
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        [SVProgressHUD showInfoWithStatus:@"结束日期不能小于开始日期"];
    }else{
        
        [self getDatasWithtype:self.type begin_date:self.time1Str end_date:self.time2Str];
    }
}
#pragma mark - DZNEmptyDataSetDelegate

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
        aStr = @"您还没有的相关记录～";
    }else{
        aStr = @"";
    }
    return [[NSAttributedString alloc] initWithString:aStr attributes:@{NSFontAttributeName:FONT(14),NSForegroundColorAttributeName:APP_purple_Color}];
}
//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
//
//    return [[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:FONT(12),NSForegroundColorAttributeName:KACLabelColor}];
//
//}

- (void)setUpTableView{
    
    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT - 64-40-45-10;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,92+1, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHMyWalletCell" bundle:nil] forCellReuseIdentifier:@"HHMyWalletCell"];
    
}
- (void)setUpSGSegmentedControl{
    
    self.SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 48, SCREEN_WIDTH, 44) delegate:self segmentedControlType:SGSegmentedControlTypeStatic nomalImageArr:@[@"",@"",@"",@"",@"icon_integral_default"] selectedImageArr:@[@"",@"",@"",@"",@"icon_integral_default"] titleArr:self.title_arr];
    self.SG.title_fondOfSize = FONT(14);
    self.SG.titleColorStateNormal = APP_COMMON_COLOR;
    self.SG.titleColorStateSelected = APP_COMMON_COLOR;
    self.SG.indicatorColor = APP_COMMON_COLOR;
    [self.view addSubview:_SG];
    
}
- (void)addHeadRefresh{
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.datas removeAllObjects];
        self.isFooterRefresh = YES;
        self.page = 1;
        [self getDatasWithtype:self.type begin_date:self.time1Str end_date:self.time2Str];
    }];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    self.tableView.mj_header = refreshHeader;
    
}
- (void)addFootRefresh{
    
    MJRefreshAutoNormalFooter *refreshfooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.isFooterRefresh = YES;
        self.page++;
        [self getDatasWithtype:self.type begin_date:self.time1Str end_date:self.time2Str];
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
- (NSMutableArray *)datas{
    
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (void)getDatasWithtype:(NSNumber *)type begin_date:(NSString *)begin_date end_date:(NSString *)end_date {
    
    [[[HHMineAPI GetIntegralChangeRecordWithpage:@(self.page) type:self.type begin_date:self.time1Str end_date:self.time2Str] netWorkClient] getRequestInView:self.isFooterRefresh?nil:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
       
        if (!error) {
            
            if (api.code == 0) {
                [self addFootRefresh];
                NSArray *arr = api.data[@"list"];
                self.isLoading = YES;
                [self loadDataFinish:arr];
            }else{
                [SVProgressHUD showInfoWithStatus:api.msg];
            }
        }
    }];
}

- (void)SGSegmentedControl:(SGSegmentedControl *)segmentedControl didSelectBtnAtIndex:(NSInteger)index {
  
    [self.datas removeAllObjects];
    self.page = 1;
    if (index == 0) {
        self.type = nil;
    }else if (index == 1){
        self.type = @0;

    }else if (index == 2){
        self.type = @1;

    }else if (index == 3){
        self.type = @3;
    }else if (index == 4){
        self.type = @2;
    }
    self.isFooterRefresh = NO;
    self.tableView.mj_footer.hidden = NO;

    [self getDatasWithtype:self.type begin_date:self.time1Str end_date:self.time2Str];
}

- (NSMutableAttributedString *)lh_attriStrWithAttrStr1:(NSString *)attrStr1 content:(NSString *)content attrStr2:(NSString *)attrStr2 attrStr3:(NSString *)attrStr3 protocolStrColor:(UIColor *)protocolStrColor  contentColor:(UIColor *)contentColor{
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:content];
    
    NSRange attrStr1Range = [content rangeOfString:attrStr1];
    NSRange attrStr2Range = [content rangeOfString:attrStr2];
    NSRange attrStr3Range = [content rangeOfString:attrStr3];
    NSRange contentRange = [content rangeOfString:content];
    
    [attr addAttribute:NSFontAttributeName value:FONT(14) range:contentRange];
    [attr addAttribute:NSForegroundColorAttributeName value:contentColor range:contentRange];
    [attr addAttribute:NSForegroundColorAttributeName value:protocolStrColor range:attrStr1Range];
    [attr addAttribute:NSForegroundColorAttributeName value:protocolStrColor range:attrStr2Range];
    [attr addAttribute:NSForegroundColorAttributeName value:protocolStrColor range:attrStr3Range];

    return attr;
}

#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHMyWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHMyWalletCell"];
    if (self.datas.count>0) {
        cell.myWalletModel = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.row]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return cell;
}
- (void)oneAction:(UIButton *)btn{
    
    
}
- (void)twoAction:(UIButton *)btn{
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//        HHWalletDetailVC *vc = [[HHWalletDetailVC alloc]initWithNibName:@"HHWalletDetailVC" bundle:nil];
//        vc.myWalletModel = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.row]];
//        vc.userid = self.userid;
//        [self.navigationController pushVC:vc];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}
@end
