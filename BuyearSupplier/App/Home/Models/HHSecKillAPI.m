//
//  HHSecKillAPI.m
//  Store
//
//  Created by User on 2018/4/18.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHSecKillAPI.h"

@implementation HHSecKillAPI

#pragma mark - get

//获得配额秒杀活动信息
+ (instancetype)GetSeckillInfo{
    
    HHSecKillAPI *api = [self new];
    api.subUrl = API_Seckill_GetActInfo;
    api.parametersAddToken = NO;
    
    return api;
}
//获得配额选择信息
+ (instancetype)GetSeckill_Quatos{
    
    HHSecKillAPI *api = [self new];
    api.subUrl = API_Seckill_Quatos;
    api.parametersAddToken = NO;
    
    return api;
}

#pragma mark - post

//立即秒杀
+ (instancetype)postSeckill_JoinWithSelect_count:(NSNumber *)select_count{
    
    HHSecKillAPI *api = [self new];
    api.subUrl = API_Seckill_Join;
    if (select_count) {
        [api.parameters setObject:select_count forKey:@"select_count"];
    }
    api.parametersAddToken = NO;
    return api;
}
@end
