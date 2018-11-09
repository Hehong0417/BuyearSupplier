//
//  HHRechargeRecordCell.m
//  Store
//
//  Created by User on 2018/1/8.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHRechargeRecordCell.h"

@implementation HHRechargeRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setRechargeModel:(HHMineModel *)rechargeModel {
    _rechargeModel = rechargeModel;
    self.infoLabel.text = rechargeModel.bank_cardno?rechargeModel.bank_cardno:@"";
    self.datetimeLabel.text  = rechargeModel.datetime;
    self.moneyLabel.text  =  [NSString stringWithFormat:@"%@",rechargeModel.money];
    self.statusLabel.text = rechargeModel.status;
    
}
- (void)setTransferModel:(HHMineModel *)TransferModel{
    
    _TransferModel = TransferModel;
    self.infoLabel.text = TransferModel.info;
    self.datetimeLabel.text  = TransferModel.datetime;
    self.moneyLabel.text  =  [NSString stringWithFormat:@"%@",TransferModel.money];
    self.statusLabel.text = [NSString stringWithFormat:@"%@%@",TransferModel.type,TransferModel.status];
}

@end
