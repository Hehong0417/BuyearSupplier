//
//  HXBonusLogCell.h
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHStoreSubsidyCell : UITableViewCell
@property (nonatomic,strong) HHMineModel *storeSubsidyModel;
@property (weak, nonatomic) IBOutlet UILabel *datetimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *reward_totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *platform_integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopping_integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *money_integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@end
