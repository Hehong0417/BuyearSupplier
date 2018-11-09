//
//  HHQuotasCell.h
//  Store
//
//  Created by User on 2018/4/17.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHSecKillModel.h"

@interface HHQuotasCell : UICollectionViewCell

typedef void(^ChooseBtnSelectAction)(NSIndexPath *indexPath,BOOL leftButtonSelected);

@property (weak, nonatomic) IBOutlet UIButton *number_btn;
@property (nonatomic, copy) ChooseBtnSelectAction ChooseBtnSelectAction;
@property (nonatomic, assign) BOOL leftSelected;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong)   HHQuatoModel *quatoModel;

@end
