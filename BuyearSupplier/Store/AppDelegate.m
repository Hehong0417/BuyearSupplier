//
//  AppDelegate.m
//  Store
//
//  Created by User on 2017/12/12.
//  Copyright © 2017年 User. All rights reserved.
//

#import "AppDelegate.h"
#import "HHLoginVC.h"


#define STOREAPPID  @"1342153235"

@interface AppDelegate ()
@property (assign, nonatomic) BOOL IsMustUpdate;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = [[HJTabBarController alloc] init];
    
    [self.window makeKeyAndVisible];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //键盘上移
    [self IQKeyboardManagerConfig];
    //监测网络
    [self startMonitor];
    
    if ([API_HOST isEqualToString:@"http://app.buyear.com"]) {
        //检测版本更新
        [self hsUpdateApp];
    }
    return YES;
}
- (void)IQKeyboardManagerConfig {
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = YES; // 控制整个功能是否启用
    
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    
}
//检测版本更新
-(void)hsUpdateApp
{
    //2先获取当前工程项目版本号
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
    
    //3从网络获取appStore版本号
    NSError *error;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",STOREAPPID]]] returningResponse:nil error:nil];
    if (response == nil) {
        NSLog(@"你没有连接网络哦");
        return;
    }
    NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        NSLog(@"hsUpdateAppError:%@",error);
        return;
    }
    NSArray *array = appInfoDic[@"results"];
    NSDictionary *dic = array[0];
    NSString *appStoreVersion = dic[@"version"];
    //打印版本号
    NSLog(@"当前版本号:%@\n商店版本号:%@",currentVersion,appStoreVersion);
    

    //4当前版本号小于商店版本号,就更新
    // 版本号相等,返回0; v1小于v2,返回-1; 否则返回1.
    NSInteger isUpdate = [NSString compareVersion:currentVersion to:appStoreVersion];
    
    if (isUpdate == -1) {

        [[[HHVersionAPI GetAPPIsMustUpdate] netWorkClient] getRequestInView:nil finishedBlock:^(HHVersionAPI *api, NSError *error) {
            
            if (!error) {
                
                if (api.code == 0) {
                    NSNumber *data = api.data;
                    self.IsMustUpdate = data.boolValue;
                    if ([data isEqual:@0]) {
                        //可选
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本有更新" message:[NSString stringWithFormat:@"检测到新版本(%@),是否更新?",appStoreVersion] delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"更新",nil];
                        [alert show];
                    }else{
                        //强制更新
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本有更新" message:[NSString stringWithFormat:@"检测到新版本(%@)",appStoreVersion] delegate:self cancelButtonTitle:nil otherButtonTitles:@"更新",nil];
                        [alert show];
                    }
                    
                }
            }
        }];
        
    }else{
        NSLog(@"检测到不到新版本");
    }
    
}
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    HJUser *user = [HJUser sharedUser];

    //5实现跳转到应用商店进行更新
    if (self.IsMustUpdate) {
//        强制更新
        if(buttonIndex==0)
        {
            
            NSString *urlStr = @"https://itunes.apple.com/us/app/buyear/id1342153235?l=zh&ls=1&mt=8";
            if (user.token.length > 0) {
                user.token = @"";
                [user write];
            }
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
        }
    }else{

        if(buttonIndex==1)
        {
            if (user.token.length > 0) {
                user.token = @"";
                [user write];
            }
            NSString *urlStr = @"https://itunes.apple.com/us/app/buyear/id1342153235?l=zh&ls=1&mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
        }
    }
}
//监测网络
- (void)startMonitor{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
                NSLog(@"未知网络");
                break;
            case 0:
                NSLog(@"网络不可达");
                break;
            case 1:
                NSLog(@"GPRS网络");
                break;
            case 2:
                NSLog(@"wifi网络");
                break;
            default:
                break;
        }
        if(status == 1 || status == 2)
        {
            NSLog(@"有网");
        }else
        {
            NSLog(@"没有网");
            [SVProgressHUD showInfoWithStatus:@"网络竟然崩溃了～"];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        }
    }];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:UIApplicationWillEnterForegroundNotification object:nil];

}
@end
