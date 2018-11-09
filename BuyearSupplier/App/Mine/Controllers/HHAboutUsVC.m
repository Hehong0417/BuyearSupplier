//
//  HHAboutUsVC.m
//  Store
//
//  Created by User on 2018/1/31.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHAboutUsVC.h"

@interface HHAboutUsVC ()

@end

@implementation HHAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"关于我们";
    UIImageView *logo_imgv = [UIImageView lh_imageViewWithFrame:CGRectMake(0, 0, ScreenW, 100) image:[UIImage imageNamed:@"logo_baiyehui_default"]];
    logo_imgv.contentMode = UIViewContentModeCenter;
    [self.view addSubview:logo_imgv];
    
    UILabel *versionLab = [UILabel lh_labelAdaptionWithFrame:CGRectMake(0, CGRectGetMaxY(logo_imgv.frame), ScreenW, 30) text:[NSString stringWithFormat:@"圣韵百业惠v%@",kAppCurrentVersion] textColor:KACLabelColor font:FONT(14) textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:versionLab];
    
}


@end
