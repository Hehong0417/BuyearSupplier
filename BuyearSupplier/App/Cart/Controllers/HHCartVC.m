//
//  CartVC.m
//  Store
//
//  Created by User on 2017/12/12.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHCartVC.h"
#import "HHCartCell.h"
#import "HHCartFootView.h"
#import "HHSubmitOrdersVC.h"
#import "HHGoodBaseViewController.h"
#import "HHtEditCarItem.h"
#import "HHGoodListVC.h"
#import "HHCategoryVC.h"

@interface HHCartVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    NSInteger  count;
    NSInteger  subcount;
}
@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, assign)   NSInteger page;
@property (nonatomic, strong)   NSMutableArray *datas;
@property (nonatomic, strong)   HHCartFootView *settleAccountView;
@property (nonatomic, strong)   HHCartModel *model;
@property (nonatomic, strong)   NSString *money_total;
@property (nonatomic, strong)   NSString *s_integral_total;
@property (nonatomic, strong)   NSMutableArray *selectItems;
@property(nonatomic,assign)   BOOL  isLoading;

@end

@implementation HHCartVC

#pragma mark - LifeCycle
#pragma mark - UI
#pragma mark - NetWork
#pragma mark - Action
#pragma mark - LazyLoad

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //是否登录
    [self isLoginOrNot];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.page = 1;
    
    self.title = @"购物车";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //tableView
    
    //返回按钮
    UIButton *backBtn = [UIButton lh_buttonWithFrame:CGRectMake(0, 0, 30, 45) target:self action:@selector(backBtnAction) image:[UIImage imageNamed:@"icon_return_default"]];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    
    CGFloat tableHeight;
    if (self.cartType == HHcartType_goodDetail) {
        tableHeight = SCREEN_HEIGHT - 64;
        backBtn.hidden = NO;

    }else{
        tableHeight = SCREEN_HEIGHT - 64 - 50 - 49;
        backBtn.hidden = YES;
    }
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,tableHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = KVCBackGroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHCartCell" bundle:nil] forCellReuseIdentifier:@"HHCartCell"];
    
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    
    //底部结算条
    [self addSettleAccountView];
    
    //获取数据
    [self getDatas];
    
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;


}
- (void)backBtnAction{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(cartVCBackActionHandle)]) {
        
        [self.delegate cartVCBackActionHandle];
    }
    
    [self.navigationController popVC];
    
}
#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    if (self.isLoading) {
    
        return [UIImage imageNamed:@"img_shopcar_disable"];
       
    }else{
        //没加载过
        return [UIImage imageNamed:@""];
    }

}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    NSString *titleStr;
    if (self.isLoading) {
        titleStr = @"购物车是空的";
    }else{
        //没加载过
        titleStr = @"";
    }
  return [[NSAttributedString alloc] initWithString:titleStr attributes:@{NSFontAttributeName:FONT(18),NSForegroundColorAttributeName:APP_purple_Color}];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *titleStr;
    if (self.isLoading) {
        titleStr = @"再忙也要犒劳下自己";
    }else{
        //没加载过
        titleStr = @"";
    }
    return [[NSAttributedString alloc] initWithString:titleStr attributes:@{NSFontAttributeName:FONT(12),NSForegroundColorAttributeName:KACLabelColor}];

}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    NSString *titleStr;
    if (self.isLoading) {
        titleStr = @"去逛逛";
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
    
    self.navigationController.tabBarController.selectedIndex = 1;
    
}

- (void)isLoginOrNot{
    //
    HJUser *user = [HJUser sharedUser];
    if (user.token.length == 0) {
        //判断是否登录
        HHLoginVC *vc = [[HHLoginVC alloc] initWithNibName:@"HHLoginVC" bundle:nil];
        vc.tabBarVC = (HJTabBarController *)self.tabBarController;
        vc.tabSelectIndex = 2;
        HJNavigationController *nav = [[HJNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        //获取数据
        [self getDatas];
    }
}
//获取数据
- (void)getDatas{
    
    NetworkClient *netWorkClient = [[HHCartAPI GetCartProducts] netWorkClient];
    
    dispatch_semaphore_t  semaphore = dispatch_semaphore_create(0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    
    dispatch_group_async(group, globalQueue, ^{
        
        netWorkClient.manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataDontLoad;
        
        [netWorkClient getRequestInView:nil finishedBlock:^(HHCartAPI *api, NSError *error) {
            
            if (!error) {
                if (api.code == 0) {
                    
                    self.model  =  [HHCartModel mj_objectWithKeyValues:api.data];
                    self.isLoading = YES;
                    
                    [self getShopCartListFinsih:self.model];
                    dispatch_semaphore_signal(semaphore);
                    
                }else if (api.code == 2){
                    //未登录
                    HHLoginVC *vc = [[HHLoginVC alloc] initWithNibName:@"HHLoginVC" bundle:nil];
                    vc.tabBarVC = (HJTabBarController *)self.tabBarController;
                    vc.tabSelectIndex = 3;
                    HJNavigationController *nav = [[HJNavigationController alloc] initWithRootViewController:vc];
                    [self presentViewController:nav animated:YES completion:nil];
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
            
            [[[HHCartAPI GetCartProducts] netWorkClient] getRequestInView:nil finishedBlock:^(HHCartAPI *api, NSError *error) {
                
                if (!error) {
                    if (api.code == 0) {
                        
                        self.model  =  [HHCartModel mj_objectWithKeyValues:api.data];
                        self.isLoading = YES;

                        [self getShopCartListFinsih:self.model];
                        
                    }else if (api.code == 2){
                        //未登录
                        HHLoginVC *vc = [[HHLoginVC alloc] initWithNibName:@"HHLoginVC" bundle:nil];
                        vc.tabBarVC = (HJTabBarController *)self.tabBarController;
                        vc.tabSelectIndex = 3;
                        HJNavigationController *nav = [[HJNavigationController alloc] initWithRootViewController:vc];
                        [self presentViewController:nav animated:YES completion:nil];
                        
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
- (void)getShopCartListFinsih:(HHCartModel *)data {
    
    self.datas = [data.products mutableCopy];
    if (self.datas.count ==0) {
        if (self.cartType == HHcartType_goodDetail) {
            self.settleAccountView.hidden = YES;
            self.tableView.height = SCREEN_HEIGHT - 64;
        }else{
            self.settleAccountView.hidden = YES;
            self.tableView.height = SCREEN_HEIGHT - 64-49;
        }
 
    }else{
        if (self.cartType == HHcartType_goodDetail) {
            self.settleAccountView.hidden = NO;
            self.tableView.height = SCREEN_HEIGHT - 64-50;
        }else{
        self.settleAccountView.hidden = NO;
        self.tableView.height = SCREEN_HEIGHT - 64-49-50;
        }
    }
    self.settleAccountView.selectBtn.selected = NO;
    //全选左边点击数据源
    self.selectItems = [NSMutableArray array];
    [self.datas enumerateObjectsUsingBlock:^(HHproductsModel *productsModel, NSUInteger idx, BOOL *stop) {
        [self.selectItems addObject:@0];
    }];
    [self.tableView reloadData];
}
- (void)addSettleAccountView{
    
    self.settleAccountView  = [[[NSBundle mainBundle] loadNibNamed:@"HHCartFootView" owner:self options:nil] lastObject];
    CGFloat settleView_y;
    if (self.cartType == HHcartType_goodDetail) {
        settleView_y = SCREEN_HEIGHT-64-50;
        
    }else{
        settleView_y = SCREEN_HEIGHT-49-50-64;
    }
    UIView *settleView = [[UIView alloc] initWithFrame:CGRectMake(0, settleView_y, SCREEN_WIDTH, 50)];
    self.settleAccountView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    self.settleAccountView.settleBtn.userInteractionEnabled = YES;

    [settleView addSubview:self.settleAccountView];
    [self.view addSubview:settleView];
    
    //全选
    WEAK_SELF();
    self.settleAccountView.allChooseBlock = ^(NSNumber *allSelected) {
        [weakSelf caculateSettleGoodsListBaseLeftSelectArrIsAllSelected:allSelected.boolValue];
    };
    
    //提交订单
    [self.settleAccountView.settleBtn setTapActionWithBlock:^{
        
        __block  NSMutableArray *orderSelect_IdsArr = [NSMutableArray array];
        [weakSelf.datas enumerateObjectsUsingBlock:^(HHproductsModel *model, NSUInteger oneIdx, BOOL * _Nonnull stop) {
            [weakSelf.selectItems enumerateObjectsUsingBlock:^(NSNumber *select, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([select isEqual:@1]) {
                    if (idx == oneIdx) {
                        [orderSelect_IdsArr addObject:model.cart_id];
                    }
                }
                
            }];
        }];
//
        if (orderSelect_IdsArr.count>0) {
            HHSubmitOrdersVC *vc = [HHSubmitOrdersVC new];
            vc.ids_Arr = orderSelect_IdsArr;
            [self.navigationController pushVC:vc];
        }else{

            [SVProgressHUD showInfoWithStatus:@"请先选择商品！"];
        }

    }];
    
}
//加
- (void)plusBtnAction:(UIButton *)btn{
    
    HHCartCell *cell = (HHCartCell *)btn.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    HHproductsModel *model = self.model.products[indexPath.row];

    if (model.quantity.integerValue>1) {
        cell.minusBtn.enabled = YES;
    }
    NSInteger  quantity = model.quantity.integerValue;
    quantity++;
    
    [self minusOrPlusQuantityWithcart_id:model.cart_id quantity:@"1" cartCell:cell];
    
}
//减
- (void)minusBtnAction:(UIButton *)btn{

     HHCartCell *cell = (HHCartCell *)btn.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    HHproductsModel *model = self.model.products[indexPath.row];
    if (model.quantity.integerValue<=1) {
        btn.enabled = NO;
    }else{
        
        NSInteger   quantity = model.quantity.integerValue;
        quantity--;
        [self minusOrPlusQuantityWithcart_id:model.cart_id quantity:@"-1"  cartCell:cell];
        
    }
}
- (void)minusOrPlusQuantityWithcart_id:(NSString *)cart_id quantity:(NSString *)quantity cartCell:(HHCartCell *)cartCell{
    
    [[[HHCartAPI postAddQuantityWithcart_id:cart_id quantity:quantity] netWorkClient] postRequestInView:nil finishedBlock:^(HHCartAPI *api, NSError *error) {
        if (!error) {
            if (api.code == 0) {
                
                [self refreshData];
                
            }else{
                [SVProgressHUD showInfoWithStatus:api.msg];
            }
        }else{
            
            [SVProgressHUD showInfoWithStatus:api.msg];
        }
        
    }];
    
}
- (void)refreshData{
    
    [[[HHCartAPI GetCartProducts] netWorkClient] getRequestInView:nil finishedBlock:^(HHCartAPI *api, NSError *error) {
        
        if (!error) {
            if (api.code == 0) {
                [self.datas removeAllObjects];
                self.model  =  [HHCartModel mj_objectWithKeyValues:api.data];
                self.datas = [self.model.products mutableCopy];
                HHtEditCarItem *editCarItem  = [HHtEditCarItem shopCartGoodsList:self.datas selectionArr:self.selectItems];
                self.settleAccountView.money_totalLabel.text =  [NSString stringWithFormat:@"共计¥ %.2f",editCarItem.total_Price?editCarItem.total_Price:0.00];
                NSMutableAttributedString *attrStr = [NSString lh_attriStrWithprotocolStr:[NSString stringWithFormat:@"%.2f",editCarItem.s_integral_total] content:[NSString stringWithFormat:@"赠送S积分%.2f",editCarItem.s_integral_total] protocolStrColor:kRedColor contentColor:KACLabelColor];
                self.settleAccountView.sintegral_totalLabel.attributedText = attrStr;
                self.settleAccountView.selectBtn.selected = editCarItem.settleAllSelect;
                
                [self.tableView reloadData];
            }
            
        }else{
            
            [SVProgressHUD showInfoWithStatus:api.msg];
        }
        
    }];
    
}
- (void)caculateSettleGoodsListBaseLeftSelectArrIsAllSelected:(BOOL )allSelect{
    
    [self.selectItems removeAllObjects];
    [self.datas enumerateObjectsUsingBlock:^(HHproductsModel *productsModel, NSUInteger idx, BOOL *stop) {
        [self.selectItems addObject:@(allSelect)];
    }];
    [self caculateSettleGoodsListBaseLeftSelectArr];
    
}
- (void)caculateSettleGoodsListBaseLeftSelectArr {
    
    HHtEditCarItem *editCarItem = [HHtEditCarItem shopCartGoodsList:self.datas selectionArr:self.selectItems];
    self.settleAccountView.money_totalLabel.text =  [NSString stringWithFormat:@"共计¥%.2f",editCarItem.total_Price?editCarItem.total_Price:0.00];
    NSMutableAttributedString *attrStr = [NSString lh_attriStrWithprotocolStr:[NSString stringWithFormat:@"%.2f",editCarItem.s_integral_total] content:[NSString stringWithFormat:@"赠送S积分%.2f分",editCarItem.s_integral_total] protocolFont:FONT(12) contentFont:FONT(12) protocolStrColor:kRedColor contentColor:KACLabelColor];
    self.settleAccountView.sintegral_totalLabel.attributedText = attrStr;
    [self.tableView reloadData];
}

#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHCartCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HHproductsModel *model = self.model.products[indexPath.row];
    cell.productModel = model;
    [cell.plusBtn addTarget:self action:@selector(plusBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.minusBtn addTarget:self action:@selector(minusBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    if (model.quantity.integerValue <= 1) {
        cell.minusBtn.enabled = NO;
    }else{
        cell.minusBtn.enabled = YES;
    }
    cell.indexPath = indexPath;
    cell.leftSelected = ((NSNumber *)self.selectItems[indexPath.row]).boolValue;
    WEAK_SELF();
    cell.ChooseBtnSelectAction = ^(NSIndexPath *indexPath, BOOL chooseBtnSelected) {
        [weakSelf.selectItems replaceObjectAtIndex:indexPath.row withObject:@(chooseBtnSelected)];
    
        HHtEditCarItem *editCarItem  = [HHtEditCarItem shopCartGoodsList:weakSelf.datas selectionArr:weakSelf.selectItems];
        self.settleAccountView.money_totalLabel.text =  [NSString stringWithFormat:@"共计¥ %.2f",editCarItem.total_Price?editCarItem.total_Price:0.00];
        NSMutableAttributedString *attrStr = [NSString lh_attriStrWithprotocolStr:[NSString stringWithFormat:@"%.2f",editCarItem.s_integral_total] content:[NSString stringWithFormat:@"赠送S积分%.2f分",editCarItem.s_integral_total] protocolStrColor:kRedColor contentColor:KACLabelColor];
        self.settleAccountView.sintegral_totalLabel.attributedText = attrStr;
        self.settleAccountView.selectBtn.selected = editCarItem.settleAllSelect;
    };
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.model.products.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHGoodBaseViewController *vc = [HHGoodBaseViewController new];
    HHproductsModel *model = self.model.products[indexPath.row];
    vc.Id = model.pid;
    [self.navigationController pushVC:vc];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除该商品吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            HHproductsModel *model = self.model.products[indexPath.row];
            [[[HHCartAPI postShopCartDeleteWithcart_id:model.cart_id] netWorkClient] postRequestInView:self.view finishedBlock:^(HHCartAPI *api, NSError *error) {
                if (!error) {
                    if (api.code == 0) {
                        [self.datas removeAllObjects];
                        [self deleteGetData];
                    }else{
                        [SVProgressHUD showInfoWithStatus:api.msg];
                        
                    }
                }else{
                    
                    [SVProgressHUD showInfoWithStatus:api.msg];
                }
            }];

        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        [alertC addAction:action1];
        [alertC addAction:action2];
        [self presentViewController:alertC animated:YES completion:nil];
    
    }else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)deleteGetData{
    
    [[[HHCartAPI GetCartProducts] netWorkClient] getRequestInView:nil finishedBlock:^(HHCartAPI *api, NSError *error) {
        if (!error) {
            if (api.code == 0) {
                self.model  =  [HHCartModel mj_objectWithKeyValues:api.data];
                self.datas = [self.model.products mutableCopy];
                if (self.datas.count == 0) {
                    self.settleAccountView.hidden = YES;
                }else{
                    self.settleAccountView.hidden = NO;
                }
                [self.tableView reloadData];
            }
        }
        
    }];
}
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
@end
