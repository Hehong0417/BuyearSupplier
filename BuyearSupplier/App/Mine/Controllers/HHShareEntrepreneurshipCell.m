//
//  HHShareEntrepreneurshipCell.m
//  Store
//
//  Created by User on 2018/1/8.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHShareEntrepreneurshipCell.h"

@implementation HHShareEntrepreneurshipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setShareEntrepreneurshipModel:(HHMineModel *)shareEntrepreneurshipModel{
    
    _shareEntrepreneurshipModel = shareEntrepreneurshipModel;
    
    self.display_noLabel.text = shareEntrepreneurshipModel.username;
    self.sign_noLabel.text = shareEntrepreneurshipModel.display_no;
    self.achievement_totalLabel.text = shareEntrepreneurshipModel.achievement_total?shareEntrepreneurshipModel.achievement_total:@"0";

}

@end
