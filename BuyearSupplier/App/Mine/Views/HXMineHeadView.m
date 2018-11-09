

//
//  HXMineHeadView.m
//  mengyaProject
//
//  Created by n on 2017/6/16.
//  Copyright © 2017年 n. All rights reserved.
//

#import "HXMineHeadView.h"
//#import "HXUserLoginVC.h"

@implementation HXMineHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        
 
        UIImageView *imagV = [UIImageView lh_imageViewWithFrame:self.bounds image:[UIImage imageNamed:@"img_bg_user"]];
        [self addSubview:imagV];
        //登录后状态底视图
        self.loginContentView = [UIView lh_viewWithFrame:frame backColor:kClearColor];
        [self addSubview:self.loginContentView];
        self.teacherImageIcon.centerX = SCREEN_WIDTH/2;
        self.nameLabel.centerX = SCREEN_WIDTH/2;
        self.IDLabel.centerX = SCREEN_WIDTH/2;

        [self.loginContentView addSubview:self.teacherImageIcon];
        [self.loginContentView addSubview:self.nameLabel];
        [self.loginContentView addSubview:self.IDLabel];
        [self.loginContentView addSubview:self.signRight_title_Label];
        [self.loginContentView addSubview:self.signRight_value_Label];

        //底图
        [self.loginContentView addSubview:self.bottomView];
        
    }
    return self;
}

- (void)regAndLoginAction:(UIButton *)btn{

//    [self.nav pushVC:[HXUserLoginVC new]];
    
}
//标题1
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, WidthScaleSize_H(20), WidthScaleSize_W(160), WidthScaleSize_H(30))];
        _titleLabel.textColor = kBlackColor;
        _titleLabel.text = @"";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = FONT(17);
    }
    return _titleLabel;
    
}

//用户头像
- (UIImageView *)teacherImageIcon {
    
    if (!_teacherImageIcon) {
        _teacherImageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(WidthScaleSize_W(20), WidthScaleSize_H(20), WidthScaleSize_W(100), WidthScaleSize_W(100))];
        _teacherImageIcon.backgroundColor = KVCBackGroundColor;
        [_teacherImageIcon lh_setRoundImageViewWithBorderWidth:0 borderColor:nil];
    }
    return _teacherImageIcon;
          
}

//姓名
- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.teacherImageIcon.frame)+5, WidthScaleSize_W(150), WidthScaleSize_H(25))];
        _nameLabel.textColor = kWhiteColor;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = BoldFONT(16);
    }
    return _nameLabel;
    
}
//ID
- (UILabel *)IDLabel {
    
    if (!_IDLabel) {
        _IDLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nameLabel.frame), WidthScaleSize_W(200), WidthScaleSize_H(25))];
        _IDLabel.textColor = kWhiteColor;
        _IDLabel.textAlignment = NSTextAlignmentCenter;
        _IDLabel.font = BoldFONT(13);
    }
    return _IDLabel;
    
}
// 底图
- (UIView *)bottomView {
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.mj_h-WidthScaleSize_H(150), SCREEN_WIDTH, WidthScaleSize_H(150))];
        _bottomView.backgroundColor = APP_Deep_purple_Color;
    }
    return _bottomView;
    
}
- (UILabel *)signRight_title_Label{
    
    if (!_signRight_title_Label) {
        _signRight_title_Label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame), self.nameLabel.mj_y, ScreenW-CGRectGetMaxX(self.nameLabel.frame), WidthScaleSize_H(25))];
        _signRight_title_Label.textColor = kWhiteColor;
        _signRight_title_Label.textAlignment = NSTextAlignmentCenter;
        _signRight_title_Label.text = @"惠万家期权数";
        _signRight_title_Label.font = FONT(12);
    }
    return _signRight_title_Label;
    
}
- (UILabel *)signRight_value_Label{                                                                                                                                                                                                   
    if (!_signRight_value_Label) {
        _signRight_value_Label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame), CGRectGetMaxY(_signRight_title_Label.frame), ScreenW-CGRectGetMaxX(self.nameLabel.frame), WidthScaleSize_H(25))];
        _signRight_value_Label.textColor = kWhiteColor;
        _signRight_value_Label.textAlignment = NSTextAlignmentCenter;
        _signRight_value_Label.text = @"";
        _signRight_value_Label.font = FONT(12);
    }
    return _signRight_value_Label;
}
@end
