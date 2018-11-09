//
//  HHTeamListSubCell.m
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHTeamListSubCell.h"

@implementation HHTeamListSubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setChildTeamsModel:(HHMineModel *)childTeamsModel {
    
    _childTeamsModel = childTeamsModel;
    
    self.sign_noLabel.text = childTeamsModel.display_no;
    self.mobileLabel.text = childTeamsModel.mobile;
    self.sign_levelLable.text = childTeamsModel.sign_level;
    self.usernameLabel.text = childTeamsModel.username;
    self.sign_typeLabel.text = childTeamsModel.sign_type;

}

@end
