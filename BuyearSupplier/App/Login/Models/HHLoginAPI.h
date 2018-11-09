//
//  HHLoginAPI.h
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "BaseAPI.h"

@interface HHLoginAPI : BaseAPI

#pragma mark - get

//点击更换用户名
+ (instancetype)getUserNo;

//点击获取验证码
+ (instancetype)getSms_SendCodeWithmobile:(NSString *)mobile code:(NSString *)code;

//点击获取验证码(修改密码)
+ (instancetype)getSms_SendCodeWithuserno:(NSString *)userno;

//点击获取图片验证码
+ (instancetype)getImage_CodeWithV:(NSString *)vStr;

//协议是否开放
+ (instancetype)GetIOSProtocolIsOpen;

#pragma mark - post
//注册
+ (instancetype)postRegisterWithmobile:(NSString *)mobile fullname:(NSString *)fullname smscode:(NSString *)smscode login_pwd:(NSString *)login_pwd repeat_login_pwd:(NSString *)repeat_login_pwd security_pwd:(NSString *)security_pwd repeat_security_pwd:(NSString *)repeat_security_pwd referral_username:(NSString *)referral_username;
//登录
+ (instancetype)postLoginWithlogin_name:(NSString *)login_name pwd:(NSString *)pwd;
//重置密码
+ (instancetype)postResetPasswordWithuserno:(NSString *)userno smscode:(NSString *)smscode newpwd:(NSString *)newpwd repeat_newpwd:(NSString *)repeat_newpwd;


//选择出货方式
+ (instancetype)postSelectChannelWithchannel:(NSString *)channel;
@end
