//
//  HHOrderDetailVC.m
//  Store
//
//  Created by User on 2018/1/8.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHOrderDetailVC.h"
#import "HHSubmitOrderCell.h"
#import "HHOrderDetailCellOne.h"
#import "HHOrderDetailHead.h"
#import "HHOrderDetailTableHead.h"

@interface HHOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *orderIdLabel;
    UILabel *createdateLabel;
    HHOrderDetailTableHead *subhead;
}
@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, strong)   HHCartModel *model;


@end

@implementation HHOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"订单详情";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT - 64 ;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHSubmitOrderCell" bundle:nil] forCellReuseIdentifier:@"HHSubmitOrderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HHOrderDetailCellOne" bundle:nil] forCellReuseIdentifier:@"HHOrderDetailCellOne"];
    //添加头部
    [self addTableHeader];
    
//    [self addPayBtn];
    
    //获取数据
    [self getDatas];
}
//获取数据
- (void)getDatas{
    
    [[[HHMineAPI GetOrderDetailWithorderid:self.orderid] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
       
        if (!error) {
            if (api.code == 0) {
        
                    self.model = [HHCartModel mj_objectWithKeyValues:api.data];
                    orderIdLabel.text = [NSString stringWithFormat:@"订单编号：%@",self.model.orderid];
                    createdateLabel.text = [NSString stringWithFormat:@"下单时间：%@",self.model.createdate];
                    subhead.order_status_label.text = self.model.status;
                    [self.tableView reloadData];
                    
            }else{

                [SVProgressHUD showInfoWithStatus:api.msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.msg];

        }
    }];
    
}
- (void)addTableHeader{
    
    UIView *tableHead = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 100) backColor:KVCBackGroundColor];
    tableHead.backgroundColor = KVCBackGroundColor;

    subhead = [[[NSBundle mainBundle] loadNibNamed:@"HHOrderDetailTableHead" owner:self options:nil] lastObject];
    orderIdLabel = [UILabel lh_labelWithFrame:CGRectMake(41,35 , ScreenW, 30) text:@"订单编号：" textColor:kBlackColor font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft backgroundColor:KVCBackGroundColor];
    createdateLabel = [UILabel lh_labelWithFrame:CGRectMake(41,65 , ScreenW, 30) text:@"下单时间：" textColor:kBlackColor font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft backgroundColor:KVCBackGroundColor];
    [tableHead addSubview:subhead];
    [tableHead addSubview:orderIdLabel];
    [tableHead addSubview:createdateLabel];

    self.tableView.tableHeaderView = tableHead;
}
- (void)addPayBtn{
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, ScreenH - 50-64, SCREEN_WIDTH, 50) backColor:kWhiteColor];
    
    UIButton *oneBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH-140, 10, 60, 30) target:self action:@selector(oneAction:) title:@"取消" titleColor:APP_COMMON_COLOR font:FONT(16) backgroundColor:kWhiteColor];
    [oneBtn lh_setCornerRadius:5 borderWidth:1 borderColor:APP_COMMON_COLOR];
    [footView addSubview:oneBtn];
    
    UIButton *twoBtn = [UIButton lh_buttonWithFrame:CGRectMake(SCREEN_WIDTH-70, 10, 60, 30) target:self action:@selector(twoAction:) title:@"去支付" titleColor:kWhiteColor font:FONT(16) backgroundColor:APP_COMMON_COLOR];
    [twoBtn lh_setCornerRadius:5 borderWidth:1 borderColor:APP_COMMON_COLOR];
    [footView addSubview:twoBtn];
    
    UIView *downLine = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1) backColor:KVCBackGroundColor];
    [footView addSubview:downLine];
    
    [self.view addSubview:footView];
    
}
- (void)oneAction:(UIButton *)btn{
    
    
}
- (void)twoAction:(UIButton *)btn{
    
    
}
#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *gridCell;
    
    if (indexPath.section == 0) {
        
        HHOrderDetailCellOne *cell = [tableView dequeueReusableCellWithIdentifier:@"HHOrderDetailCellOne"];
        cell.addressModel = self.model;
        gridCell = cell;
        
    }else if (indexPath.section == 1){
        
        HHSubmitOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHSubmitOrderCell"];
        cell.orderProductsModel = self.model.products[indexPath.row];
        gridCell = cell;
        
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        cell.textLabel.font = FONT(14);
        cell.detailTextLabel.font = FONT(14);
        if (indexPath.row == 0) {
            cell.textLabel.text = @"发货渠道";
            NSString *ship_channel = self.model.ship_channel;
            NSString *detailText = @"总部";
            if ([ship_channel isEqualToString:@"0"]) {
                detailText = @"总部";
            }else{
                detailText = [NSString stringWithFormat:@"体验店,%@",self.model.shopid?self.model.shopid:@""];
            }
            cell.detailTextLabel.text = detailText;
        }else  if (indexPath.row == 1) {
            cell.textLabel.text = @"配送方式";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.model.ship_mode_name?self.model.ship_mode_name:@"0"];
            
        }else  if (indexPath.row == 2) {
            cell.textLabel.text = @"订单总计";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"¥ %@",self.model.order_total?self.model.order_total:@"0"];

        }else  if (indexPath.row == 3) {
            cell.textLabel.text = @"支付现金积分";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.model.pay_money_integral?self.model.pay_money_integral:@"0"];
            
        }else  if (indexPath.row == 4) {
            cell.textLabel.text = @"支付购物积分";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.model.pay_shopping_integral?self.model.pay_shopping_integral:@"0"];
            
        }else  if (indexPath.row == 5) {
            cell.textLabel.text = @"支付提货积分";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.model.pay_picking_integral?self.model.pay_picking_integral:@"0"];
            
        }else  if (indexPath.row == 6) {
            cell.textLabel.text = @"实付";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"¥ %@",self.model.pya_total?self.model.pya_total:@"0"];

        }else  if (indexPath.row == 7) {
            cell.textLabel.text = @"赠送积分总计";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.model.s_integral?self.model.s_integral:@"0"];
            cell.imageView.image = [UIImage imageNamed:@"icon_integral_default"];
        }

        gridCell = cell;
    }
    
    gridCell.selectionStyle = UITableViewCellSelectionStyleNone;
    gridCell.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
    return gridCell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0){
        return 1;
    }else if (section == 1)
   {
        return self.model.products.count;
    }else  {
        return 8;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        return 80;
    }else  if(indexPath.section == 1){
        return 110;
    }else{
        return 50;
    }
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
    headView.backgroundColor = kWhiteColor;
    HHOrderDetailHead *head = [[[NSBundle mainBundle] loadNibNamed:@"HHOrderDetailHead" owner:self options:nil] lastObject];
    if (section == 0) {
        head.iconImageV.image = [UIImage imageNamed:@"icon_address_default"];
        head.titleLabel.text = @"收货信息";
    }else if (section == 1){
        head.iconImageV.image = [UIImage imageNamed:@"icon_mark_default"];
        head.titleLabel.text = @"商品信息";
    }else{
        head.iconImageV.image = [UIImage imageNamed:@""];
        head.titleLabel.text = @"";
    }
    [headView addSubview:head];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 0.01;
    }else{
      return 8;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 0.01;
    }else{
      return 40;
    }
}

@end
