//
//  HHSecKillModel.h
//  Store
//
//  Created by User on 2018/4/18.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@interface HHSecKillModel : BaseModel

//活动信息
@property(nonatomic,strong) NSNumber *status;
@property(nonatomic,strong) NSNumber *begin_seconds_span;
@property(nonatomic,strong) NSNumber *end_seconds_span;
@property(nonatomic,strong) NSString *info;
@property(nonatomic,strong) NSString *is_join;
@property(nonatomic,strong) NSString *minute_span;
@property(nonatomic,strong) NSString *being_datetime;
@property(nonatomic,strong) NSString *seconds;
//配额选择
@property(nonatomic,strong) NSArray *prizes;

@end

@interface HHQuatoModel : BaseModel
@property(nonatomic,strong) NSString *count;
@property(nonatomic,strong) NSNumber *is_enabled;

@end
