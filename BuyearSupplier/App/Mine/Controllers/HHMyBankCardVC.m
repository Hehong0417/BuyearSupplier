//
//  HHMyBankCardVC.m
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHMyBankCardVC.h"
#import "HHMyBankCardCell.h"
#import "HHAddBankCardVC.h"
#import "HHAddBankCardVC.h"

@interface HHMyBankCardVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
{
    UIButton *addAddressBtn;
}
@property (nonatomic, strong)   UITableView *tableView;
@property (nonatomic, strong)   NSMutableArray *datas;
@property(nonatomic,assign)   BOOL  isLoading;

@end

@implementation HHMyBankCardVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //获取数据
    [self getDatas];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的银行卡";
    
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HHMyBankCardCell" bundle:nil] forCellReuseIdentifier:@"HHMyBankCardCell"];
    
    UIView *footView = [UIView lh_viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) backColor:KVCBackGroundColor];
    addAddressBtn = [UIButton lh_buttonWithFrame:CGRectMake(30, 20, SCREEN_WIDTH-60, 45) target:self action:@selector(addAddressAction) image:nil];
    [addAddressBtn setTitle:@"添加银行卡" forState:UIControlStateNormal];
    [addAddressBtn lh_setBackgroundColor:APP_COMMON_COLOR forState:UIControlStateNormal];
    [addAddressBtn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [addAddressBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [footView addSubview:addAddressBtn];
    self.tableView.tableFooterView = footView;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    
}
#pragma mark - DZNEmptyDataSetDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.datas.count == 0) {
        addAddressBtn.hidden = YES;
    }else{
        addAddressBtn.hidden = NO;
    }
    if (self.isLoading) {
        return [UIImage imageNamed:@"img_card_disable"];
    }else{
        //没加载过
        return [UIImage imageNamed:@""];
    }
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    if (self.isLoading) {
        return [[NSAttributedString alloc] initWithString:@"未添加任何银行卡" attributes:@{NSFontAttributeName:FONT(18),NSForegroundColorAttributeName:APP_purple_Color}];
    }else{
        return [[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:FONT(18),NSForegroundColorAttributeName:APP_purple_Color}];
    }
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    
    if (self.isLoading) {
    return [[NSAttributedString alloc] initWithString:@"仅可绑定农业银行卡" attributes:@{NSFontAttributeName:FONT(12),NSForegroundColorAttributeName:KACLabelColor}];
    }else{
         return [[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:FONT(12),NSForegroundColorAttributeName:KACLabelColor}];
    }
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    
    if (self.isLoading) {
    return [[NSAttributedString alloc] initWithString:@"添加银行卡" attributes:@{NSFontAttributeName:BoldFONT(18),NSForegroundColorAttributeName:kWhiteColor}];
    }else{
        return [[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:BoldFONT(18),NSForegroundColorAttributeName:kWhiteColor}];
    }
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
    
    HHAddBankCardVC *vc = [HHAddBankCardVC new];
    vc.useridStr = self.useridStr;
    vc.is_edit= @"no";
    [self.navigationController pushVC:vc];
    
}
- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (void)getDatas{
    
    [[[HHMineAPI GetBankListWithpage:@1] netWorkClient] getRequestInView:self.view finishedBlock:^(HHMineAPI *api, NSError *error) {
        
        if (!error) {
            self.isLoading = YES;
            
            if (api.code == 0) {
                
                NSArray *arr = api.data[@"list"];
                self.datas = arr.mutableCopy;
                if (self.datas.count == 0) {
                    addAddressBtn.hidden = YES;
                }else{
                    addAddressBtn.hidden = NO;
                }
                [self.tableView reloadEmptyDataSet];
                [self.tableView reloadData];
            }else{
                [SVProgressHUD showInfoWithStatus:api.msg];
            }
            
        }
        
    }];
    
    
    
}
- (void)addAddressAction{
    
    HHAddBankCardVC *vc = [HHAddBankCardVC new];
    vc.useridStr = self.useridStr;
    vc.is_edit= @"no";
    [self.navigationController pushVC:vc];
    
}
#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHMyBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHMyBankCardCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.bankCardModel = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.row]];
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHAddBankCardVC *vc = [HHAddBankCardVC new];
    vc.is_edit= @"yes";
    vc.useridStr = self.useridStr;
    HHMineModel *model = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.row]];
    vc.bank_no = model.bank_no;
    vc.bank_name = model.bank_name;
    vc.is_default = model.is_default;
    vc.user_Name = model.username;
    vc.Id = model.Id;
    
    [self.navigationController pushVC:vc];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        HHMineModel *model = [HHMineModel mj_objectWithKeyValues:self.datas[indexPath.row]];
        [[[HHMineAPI postDeleteBankWithId:model.Id] netWorkClient] postRequestInView:nil finishedBlock:^(HHMineAPI *api, NSError *error) {
            if (api.code == 0) {
                
                [self.datas removeObjectAtIndex:indexPath.row];
                
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
            }
            
        }];

    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
@end
