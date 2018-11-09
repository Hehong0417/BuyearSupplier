//
//  HHSecKillAPI.h
//  Store
//
//  Created by User on 2018/4/18.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseAPI.h"

@interface HHSecKillAPI : BaseAPI

#pragma mark - get

//获得配额秒杀活动信息
+ (instancetype)GetSeckillInfo;

//获得配额选择信息
+ (instancetype)GetSeckill_Quatos;

#pragma mark - post

//立即秒杀
+ (instancetype)postSeckill_JoinWithSelect_count:(NSNumber *)select_count;


@end
