//
//  HHReturnGoodsVC.h
//  Store
//
//  Created by User on 2018/1/8.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHReturnGoodsVC : UIViewController

@property(nonatomic,copy) numberBlock returnBlock;

@property(nonatomic,strong) NSString  *titleStr;

@property(nonatomic,strong) NSString  *orderid;

@property(nonatomic,assign) NSInteger  sg_selectIndex;


@end
