//
//  HHCommentSection.m
//  mengyaProject
//
//  Created by n on 2017/10/31.
//  Copyright © 2017年 n. All rights reserved.
//

#import "HHCommentSection.h"

@implementation HHCommentSection

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {

        [self addSubview:self.titleLabel];
        [self addSubview:self.countLabel];
    }

    return self;

}

- (UILabel *)titleLabel{

    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.mj_h/2-5, self.mj_w, self.mj_h/2-10)];
        _titleLabel.textColor = kWhiteColor;
        _titleLabel.font = BoldFONT(18);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)countLabel{
    
    if (!_countLabel) {
        _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.mj_w, self.mj_h/2-8)];
        _countLabel.textColor = kWhiteColor;
        _countLabel.font = FONT(12);
        _countLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _countLabel;
}

@end
