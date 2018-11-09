//
//  HHMineModel.h
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseModel.h"

@interface HHMineModel : BaseModel

//用户详细
@property(nonatomic,strong) NSString *money_integral;
@property(nonatomic,strong) NSString *shopping_integral;
@property(nonatomic,strong) NSString *s_integral;
@property(nonatomic,strong) NSString *picking_integral;
@property(nonatomic,strong) NSString *username;
@property(nonatomic,strong) NSString *userid;
@property(nonatomic,strong) NSString *usericon;
@property(nonatomic,strong) NSString *email;
@property(nonatomic,strong) NSString *idcard;
@property(nonatomic,strong) NSString *parent_userid;
@property(nonatomic,strong) NSString *parent_username;
@property(nonatomic,strong) NSString *Id;
@property(nonatomic,strong) NSString *level;
@property(nonatomic,strong) NSString  *qrcode_url;
@property(nonatomic,strong) NSString  *options;

@property(nonatomic,strong) NSString  *is_login_shop;
@property(nonatomic,strong) NSString  *login_username;
@property(nonatomic,strong) NSString  *login_userid;
@property(nonatomic,strong) NSString  *loginShopId;
@property(nonatomic,strong) NSString  *ticke;
@property(nonatomic,strong) NSString  *ship_channel;
@property(nonatomic,strong) NSString  *referrer_count;
@property(nonatomic,strong) NSString  *buy_group_pro_count;
@property(nonatomic,strong) NSString  *sign_shopname;
@property(nonatomic,strong) NSString  *sign_shopid;
@property(nonatomic,strong) NSString  *is_entity_shop;


//实名认证 0未认证  1待审核  2已认证
@property(nonatomic,strong) NSString  *status;

//签约单列表
@property(nonatomic,strong) NSString *sign_no;
@property(nonatomic,strong) NSString *display_no;
@property(nonatomic,strong) NSString *sign_type;
@property(nonatomic,strong) NSString *sign_level;
@property(nonatomic,strong) NSString *datetime;
@property(nonatomic,strong) NSString *sign_level_tag;
@property(nonatomic,strong) NSString *grant_a_profit;

//签约单详细
@property(nonatomic,strong) NSString *parent_name;
@property(nonatomic,strong) NSString *grant_signprofit;
@property(nonatomic,strong) NSString *grant_b_profit;
@property(nonatomic,strong) NSNumber *is_borrow;
@property(nonatomic,strong) NSString *signid;


//签约单列表
@property(nonatomic,strong) NSString *parent_shopno;
@property(nonatomic,strong) NSString *reward_ach_total;
@property(nonatomic,strong) NSString *ach_total;
@property(nonatomic,strong) NSString *shopno;



//签约单分享创业额
@property(nonatomic,strong) NSString *integral;
@property(nonatomic,strong) NSString *achievement_total;

//转账记录
@property(nonatomic,strong) NSString *info;
@property(nonatomic,strong) NSString *money;
@property(nonatomic,strong) NSString *type;
@property(nonatomic,strong) NSString *remark;
//@property(nonatomic,strong) NSString *status;
@property(nonatomic,strong) NSString *real_money;
@property(nonatomic,strong) NSString *bank_cardno;
@property(nonatomic,strong) NSString *apply_money;
@property(nonatomic,strong) NSNumber *status_code;

//签约单团队列表
@property(nonatomic,strong) NSString *mobile;

//分享推广奖
@property(nonatomic,strong) NSString *from_userid;
@property(nonatomic,strong) NSString *from_username;
@property(nonatomic,strong) NSString *orderid;
@property(nonatomic,strong) NSString *createdate;
@property(nonatomic,strong) NSString *platform_integral;
@property(nonatomic,strong) NSString *share_reward;

//现金积分兑换记录
@property(nonatomic,strong) NSString *shop_username;

//消费分利,A奖，B奖
@property(nonatomic,strong) NSString *periods;
@property(nonatomic,strong) NSString *blend_integral;
@property(nonatomic,strong) NSString *bonus_total;
@property(nonatomic,strong) NSString *sign_name;

//收货地址
@property(nonatomic,strong) NSString *address;
@property(nonatomic,strong) NSString *full_address;
@property(nonatomic,strong) NSString *is_default;
@property(nonatomic,strong) NSString *province;
@property(nonatomic,strong) NSString *city;
@property(nonatomic,strong) NSString *region;
@property(nonatomic,strong) NSString *province_id;
@property(nonatomic,strong) NSString *city_id;
@property(nonatomic,strong) NSString *region_id;

//收款银行卡列表
@property(nonatomic,strong) NSString *bank_name;
@property(nonatomic,strong) NSString *bank_no;

//店补
@property(nonatomic,strong) NSString *reward_total;

//我的钱包
@property(nonatomic,strong) NSString *action_name;
@property(nonatomic,strong) NSString *action_type;
@property(nonatomic,strong) NSString *integral_type;
@property(nonatomic,strong) NSString *number;

//体验店配额
@property(nonatomic,strong) NSString *shopid;
@property(nonatomic,strong) NSString *end_datetime;
@property(nonatomic,strong) NSString *used_total;

@property(nonatomic,strong) NSString *total;
@property(nonatomic,strong) NSString *real_newuser_count;
@property(nonatomic,strong) NSString *used_newuser_count;
@property(nonatomic,strong) NSString *used_seckill_count;
@property(nonatomic,strong) NSString *surplus_total;

//签约权
@property(nonatomic,strong) NSString *usable_quota;
@property(nonatomic,strong) NSString *assign_quota;
@property(nonatomic,strong) NSString *from_assign_quota;
@property(nonatomic,strong) NSString *recharge_quota;
@property(nonatomic,strong) NSString *signed_use_quota;

//签约权分配记录
@property(nonatomic,strong) NSString *value;
@property(nonatomic,strong) NSString *remarks;


@property(nonatomic,strong) NSString *is_certified;

//物流信息
@property(nonatomic,strong) NSString *express_name;
@property(nonatomic,strong) NSString *express_order;
@property(nonatomic,strong) NSArray *express_message_list;

//快递公司
@property(nonatomic,strong) NSString *code;
@property(nonatomic,strong) NSString *name;

//配额数量
@property(nonatomic,strong) NSString *newuser_count;
@property(nonatomic,strong) NSString *seckill_count;

@end
@interface HHExpress_message_list : BaseModel
@property(nonatomic,strong) NSString *express_full_date;
@property(nonatomic,strong) NSString *express_date;
@property(nonatomic,strong) NSString *express_time;
@property(nonatomic,strong) NSString *express_message;

@end

