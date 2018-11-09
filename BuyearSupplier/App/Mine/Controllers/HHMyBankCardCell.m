
//
//  HHMyBankCardCell.m
//  Store
//
//  Created by User on 2017/12/25.
//  Copyright © 2017年 User. All rights reserved.
//

#import "HHMyBankCardCell.h"

@implementation HHMyBankCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bankName_title.font = FONT(14);
    self.bankNo_title.font = FONT(14);
    self.bank_noLabel.font = FONT(14);
    self.bank_no.font = FONT(14);
}

- (void)setBankCardModel:(HHMineModel *)bankCardModel{
    
    _bankCardModel = bankCardModel;
    self.bank_noLabel.text = bankCardModel.bank_name;
    self.bank_no.text = bankCardModel.bank_no;
  
    if ([bankCardModel.is_default isEqualToString:@"1"]) {
        self.is_defaultLabel.hidden = NO;
    }else{
        self.is_defaultLabel.hidden = YES;
    }
    
}

@end
