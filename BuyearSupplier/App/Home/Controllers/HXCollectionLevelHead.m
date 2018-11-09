//
//  HXCollectionLevelHead.m
//  Store
//
//  Created by User on 2018/1/3.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HXCollectionLevelHead.h"

@implementation HXCollectionLevelHead

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        
        //楼层
        self.levelBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, WidthScaleSize_H(60))];
        self.levelBgView.backgroundColor = kWhiteColor;
        [self addSubview:self.levelBgView];
        
        self.levelBgLab = [UILabel lh_labelWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20,  WidthScaleSize_H(60)) text:@"" textColor:kBlackColor font:FONT(15) textAlignment:NSTextAlignmentCenter backgroundColor:kWhiteColor];
        [self.levelBgView addSubview:self.levelBgLab];
        
    }
    
    return self;
}
@end
