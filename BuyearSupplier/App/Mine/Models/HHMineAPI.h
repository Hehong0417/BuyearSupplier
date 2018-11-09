//
//  HHMineAPI.h
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseAPI.h"

@interface HHMineAPI : BaseAPI

#pragma mark - get

//获取用户详细
+ (instancetype)GetUserDetail;

//退出登录
+ (instancetype)UserLogout;

//获取签约单列表
+ (instancetype)GetUserSignListWithsignno:(NSString *)signno page:(NSNumber *)page;

//签约订单详细
+ (instancetype)GetUserSignDetailWithsignno:(NSString *)signno;

//签约单分享创业额
+ (instancetype)GetChildAchievementWithsignno:(NSString *)signno page:(NSNumber *)page;

//签约单团队列表
+ (instancetype)GetChildTeamsWithsignno:(NSString *)signno userid:(NSString *)userid page:(NSNumber *)page;

//获取服务经理姓名
+ (instancetype)GetUserBySignNoWithsignno:(NSString *)signno;
//获取体验店名称
+ (instancetype)GetUserByShopNoWithshopno:(NSString *)shopno;

//转账记录
+ (instancetype)getTransferListWithpage:(NSNumber *)page;

//充值记录
+ (instancetype)getRechargeListWithpage:(NSNumber *)page;

//分配记录
+ (instancetype)GetSignedQuotaAssignListWithpage:(NSNumber *)page userid:(NSString *)userid;

//消费分利,A奖，B奖 的资金日志
+ (instancetype)getReward_BonusWithtype:(NSNumber *)type page:(NSNumber *)page;

//资金日志，分享推广奖
+ (instancetype)getReward_ShareWithpage:(NSNumber *)page;

//现金积分兑换记录
+ (instancetype)getCashExchangeRecordPage:(NSNumber *)page;

//用户收货地址列表
+ (instancetype)GetAddressListWithpage:(NSNumber *)page;

//获取一个收货地址
+ (instancetype)GetAddressWithId:(NSString *)Id;

//提现记录
+ (instancetype)GetWithdrawalsListWithpage:(NSNumber *)page;

//收款银行卡列表
+ (instancetype)GetBankListWithpage:(NSNumber *)page;

//获取一个收款地址
+ (instancetype)GetBankDetailWithId:(NSString *)Id;

//店补
+ (instancetype)GetRewardListWithpage:(NSNumber *)page;

//获取积分变更记录，收会明细
+ (instancetype)GetIntegralChangeRecordWithpage:(NSNumber *)page type:(NSNumber *)type begin_date:(NSString *)begin_date end_date:(NSString *)end_date;

//体验店配额
+ (instancetype)GetShopBorrowLimitWithshopid:(NSString *)shopid;

//获取所有体验店编号
+ (instancetype)GetShopIds;

//获取订单列表
+ (instancetype)GetOrderListWithstatus:(NSNumber *)status page:(NSNumber *)page;

//获取订单详情
+ (instancetype)GetOrderDetailWithorderid:(NSString *)orderid;

//获取订单的物流信息
+ (instancetype)GetOrderExpressWithorderid:(NSString *)orderid  type:(NSNumber *)type;

//获得可审核退款的商品
+ (instancetype)GetRefundProductWithorderid:(NSString *)orderid;

//获取所有的快递公司
+ (instancetype)GetExpressCompany;

//获得配额数量
+ (instancetype)GetQuotaCount;

//签约权
+ (instancetype)GetSignedQuota;

#pragma mark - post

//修改登录密码
+ (instancetype)ModifyLoginPasswordWithold_pwd:(NSString *)old_pwd new_pwd:(NSString *)new_pwd repeat_new_pwd:(NSString *)repeat_new_pwd;

//修改安全密码
+ (instancetype)ModifySecurityPasswordWithold_pwd:(NSString *)old_pwd new_pwd:(NSString *)new_pwd repeat_new_pwd:(NSString *)repeat_new_pwd;

//签署协议
+ (instancetype)postSignWithtype:(NSString *)type parentId:(NSString *)parentId isBorrowIntegral:(NSString *)isBorrowIntegral shopsId:(NSString *)shopsId;

//实名认证
+ (instancetype)postAuthenticationWithusername:(NSString *)username idcard:(NSString *)idcard;

//特殊认证
+ (instancetype)postSpecialAuthenticationWithusername:(NSString *)username idcard:(NSString *)idcard front_img:(NSString *)front_img back_img:(NSString *)back_img;

//账户充值
+ (instancetype)postRechargeWithmenoy:(NSString *)menoy remark:(NSString *)remark password:(NSString *)password;

//转账
+ (instancetype)postTransferWithmoney:(NSString *)money userid:(NSString *)userid username:(NSString *)username password:(NSString *)password remark:(NSString *)remark;

//删除收货地址
+ (instancetype)postDeleteAddressWithId:(NSString *)Id;

//设置为默认收货地址
+ (instancetype)postSetDefaultAddressWithId:(NSString *)Id;

//编辑收货地址
+ (instancetype)postEditAddressWithId:(NSString *)Id district_id:(NSString *)district_id address:(NSString *)address username:(NSString *)username mobile:(NSString *)mobile is_default:(NSString *)is_default;

//添加地址
+ (instancetype)postAddAddressWithdistrict_id:(NSString *)district_id address:(NSString *)address username:(NSString *)username mobile:(NSString *)mobile is_default:(NSString *)is_default;

//申请提现
+ (instancetype)postWithdrawalsWithmoney:(NSString *)money password:(NSString *)password bank_id:(NSString *)bank_id;
//取消申请提现
+ (instancetype)postCancelWithdrawalsWithIds:(NSArray *)ids;

//添加收银账户
+ (instancetype)postAddBankWithbank_name:(NSString *)bank_name bank_no:(NSString *)bank_no bank_id:(NSString *)bank_id is_default:(NSString *)is_default username:(NSString *)username Id:(NSString *)Id remarks:(NSString *)remarks;

//设置为默认收款账户
+ (instancetype)postSetDefaultBankWithId:(NSString *)Id;

//删除收款账户
+ (instancetype)postDeleteBankWithId:(NSString *)Id;

//编辑收款帐户
+ (instancetype)postEditBankWithbank_name:(NSString *)bank_name bank_no:(NSString *)bank_no is_default:(NSString *)is_default username:(NSString *)username Id:(NSString *)Id remarks:(NSString *)remarks;

//分配用户
+ (instancetype)postAddBorrowLimitWithshopid:(NSString *)shopid userid:(NSString *)userid count:(NSString *)count remark:(NSString *)remark;

//分配签约权
+ (instancetype)postAssignQuotaWithuserid:(NSString *)userid value:(NSString *)value remark:(NSString *)remark  username:(NSString *)username;

//积分兑换
+ (instancetype)postChangePickingIntegralWithmoney_integral:(NSString *)money_integral shopid:(NSString *)shopid security_pwd:(NSString *)security_pwd remark:(NSString *)remark;

//上传文件流
+ (instancetype)UploadCertificateWithImageData:(NSData *)imageData;

//上传用户头像
+ (instancetype)UploadUserIconWithImageData:(NSData *)imageData;
//保存用户头像
+ (instancetype)SaveUserIconWithfilename:(NSString *)filename;

//取消订单
+ (instancetype)postOrder_CloseWithorderid:(NSString *)orderid;
//支付订单
+ (instancetype)postPayOrderWithorderid:(NSString *)orderid;
//确认收货
+ (instancetype)postConfirmOrderWithorderid:(NSString *)orderid;
//申请退款
+ (instancetype)postApplyRefundWithqu:(NSString *)qu message:(NSString *)message;
//提交退货快递物流单号
+ (instancetype)postSubReturnGoodsExpressWithorderid:(NSString *)orderid exp_code:(NSString *)exp_code exp_order:(NSString *)exp_order;


@end
