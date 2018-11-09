//
//  HHShareCountVC.m
//  Store
//
//  Created by User on 2018/5/8.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHShareCountVC.h"

@interface HHShareCountVC ()

@end

@implementation HHShareCountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.titleStr;
    
}
- (NSArray *)groupTitles{
    

    return @[@[self.titleStr]];
    
}
- (NSArray *)groupIcons {
    
    
    return @[@[@""]];
    
}
- (NSArray *)groupDetials{
    
    return @[@[self.referrer_count?self.referrer_count:@" "]];
}
@end
