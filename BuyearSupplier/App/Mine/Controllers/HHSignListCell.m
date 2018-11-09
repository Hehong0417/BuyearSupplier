//
//  HHSignListCell.m
//  Store
//
//  Created by User on 2018/1/11.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHSignListCell.h"

@implementation HHSignListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSignModel:(HHMineModel *)signModel{
    
    _signModel = signModel;
    
    self.sign_noLable.text = signModel.display_no;
    self.sign_level.text = signModel.sign_type;
  
    
    for (NSInteger i= 0; i<10; i++) {
        if ([signModel.sign_level_tag isEqualToString:[NSString stringWithFormat:@"%ld",i]]) {
            self.sign_level_tagImageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_level%ld_default",i]];
        }else if ([signModel.sign_level_tag isEqualToString:[NSString stringWithFormat:@"L%ld",i]]){
            self.sign_level_tagImageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_level%ld_default",i]];
        }else if ([signModel.sign_level_tag isEqualToString:[NSString stringWithFormat:@"S%ld",i]]){
            self.sign_level_tagImageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_s%ld_default",i]];
        }
    }
    if ([signModel.is_borrow isEqual:@0]) {
        self.borrow_level_imagV.hidden = YES;
    }else if ([signModel.is_borrow isEqual:@1]){
        self.borrow_level_imagV.hidden = NO;
    }
}
@end
