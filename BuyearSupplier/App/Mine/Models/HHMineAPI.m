//
//  HHMineAPI.m
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHMineAPI.h"

@implementation HHMineAPI

#pragma mark - get

//获取用户详细
+ (instancetype)GetUserDetail{
    HHMineAPI *api = [self new];
    api.subUrl = API_GetUserDetail;
    api.parametersAddToken = NO;
    return api;
}
//获取签约单列表
+ (instancetype)GetUserSignListWithsignno:(NSString *)signno page:(NSNumber *)page{
    HHMineAPI *api = [self new];
    api.subUrl = API_GetUserSign;
    if (signno) {
        [api.parameters setObject:signno forKey:@"signno"];
    }
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    api.parametersAddToken = NO;
    return api;
}

//签约订单详细
+ (instancetype)GetUserSignDetailWithsignno:(NSString *)signno{
    HHMineAPI *api = [self new];
    api.subUrl = API_GetSignDetail;
    if (signno) {
        [api.parameters setObject:signno forKey:@"signno"];
    }
    api.parametersAddToken = NO;
    return api;
}

//签约单分享创业额
+ (instancetype)GetChildAchievementWithsignno:(NSString *)signno page:(NSNumber *)page{
    HHMineAPI *api = [self new];
    api.subUrl = API_GetChildAchievement;
    if (signno) {
        [api.parameters setObject:signno forKey:@"signno"];
    }
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    api.parametersAddToken = NO;
    return api;
}

//签约单团队列表
+ (instancetype)GetChildTeamsWithsignno:(NSString *)signno userid:(NSString *)userid page:(NSNumber *)page{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_GetChildTeams;
    if (signno) {
        [api.parameters setObject:signno forKey:@"signno"];
    }
    if (userid) {
        [api.parameters setObject:userid forKey:@"userid"];
    }
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    api.parametersAddToken = NO;
    return api;
    
}

//转账记录
+ (instancetype)getTransferListWithpage:(NSNumber *)page{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_TransferList;
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    api.parametersAddToken = NO;
    return api;
}
//充值记录
+ (instancetype)getRechargeListWithpage:(NSNumber *)page{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_RechargeList;
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    api.parametersAddToken = NO;
    return api;
    
}
//分配记录
+ (instancetype)GetSignedQuotaAssignListWithpage:(NSNumber *)page userid:(NSString *)userid{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_GetSignedQuotaAssignList;
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    if (userid) {
        [api.parameters setObject:userid forKey:@"userid"];
    }
    api.parametersAddToken = NO;
    return api;
    
}
//消费分利,A奖，B奖 的资金日志
+ (instancetype)getReward_BonusWithtype:(NSNumber *)type page:(NSNumber *)page{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_Reward_Bonus;
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    if (type) {
        [api.parameters setObject:type forKey:@"type"];
    }
    api.parametersAddToken = NO;
    return api;
}
//现金积分兑换记录
+ (instancetype)getCashExchangeRecordPage:(NSNumber *)page{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_GetChangePickingIntegralList;
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    
    api.parametersAddToken = NO;
    return api;
}
//资金日志，分享推广奖
+ (instancetype)getReward_ShareWithpage:(NSNumber *)page{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_Reward_Share;
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    api.parametersAddToken = NO;
    return api;
    
}

//用户收货地址列表
+ (instancetype)GetAddressListWithpage:(NSNumber *)page{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_GetAddressList;
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    api.parametersAddToken = NO;
    return api;
}

//获取一个收货地址
+ (instancetype)GetAddressWithId:(NSString *)Id{
    HHMineAPI *api = [self new];
    api.subUrl = API_GetAddress;
    if (Id) {
        [api.parameters setObject:Id forKey:@"id"];
    }
    api.parametersAddToken = NO;
    return api;
}

//提现记录
+ (instancetype)GetWithdrawalsListWithpage:(NSNumber *)page{
    HHMineAPI *api = [self new];
    api.subUrl = API_WithdrawalsList;
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    api.parametersAddToken = NO;
    return api;
}

//收款银行卡列表
+ (instancetype)GetBankListWithpage:(NSNumber *)page{
    HHMineAPI *api = [self new];
    api.subUrl = API_BankList;
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    api.parametersAddToken = NO;
    return api;
}

//获取一个收款地址
+ (instancetype)GetBankDetailWithId:(NSString *)Id{
    HHMineAPI *api = [self new];
    api.subUrl = API_GetBankDetail;
    if (Id) {
        [api.parameters setObject:Id forKey:@"id"];
    }
    api.parametersAddToken = NO;
    return api;
}

//店补
+ (instancetype)GetRewardListWithpage:(NSNumber *)page{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_GetRewardList;
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    api.parametersAddToken = NO;
    return api;
    
}

//获取积分变更记录，收会明细
+ (instancetype)GetIntegralChangeRecordWithpage:(NSNumber *)page type:(NSNumber *)type begin_date:(NSString *)begin_date end_date:(NSString *)end_date{
    HHMineAPI *api = [self new];
    api.subUrl = API_GetIntegralChangeRecord;
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    if (type) {
        [api.parameters setObject:type forKey:@"type"];
    }
    if (begin_date) {
        [api.parameters setObject:begin_date forKey:@"begin_date"];
    }
    if (end_date) {
        [api.parameters setObject:end_date forKey:@"end_date"];
    }
    api.parametersAddToken = NO;
    return api;
}
//体验店配额
+ (instancetype)GetShopBorrowLimitWithshopid:(NSString *)shopid{
    HHMineAPI *api = [self new];
    api.subUrl = API_GetShopQuotaCount;
    api.parametersAddToken = NO;
    return api;
}
//签约权
+ (instancetype)GetSignedQuota{
    HHMineAPI *api = [self new];
    api.subUrl = API_GetSignedQuota;
    api.parametersAddToken = NO;
    return api;
}

//获取所有体验店编号
+ (instancetype)GetShopIds{
    HHMineAPI *api = [self new];
    api.subUrl = API_GetShopIds;
    api.parametersAddToken = NO;
    return api;
    
}
//获取订单列表
+ (instancetype)GetOrderListWithstatus:(NSNumber *)status page:(NSNumber *)page{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_GetOrderList;
    if (status) {
        [api.parameters setObject:status forKey:@"status"];
    }
    if (page) {
        [api.parameters setObject:page forKey:@"page"];
    }
    api.parametersAddToken = NO;
    return api;
}
//获取订单详情
+ (instancetype)GetOrderDetailWithorderid:(NSString *)orderid{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_GetOrderDetail;
    if (orderid) {
        [api.parameters setObject:orderid forKey:@"orderid"];
    }
    api.parametersAddToken = NO;
    return api;
    
}
//退出登录
+ (instancetype)UserLogout{
    HHMineAPI *api = [self new];
    api.subUrl = API_Logout;
    api.parametersAddToken = NO;
    return api;
}
//获取订单的物流信息
+ (instancetype)GetOrderExpressWithorderid:(NSString *)orderid type:(NSNumber *)type{
    HHMineAPI *api = [self new];
    api.subUrl = API_GetOrderExpress;
    if (orderid) {
        [api.parameters setObject:orderid forKey:@"orderid"];
    }
    if (type) {
        [api.parameters setObject:type forKey:@"type"];
    }
    api.parametersAddToken = NO;
    return api;
}
//获取所有的快递公司
+ (instancetype)GetExpressCompany{
    HHMineAPI *api = [self new];
    api.subUrl = API_GetExpressCompany;
    api.parametersAddToken = NO;
    return api;

}
//获得配额数量
+ (instancetype)GetQuotaCount{
    HHMineAPI *api = [self new];
    api.subUrl = API_GetQuotaCount;
    api.parametersAddToken = NO;
    return api;
}

//获得可审核退款的商品
+ (instancetype)GetRefundProductWithorderid:(NSString *)orderid{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_GetRefundProduct;
    if (orderid) {
        [api.parameters setObject:orderid forKey:@"orderid"];
    }
  
    api.parametersAddToken = NO;
    return api;
    
}
//获取服务经理姓名
+ (instancetype)GetUserBySignNoWithsignno:(NSString *)signno{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_GetUserBySignNo;
    if (signno) {
        [api.parameters setObject:signno forKey:@"signno"];
    }
    
    api.parametersAddToken = NO;
    return api;
    
}

//获取体验店名称
+ (instancetype)GetUserByShopNoWithshopno:(NSString *)shopno{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_GetUserByShopNo;
    if (shopno) {
        [api.parameters setObject:shopno forKey:@"shopno"];
    }
    
    api.parametersAddToken = NO;
    return api;
    
}
#pragma mark - post

//修改登录密码
+ (instancetype)ModifyLoginPasswordWithold_pwd:(NSString *)old_pwd new_pwd:(NSString *)new_pwd repeat_new_pwd:(NSString *)repeat_new_pwd{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_ModifyLoginPassword;
    if (old_pwd) {
        [api.parameters setObject:old_pwd forKey:@"old_pwd"];
    }
    if (new_pwd) {
        [api.parameters setObject:new_pwd forKey:@"new_pwd"];
    }
    if (repeat_new_pwd) {
        [api.parameters setObject:repeat_new_pwd forKey:@"repeat_new_pwd"];
    }
    api.parametersAddToken = NO;
    return api;
    
}
//修改安全密码
+ (instancetype)ModifySecurityPasswordWithold_pwd:(NSString *)old_pwd new_pwd:(NSString *)new_pwd repeat_new_pwd:(NSString *)repeat_new_pwd{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_ModifySecurityPassword;
    if (old_pwd) {
        [api.parameters setObject:old_pwd forKey:@"old_pwd"];
    }
    if (new_pwd) {
        [api.parameters setObject:new_pwd forKey:@"new_pwd"];
    }
    if (repeat_new_pwd) {
        [api.parameters setObject:repeat_new_pwd forKey:@"repeat_new_pwd"];
    }
    api.parametersAddToken = NO;
    return api;
    
    
}
//签署协议
+ (instancetype)postSignWithtype:(NSString *)type parentId:(NSString *)parentId isBorrowIntegral:(NSString *)isBorrowIntegral shopsId:(NSString *)shopsId{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_Signing;
    if (type) {
        [api.parameters setObject:type forKey:@"type"];
    }
    if (parentId) {
        [api.parameters setObject:parentId forKey:@"parentId"];
    }
    if (isBorrowIntegral) {
        [api.parameters setObject:isBorrowIntegral forKey:@"isBorrowIntegral"];
    }
    if (shopsId) {
        [api.parameters setObject:shopsId forKey:@"shopsId"];
    }
    api.parametersAddToken = NO;
    return api;
}

//实名认证
+ (instancetype)postAuthenticationWithusername:(NSString *)username idcard:(NSString *)idcard{
    HHMineAPI *api = [self new];
    api.subUrl = API_Authentication;
    if (username) {
        [api.parameters setObject:username forKey:@"username"];
    }
    if (idcard) {
        [api.parameters setObject:idcard forKey:@"idcard"];
    }
    api.parametersAddToken = NO;
    return api;
}
//特殊认证
+ (instancetype)postSpecialAuthenticationWithusername:(NSString *)username idcard:(NSString *)idcard front_img:(NSString *)front_img back_img:(NSString *)back_img{
    HHMineAPI *api = [self new];
    api.subUrl = API_SpecialAuthentication;
    if (username) {
        [api.parameters setObject:username forKey:@"username"];
    }
    if (idcard) {
        [api.parameters setObject:idcard forKey:@"idcard"];
    }
    if (front_img) {
        [api.parameters setObject:front_img forKey:@"front_img"];
    }
    if (back_img) {
        [api.parameters setObject:back_img forKey:@"back_img"];
    }
    api.parametersAddToken = NO;
    return api;
}
+ (instancetype)postRechargeWithmenoy:(NSString *)menoy remark:(NSString *)remark password:(NSString *)password{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_Recharge;
    if (menoy) {
        [api.parameters setObject:menoy forKey:@"menoy"];
    }
    if (remark) {
        [api.parameters setObject:remark forKey:@"remark"];
    }
    if (password) {
        [api.parameters setObject:password forKey:@"password"];
    }
    api.parametersAddToken = NO;
    return api;
}
//转账
+ (instancetype)postTransferWithmoney:(NSString *)money userid:(NSString *)userid username:(NSString *)username password:(NSString *)password remark:(NSString *)remark{
    HHMineAPI *api = [self new];
    api.subUrl = API_Transfer;
    if (money) {
        [api.parameters setObject:money forKey:@"money"];
    }
    if (userid) {
        [api.parameters setObject:userid forKey:@"userid"];
    }
    if (username) {
        [api.parameters setObject:username forKey:@"username"];
    }
    if (password) {
        [api.parameters setObject:password forKey:@"password"];
    }
    if (remark) {
        [api.parameters setObject:remark forKey:@"remark"];
    }
    api.parametersAddToken = NO;
    return api;
    
}
//删除收货地址
+ (instancetype)postDeleteAddressWithId:(NSString *)Id{
    HHMineAPI *api = [self new];
    api.subUrl = API_DeleteAddress;
    if (Id) {
        [api.parameters setObject:Id forKey:@"Id"];
    }
   
    api.parametersAddToken = NO;
    return api;
}

//设置为默认收货地址
+ (instancetype)postSetDefaultAddressWithId:(NSString *)Id{
    HHMineAPI *api = [self new];
    api.subUrl = API_SetDefaultAddress;
    if (Id) {
        [api.parameters setObject:Id forKey:@"Id"];
    }
    
    api.parametersAddToken = NO;
    return api;
}

//编辑收货地址
+ (instancetype)postEditAddressWithId:(NSString *)Id district_id:(NSString *)district_id address:(NSString *)address username:(NSString *)username mobile:(NSString *)mobile is_default:(NSString *)is_default{
    HHMineAPI *api = [self new];
    api.subUrl = API_EditAddress;
    if (Id) {
        [api.parameters setObject:Id forKey:@"Id"];
    }
    if (district_id) {
        [api.parameters setObject:district_id forKey:@"district_id"];
    }
    if (address) {
        [api.parameters setObject:address forKey:@"address"];
    }
    if (username) {
        [api.parameters setObject:username forKey:@"username"];
    }
    if (mobile) {
        [api.parameters setObject:mobile forKey:@"mobile"];
    }
    if (is_default) {
        [api.parameters setObject:is_default forKey:@"is_default"];
    }
    api.parametersAddToken = NO;
    return api;
}

//添加地址
+ (instancetype)postAddAddressWithdistrict_id:(NSString *)district_id address:(NSString *)address username:(NSString *)username mobile:(NSString *)mobile is_default:(NSString *)is_default{
    HHMineAPI *api = [self new];
    api.subUrl = API_AddAddress;
    if (district_id) {
        [api.parameters setObject:district_id forKey:@"district_id"];
    }
    if (address) {
        [api.parameters setObject:address forKey:@"address"];
    }
    if (username) {
        [api.parameters setObject:username forKey:@"username"];
    }
    if (mobile) {
        [api.parameters setObject:mobile forKey:@"mobile"];
    }
    if (is_default) {
        [api.parameters setObject:is_default forKey:@"is_default"];
    }
    api.parametersAddToken = NO;
    return api;
    
}

//申请提现
+ (instancetype)postWithdrawalsWithmoney:(NSString *)money password:(NSString *)password bank_id:(NSString *)bank_id{
    HHMineAPI *api = [self new];
    api.subUrl = API_Withdrawals;
    if (money) {
        [api.parameters setObject:money forKey:@"money"];
    }
    if (password) {
        [api.parameters setObject:password forKey:@"password"];
    }
    if (bank_id) {
        [api.parameters setObject:bank_id forKey:@"bank_id"];
    }
    api.parametersAddToken = NO;
    return api;
}
//取消申请提现
+ (instancetype)postCancelWithdrawalsWithIds:(NSArray *)ids{
    HHMineAPI *api = [self new];
    api.subUrl = API_WithdrawalsReject;
    if (ids) {
        [api.parameters setObject:ids forKey:@"ids"];
    }
    api.parametersAddToken = NO;
    return api;
}
//添加收银账户
+ (instancetype)postAddBankWithbank_name:(NSString *)bank_name bank_no:(NSString *)bank_no bank_id:(NSString *)bank_id is_default:(NSString *)is_default username:(NSString *)username Id:(NSString *)Id remarks:(NSString *)remarks{
    HHMineAPI *api = [self new];
    api.subUrl = API_AddBank;
    if (bank_name) {
        [api.parameters setObject:bank_name forKey:@"bank_name"];
    }
    if (bank_no) {
        [api.parameters setObject:bank_no forKey:@"bank_no"];
    }
    
    if (is_default) {
        [api.parameters setObject:is_default forKey:@"is_default"];
    }
    if (username) {
        [api.parameters setObject:username forKey:@"username"];
    }
    if (remarks) {
        [api.parameters setObject:remarks forKey:@"remarks"];
    }
    api.parametersAddToken = NO;
    return api;
}

//设置为默认收款账户
+ (instancetype)postSetDefaultBankWithId:(NSString *)Id{
    HHMineAPI *api = [self new];
    api.subUrl = API_SetDefaultBank;
    if (Id) {
        [api.parameters setObject:Id forKey:@"Id"];
    }
    api.parametersAddToken = NO;
    return api;
}

//删除收款账户
+ (instancetype)postDeleteBankWithId:(NSString *)Id{
    HHMineAPI *api = [self new];
    api.subUrl = API_DeleteBank;
    if (Id) {
        [api.parameters setObject:Id forKey:@"Id"];
    }
    api.parametersAddToken = NO;
    return api;
}

//编辑收款帐户
+ (instancetype)postEditBankWithbank_name:(NSString *)bank_name bank_no:(NSString *)bank_no is_default:(NSString *)is_default username:(NSString *)username Id:(NSString *)Id remarks:(NSString *)remarks {
    HHMineAPI *api = [self new];
    api.subUrl = API_EditBank;
    if (bank_name) {
        [api.parameters setObject:bank_name forKey:@"bank_name"];
    }
    if (bank_no) {
        [api.parameters setObject:bank_no forKey:@"bank_no"];
    }
    if (is_default) {
        [api.parameters setObject:is_default forKey:@"is_default"];
    }
    if (remarks) {
        [api.parameters setObject:remarks forKey:@"remarks"];
    }
    if (Id) {
        [api.parameters setObject:Id forKey:@"id"];
    }
    if (username) {
        [api.parameters setObject:username forKey:@"username"];
    }
    api.parametersAddToken = NO;
    return api;
}
//分配用户
+ (instancetype)postAddBorrowLimitWithshopid:(NSString *)shopid userid:(NSString *)userid count:(NSString *)count remark:(NSString *)remark{
    HHMineAPI *api = [self new];
    api.subUrl = API_AddBorrowLimit;
    if (shopid) {
        [api.parameters setObject:shopid forKey:@"shopid"];
    }
    if (userid) {
        [api.parameters setObject:userid forKey:@"userid"];
    }
    if (count) {
        [api.parameters setObject:count forKey:@"count"];
    }
    if (remark) {
        [api.parameters setObject:remark forKey:@"remark"];
    }

    api.parametersAddToken = NO;
    return api;
}
//分配签约权
+ (instancetype)postAssignQuotaWithuserid:(NSString *)userid value:(NSString *)value remark:(NSString *)remark username:(NSString *)username{
    HHMineAPI *api = [self new];
    api.subUrl = API_AssignQuota;
    if (userid) {
        [api.parameters setObject:userid forKey:@"userid"];
    }
    if (value) {
        [api.parameters setObject:value forKey:@"value"];
    }
    if (remark) {
        [api.parameters setObject:remark forKey:@"remark"];
    }
    if (username) {
        [api.parameters setObject:username forKey:@"username"];
    }
    api.parametersAddToken = NO;
    return api;
}
//积分兑换
+ (instancetype)postChangePickingIntegralWithmoney_integral:(NSString *)money_integral shopid:(NSString *)shopid security_pwd:(NSString *)security_pwd remark:(NSString *)remark{
    HHMineAPI *api = [self new];
    api.subUrl = API_ChangePickingIntegral;
    if (money_integral) {
        [api.parameters setObject:money_integral forKey:@"money_integral"];
    }
    if (shopid) {
        [api.parameters setObject:shopid forKey:@"shopid"];
    }
    if (security_pwd) {
        [api.parameters setObject:security_pwd forKey:@"security_pwd"];
    }
    if (remark) {
        [api.parameters setObject:remark forKey:@"remark"];
    }
    
    api.parametersAddToken = NO;
    return api;
    
    
}
//上传图片
+ (instancetype)UploadCertificateWithImageData:(NSData *)imageData;{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_UploadCertificate;
    if (imageData) {
        NetworkClientFile *file = [NetworkClientFile imageFileWithFileData:imageData name:@"file"];
        
        api.uploadFile = @[file];
    }
   
    api.parametersAddToken = NO;
    return api;
    
}
//上传用户头像
+ (instancetype)UploadUserIconWithImageData:(NSData *)imageData{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_UploadUserIcon;
    if (imageData) {
        NetworkClientFile *file = [NetworkClientFile imageFileWithFileData:imageData name:@"file"];
        
        api.uploadFile = @[file];
    }
    
    api.parametersAddToken = NO;
    return api;
    
}

//保存用户头像
+ (instancetype)SaveUserIconWithfilename:(NSString *)filename{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_SaveUserIcon;
    if (filename) {
        [api.parameters setObject:filename forKey:@"filename"];
    }
    api.parametersAddToken = NO;
    return api;
    
}
//取消订单
+ (instancetype)postOrder_CloseWithorderid:(NSString *)orderid{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_order_Close;
    if (orderid) {
        [api.parameters setObject:orderid forKey:@"orderid"];
    }
    api.parametersAddToken = NO;
    return api;

}

//支付订单
+ (instancetype)postPayOrderWithorderid:(NSString *)orderid{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_PayOrder;
    if (orderid) {
        [api.parameters setObject:orderid forKey:@"orderid"];
    }
    api.parametersAddToken = NO;
    return api;
}

//确认收货
+ (instancetype)postConfirmOrderWithorderid:(NSString *)orderid{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_ConfirmOrder;
    if (orderid) {
        [api.parameters setObject:orderid forKey:@"orderid"];
    }
    api.parametersAddToken = NO;
    return api;
    
}
//申请退款
+ (instancetype)postApplyRefundWithqu:(NSString *)qu message:(NSString *)message{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_ApplyRefund;
    if (qu) {
        [api.parameters setObject:qu forKey:@"qu"];
    }
    if (message) {
        [api.parameters setObject:message forKey:@"message"];
    }
    api.parametersAddToken = NO;
    return api;
    
}
//提交退货快递物流单号
+ (instancetype)postSubReturnGoodsExpressWithorderid:(NSString *)orderid exp_code:(NSString *)exp_code exp_order:(NSString *)exp_order{
    
    HHMineAPI *api = [self new];
    api.subUrl = API_SubReturnGoodsExpress;
    if (orderid) {
        [api.parameters setObject:orderid forKey:@"orderid"];
    }
    if (exp_code) {
        [api.parameters setObject:exp_code forKey:@"exp_code"];
    }
    if (exp_order) {
        [api.parameters setObject:exp_order forKey:@"exp_order"];
    }
    api.parametersAddToken = NO;
    return api;
    
    
}
@end
