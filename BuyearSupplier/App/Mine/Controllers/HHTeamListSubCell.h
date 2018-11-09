//
//  HHTeamListSubCell.h
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHTeamListSubCell : UITableViewCell

@property (nonatomic,strong) HHMineModel *childTeamsModel;
@property (weak, nonatomic) IBOutlet UILabel *sign_noLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *sign_typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sign_levelLable;

@end
