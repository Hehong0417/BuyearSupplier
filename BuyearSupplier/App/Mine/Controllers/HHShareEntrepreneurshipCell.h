//
//  HHShareEntrepreneurshipCell.h
//  Store
//
//  Created by User on 2018/1/8.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHShareEntrepreneurshipCell : UITableViewCell

@property (nonatomic,strong) HHMineModel *shareEntrepreneurshipModel;
@property (weak, nonatomic) IBOutlet UILabel *sign_noLabel;
@property (weak, nonatomic) IBOutlet UILabel *display_noLabel;
@property (weak, nonatomic) IBOutlet UILabel *achievement_totalLabel;

@end
