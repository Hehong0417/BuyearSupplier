//
//  HHCollectionReusableHead.h
//  Store
//
//  Created by User on 2018/1/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "HHQuotasSelectAlert.h"
#import "HHSecKillModel.h"
#import "CZCountDownView.h"

@interface HHCollectionReusableHead : UICollectionReusableView

@property (nonatomic, strong)   SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong)   UIView *searchView;

@property(nonatomic,strong)NSArray *imageURLStringsGroup;

@property(nonatomic,strong) XYQButton *modelBtn;

@property(nonatomic,copy) idBlock buttonSelectBlock;

//楼层
@property(nonatomic,strong) UIView  *levelBgView;
@property(nonatomic,strong) UILabel  *levelBgLab;

@property(nonatomic,strong) UINavigationController *nav;
@property(nonatomic,strong) UIViewController *vc;

/*
 配额秒杀
 */
@property(nonatomic,strong) UIView  *secondsKill_bg;

@property(nonatomic,strong) UIView  *secondsKill_left_sub;

//左边上描述
@property(nonatomic,strong) UILabel  *left_top_title;
//倒计时图片
@property(nonatomic,strong) UIImageView  *left_countdown_img;
//状态描述
@property(nonatomic,strong) UILabel  *state;
//左边下描述
@property(nonatomic,strong) UILabel  *left_bottom_title;

@property(nonatomic,strong) UIView  *secondsKill_right_sub;
//配额秒杀
@property(nonatomic,strong) UILabel  *secondsKill_title;
//活动总时间
@property(nonatomic,strong) UILabel  *right_time_title;
//秒杀规则
@property(nonatomic,strong) UILabel  *secondsKill_rules;
//立即秒杀按钮
@property(nonatomic,strong) UIButton  *secondsKill_Btn;

@property(nonatomic,strong)   CZCountDownView *countDown;

@property(nonatomic,strong)    HHQuotasSelectAlert *quotasSelectAlert;

@property(nonatomic,strong)    HHSecKillModel *secKillModel;

@property(nonatomic,strong)    HHSecKillModel *setHead_height_model;

@end
