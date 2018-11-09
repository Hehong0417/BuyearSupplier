//
//  HHReturnGoodsVC.m
//  Store
//
//  Created by User on 2018/1/8.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHReturnGoodsVC.h"
#import "HHCartCell.h"

@interface HHReturnGoodsVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger a;
}
@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, strong)   NSArray *title_arr;
@property (nonatomic, strong)   UITextField *reasonTF;
@property (nonatomic, strong)   NSMutableArray *selectItems;
@property (nonatomic, strong)   NSMutableArray  *pModels;
@property(nonatomic,strong) NSArray <HHproductsModel *> *products;

@end

@implementation HHReturnGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.titleStr;
    
    a=0;
    self.selectItems = [NSMutableArray array];
    self.pModels = [NSMutableArray array];
    
    //获取数据
    [self getDatas];
    
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
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) backColor:KVCBackGroundColor];
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(30, 40, SCREEN_WIDTH-60, 45);
     [saveBtn addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
    [saveBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [saveBtn setTitle:@"提交" forState:UIControlStateNormal];
    [saveBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [footView addSubview:saveBtn];
    self.tableView.tableFooterView = footView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHCartCell" bundle:nil] forCellReuseIdentifier:@"HHCartCell"];
    
}
//获取数据
- (void)getDatas{
    
    [[[HHMineAPI GetRefundProductWithorderid:self.orderid] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        if (!error) {
            if (api.code == 0) {
                self.products  = [HHproductsModel mj_objectArrayWithKeyValuesArray:api.data[@"products"]];
                [self.products enumerateObjectsUsingBlock:^(HHproductsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self.selectItems  addObject:@0];
                    [self.pModels addObject:obj];
                    *stop = NO;
                }];
                [self.tableView reloadData];
            }
        }
    }];
    
}
- (void)saveBtnAction:(UIButton *)btn{

    [btn lh_setBackgroundColor:KA0LabelColor forState:UIControlStateNormal];
    [btn setEnabled:NO];
    
    __block  NSMutableArray *orderSelectArr = [NSMutableArray array];
      [self.products enumerateObjectsUsingBlock:^(HHproductsModel *model, NSUInteger oneIdx, BOOL * _Nonnull stop) {
        [self.selectItems enumerateObjectsUsingBlock:^(NSNumber *select, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([select isEqual:@1]) {
                if (idx == oneIdx) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    if (model.item_id) {
                        [dic setObject:model.item_id forKey:@"id"];
                    }
                    HHCartCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:oneIdx inSection:0]];
                    
                    if (cell.quantityTextField.text) {
                        [dic setObject:cell.quantityTextField.text forKey:@"quantity"];
                    }else{
                        [dic setObject:model.quantity forKey:@"quantity"];
                    }
                    [orderSelectArr addObject:dic];
                }
            }
        }];
    }];
    //申请退货
    if (orderSelectArr.count>0) {
        NSString *orderSelect_Str = [orderSelectArr mj_JSONString];
        [[[HHMineAPI postApplyRefundWithqu:orderSelect_Str message:self.reasonTF.text] netWorkClient] postRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
            a=0;
            [btn setEnabled:YES];
            [btn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
            if (!error) {
                if (api.code == 0) {
                    if (self.returnBlock) {
                        self.returnBlock();
                    }
                    if ([self.titleStr isEqualToString:@"申请退款"]) {
                        [SVProgressHUD showSuccessWithStatus:@"退款申请成功！"];
                    }else{
                        [SVProgressHUD showSuccessWithStatus:@"退货申请成功！"];
                    }
                    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                    [self.navigationController popVC];

                }else{
                    [SVProgressHUD showInfoWithStatus:api.msg];
                }
            }
        }];
        
    }else{
        
        [SVProgressHUD showInfoWithStatus:@"请先选择商品！"];
    }

}
- (void)plusBtnAction:(UIButton *)btn{
    
    HHCartCell *cell  = ( HHCartCell *) btn.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    HHproductsModel *model = self.products[indexPath.row];
    cell.minusBtn.enabled = YES;
    if (cell.quantityTextField.text.integerValue >= model.quantity.integerValue-1) {
        cell.plusBtn.enabled = NO;
    }else{
        cell.plusBtn.enabled = YES;
    }
     NSInteger count =  cell.quantityTextField.text.integerValue;
      count++;
      cell.quantityTextField.text = [NSString stringWithFormat:@"%ld",count];
    
}
- (void)minusBtnAction:(UIButton *)btn{
    
    HHCartCell *cell  = ( HHCartCell *) btn.superview.superview;
    cell.plusBtn.enabled = YES;
    if (cell.quantityTextField.text.integerValue <=2) {
        cell.minusBtn.enabled = NO;
    }else{
        cell.minusBtn.enabled = YES;
    }
     NSInteger count =  cell.quantityTextField.text.integerValue;
     count--;
     cell.quantityTextField.text = [NSString stringWithFormat:@"%ld",count];
}
#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *gridCell;
    if (indexPath.section == 0) {
        
        HHCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHCartCell"];
        HHproductsModel *model = self.products[indexPath.row];
        cell.pModel = model;
        cell.quantityTextField.text = model.quantity;
        [cell.plusBtn addTarget:self action:@selector(plusBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.minusBtn addTarget:self action:@selector(minusBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.indexPath = indexPath;
        
        if (model.quantity.integerValue == 1) {
            cell.minusBtn.enabled = NO;
        }else{
            cell.minusBtn.enabled = YES;
        }
            cell.plusBtn.enabled = NO;

        cell.ChooseBtnSelectAction = ^(NSIndexPath *indexPath, BOOL chooseBtnSelected) {
           
            [self.selectItems replaceObjectAtIndex:indexPath.row withObject:@(chooseBtnSelected)];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        gridCell = cell;

    }else{

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            self.reasonTF = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, ScreenW - 130, 44)];
            self.reasonTF.font = FONT(14);
            self.reasonTF.placeholder = @"选填";
            [cell.contentView addSubview:self.reasonTF];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.titleStr isEqualToString:@"申请退款"]) {
            cell.textLabel.text = @"退款理由";
        }else{
            cell.textLabel.text = @"退货理由";
        }
        cell.textLabel.font = FONT(14);
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        gridCell = cell;
        
    }
    return gridCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return self.products.count;
        
    }else {
        
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
        return 110;
        
    }else {
        
        return 40;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}
@end
