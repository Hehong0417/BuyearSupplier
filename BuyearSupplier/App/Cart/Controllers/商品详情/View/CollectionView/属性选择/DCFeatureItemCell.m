//
//  DCFeatureItemCell.m
//  CDDStoreDemo
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCFeatureItemCell.h"

// Controllers

// Models
#import "DCFeatureItem.h"
#import "DCFeatureList.h"
// Views

// Vendors

// Categories

// Others

@interface DCFeatureItemCell ()

@end

@implementation DCFeatureItemCell

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    _attLabel = [[UILabel alloc] init];
    _attLabel.textAlignment = NSTextAlignmentCenter;
    _attLabel.font = FONT(13);
    [self addSubview:_attLabel];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_attLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}


#pragma mark - Setter Getter Methods

- (void)setContent:(HHsku_name_valueModel *)content
{
    _content = content;
    _attLabel.text = content.sku_value_value;

    if (content.isSelect) {
        _attLabel.textColor = [UIColor redColor];
        [DCSpeedy dc_chageControlCircularWith:_attLabel AndSetCornerRadius:5 SetBorderWidth:1 SetBorderColor:[UIColor redColor] canMasksToBounds:YES];
    }else{
        _attLabel.textColor = [UIColor blackColor];
        [DCSpeedy dc_chageControlCircularWith:_attLabel AndSetCornerRadius:5 SetBorderWidth:1 SetBorderColor:[[UIColor lightGrayColor]colorWithAlphaComponent:0.4] canMasksToBounds:YES];
    }
}

@end
