//
//  HJUser.h
//  Bsh
//
//  Created by IMAC on 15/12/25.
//  Copyright (c) 2015年 lh. All rights reserved.
//

#import "BaseModel.h"
#import "LHMacro.h"

@interface HJLoginModel : BaseModel

@property(nonatomic,copy) NSString *state;
@property(nonatomic,copy) NSString *token;
@property(nonatomic,copy) NSString *users_id;
@property(nonatomic,copy) NSString *teacher_id;
@property(nonatomic,copy) NSString *logins_id;
@property(nonatomic,copy) NSString *phone;
@property(nonatomic,copy) NSString *password;


@end


@interface HJUser : BaseModel {
    
//    HJLoginModel *_userModel;
}
singleton_h(User)

@property (nonatomic, strong) HJLoginModel *pd;
@property(nonatomic,strong) NSString *token;
@property(nonatomic,strong) NSString *userName;

//体验店编号
@property(nonatomic,strong) NSString *shop_userid;
@property(nonatomic,strong) NSString *login_userid;
@property(nonatomic,strong) NSString *login_username;
@property(nonatomic,strong) NSString *is_login_shop;
@property(nonatomic,strong) NSString *ship_channel;

//角色
@property(nonatomic,strong) NSString *level;

//版本号
@property(nonatomic,strong) NSString *version_no;
@property(nonatomic,strong) NSString *version_Update;
@property(nonatomic,strong) NSIndexPath *category_selectIndexPath;
@property(nonatomic,assign) NSInteger store_selectIndex;
@property(nonatomic,assign) NSInteger is_currentPage;
//
@property(nonatomic,assign) BOOL is_pickageIntegral;
@property(nonatomic,assign) BOOL is_shopIntegral;

@end
