//
//  HHMyWalletCell.h
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHMyWalletCell : UITableViewCell

@property (nonatomic,strong) HHMineModel *myWalletModel;
@property (weak, nonatomic) IBOutlet UILabel *action_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *integral_typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *datetimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon_img;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w_constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *time_w_constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *date_w_constraint;


@end
