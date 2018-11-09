//
//  HXTeacherCenterCell.h
//  mengyaProject
//
//  Created by n on 2017/8/8.
//  Copyright © 2017年 n. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HXTeacherCenterCellProtocol <NSObject>

- (void)pushRatifyAccord;

@end

@interface HXTeacherCenterCell : UITableViewCell

@property(nonatomic,strong) XYQButton *modelBtn;

@property(nonatomic,copy) idBlock buttonSelectBlock;

@property(nonatomic,strong) UINavigationController *nav;

@property(nonatomic,strong) NSString *userName;

@property(nonatomic,weak) id <HXTeacherCenterCellProtocol> delegate;


@end
