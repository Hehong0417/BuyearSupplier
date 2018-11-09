//
//  HHCollectionReusableHead.m
//  Store
//
//  Created by User on 2018/1/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHCollectionReusableHead.h"
#import "HHMyOrderVC.h"
#import "HHCategoryVC.h"
#import "HHMyWalletVC.h"
#import "HHRatifyAccordSuperVC.h"
#import "HHSecKillRuleVC.h"

@implementation HHCollectionReusableHead

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = kWhiteColor;
        
        [self addSubview:self.searchView];
        
        [self addSubview:self.cycleScrollView];
        
        self.cycleScrollView.autoScrollTimeInterval = 4.0;


        //中间模块
        [self addModels];
        
        [self GetActInfoWithsemaphore:nil];

        //注册通知观察者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptActStartNoti:) name:kNOTIFY_ACT_INFO object:nil];
        
        
        //程序进入前台
        [[NSNotificationCenter defaultCenter]addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            if (![note.object isKindOfClass:[UIApplication class]]) {
              
                //配额秒杀数据
                [self GetActInfoWithsemaphore:nil];
            }
        }];
        
    }
    
    return self;
}
- (void)acceptActStartNoti:(NSNotification *)noti{
    
    //配额秒杀数据
    [self GetActInfoWithsemaphore:nil];
    
}
- (void)addModels{
    
    CGFloat imagW = 85;
    CGFloat imagH = 95;
    CGFloat margin = (ScreenW-3*imagW)/4;

    UIView *modelsView = [UIView lh_viewWithFrame:CGRectMake(0, CGRectGetMaxY(self.cycleScrollView.frame)+10, SCREEN_WIDTH, 2*imagH) backColor:kWhiteColor];
    
    [self addSubview:modelsView];
    
    NSArray *models = @[@[@"baiyuehui",@"huiwanjia",@"zaixiankefu"],@[@"dingdan",@"qianbao",@"qiandingxieyi"]];
    NSArray *modelsNames = @[@[@"百业惠",@"惠万家",@"在线客服"],@[@"我的订单",@"我的钱包",@"签署协议"]];
    //        CGFloat imagW = (SCREEN_WIDTH)/4 - WidthScaleSize_W(3);
    for (NSInteger i = 0; i < 6; i++) {
        NSInteger line = i%3;
        NSInteger row = i/3;
        CGFloat imageX = line*(imagW+margin)+margin+margin/3;
        CGFloat imageY = row*imagH;
        self.modelBtn = [XYQButton ButtonWithFrame:CGRectMake(imageX, imageY, imagW, imagH) imgaeName:models[row][line] titleName:modelsNames[row][line] contentType:TopImageBottomTitle buttonFontAttributes:[FontAttributes fontAttributesWithFontColor:RGB(51, 51, 51) fontsize:14] title_image_padding:10 tapAction:^(XYQButton *button) {
            if (i == 0) {
                //百业惠商城
//               UINavigationController *nav =   self.nav.tabBarController.childViewControllers[1];
//                HHCategoryVC *vc = (HHCategoryVC *)nav.childViewControllers[0];
                HJUser *user = [HJUser sharedUser];
                user.store_selectIndex = 1;
                user.is_currentPage = YES;
                [user write];
                self.nav.tabBarController.selectedIndex = 1;
                
            }else if (i == 1){
                 //惠万家商城
//                UINavigationController *nav = self.nav.tabBarController.childViewControllers[1];
//                HHCategoryVC *vc = (HHCategoryVC *)nav.childViewControllers[0];
                HJUser *user = [HJUser sharedUser];
                user.store_selectIndex = 2;
                user.is_currentPage = YES;
                [user write];
                self.nav.tabBarController.selectedIndex = 1;
            }else if (i == 2){
                //在线客服
                [self telWithPhoneNumber:@"400-600-4811"];
                
            }else if (i == 3){
                //我的订单
                HJUser *user = [HJUser sharedUser];
                if (user.token.length == 0) {
                    HHLoginVC *vc = [[HHLoginVC alloc] initWithNibName:@"HHLoginVC" bundle:nil];
                    HJNavigationController *nav = [[HJNavigationController alloc] initWithRootViewController:vc];
                    [self.vc presentViewController:nav animated:YES completion:nil];
                }else{
                   HHMyOrderVC *vc = [HHMyOrderVC new];
                   [self.nav pushVC:vc];
                }
                
            }else if (i == 4){
                //我的钱包
                HJUser *user = [HJUser sharedUser];
                if (user.token.length == 0) {
                    HHLoginVC *vc = [[HHLoginVC alloc] initWithNibName:@"HHLoginVC" bundle:nil];
                    HJNavigationController *nav = [[HJNavigationController alloc] initWithRootViewController:vc];
                    [self.vc presentViewController:nav animated:YES completion:nil];
                }else{
                    HHMyWalletVC *vc = [HHMyWalletVC new];
                    [self.nav pushVC:vc];
                }
                
            }else if (i == 5){
                //签署协议
                HJUser *user = [HJUser sharedUser];
                if (user.token.length == 0) {
                    HHLoginVC *vc = [[HHLoginVC alloc] initWithNibName:@"HHLoginVC" bundle:nil];
                    HJNavigationController *nav = [[HJNavigationController alloc] initWithRootViewController:vc];
                    [self.vc presentViewController:nav animated:YES completion:nil];
                }else{
                    HHRatifyAccordSuperVC *vc = [HHRatifyAccordSuperVC new];
                    [self.nav pushVC:vc];
                }
            }
            
        }];
        self.modelBtn.tag = i+1000;
        self.modelBtn.backgroundColor = kWhiteColor;
        [self.modelBtn setTitleColor:KLightTitleColor forState:UIControlStateNormal];
        self.modelBtn.titleLabel.font = FONT(14);
        self.backgroundColor = kWhiteColor;
        [modelsView addSubview:self.modelBtn];
        
    }
    /*
     配额秒杀模块
     */
    [self addSecKillModelWithFrame:modelsView.frame];

    
}
/*
 配额秒杀部分
 */
-(void)addSecKillModelWithFrame:(CGRect)frame{
    
    self.secondsKill_bg = [UIView lh_viewWithFrame:CGRectMake(0, CGRectGetMaxY(frame)+20, SCREEN_WIDTH, WidthScaleSize_H(140)) backColor:[UIColor colorWithHexString:@"#fcd4d2"]];
    [self addSubview:self.secondsKill_bg];

    //左边部分
    self.secondsKill_left_sub = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW/2, WidthScaleSize_H(140)) backColor:kClearColor];
    [self.secondsKill_bg addSubview:self.secondsKill_left_sub];
    
    self.left_countdown_img = [UIImageView lh_imageViewWithFrame:CGRectMake(0, 0, ScreenW/2, self.secondsKill_bg.mj_h/3) image:[UIImage imageNamed:@"miaoshatubiao"]];
    self.left_countdown_img.contentMode = UIViewContentModeCenter;
    self.left_countdown_img.centerY = self.secondsKill_left_sub.centerY;
    [self.secondsKill_left_sub addSubview:self.left_countdown_img];
    
    
    UIView *state_bg = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW/2, self.secondsKill_bg.mj_h/3) backColor:kClearColor];
    state_bg.centerY = self.left_countdown_img.centerY;
    
    [self.secondsKill_left_sub addSubview:state_bg];
    
    self.countDown = [CZCountDownView countDown];
    self.countDown.frame = CGRectMake(3, 0, ScreenW/3-6, self.secondsKill_bg.mj_h/3);
    self.countDown.timestamp = 0;
    self.countDown.separateLabelCount = 2;
    self.countDown.labelCount = 3;
    self.countDown.timeColor = [UIColor colorWithHexString:@"#7e4395"];
    self.countDown.timeFont = FONT(22);
    self.countDown.center_X = state_bg.centerX;
    [state_bg addSubview:self.countDown];
    
//    self.state = [UILabel lh_labelWithFrame:CGRectMake(0, 0, ScreenW/2, self.secondsKill_bg.mj_h/3) text:@"进行中..." textColor:[UIColor colorWithHexString:@"#7e4395"] font:BoldFONT(22) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
//    self.state.center_X = state_bg.center_X;
//    self.state.hidden = YES;
//    [state_bg addSubview:self.state];
    
    self.left_top_title = [UILabel lh_labelWithFrame:CGRectMake(0, self.left_countdown_img.mj_y-30, self.secondsKill_left_sub.mj_w, 30) text:@"离秒抢剩余时间还有:" textColor:kBlackColor font:FONT(11) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
    [self.secondsKill_left_sub addSubview:self.left_top_title];
//    self.left_top_title.font = [UIFont fontWithName:@"PingFangSC-Light" size:WidthScaleSize_H(11)];

    
    self.left_bottom_title = [UILabel lh_labelWithFrame:CGRectMake(0, CGRectGetMaxY(self.left_countdown_img.frame), self.secondsKill_left_sub.mj_w, 30) text:@"每天一场  开抢" textColor:kBlackColor font:FONT(13) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
    self.left_bottom_title.font = [UIFont fontWithName:@"PingFangSC-Light" size:WidthScaleSize_H(13)];
    [self.secondsKill_left_sub addSubview:self.left_bottom_title];
    
    
    //右边部分
    self.secondsKill_right_sub = [UIView lh_viewWithFrame:CGRectMake(ScreenW/2, 0, ScreenW/2, WidthScaleSize_H(140)) backColor:kClearColor];
    [self.secondsKill_bg addSubview:self.secondsKill_right_sub];
    
    self.secondsKill_title = [UILabel lh_labelWithFrame:CGRectMake(0, self.left_top_title.mj_y+10, self.secondsKill_right_sub.mj_w, 35) text:@"配额秒抢" textColor:kBlackColor font:FONT(34) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    [self.secondsKill_right_sub addSubview:self.secondsKill_title];
    [self setLabelSpace:self.secondsKill_title withValue:@"配额秒抢" withFont:FONT(34) KernAttribute:7.0f textAlignment:NSTextAlignmentLeft];
    
    
    self.right_time_title = [UILabel lh_labelWithFrame:CGRectMake(0, CGRectGetMaxY(self.secondsKill_title.frame)+8, self.secondsKill_right_sub.mj_w, WidthScaleSize_H(12)) text:[NSString stringWithFormat:@"每场时间：%@",self.secKillModel.minute_span.length>0?self.secKillModel.minute_span:@""]  textColor:kBlackColor font:FONT(12) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    [self.secondsKill_right_sub addSubview:self.right_time_title];
    self.right_time_title.font = [UIFont fontWithName:@"PingFangSC-Light" size:WidthScaleSize_H(12)];
    
    self.secondsKill_rules = [UILabel lh_labelWithFrame:CGRectMake(0, self.left_bottom_title.mj_y, WidthScaleSize_W(80), WidthScaleSize_H(30)) text:@"秒 抢 规 则 》" textColor:kBlackColor font:FONT(10) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
    [self.secondsKill_right_sub addSubview:self.secondsKill_rules];
    self.secondsKill_rules.font = [UIFont fontWithName:@"PingFangSC-Light" size:WidthScaleSize_H(10)];
    
    self.secondsKill_rules.userInteractionEnabled = YES;
    //
    WEAK_SELF();
    [self.secondsKill_rules setTapActionWithBlock:^{
        HHSecKillRuleVC *vc = [[HHSecKillRuleVC alloc] initWithNibName:@"HHSecKillRuleVC" bundle:nil];
        [weakSelf.nav pushVC:vc];
    }];

    //立即秒杀
    self.secondsKill_Btn = [UIButton lh_buttonWithFrame:CGRectMake(CGRectGetMaxX(self.secondsKill_rules.frame), self.secondsKill_rules.mj_y-WidthScaleSize_W(5), WidthScaleSize_W(90), WidthScaleSize_H(25)) target:self action:@selector(secondsKillAction:) title:@"立即秒抢" titleColor:kWhiteColor font:FONT(14) backgroundColor:kBlackColor];
    [self.secondsKill_Btn lh_setCornerRadius:5 borderWidth:0 borderColor:nil];
    [self.secondsKill_right_sub addSubview:self.secondsKill_Btn];
    self.secondsKill_Btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:WidthScaleSize_H(14)];
    [self setBtnSpace:self.secondsKill_Btn withValue:@"立即秒抢" withFont:FONT(14)];
    self.secondsKill_bg.hidden = YES;

    
    //楼层
    self.levelBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.secondsKill_bg.frame), SCREEN_WIDTH, WidthScaleSize_H(70))];
    self.levelBgView.backgroundColor = KVCBackGroundColor;
    [self addSubview:self.levelBgView];
    
    UIView *line = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 1) backColor:KVCBackGroundColor];
    [self.levelBgView addSubview:line];
    
    self.levelBgLab = [UILabel lh_labelWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, WidthScaleSize_H(60)) text:@"" textColor:kBlackColor font:FONT(15) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
    
    [self.levelBgView addSubview:self.levelBgLab];
}
//查看活动状态
-(void)GetActInfoWithsemaphore:(dispatch_semaphore_t)semaphore{
    
    self.secondsKill_bg.hidden = YES;
    
    [[[HHSecKillAPI GetSeckillInfo] netWorkClient] getRequestInView:nil finishedBlock:^(HHSecKillAPI *api, NSError *error) {
        if (!error) {
            if (api.code == 0) {
               HHSecKillModel *secKill_model = [HHSecKillModel mj_objectWithKeyValues:api.data];
                self.secKillModel = secKill_model;
                
                if ([secKill_model.status isEqual:@2]) {
                    
                 //秒杀开始--进行中
                 [self startSecKillWithSecKillModel:secKill_model];
                    
                }else if ([secKill_model.status isEqual:@3]){
                    
                    //秒杀结束--已结束
                    [self endSecKill];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:api.msg];
            }
        }else{

        }
    }];
}
//秒杀开始
- (void)startSecKillWithSecKillModel:(HHSecKillModel*)secKillModel{

    self.left_top_title.text = @"离秒抢结束时间还有:";
    [self setLabelSpace:self.left_top_title withValue:self.left_top_title.text withFont:FONT(11) KernAttribute:2.0f textAlignment:NSTextAlignmentCenter];
    
    self.left_bottom_title.text = [NSString stringWithFormat:@"每天一场  %@开抢",self.secKillModel.being_datetime];
    //倒计时
    [self.countDown.timer invalidate];
    self.countDown.timestamp = self.secKillModel.end_seconds_span.integerValue;
    //**********活动结束************//
    WEAK_SELF();
    self.countDown.timerStopBlock = ^{
        NSLog(@"活动结束～");
//        [weakSelf GetActInfoWithsemaphore:nil];
        //秒杀结束--已结束
        [weakSelf endSecKill];
    };
    self.secondsKill_Btn.enabled = YES;
    [self.secondsKill_Btn lh_setBackgroundColor:kBlackColor forState:UIControlStateNormal];
    
}
//秒杀结束
-(void)endSecKill{
    
    self.left_top_title.text = @"秒抢已结束,明天再来吧";
    self.left_bottom_title.text = [NSString stringWithFormat:@"每天一场  %@开抢",self.secKillModel.being_datetime];
    [self.countDown.timer invalidate];
    [self.countDown getDetailTimeWithTimestamp:0];
    self.secondsKill_Btn.enabled = NO;
    [self.secondsKill_Btn lh_setBackgroundColor:kLightGrayColor forState:UIControlStateNormal];
    
}

-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font KernAttribute:(CGFloat)kernAttribute textAlignment:(NSTextAlignment)alignment {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = alignment;
    paraStyle.lineSpacing = 1.0; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@(kernAttribute)
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}
-(void)setBtnSpace:(UIButton*)btn withValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentCenter;
//    paraStyle.lineSpacing = 15; //设置行间距
//    paraStyle.hyphenationFactor = 1.0;
//    paraStyle.firstLineHeadIndent = 0.0;
//    paraStyle.paragraphSpacingBefore = 0.0;
//    paraStyle.headIndent = 0;
//    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@2.0f
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    [btn setAttributedTitle:attributeStr forState:UIControlStateNormal];
}

//立即秒杀
- (void)secondsKillAction:(UIButton *)btn{
    
    HJUser *user = [HJUser sharedUser];
    
    if (user.token.length == 0) {
        //判断是否登录
        HHLoginVC *vc = [[HHLoginVC alloc] initWithNibName:@"HHLoginVC" bundle:nil];
        vc.tabBarVC = (HJTabBarController *)self.vc.tabBarController;
        vc.tabSelectIndex = 0;
        HJNavigationController *nav = [[HJNavigationController alloc] initWithRootViewController:vc];
        [self.vc presentViewController:nav animated:YES completion:nil];
    }else{
           //立即秒杀
            [self getQuatoData];
    }
}
//获取配额选择数据
- (void)getQuatoData{
    
    [[[HHSecKillAPI GetSeckill_Quatos] netWorkClient] getRequestInView:nil finishedBlock:^(HHSecKillAPI *api, NSError *error) {
        
        if (!error) {
            if (api.code == 0) {
                
                self.quotasSelectAlert = [[HHQuotasSelectAlert alloc] init];
                HHSecKillModel *model = [HHSecKillModel mj_objectWithKeyValues:api.data];
                self.quotasSelectAlert.secKill_model = model;
                [self.quotasSelectAlert showAnimated:NO];

            }else{
                [SVProgressHUD showInfoWithStatus:api.msg];
                
            }
        }else{
            

        }
    }];
}
- (SDCycleScrollView *)cycleScrollView {
    
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2) imageNamesGroup:@[@"",@"",@""]];
        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"xuanzhong"];
        _cycleScrollView.pageDotImage =  [UIImage imageNamed:@"weixuanzhong"];
        _cycleScrollView.pageControlDotSize = CGSizeMake(21, 4.5);
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    }
    
    return _cycleScrollView;
}
- (void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup {
    
    _imageURLStringsGroup = imageURLStringsGroup;
    
    self.cycleScrollView.imageURLStringsGroup = imageURLStringsGroup.count?imageURLStringsGroup:@[@"",@"",@""];
    
}
- (void)setSetHead_height_model:(HHSecKillModel *)setHead_height_model{
    
    _setHead_height_model = setHead_height_model;
    self.levelBgView.frame =CGRectMake(0, CGRectGetMaxY(self.frame)-WidthScaleSize_H(70), SCREEN_WIDTH, WidthScaleSize_H(70));

    if ([setHead_height_model.status isEqual:@0]) {
        //活动不存在
        self.secondsKill_bg.hidden = YES;
    }else{
        self.secondsKill_bg.hidden = NO;
    }
    
}
- (void)setSecKillModel:(HHSecKillModel *)secKillModel{
    _secKillModel = secKillModel;
    
    self.right_time_title.text = [NSString stringWithFormat:@"每场时间：%@",self.secKillModel.minute_span.length>0?self.secKillModel.minute_span:@""];
    
    if ([secKillModel.status isEqual:@0]) {
        //活动不存在
        self.secondsKill_bg.hidden = YES;
        self.levelBgView.frame =CGRectMake(0, CGRectGetMaxY(self.frame)-WidthScaleSize_H(70), SCREEN_WIDTH, WidthScaleSize_H(70));
        
    }else if([secKillModel.status isEqual:@1]){
        // 预热中
        self.secondsKill_bg.hidden = NO;
        self.left_top_title.text = @"离秒抢剩余时间还有:";
        [self setLabelSpace:self.left_top_title withValue:self.left_top_title.text withFont:FONT(11) KernAttribute:2.0f textAlignment:NSTextAlignmentCenter];
        
        self.left_bottom_title.text = [NSString stringWithFormat:@"每天一场  %@开抢",self.secKillModel.being_datetime];
        //倒计时
        [self.countDown.timer invalidate];
        self.countDown.timestamp = secKillModel.begin_seconds_span.integerValue;
        //*************活动开始***********//
        WEAK_SELF();
        self.countDown.timerStopBlock = ^{
            NSLog(@"活动开始～");
            //请求服务器----查看状态
//            [weakSelf GetActInfoWithsemaphore:nil];
            //秒杀开始--进行中
            [weakSelf startSecKillWithSecKillModel:secKillModel];
            
        };
        
        self.secondsKill_Btn.enabled = NO;
        [self.secondsKill_Btn lh_setBackgroundColor:kLightGrayColor forState:UIControlStateNormal];

    }else if([secKillModel.status isEqual:@2]){

        // 进行中
        self.secondsKill_bg.hidden = NO;
        //秒杀开始
        [self startSecKillWithSecKillModel:secKillModel];
        
    }else if([secKillModel.status isEqual:@3]){
        // 已结束
        self.secondsKill_bg.hidden = NO;
        //秒杀结束
        [self endSecKill];
    }
}
@end
