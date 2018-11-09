//
//  HXMineHeadView.h
//  mengyaProject
//
//  Created by n on 2017/6/16.
//  Copyright © 2017年 n. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXMineHeadView : UIView

@property(nonatomic,strong) UIImageView *teacherImageIcon;

@property(nonatomic,strong) UILabel *nameLabel;

@property(nonatomic,strong) UILabel *IDLabel;

//登录前状态底视图
@property(nonatomic,strong) UIView *registerContentView;

//登录后底视图
@property(nonatomic,strong) UIView *loginContentView;


@property(nonatomic,strong) UILabel *titleLabel;

@property(nonatomic,strong) UILabel *title2Label;

@property(nonatomic,strong) UIButton *regAndLoginBtn;

@property(nonatomic,assign) NSInteger stateNum;


@property(nonatomic,strong) UINavigationController *nav;

@property(nonatomic,strong) UIView *bottomView;

@property(nonatomic,strong) UILabel *signRight_title_Label;

@property(nonatomic,strong) UILabel *signRight_value_Label;

@end
