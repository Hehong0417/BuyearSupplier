//
//  HHPaySucessVC.m
//  Store
//
//  Created by User on 2018/1/19.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHPaySucessVC.h"
#import "HHPaySucessVC.h"
#import "HHMyOrderVC.h"

@interface HHPaySucessVC ()

@end

@implementation HHPaySucessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"支付成功";
    
    UIImageView *successImageV = [UIImageView lh_imageViewWithFrame:CGRectMake(0, 70, ScreenW, 130) image:[UIImage imageNamed:@"icon_paysuccess_default"]];
    successImageV.contentMode = UIViewContentModeCenter;
    [self.view addSubview:successImageV];
    
    UILabel *label = [UILabel lh_labelWithFrame:CGRectMake(0, 200, ScreenW, 20) text:@"支付成功" textColor:APP_purple_Color font:FONT(14) textAlignment:NSTextAlignmentCenter backgroundColor:KVCBackGroundColor];
    [self.view addSubview:label];

    UIButton *btn = [UIButton lh_buttonWithFrame:CGRectMake(30, CGRectGetMaxY(label.frame)+60, ScreenW-60, 40) target:self action:@selector(myOrderAction) image:nil title:@"查看订单" titleColor:kWhiteColor font:FONT(14)];
    btn.backgroundColor = APP_COMMON_COLOR;
    [btn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [self.view addSubview:btn];
    
    //抓取返回按钮
    UIButton *backBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [backBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)backBtnAction{
    
    [self.navigationController popToRootVC];
    
}
- (void)myOrderAction{
    
    HHMyOrderVC *vc = [HHMyOrderVC new];
    [self.navigationController pushVC:vc];
    
}


@end
