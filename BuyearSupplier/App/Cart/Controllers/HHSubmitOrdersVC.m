//
//  HHSubmitOrdersVC.m
//  Store
//
//  Created by User on 2018/1/4.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHSubmitOrdersVC.h"
#import "HHSubmitOrderTool.h"
#import "HHSubmitOrderCell.h"
#import "HHSubmitOrdersHead.h"
#import "HHShippingAddressVC.h"
#import "HHGoodBaseViewController.h"
#import "HHPaySucessVC.h"
#import "HHCurrentStoreVC.h"

@interface HHSubmitOrdersVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,HHShippingAddressVCProtocol,UITextFieldDelegate>
{
    UITextField *noteTF;
    HHSubmitOrdersHead *SubmitOrdersHead;
    UISwitch *swi;
    UITextField *integral_TF;

    HXCommonPickView *pickView;
}

@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, strong)   HHSubmitOrderTool *submitOrderTool;
@property (nonatomic, strong)   NSMutableArray *leftTitleArr;
@property (nonatomic, strong)   NSMutableArray *leftTitle2Arr;
@property (nonatomic, strong)   NSMutableArray *rightDetailArr;
@property (nonatomic, strong)   NSMutableArray *rightDetail2Arr;
@property (nonatomic, strong)   HHCartModel *model;
@property (nonatomic, strong)   NSString *address_id;
@property (nonatomic, strong)   NSNumber *pay_mode;
@property (nonatomic, strong)   NSString *Id;

@end

@implementation HHSubmitOrdersVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //获取数据
    [self getDatas];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    HJUser *user = [HJUser sharedUser];
    user.is_pickageIntegral = YES;
    user.is_shopIntegral = YES;
    [user write];
    
    self.datas = [NSMutableArray array];
    
    self.page = 1;

    self.title = @"提交订单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    //tableView
    CGFloat tableHeight;
    tableHeight = SCREEN_HEIGHT - 64-50;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.backgroundColor = KVCBackGroundColor;

    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHSubmitOrderCell" bundle:nil] forCellReuseIdentifier:@"HHSubmitOrderCell"];

    
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    //地址栏
    [self addSubmitOrdersHead];
    
    //底部结算条
    [self addSubmitOrderTool];
    
    pickView = [[HXCommonPickView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];


//
    //获取收货数据
    [self getAddressData];
}
- (NSMutableArray *)leftTitleArr{
    if (!_leftTitleArr) {
        _leftTitleArr =  [NSMutableArray array];
    }
    return _leftTitleArr;
}
- (NSMutableArray *)leftTitle2Arr{
    if (!_leftTitle2Arr) {
        _leftTitle2Arr = [NSMutableArray array];
    }
    return _leftTitle2Arr;
}
- (NSMutableArray *)rightDetailArr{
    if (!_rightDetailArr) {
        _rightDetailArr = [NSMutableArray array];
    }
    return _rightDetailArr;
}
- (NSMutableArray *)rightDetail2Arr{
    if (!_rightDetail2Arr) {
        _rightDetail2Arr = [NSMutableArray array];
    }
    return _rightDetail2Arr;
}
- (void)addSubmitOrdersHead{
    
    SubmitOrdersHead = [[[NSBundle mainBundle] loadNibNamed:@"HHSubmitOrdersHead" owner:nil options:nil] lastObject];
    SubmitOrdersHead.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    SubmitOrdersHead.userInteractionEnabled = YES;
    //收货地址
    WEAK_SELF();
    [SubmitOrdersHead setTapActionWithBlock:^{
       
        HHShippingAddressVC *vc = [HHShippingAddressVC new];
        vc.delegate = weakSelf;
        [weakSelf.navigationController pushVC:vc];
        
    }];
    self.tableView.tableHeaderView = SubmitOrdersHead;
    
}
- (void)addSubmitOrderTool{
    
    self.submitOrderTool  = [[[NSBundle mainBundle] loadNibNamed:@"HHSubmitOrderTool" owner:nil options:nil] lastObject];
    UIView *toolView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-Status_HEIGHT-44-50, SCREEN_WIDTH, 50)];
    self.submitOrderTool.frame = CGRectMake(0,0, SCREEN_WIDTH, 50);
    
    //去付款
    self.submitOrderTool.ImmediatePayLabel.userInteractionEnabled = YES;
    [self.submitOrderTool.ImmediatePayLabel setTapActionWithBlock:^{

        HJUser *user = [HJUser sharedUser];
        NSString *ids = [self.ids_Arr componentsJoinedByString:@","];
    
        //请添加店长账号
     NSString *validStr = [self isValidStrWithaddressId:self.address_id login_userid:self.model.login_userid];
        
        if (!validStr) {
            MBProgressHUD  *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.color = KA0LabelColor;
            hud.detailsLabelText = @"付款中...";
            hud.detailsLabelColor = kWhiteColor;
            hud.detailsLabelFont = FONT(14);
            hud.activityIndicatorColor = kWhiteColor;
            [hud showAnimated:YES];
            
            NSString *integral_TF_str;
            NSNumber *payMode = @1;
            if (integral_TF.text.length>0) {
                if ([self.model.shop_type isEqualToString:@"0"]) {
                    //百业惠
                    integral_TF_str = [integral_TF.text substringFromIndex:2];
                    
                    if (swi.isOn) {
                        payMode = @4;
                    }else{
                        payMode = @1;
                    }
                    
                }else if ([self.model.shop_type isEqualToString:@"1"]){
                    //惠
                    payMode = @2;
                    integral_TF_str = integral_TF.text;
                }
            }else{
                payMode = @1;
                integral_TF_str = nil;
            }
            
            NSNumber *chanel;
            UITableViewCell *chanel_cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
            if ([chanel_cell.detailTextLabel.text isEqualToString:@"体验店"]) {
                chanel = @1;
            }else{
                chanel = @0;
            }
            NSString *distribute;
            UITableViewCell *distribute_cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
            if ([distribute_cell.detailTextLabel.text isEqualToString:@"自提"]) {
                distribute = @"1";
            }else{
                distribute = @"0";
            }
        [[[HHCartAPI postCreateOrderWithids:ids address_id:self.address_id shop_userid:user.login_userid  remark:noteTF.text pay_mode:payMode channe:chanel integral:integral_TF_str ship_mode:distribute] netWorkClient] postRequestInView:nil finishedBlock:^(HHCartAPI *api, NSError *error) {
            if (!error) {
                
                if (api.code == 0) {
                 //付款成功
                    //发送删除立即购买的通知
                    [[NSNotificationCenter defaultCenter]postNotificationName:DELETE_SHOPITEMSELECTBACK object:nil userInfo:nil];
                    //
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [hud hideAnimated:YES];
                        HHPaySucessVC *vc = [HHPaySucessVC new];
                        [self.navigationController pushVC:vc];
                        
                    });
                    
                }else{
                    [hud hideAnimated:YES];
                    [SVProgressHUD showInfoWithStatus:api.msg];
                }
            }else{
                [hud hideAnimated:YES];
                [SVProgressHUD showInfoWithStatus:api.msg];
            }
        }];
            
        }else{
            
            [SVProgressHUD showInfoWithStatus:validStr];

            
        }
        
    }];
    [toolView addSubview:self.submitOrderTool];
    [self.view addSubview:toolView];
}
- (NSString *)isValidStrWithaddressId:(NSString *)addressId  login_userid:(NSString *)login_userid{
    
    if (addressId.length==0) {
        return @"请添加收货地址！";
    }else if (login_userid.length==0) {
        return @"请添加店长账号！";
    }
    return nil;
}
#pragma mark - HHShippingAddressVCProtocol

- (void)shippingAddressTableView_didSelectRowWithaddressModel:(HHMineModel *)addressModel{
   
    self.address_id = addressModel.Id;
    //设置收货地址
    SubmitOrdersHead.topConstraint.constant = 20;
    SubmitOrdersHead.addressModel = addressModel;
    
}
- (void)shippingAddressBackAction{
    
    //获取收货数据
    [self getAddressData];
    
}
#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIImage imageNamed:@"logo_data_disabled"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂时没有数据";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName:KACLabelColor
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    return -100;
}
 //获取默认地址
- (void)getAddressData{

    [[[HHMineAPI GetAddressWithId:self.Id] netWorkClient] getRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.code == 0) {
                
                NSString *address = api.data[@"address"];
                if (address.length >0) {
                    HHMineModel *model =  [HHMineModel mj_objectWithKeyValues:api.data];
                    self.address_id = model.Id;
                    SubmitOrdersHead.addressModel = model;
                    SubmitOrdersHead.topConstraint.constant = 20;
                }else{
                    //设置收货地址
                    SubmitOrdersHead.usernameLabel.text = @"请添加收货地址";
                    SubmitOrdersHead.topConstraint.constant = 40;
                    SubmitOrdersHead.full_addressLabel.text = @"";
                }
            }else{
                
                [SVProgressHUD showInfoWithStatus:api.msg];
            }
            
        }else{
            [SVProgressHUD showInfoWithStatus:error.localizedDescription];

        }
    }];
    
}
//获取数据
- (void)getDatas{
    
    //惠万家
    [self.leftTitleArr removeAllObjects];
    [self.leftTitleArr addObjectsFromArray:@[@"当前店长账号",@"发货渠道",@"配送方式",@"订单总计",@"赠送积分总计",@"使用购物积分",@"购物积分余额",@"现金积分余额",@"备注"]];
    [self.rightDetailArr removeAllObjects];
    [self.rightDetailArr addObjectsFromArray:@[@" ",@"总部",@"自提",@" ",@" ",@" ",@" ",@" ",@" "]];
 //百业惠
    [self.leftTitle2Arr removeAllObjects];
    [self.leftTitle2Arr addObjectsFromArray:@[@"当前店长账号",@"发货渠道",@"配送方式",@"订单总计",@"赠送积分总计",@"可用提货积分",@"提货积分余额",@"现金积分余额",@"使用提货积分",@"备注"]];
    [self.rightDetail2Arr removeAllObjects];
    [self.rightDetail2Arr addObjectsFromArray:@[@" ",@"总部",@"自提",@" ",@" ",@" ",@" ",@" ",@" ",@" "]];
    
    
    if (self.ids_Arr.count>0) {

        NSString *ids_str = [self.ids_Arr componentsJoinedByString:@","];
        [[[HHCartAPI GetConfirmOrderWithids:ids_str] netWorkClient] getRequestInView:self.view finishedBlock:^(HHCartAPI *api, NSError *error) {
            
                if (!error) {
                    if (api.code == 0) {
                        self.model =  [HHCartModel mj_objectWithKeyValues:api.data];
                        HJUser *user = [HJUser sharedUser];
                        user.login_userid = self.model.login_userid;
                        user.login_username = self.model.login_username;
                        [user write];
                        
                        self.datas = self.model.products.mutableCopy;
                        
                        if ([self.model.ship_channel isEqualToString:@"1"]) {
                            [self.rightDetailArr replaceObjectAtIndex:1 withObject:@"体验店"];
                            [self.rightDetail2Arr replaceObjectAtIndex:1 withObject:@"体验店"];
                        }else if ([self.model.ship_channel isEqualToString:@"0"]){
                            [self.rightDetailArr replaceObjectAtIndex:1 withObject:@"总部"];
                            [self.rightDetail2Arr replaceObjectAtIndex:1 withObject:@"总部"];
                        }
                        
                        //***********普通用户*********//
                     
                        if ([user.level isEqualToString:@"0"]) {
                            if ([self.model.shop_type isEqualToString:@"0"]) {
                                //百业惠
                                NSMutableIndexSet *indexset = [NSMutableIndexSet indexSet];
                                [indexset addIndex:5];
                                [indexset addIndex:6];
                                [indexset addIndex:8];
                                [self.leftTitle2Arr removeObjectsAtIndexes:indexset];
                                [self.rightDetail2Arr removeObjectsAtIndexes:indexset];
                                [self.rightDetail2Arr replaceObjectAtIndex:0 withObject:self.model.login_userid];
                                [self.rightDetail2Arr replaceObjectAtIndex:3 withObject:self.model.money_total];
                                [self.rightDetail2Arr replaceObjectAtIndex:4 withObject:self.model.s_integral_total];
                                [self.rightDetail2Arr replaceObjectAtIndex:5 withObject:self.model.money_integral];
                                
                            }else if ([self.model.shop_type isEqualToString:@"1"]){
                                
                                //惠万家
                                NSMutableIndexSet *indexset = [NSMutableIndexSet indexSet];
                                [indexset addIndex:5];
                                [indexset addIndex:6];
                                [self.leftTitleArr removeObjectsAtIndexes:indexset];
                                [self.rightDetailArr removeObjectsAtIndexes:indexset];
                                [self.rightDetailArr replaceObjectAtIndex:0 withObject:self.model.login_userid];
                                [self.rightDetailArr replaceObjectAtIndex:3 withObject:self.model.money_total];
                                [self.rightDetailArr replaceObjectAtIndex:4 withObject:self.model.s_integral_total];
                                [self.rightDetailArr replaceObjectAtIndex:5 withObject:self.model.money_integral];
                                
                            }
                            CGFloat money_total = self.model.money_total.floatValue;
                            self.submitOrderTool.pay_modeLabel.text = @"现金积分支付";
                            self.submitOrderTool.money_totalLabel.text = [NSString stringWithFormat:@"共计¥ %.2f",money_total];
                            self.submitOrderTool.s_integral_totalLabel.text = [NSString stringWithFormat:@"赠送积分%@",self.model.s_integral_total];
                            [self.tableView reloadData];
                            
                        }else {
                            //***********签约会员**************//
                            if ([self.model.shop_type isEqualToString:@"0"]) {
                                //百业惠
                                [self.rightDetail2Arr replaceObjectAtIndex:0 withObject:self.model.login_userid];
                                [self.rightDetail2Arr replaceObjectAtIndex:3 withObject:self.model.money_total];
                                [self.rightDetail2Arr replaceObjectAtIndex:4 withObject:self.model.s_integral_total];
                                [self.rightDetail2Arr replaceObjectAtIndex:5 withObject:self.model.max_usable_shopping_integral];
                                [self.rightDetail2Arr replaceObjectAtIndex:6 withObject:self.model.picking_integral];
                                [self.rightDetail2Arr replaceObjectAtIndex:7 withObject:self.model.money_integral];
                                CGFloat money_total = self.model.money_total.floatValue;
                                self.submitOrderTool.money_totalLabel.text = [NSString stringWithFormat:@"共计¥ %.2f",money_total];
                                
                                //百业惠-->提货
                                if (user.is_pickageIntegral) {
                                    self.submitOrderTool.pay_modeLabel.text = @"提货积分支付";
                                    self.submitOrderTool.s_integral_totalLabel.text = [NSString stringWithFormat:@"赠送积分%@",@"0"];

                                }else{
                                    self.submitOrderTool.pay_modeLabel.text = @"现金积分支付";
                                    self.submitOrderTool.s_integral_totalLabel.text = [NSString stringWithFormat:@"赠送积分%@",self.model.s_integral_total];
                                }
                                
                                [self.tableView reloadData];
                                
                            }else if ([self.model.shop_type isEqualToString:@"1"]){
                                //惠万家
                                [self.rightDetailArr replaceObjectAtIndex:0 withObject:self.model.login_userid];
                                [self.rightDetailArr replaceObjectAtIndex:3 withObject:self.model.money_total];
                                [self.rightDetailArr replaceObjectAtIndex:4 withObject:self.model.s_integral_total];
                                [self.rightDetailArr replaceObjectAtIndex:5 withObject:self.model.max_usable_shopping_integral];
                                [self.rightDetailArr replaceObjectAtIndex:6 withObject:self.model.shopping_integral];
                                [self.rightDetailArr replaceObjectAtIndex:7 withObject:self.model.money_integral];
           
                                NSString *ids_str = [self.ids_Arr componentsJoinedByString:@","];
                                
                                [[[HHCartAPI GetPayMoneyWithids:ids_str integral:self.model.max_usable_shopping_integral] netWorkClient] getRequestInView:nil finishedBlock:^(HHCartAPI *api, NSError *error) {
                                    
                                    if (api.code == 0) {
                                        NSString *data = api.data[@"pay_money"];
                                        self.submitOrderTool.money_totalLabel.text = [NSString stringWithFormat:@"共计¥%@",data];
                                    }
                                }];
                                if (user.is_shopIntegral) {
                                    self.submitOrderTool.pay_modeLabel.text = @"购物积分支付";
                                }else{
                                    self.submitOrderTool.pay_modeLabel.text = @"现金积分支付";
                                }
                                self.submitOrderTool.s_integral_totalLabel.text = [NSString stringWithFormat:@"赠送积分%@",self.model.s_integral_total];
                                [self.tableView reloadData];
                                
                            }
                            
                        }
 
                    }else{
                        
                        [SVProgressHUD showInfoWithStatus:api.msg];
                    }
                }
        }];

    }
    
}
//提货积分开关
- (void)swiAction:(UISwitch *)swi{
    
    HJUser *user = [HJUser sharedUser];
    user.is_pickageIntegral = swi.isOn;
    [user write];
    if (swi.isOn) {
        self.submitOrderTool.pay_modeLabel.text = @"提货积分支付";
        self.submitOrderTool.s_integral_totalLabel.text = @"赠送积分0";
    }else{
        self.submitOrderTool.pay_modeLabel.text = @"现金积分支付";
        self.submitOrderTool.s_integral_totalLabel.text = [NSString stringWithFormat:@"赠送积分%@分",self.model.s_integral_total];
    }
}

#pragma mark --- textField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([self.model.shop_type isEqualToString:@"0"]) {
        //百业惠
        if (self.ids_Arr.count>0) {
            NSString *ids_str = [self.ids_Arr componentsJoinedByString:@","];
            NSString *integral=@"0";
            if(textField.text.length==0){
                integral = @"0";
            }else{
                integral = textField.text;
            }
            [[[HHCartAPI GetPayMoneyWithids:ids_str integral:integral] netWorkClient] getRequestInView:nil finishedBlock:^(HHCartAPI *api, NSError *error) {
                if (api.code == 0) {
                    NSString *data = api.data[@"pay_money"];
                    self.submitOrderTool.money_totalLabel.text = [NSString stringWithFormat:@"共计¥ %@",data];
                }
            }];
        }
    }else if ([self.model.shop_type isEqualToString:@"1"]){
       //惠万家
        HJUser *user = [HJUser sharedUser];
        if (self.ids_Arr.count>0) {
            NSString *ids_str = [self.ids_Arr componentsJoinedByString:@","];
            NSString *integral=@"0";
            if(textField.text.length==0){
                integral = @"0";
            }else{
                integral = textField.text;
            }
            [[[HHCartAPI GetPayMoneyWithids:ids_str integral:textField.text] netWorkClient] getRequestInView:nil finishedBlock:^(HHCartAPI *api, NSError *error) {
                if (textField.text.length ==0) {
                    self.submitOrderTool.pay_modeLabel.text = @"现金积分支付";
                }else{
                    self.submitOrderTool.pay_modeLabel.text = @"购物积分支付";
                }
                if (api.code == 0) {
                    NSString *data = api.data[@"pay_money"];
                    self.submitOrderTool.money_totalLabel.text = [NSString stringWithFormat:@"共计¥%@",data];
                }
            }];
        }
    }
}
#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        HHSubmitOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHSubmitOrderCell"];
        HHproductsModel *model =  self.datas[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.productsModel = model;
        return cell;
        
    }else{
       UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell1) {
            cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        if (indexPath.row == 0||indexPath.row == 1||indexPath.row == 2) {
            cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
       cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.model.shop_type isEqualToString:@"0"]) {
            //百业惠
            cell1.textLabel.text = self.leftTitle2Arr[indexPath.row];
            cell1.detailTextLabel.text = self.rightDetail2Arr[indexPath.row];
          
            if (indexPath.row == 3) {
                cell1.detailTextLabel.text =  [NSString stringWithFormat:@"¥ %@",self.rightDetail2Arr[indexPath.row]];
            }
            if (indexPath.row == 4) {
                cell1.imageView.image = [UIImage imageNamed:@"icon_integral_default"];
            }
            HJUser *user = [HJUser sharedUser];
            if (![user.level isEqualToString:@"0"]) {
                //
               if (indexPath.row == 5) {
                integral_TF = [UITextField lh_textFieldWithFrame:CGRectMake(0, 0, 100, 30) placeholder:@"" font:FONT(14) textAlignment:NSTextAlignmentRight backgroundColor:kWhiteColor];
                integral_TF.textColor = KTitleLabelColor;
                integral_TF.borderStyle = UITextBorderStyleNone;
                integral_TF.keyboardType = UIKeyboardTypeDecimalPad;
                integral_TF.delegate = self;
                cell1.detailTextLabel.text = @"";
                integral_TF.text =  [NSString stringWithFormat:@"可用%@",self.rightDetail2Arr[indexPath.row]];
                integral_TF.enabled = NO;
                integral_TF.textColor = kGrayColor;
                cell1.accessoryView = integral_TF;
                  
                }
                }
            //备注（普通用户）
            if (indexPath.row == 6) {
                if ([user.level isEqualToString:@"0"]) {
                    if (!noteTF) {
                        noteTF = [[UITextField alloc]initWithFrame:CGRectMake(70, 0, SCREEN_WIDTH-70, 44)];
                        noteTF.placeholder = @"(选填)";
                        [cell1.contentView addSubview:noteTF];
                    }
                }
            }
        }else if ([self.model.shop_type isEqualToString:@"1"]){
            //惠万家
            cell1.textLabel.text = self.leftTitleArr[indexPath.row];
            cell1.detailTextLabel.text = self.rightDetailArr[indexPath.row];
            if (indexPath.row == 3) {
                cell1.detailTextLabel.text =  [NSString stringWithFormat:@"¥%@",self.rightDetailArr[indexPath.row]];
            }
            if (indexPath.row == 4) {
                cell1.imageView.image = [UIImage imageNamed:@"icon_integral_default"];
            }
            HJUser *user = [HJUser sharedUser];
            if (![user.level isEqualToString:@"0"]) {
            if (indexPath.row == 5) {
                integral_TF = [UITextField lh_textFieldWithFrame:CGRectMake(0, 0, 100, 30) placeholder:@"" font:FONT(14) textAlignment:NSTextAlignmentRight backgroundColor:kWhiteColor];
                integral_TF.textColor = KTitleLabelColor;
                integral_TF.borderStyle = UITextBorderStyleNone;
                integral_TF.keyboardType = UIKeyboardTypeNumberPad;
                integral_TF.delegate = self;
                integral_TF.enabled = YES;
                cell1.accessoryView = integral_TF;
                cell1.detailTextLabel.text = @"";
                integral_TF.text =  [NSString stringWithFormat:@"%@ ",self.rightDetailArr[indexPath.row]];
                [integral_TF lh_setCornerRadius:0 borderWidth:1 borderColor:KACLabelColor];
                     }
            }
            //备注（普通用户）
            if (indexPath.row == 6) {
                if ([user.level isEqualToString:@"0"]) {
                    noteTF = [[UITextField alloc]initWithFrame:CGRectMake(70, 0, SCREEN_WIDTH-70, 44)];
                    noteTF.placeholder = @"(选填)";
                    [cell1.contentView addSubview:noteTF];
                }
            }
        }

        //***************************//
        if (indexPath.row == 8) {
            
            if ([self.model.shop_type isEqualToString:@"0"]) {
                //百业惠（提货积分）
                if (!swi) {
                swi = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-70, 4,70, 36)];
                [swi addTarget:self action:@selector(swiAction:) forControlEvents:UIControlEventValueChanged];
                [cell1.contentView addSubview:swi];
                }
                HJUser *user = [HJUser sharedUser];
                [swi setOn:user.is_pickageIntegral];

            }else if ([self.model.shop_type isEqualToString:@"1"]){
                //惠万家（购物积分）
                noteTF = [[UITextField alloc]initWithFrame:CGRectMake(70, 0, SCREEN_WIDTH-70, 44)];
                noteTF.placeholder = @"(选填)";
                [cell1.contentView addSubview:noteTF];
            }
        }
        //
        if ([self.model.shop_type isEqualToString:@"0"]) {
            //百业惠
            if (indexPath.row == 9) {
                if (!noteTF) {
                    noteTF = [[UITextField alloc]initWithFrame:CGRectMake(70, 0, SCREEN_WIDTH-70, 44)];
                    noteTF.placeholder = @"(选填)";
                    [cell1.contentView addSubview:noteTF];
                }
            }
        }else if ([self.model.shop_type isEqualToString:@"1"]){
            //惠万家
            
        }
    return cell1;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return self.datas.count;

    }else{
        if ([self.model.shop_type isEqualToString:@"0"]) {
            //百业惠-->提货
            return self.leftTitle2Arr.count;

        }else{
            return self.leftTitleArr.count;
        }
    }
    
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
           return 110;
    }else{
           return 44;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        HHGoodBaseViewController *vc = [HHGoodBaseViewController new];
        HHproductsModel *model = self.datas[indexPath.row];
        vc.Id = model.pid;
        [self.navigationController pushVC:vc];
        
    }else{
        
        if (indexPath.row == 0) {
            HHCurrentStoreVC *vc = [HHCurrentStoreVC new];
             vc.store_num =  self.model.login_userid;
            [self.navigationController pushVC:vc];
        }
        if (indexPath.row == 1) {
            //发货渠道
//            HJUser *user = [HJUser sharedUser];
//            if (user.login_userid.length>0) {
//                [pickView setStyle:HXCommonPickViewStyleDIY titleArr:@[@"总部",@"体验店"]];
//                [pickView showPickViewAnimation:YES];
//                WEAK_SELF();
//                pickView.completeBlock = ^(NSString *result) {
//
//                    [weakSelf.rightDetailArr replaceObjectAtIndex:1 withObject:result];
//                    [weakSelf.rightDetail2Arr replaceObjectAtIndex:1 withObject:result];
//                    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//                    cell.detailTextLabel.text = result;
//                };
//            }
        }
        if (indexPath.row == 2) {
            //配送方式
            [pickView setStyle:HXCommonPickViewStyleDIY titleArr:@[@"自提",@"快递"]];
            WEAK_SELF();
            pickView.completeBlock = ^(NSString *result) {
                [weakSelf.rightDetailArr replaceObjectAtIndex:2 withObject:result];
                [weakSelf.rightDetail2Arr replaceObjectAtIndex:2 withObject:result];
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.detailTextLabel.text = result;
            };
             [pickView showPickViewAnimation:YES];
        }
    }

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        UIView *sectionHead =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
        sectionHead.backgroundColor = kWhiteColor;
        UILabel *orderNo = [UILabel lh_labelWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 35) text:@"订单" textColor:kBlackColor font:FONT(13) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
        [sectionHead addSubview:orderNo];
        
        return sectionHead;
    }
    return nil;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 35;
        
    }
    return 0.01;
    
}



@end
