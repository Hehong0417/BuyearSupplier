//
//  HHQuotasCell.m
//  Store
//
//  Created by User on 2018/4/17.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHQuotasCell.h"

@implementation HHQuotasCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self lh_setCornerRadius:5 borderWidth:1 borderColor:kBlackColor];
    [self.number_btn addTarget:self action:@selector(chooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.number_btn lh_setBackgroundColor:[UIColor colorWithHexString:@"#7e4395"] forState:UIControlStateSelected];
    [self.number_btn lh_setBackgroundColor:kWhiteColor forState:UIControlStateNormal];

    self.number_btn.titleLabel.font = FONT(26);
}
- (void)chooseBtnAction:(UIButton *)sender{
    
    sender.selected = ! sender.selected;

    [self lh_setCornerRadius:5 borderWidth:sender.selected?0:1 borderColor:sender.selected?kClearColor:kBlackColor];

    if (self.ChooseBtnSelectAction) {
        
    self.ChooseBtnSelectAction(self.indexPath,sender.selected);
        
    }
}
- (void)setLeftSelected:(BOOL)leftSelected{
    _leftSelected = leftSelected;
    self.number_btn.selected = leftSelected;
}
- (void)setQuatoModel:(HHQuatoModel *)quatoModel{
    
    _quatoModel = quatoModel;
    if ([quatoModel.is_enabled isEqual:@0]) {
        //不可选
        self.number_btn.enabled = NO;
        [self.number_btn setTitleColor:kGrayColor forState:UIControlStateNormal];
        [self lh_setCornerRadius:5 borderWidth:1 borderColor:[UIColor colorWithHexString:@"999999"]];
    }else{
        //可选
        self.number_btn.enabled = YES;
        [self.number_btn setTitleColor:kBlackColor forState:UIControlStateNormal];
        [self lh_setCornerRadius:5 borderWidth:1 borderColor:kBlackColor];
    }
      [self.number_btn setTitle:quatoModel.count forState:UIControlStateNormal];
}

@end
