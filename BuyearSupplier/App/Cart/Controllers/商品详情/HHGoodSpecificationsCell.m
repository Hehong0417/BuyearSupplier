//
//  HHGoodSpecificationsCell.m
//  Store
//
//  Created by User on 2018/1/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHGoodSpecificationsCell.h"

@implementation HHGoodSpecificationsCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.whc_CellBottomOffset = 5;
    self.whc_CellBottomView = self.discribeLabel;

}

@end
