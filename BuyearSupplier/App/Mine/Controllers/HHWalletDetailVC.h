//
//  HHWalletDetailVC.h
//  Store
//
//  Created by User on 2018/3/6.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHWalletDetailVC : UIViewController

@property (nonatomic,strong) HHMineModel *myWalletModel;
@property(nonatomic,strong) NSString  *userid;


@property (weak, nonatomic) IBOutlet UIView *walletView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *walletView_height;
@property (weak, nonatomic) IBOutlet UILabel *userid_lab;
@property (weak, nonatomic) IBOutlet UILabel *integral_type_lab;
@property (weak, nonatomic) IBOutlet UILabel *money_lab;
@property (weak, nonatomic) IBOutlet UILabel *oneName_lab;
@property (weak, nonatomic) IBOutlet UILabel *twoName_lab;
@property (weak, nonatomic) IBOutlet UILabel *three_lab;
@property (weak, nonatomic) IBOutlet UILabel *four_lab;
@property (weak, nonatomic) IBOutlet UILabel *five_lab;
@property (weak, nonatomic) IBOutlet UILabel *six_lab;


@property (weak, nonatomic) IBOutlet UILabel *one_info_lab;
@property (weak, nonatomic) IBOutlet UILabel *two_info_lab;
@property (weak, nonatomic) IBOutlet UILabel *three_info_lab;
@property (weak, nonatomic) IBOutlet UILabel *four_info_lab;
@property (weak, nonatomic) IBOutlet UILabel *five_info_lab;
@property (weak, nonatomic) IBOutlet UILabel *six_info_lab;

@end
