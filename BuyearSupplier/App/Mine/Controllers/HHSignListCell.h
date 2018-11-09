//
//  HHSignListCell.h
//  Store
//
//  Created by User on 2018/1/11.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHSignListCell : UITableViewCell
@property (nonatomic,strong) HHMineModel *signModel;
@property (weak, nonatomic) IBOutlet UILabel *sign_noLable;
@property (weak, nonatomic) IBOutlet UILabel *sign_level;
@property (weak, nonatomic) IBOutlet UIImageView *sign_level_tagImageV;
@property (weak, nonatomic) IBOutlet UIImageView *borrow_level_imagV;

@end
