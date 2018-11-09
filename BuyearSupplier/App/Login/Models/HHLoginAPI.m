//
//  HHLoginAPI.m
//  Store
//
//  Created by User on 2018/1/9.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHLoginAPI.h"

@implementation HHLoginAPI

#pragma mark - get
//点击更换用户名
+ (instancetype)getUserNo{
    
    HHLoginAPI *api = [self new];
    api.subUrl = API_GetUserNo;
    api.parametersAddToken = NO;
    
    return api;
}
//点击获取验证码
+ (instancetype)getSms_SendCodeWithmobile:(NSString *)mobile code:(NSString *)code{
    
    HHLoginAPI *api = [self new];
    api.subUrl = API_Sms_SendCode;
    if (mobile) {
        [api.parameters setObject:mobile forKey:@"mobile"];
    }
    if (code) {
        [api.parameters setObject:code forKey:@"code"];
    }
    api.parametersAddToken = NO;
    
    return api;
}
//点击获取验证码(修改密码)
+ (instancetype)getSms_SendCodeWithuserno:(NSString *)userno{
    
    HHLoginAPI *api = [self new];
    api.subUrl = API_Sms_Send;
    if (userno) {
        [api.parameters setObject:userno forKey:@"userno"];
    }
    api.parametersAddToken = NO;
    
    return api;
}
//点击获取图片验证码
+ (instancetype)getImage_CodeWithV:(NSString *)vStr{
    
    HHLoginAPI *api = [self new];
    api.subUrl = API_Image_GetCode;
    if (vStr) {
        [api.parameters setObject:vStr forKey:@"v"];
    }
    api.parametersAddToken = NO;
    
    return api;
}
//协议是否开放
+ (instancetype)GetIOSProtocolIsOpen{
    
    HHLoginAPI *api = [self new];
    api.subUrl = API_GetIOSProtocolIsOpen;
    api.parametersAddToken = NO;
    
    return api;
}

#pragma mark - post
//注册
+ (instancetype)postRegisterWithmobile:(NSString *)mobile fullname:(NSString *)fullname smscode:(NSString *)smscode login_pwd:(NSString *)login_pwd repeat_login_pwd:(NSString *)repeat_login_pwd security_pwd:(NSString *)security_pwd repeat_security_pwd:(NSString *)repeat_security_pwd referral_username:(NSString *)referral_username{
    
    HHLoginAPI *api = [self new];
    api.subUrl = API_Register;
    api.parametersAddToken = NO;
    if (mobile) {
        [api.parameters setObject:mobile forKey:@"mobile"];
    }
    if (fullname) {
        [api.parameters setObject:fullname forKey:@"fullname"];
    }
    if (smscode) {
        [api.parameters setObject:smscode forKey:@"smscode"];
    }
    if (login_pwd) {
        [api.parameters setObject:login_pwd forKey:@"login_pwd"];
    }
    if (repeat_login_pwd) {
        [api.parameters setObject:repeat_login_pwd forKey:@"repeat_login_pwd"];
    }
    if (security_pwd) {
        [api.parameters setObject:security_pwd forKey:@"security_pwd"];
    }
    if (repeat_security_pwd) {
        [api.parameters setObject:repeat_security_pwd forKey:@"repeat_security_pwd"];
    }
    if (referral_username) {
        [api.parameters setObject:referral_username forKey:@"referral_username"];
    }
        [api.parameters setObject:@"2" forKey:@"type"];
    
    return api;
    
}
//登录
+ (instancetype)postLoginWithlogin_name:(NSString *)login_name pwd:(NSString *)pwd{
    
    HHLoginAPI *api = [self new];
    api.subUrl = API_Login;
    if (login_name) {
        [api.parameters setObject:login_name forKey:@"login_name"];
    }
    if (pwd) {
        [api.parameters setObject:pwd forKey:@"pwd"];
    }
    [api.parameters setObject:@"2" forKey:@"type"];
    api.parametersAddToken = NO;
    
    return api;
    
}
//重置密码
+ (instancetype)postResetPasswordWithuserno:(NSString *)userno smscode:(NSString *)smscode newpwd:(NSString *)newpwd repeat_newpwd:(NSString *)repeat_newpwd{
    
    HHLoginAPI *api = [self new];
    api.subUrl = API_ResetPassword;
    if (userno) {
        [api.parameters setObject:userno forKey:@"userno"];
    }
    if (smscode) {
        [api.parameters setObject:smscode forKey:@"smscode"];
    }
    if (newpwd) {
        [api.parameters setObject:newpwd forKey:@"newpwd"];
    }
    if (repeat_newpwd) {
        [api.parameters setObject:repeat_newpwd forKey:@"repeat_newpwd"];
    }
    api.parametersAddToken = NO;
    
    return api;
    
}
//选择出货方式
+ (instancetype)postSelectChannelWithchannel:(NSString *)channel{
    
    HHLoginAPI *api = [self new];
    api.subUrl = API_SelectChannel;
    if (channel) {
        [api.parameters setObject:channel forKey:@"channel"];
    }
    api.parametersAddToken = NO;
    
    return api;
}
@end
