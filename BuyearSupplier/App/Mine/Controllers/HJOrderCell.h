//
//  HJOrderCell.h
//  Mcb
//
//  Created by IMAC on 15/12/25.
//  Copyright (c) 2015年 hejing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJOrderCell : UITableViewCell

@property (nonatomic, strong) HHproductsModel *productModel;
@property (weak, nonatomic) IBOutlet UILabel *sku_nameLab;

@end
