//
//  HHMyBankCardCell.h
//  Store
//
//  Created by User on 2017/12/25.
//  Copyright © 2017年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHMyBankCardCell : UITableViewCell

@property (nonatomic,strong) HHMineModel *bankCardModel;
@property (weak, nonatomic) IBOutlet UILabel *bank_noLabel;
@property (weak, nonatomic) IBOutlet UILabel *is_defaultLabel;
@property (weak, nonatomic) IBOutlet UILabel *bank_no;
@property (weak, nonatomic) IBOutlet UILabel *bankName_title;
@property (weak, nonatomic) IBOutlet UILabel *bankNo_title;

@end
