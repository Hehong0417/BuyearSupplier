//
//  HHVersionAPI.m
//  Store
//
//  Created by User on 2018/2/27.
//  Copyright © 2018年 User. All rights reserved.
//

#define STOREAPPID  @"1342153235"

#import "HHVersionAPI.h"

@implementation HHVersionAPI

//APP是否强制更新
+ (instancetype)GetAPPIsMustUpdate{
    
    HHVersionAPI *api = [self new];
    api.subUrl = API_GetAPPIsMustUpdate;
    api.parametersAddToken = NO;
    
    return api;
}

@end
