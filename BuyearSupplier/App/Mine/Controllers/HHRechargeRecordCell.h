//
//  HHRechargeRecordCell.h
//  Store
//
//  Created by User on 2018/1/8.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHRechargeRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *datetimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


//充值记录
@property(nonatomic,strong) HHMineModel *rechargeModel;

//转账记录
@property(nonatomic,strong) HHMineModel *TransferModel;



@end
