//
//  HHQuotasSelectAlert.h
//  Store
//
//  Created by User on 2018/4/17.
//  Copyright © 2018年 User. All rights reserved.
//

#import "LHAlertView.h"
#import "HHSecKillAPI.h"
#import "HHSecKillModel.h"
#import "CZCountDownView.h"

@interface HHQuotasSelectAlert : LHAlertView<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property(nonatomic,strong) UICollectionView  *quotas_Collection;

@property (nonatomic, strong)   NSMutableArray *selectItems;

@property (nonatomic, strong)   HHSecKillModel *secKill_model;

@property (nonatomic, strong)   CZCountDownView *countDown;

@property (nonatomic, strong)   UILabel *quotas_lab;

@property (nonatomic, strong)   NSNumber *select_count;

@property (nonatomic, strong)   NSNumber *is_stop;

@end
