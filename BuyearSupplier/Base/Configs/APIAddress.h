//
//  APIAddress.h
//  ganguo
//
//  Created by ganguo on 13-7-8.
//  Copyright (c) 2013年 ganguo. All rights reserved.
//
//阿里云

//#define API_HOST @"http://buyear.elevo.cn"

#define API_HOST @"http://byh.elevo.cn"

//#define API_HOST @"http://app.buyear.com"

//#define API_HOST @"http://webtest.buyear.com"

//阿里云图片`
////公共设置
#define APP_key @"59334e721bcd31"
#define APP_scode @"15ca7554e8cb486f3b8cbe1fa166c75b"
#define API_IMAGE_HOST @"http://buyear.elevo.cn"

//MD5加密
#define API_APP_BASE_URL @""
#define API_BASE_URL [NSString stringWithFormat:@"%@", API_HOST]

//接口
#define API_SUB_URL(_url) [NSString stringWithFormat:@"%@/%@", API_BASE_URL, _url]
//图片
#define kAPIImageFromUrl(url) [[NSString stringWithFormat:@"%@/%@", API_IMAGE_HOST, url]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
//
typedef enum : NSUInteger {
    HHenter_home_Type,
    HHenter_category_Type,
    HHenter_itself_Type,    
} HHenter_Type;

//微信APPStore URL
#define KWX_APPStore_URL @"https://itunes.apple.com/cn/app/微信/id414478124?mt=8"
//#define KWX_APPStore_URL @"https://itunes.apple.com/cn/app/qq/id444934666?mt=8"

/**
 *  登录注册
 */
//1.1点击更换用户名
#define API_GetUserNo API_SUB_URL(@"CustomerApi/User/GetUserNo")
//1.3注册
#define API_Register API_SUB_URL(@"CustomerApi/User/Register")
//1.4登录
#define API_Login   API_SUB_URL(@"CustomerApi/User/Login")
//1.5获取图片验证码
#define API_Image_GetCode API_SUB_URL(@"Api/Image/GetCode")
//1.6发送短信验证码
#define API_Sms_SendCode API_SUB_URL(@"Api/Sms/SendCode")
//1.6通过用户帐号发送验证码
#define API_Sms_Send API_SUB_URL(@"Api/Sms/Send")
//1.6忘记密码，重置密码
#define API_ResetPassword API_SUB_URL(@"CustomerApi/User/ResetPassword")
//1.7出货方式
#define API_SelectChannel API_SUB_URL(@"CustomerApi/User/SelectChannel")

/**
 *  首页
 */
//2.1首页商品列表
#define API_GetHomeProductList  API_SUB_URL(@"ProductApi/ApiIndexProduct/GetCategoryProductList")
//2.2商品详情
#define API_GetProductDetail  API_SUB_URL(@"ProductApi/ApiProduct/GetProductDetail")
//2.3月成交记录
#define API_GetFinishLog  API_SUB_URL(@"ProductApi/ApiProduct/GetFinishLog")
//2.4轮播图
#define API_GetHomeImg  API_SUB_URL(@"Api/Image/GetHomeImg")
//2.5登录进体验店
#define API_LoginShop  API_SUB_URL(@"CustomerApi/User/LoginShop")
#define API_QuitShop  API_SUB_URL(@"CustomerApi/User/QuitShop")
//2.6APP是否强制更新
#define API_GetAPPIsMustUpdate  API_SUB_URL(@"CustomerApi/User/GetAPPIsMustUpdate")
//2.7获得配额秒杀活动信息
#define API_Seckill_GetActInfo  API_SUB_URL(@"ActivityApi/Seckill/GetActInfo")
//2.8获得配额选择信息
#define API_Seckill_Quatos  API_SUB_URL(@"ActivityApi/Seckill/GetPrize")
//2.9立即秒杀
#define API_Seckill_Join  API_SUB_URL(@"ActivityApi/Seckill/Join")


/**
 *  商品分类
 */
//3.1获取商品分类列表
#define API_GetCategoryList API_SUB_URL(@"ProductApi/ApiProductCategory/GetCategoryList")
//3.4获取商品分类列表(搜索)
#define API_Product_search API_SUB_URL(@"ProductApi/ApiProduct/Search")
//3.5获取单个商品
#define API_GetProductDetail API_SUB_URL(@"ProductApi/ApiProduct/GetProductDetail")
//3.6获取供应商列表
#define API_SearchSupplier API_SUB_URL(@"CustomerApi/Supplier/SearchSupplier")
/**
 *  购物车
 */
//3.1获取购物车中商品
#define API_GetProducts  API_SUB_URL(@"CustomerApi/ShopCart/GetProducts")
//3.2添加或减少购物车数量
#define API_AddQuantity API_SUB_URL(@"CustomerApi/ShopCart/AddQuantity")
//3.3加入购车商品
#define API_AddProducts API_SUB_URL(@"CustomerApi/ShopCart/AddProducts")
//3.3立即购买
#define API_GotoBuy API_SUB_URL(@"CustomerApi/ShopCart/GotoBuy")
//3.4删除购物车
#define API_ShopCart_Delete API_SUB_URL(@"CustomerApi/ShopCart/Delete")
//3.5获得结算订单
#define API_GetConfirmOrder API_SUB_URL(@"CustomerApi/ShopCart/GetConfirmOrder")
//3.6去支付订单，提交订单
#define API_CreateOrder API_SUB_URL(@"CustomerApi/ShopCart/CreateOrder")
//3.7热门搜索
#define API_GetHotSearch API_SUB_URL(@"ProductApi/ApiProductSearch/GetHotSearch")
//3.8用户历史搜索
#define API_GetUserSearch API_SUB_URL(@"ProductApi/ApiProductSearch/GetUserSearch")
//4.1清除历史搜索
#define API_ClearUserSearch API_SUB_URL(@"ProductApi/ApiProductSearch/ClearUserSearch")
//3.9用户输入抵扣的购物积分或提货积分，返回真实支付的金额
#define API_GetPayMoney API_SUB_URL(@"CustomerApi/ShopCart/GetPayMoney")
//4.0协议是否开放
#define API_GetIOSProtocolIsOpen API_SUB_URL(@"CustomerApi/User/GetIOSProtocolIsOpen")


/**
 *  我的
 */
//4.1获取用户详细
#define API_GetUserDetail API_SUB_URL(@"CustomerApi/User/GetUserDetail")
//4.2退出登录
#define API_Logout API_SUB_URL(@"CustomerApi/User/Logout")
//4.2获取订单的物流信息
#define API_GetOrderExpress API_SUB_URL(@"CustomerApi/Order/GetOrderExpress")
//4.3获取所有的快递公司
#define API_GetExpressCompany API_SUB_URL(@"CustomerApi/Order/GetExpressCompany")
//4.2修改登录密码
#define API_ModifyLoginPassword API_SUB_URL(@"CustomerApi/User/ModifyLoginPassword")
//4.3修改安全密码
#define API_ModifySecurityPassword API_SUB_URL(@"CustomerApi/User/ModifySecurityPassword")
//4.3签署协议
#define API_Signing API_SUB_URL(@"CustomerApi/Signing/Sign")
//4.4获取服务经理姓名
#define API_GetUserBySignNo API_SUB_URL(@"CustomerApi/User/GetUserBySignNo")
//4.5获取体验店名称
#define API_GetUserByShopNo API_SUB_URL(@"CustomerApi/User/GetUserByShopNo")
//4.4获取签约单列表
#define API_GetUserSign API_SUB_URL(@"CustomerApi/Signing/GetUserSign")
//4.5签约订单详细
#define API_GetSignDetail API_SUB_URL(@"CustomerApi/Signing/GetDetail")
//4.6签约单分享创业额
#define API_GetChildAchievement API_SUB_URL(@"CustomerApi/Signing/GetChildAchievement")
//4.7签约单团队列表
#define API_GetChildTeams API_SUB_URL(@"CustomerApi/Signing/GetChildTeams")
//4.8实名认证
#define API_Authentication API_SUB_URL(@"CustomerApi/User/Authentication")
//4.8特殊认证
#define API_SpecialAuthentication API_SUB_URL(@"CustomerApi/User/SpecialAuthentication")
//4.9转账记录
#define API_TransferList API_SUB_URL(@"CustomerApi/Trade/TransferList")
//4.10转账
#define API_Transfer API_SUB_URL(@"CustomerApi/Trade/Transfer")
//4.11消费分利,A奖，B奖 的资金日志
#define API_Reward_Bonus API_SUB_URL(@"CustomerApi/Reward/Bonus")
//4.12资金日志，分享推广奖
#define API_Reward_Share API_SUB_URL(@"CustomerApi/Reward/Share")
//4.13用户收货地址
#define API_GetAddressList API_SUB_URL(@"CustomerApi/User/GetAddressList")
//4.14删除收货地址
#define API_DeleteAddress API_SUB_URL(@"CustomerApi/User/DeleteAddress")
//4.15设置为默认收货地址
#define API_SetDefaultAddress API_SUB_URL(@"CustomerApi/User/SetDefaultAddress")
//4.16编辑收货地址
#define API_EditAddress API_SUB_URL(@"CustomerApi/User/EditAddress")
//4.17获取一个收货地址(获取默认收货地时，不传）
#define API_GetAddress API_SUB_URL(@"CustomerApi/User/GetAddress")
//4.18添加地址
#define API_AddAddress  API_SUB_URL(@"CustomerApi/User/AddAddress")
//4.19提现记录
#define API_WithdrawalsList  API_SUB_URL(@"CustomerApi/Trade/WithdrawalsList")
//4.20申请提现
#define API_Withdrawals  API_SUB_URL(@"CustomerApi/Trade/Withdrawals")
//4.20取消申请提现
#define API_WithdrawalsReject  API_SUB_URL(@"/AdminApi/Audit/WithdrawalsReject")
//4.21收款银行卡列表
#define API_BankList  API_SUB_URL(@"CustomerApi/Trade/BankList")
//4.22添加收银账户
#define API_AddBank  API_SUB_URL(@"CustomerApi/Trade/AddBank")
//4.23设置为默认收款账户
#define API_SetDefaultBank API_SUB_URL(@"CustomerApi/Trade/SetDefaultBank")
//4.24删除收款账户
#define API_DeleteBank API_SUB_URL(@"CustomerApi/Trade/DeleteBank")
//4.25获取一个收款地址
#define API_GetBankDetail API_SUB_URL(@"CustomerApi/Trade/GetBankDetail")
//4.26编辑收款帐户
#define API_EditBank API_SUB_URL(@"CustomerApi/Trade/EditBank")
//4.27店补
#define API_GetRewardList API_SUB_URL(@"ShopApi/Shop/GetRewardList")
//4.28获取积分变更记录，收会明细
#define API_GetIntegralChangeRecord API_SUB_URL(@"CustomerApi/User/GetIntegralChangeRecord")
//4.30充值记录
#define API_RechargeList API_SUB_URL(@"CustomerApi/Trade/RechargeList")
//4.30分配记录
#define API_GetSignedQuotaAssignList API_SUB_URL(@"ShopApi/Shop/GetSignedQuotaAssignList")
//4.31充值
#define API_Recharge API_SUB_URL(@"CustomerApi/Trade/Recharge")
//4.32获取所有体验店编号
#define API_GetShopIds  API_SUB_URL(@"ShopApi/shop/GetShopIds")
//4.33获一个体验店的配额
#define API_GetShopBorrowLimit API_SUB_URL(@"ShopApi/shop/GetShopBorrowLimit")
//4.33获取订单列表
#define API_GetOrderList API_SUB_URL(@"CustomerApi/Order/GetOrderList")
//4.33获取订单详情
#define API_GetOrderDetail API_SUB_URL(@"CustomerApi/Order/GetOrderDetail")
//4.34分配用户
#define API_AddBorrowLimit API_SUB_URL(@"ShopApi/shop/AddBorrowLimit")
//4.35兑换提货积分
#define API_ChangePickingIntegral API_SUB_URL(@"CustomerApi/User/ChangePickingIntegral")
//4.36上传图片数据流
#define API_UploadCertificate API_SUB_URL(@"Api/Image/UploadCertificate")
//4.36上传用户头像
#define API_UploadUserIcon API_SUB_URL(@"Api/Image/UploadUserIcon")
//4.36保存用户头像
#define API_SaveUserIcon API_SUB_URL(@"CustomerApi/User/SaveUserIcon")
//4.37取消订单
#define API_order_Close  API_SUB_URL(@"CustomerApi/Order/Close")
//4.38支付订单
#define API_PayOrder  API_SUB_URL(@"CustomerApi/Order/PayOrder")
//4.39确认收货
#define API_ConfirmOrder  API_SUB_URL(@"CustomerApi/Order/ConfirmOrder")
//4.40申请退款
#define API_ApplyRefund  API_SUB_URL(@"CustomerApi/Order/ApplyRefund")
//4.50获得可审核退款的商品
#define API_GetRefundProduct  API_SUB_URL(@"CustomerApi/Order/GetRefundProduct")
//4.51现金积分兑换记录
#define API_GetChangePickingIntegralList  API_SUB_URL(@"CustomerApi/User/GetChangePickingIntegralList")
//4.52提交退货快递物流单号
#define API_SubReturnGoodsExpress  API_SUB_URL(@"CustomerApi/Order/SubReturnGoodsExpress")
//省
#define API_GetProvinces API_SUB_URL(@"Api/District/GetProvinces")
//获取城市或地区
#define API_GetChilds API_SUB_URL(@"Api/District/GetChilds")
//获得配额数量
#define API_GetQuotaCount API_SUB_URL(@"CustomerApi/User/GetQuotaCount")
//获得体验店配额数
#define API_GetShopQuotaCount API_SUB_URL(@"ShopApi/Shop/GetQuotaCount")
//获得签约权
#define API_GetSignedQuota API_SUB_URL(@"ShopApi/Shop/GetSignedQuota")
//分配签约权
#define API_AssignQuota API_SUB_URL(@"ShopApi/Shop/AssignQuota")

/**
 *  支付
 */

//7.1微信支付
#define API_GET_PAY_CHARGE  API_SUB_URL(@"app/wxtopay/wxtopay_anon")

