//
//  HHWithDrawCell.h
//  Store
//
//  Created by User on 2018/4/10.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHWithDrawCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *bankNo;
@property (weak, nonatomic) IBOutlet UILabel *dateTime;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *title2;
@property (weak, nonatomic) IBOutlet UIButton *cancel_withDrawBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelBtn_constant;

//提现记录
@property(nonatomic,strong) HHMineModel *withDrawModel;
@property(nonatomic,strong) voidBlock  cancel_btnBlock;
@property(nonatomic,strong) UIView  *view;
@property(nonatomic,strong) UIViewController  *vc;
@property (weak, nonatomic) IBOutlet UILabel *rejectReasonStatus;


//签约权分配记录
@property(nonatomic,strong) HHMineModel *signedQuotaModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateTime_constant;
@end
