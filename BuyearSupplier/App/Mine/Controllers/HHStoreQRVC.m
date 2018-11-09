//
//  HHStoreQRVC.m
//  Store
//
//  Created by User on 2018/1/10.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHStoreQRVC.h"

@interface HHStoreQRVC ()

@end

@implementation HHStoreQRVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"体验店二维码";
    
    UIImageView *image_w = [UIImageView lh_imageViewWithFrame:CGRectMake(60,0,ScreenW-120,ScreenW-120) image:nil];
    image_w.centerY = self.view.centerY-64;
    [image_w sd_setImageWithURL:[NSURL URLWithString:self.qrcode_url]];
    [self.view addSubview:image_w];
    
    UILabel *describ_Lab = [UILabel lh_labelWithFrame:CGRectMake(0, 0, ScreenW, 100) text:@"只有体验店店补大于0才有二维码" textColor:KACLabelColor font:FONT(15) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
    describ_Lab.centerY = self.view.centerY-64;
    [self.view addSubview:describ_Lab];
    if (self.qrcode_url.length == 0) {
        describ_Lab.hidden = NO;
    }else{
        describ_Lab.hidden = YES;
    }
    
}


@end
