//
//  HHQuotasSelectAlert.m
//  Store
//
//  Created by User on 2018/4/17.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHQuotasSelectAlert.h"
#import "HHQuotasCell.h"

@implementation HHQuotasSelectAlert

- (UIView *)alertViewContentView{
    
    
    NSMutableArray *datas = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",nil];
    self.selectItems = [NSMutableArray array];
    [datas enumerateObjectsUsingBlock:^(HHproductsModel *productsModel, NSUInteger idx, BOOL *stop) {
        [self.selectItems addObject:@0];
    }];
    
    UIView *shadow_bg = [[UIView alloc]initWithFrame:CGRectMake(WidthScaleSize_W(50), 0, ScreenW-WidthScaleSize_W(100), ScreenH/2+40)];
    shadow_bg.backgroundColor = kClearColor;
    shadow_bg.centerY = (ScreenH -44 - Status_HEIGHT)/2;

    
    UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake(20, 20, ScreenW-WidthScaleSize_W(140), ScreenH/2)];
    alertView.backgroundColor = kWhiteColor;
    [alertView lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [shadow_bg addSubview:alertView];

    //关闭按钮
    UIButton *close_btn = [UIButton lh_buttonWithFrame:CGRectMake(CGRectGetMaxX(alertView.frame)-15, 0, 30, 40) target:self action:@selector(closeAction:) image:[UIImage imageNamed:@"chahao"]];
    [shadow_bg addSubview:close_btn];
    
    //配额选择
    UILabel *title_lab = [UILabel lh_labelWithFrame:CGRectMake(0, 10, alertView.mj_w-WidthScaleSize_W(60), 35) text:@"配额选择" textColor:kBlackColor font:FONT(22) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
    title_lab.centerX = alertView.mj_w/2;
    [alertView addSubview:title_lab];
    
   //倒计时块
    UIView *countDown_view = [UIView lh_viewWithFrame:CGRectMake(title_lab.mj_x, CGRectGetMaxY(title_lab.frame), title_lab.mj_w, 25) backColor:kClearColor];
    countDown_view.centerX = title_lab.centerX;
    [alertView addSubview:countDown_view];
    //左半部分
    
    UILabel *countDown_lab = [UILabel lh_labelWithFrame:CGRectMake(0, 0, countDown_view.mj_w/2, 25) text:@"倒计时:" textColor:kBlackColor font:FONT(10) textAlignment:NSTextAlignmentRight backgroundColor:kClearColor];
    [countDown_view addSubview:countDown_lab];
    //右半部分
    self.countDown = [CZCountDownView countDown];
    self.countDown.separateLabelCount = 1;
    self.countDown.labelCount = 2;
    self.countDown.frame = CGRectMake(CGRectGetMaxX(countDown_lab.frame), 0, WidthScaleSize_W(70), 25);
    self.countDown.timeColor = [UIColor colorWithHexString:@"#7e4395"];
    self.countDown.timeFont = FONT(16);
    WEAK_SELF();
    self.countDown.timerStopBlock = ^{
        NSLog(@"时间停止");
        weakSelf.is_stop = @1;
        [weakSelf hideWithCompletion:nil];

    };
    [countDown_view addSubview:self.countDown];
    
    //倒计时
   //quotas_Collection
    //上面高度60  下面98
    UICollectionViewFlowLayout *flowout = [[UICollectionViewFlowLayout alloc]init];
    self.quotas_Collection =  [[UICollectionView alloc] initWithFrame:CGRectMake(title_lab.mj_x, CGRectGetMaxY(countDown_view.frame), title_lab.mj_w, ScreenH/2-60-WidthScaleSize_H(111)) collectionViewLayout:flowout];
    self.quotas_Collection.delegate = self;
    self.quotas_Collection.dataSource = self;
    
    [self.quotas_Collection registerNib:[UINib nibWithNibName:[HHQuotasCell className] bundle:nil] forCellWithReuseIdentifier:[HHQuotasCell className]];
    
    self.quotas_Collection.backgroundColor = kWhiteColor;
    self.quotas_Collection.showsVerticalScrollIndicator = NO;
    self.quotas_Collection.showsHorizontalScrollIndicator = NO;
    [alertView addSubview:self.quotas_Collection];
    
    //已抢配额
    self.quotas_lab = [UILabel lh_labelWithFrame:CGRectMake(title_lab.mj_x, CGRectGetMaxY(self.quotas_Collection.frame)+WidthScaleSize_H(10), title_lab.mj_w, WidthScaleSize_H(15)) text:@"已选择0个配额" textColor:kBlackColor font:FONT(12) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
    NSMutableAttributedString *attr = [NSString lh_attriStrWithprotocolStr:@"0" content:@"已选择0个配额" protocolStrColor:[UIColor colorWithHexString:@"#7e4395"] contentColor:kBlackColor];
    self.quotas_lab.attributedText = attr;
    [alertView addSubview:self.quotas_lab];

//    WidthScaleSize_H(40) + WidthScaleSize_H(36)+WidthScaleSize_H(15)
    //横线
    UIView *line = [UIView lh_viewWithFrame:CGRectMake(0, CGRectGetMaxY(self.quotas_lab.frame)+WidthScaleSize_H(5), alertView.mj_w, 1) backColor:KVCBackGroundColor];
    [alertView addSubview:line];

    //立即秒杀按钮
    UIButton *btn = [UIButton lh_buttonWithFrame:CGRectMake(title_lab.mj_x, CGRectGetMaxY(line.frame)+WidthScaleSize_H(16), 140, WidthScaleSize_H(40)) target:self action:@selector(secondKillAction:) title:@"立即秒抢" titleColor:kWhiteColor font:FONT(16) backgroundColor:kBlackColor];
    [btn lh_setCornerRadius:5 borderWidth:0 borderColor:kClearColor];
    btn.centerX = title_lab.centerX;
    [alertView addSubview:btn];

    return shadow_bg;
}

- (void)closeAction:(UIButton *)btn{
    
    [self hideWithCompletion:nil];
}
//立即秒杀
- (void)secondKillAction:(UIButton *)btn{
    
    if ([self.is_stop isEqual:@1]) {
        
        [SVProgressHUD showInfoWithStatus:@"秒抢时间已过期，请重新秒抢！"];
        
    }else{
    
    if (self.select_count.integerValue>0) {
        
        [[[HHSecKillAPI postSeckill_JoinWithSelect_count:self.select_count] netWorkClient] postRequestInView:nil finishedBlock:^(HHSecKillAPI *api, NSError *error) {
            if (!error) {
                if (api.code == 0) {
                    
                    [SVProgressHUD showSuccessWithStatus:api.msg];
                    [self hideWithCompletion:nil];
                    
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
        
    }else{
        
        [SVProgressHUD showInfoWithStatus:@"请先选择配额！"];
    }
    
       }
    
}
- (void)setSecKill_model:(HHSecKillModel *)secKill_model{
    _secKill_model = secKill_model;
    
    self.countDown.timestamp = secKill_model.seconds.integerValue;
    
    [self.quotas_Collection reloadData];
    
}
- (void)handleSelectQuato{
    
    WEAK_SELF();
    __block  NSMutableArray *orderSelect_numArr = [NSMutableArray array];
    
    [self.secKill_model.prizes enumerateObjectsUsingBlock:^(HHQuatoModel *model, NSUInteger oneIdx, BOOL * _Nonnull stop) {
        [weakSelf.selectItems enumerateObjectsUsingBlock:^(NSNumber *select, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([select isEqual:@1]) {
                if (idx == oneIdx) {
                    [orderSelect_numArr addObject:model.count];
                }
            }
        }];
    }];
    //
    NSNumber *sum = [orderSelect_numArr valueForKeyPath:@"@sum.floatValue"];
    self.select_count = sum;
    NSMutableAttributedString *attr = [NSString lh_attriStrWithprotocolStr:sum.stringValue content:[NSString stringWithFormat:@"已选择%@个配额" ,sum]   protocolStrColor:[UIColor colorWithHexString:@"#7e4395"] contentColor:kBlackColor];
    self.quotas_lab.attributedText = attr;
    
}
#pragma  mark - collectionView Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HHQuotasCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HHQuotasCell className] forIndexPath:indexPath];
    cell.indexPath = indexPath;
    
    cell.quatoModel = self.secKill_model.prizes[indexPath.row];
    cell.leftSelected = ((NSNumber *)self.selectItems[indexPath.row]).boolValue;

    cell.ChooseBtnSelectAction = ^(NSIndexPath *indexPath, BOOL leftButtonSelected) {
        [self.selectItems replaceObjectAtIndex:indexPath.row withObject:@(leftButtonSelected)];
        
        [self handleSelectQuato];
    };
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.secKill_model.prizes.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(WidthScaleSize_W(75) , WidthScaleSize_W(40));
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 1, 1, 1);
    
}
// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return WidthScaleSize_H(15);
}

// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return WidthScaleSize_W(10);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return  CGSizeMake(0.01,0.01);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return  CGSizeMake(0.001, 0.001);
    
}

@end
