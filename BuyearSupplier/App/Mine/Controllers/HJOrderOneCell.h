//
//  HJOrderOneCell.h
//  Store
//
//  Created by User on 2017/12/19.
//  Copyright © 2017年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJOrderOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *s_integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *pya_totalLabel;

@property (nonatomic, strong) HHCartModel *orderModel;

@end
