//
//  AppDelegate.m
//  MeiWan
//
//  Created by apple on 15/8/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "MD5.h"
#import <MAMapKit/MAMapKit.h>
//#import "ECDeviceKit.h"
#import "setting.h"
#import "EMSDK.h"
#import "UserInfo.h"
#import "MD5.h"
#import "CorlorTransform.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import <AlipaySDK/AlipaySDK.h>
//#import "UMSocialSinaSSOHandler.h"

#import "WXApi.h"
//#import "WXApiManager.h"

@interface AppDelegate ()<WXApiDelegate>

@property (nonatomic, strong)UserInfo *userinfo;
@property (nonatomic, strong)NSDictionary *userInfoDic;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    [setting getOpen];
    
    [UserConnector acceptInvalidSSLCerts];
    NSString *session = [PersistenceManager getLoginSession];
    if (session.length != 0) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UITabBarController *tv = [story instantiateViewControllerWithIdentifier:@"tabbar"];
        tv.tabBar.tintColor=[CorlorTransform colorWithHexString:@"#3f90a4"];
        self.window.rootViewController = tv;
    }
    [MAMapServices sharedServices].apiKey = @"d61267a8c21f9991feb021e3244749b0";
    
#if !TARGET_IPHONE_SIMULATOR
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
#endif
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //全局设置UINavigationBar字体颜色
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    [navigationBar setTintColor:[UIColor whiteColor]];
    
    [self setUpLoaduserInfo];
    
    //测试推送
//        NSString *apnsCerName = @"MeiWanDeve";
    //线上推送 打包的时候切记切换
    
    NSString * apnsCerName = nil;
#if DEBUG
    apnsCerName = @"MeiWanDeve";
#else
    apnsCerName = @"MeiWanDirs";
#endif
    
    
    EMOptions *options = [EMOptions optionsWithAppkey:@"chuangjike#peiwan"];
    options.apnsCertName = apnsCerName;
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    [self _registerRemoteNotification];
    
    /**友盟分享*/
    [UMSocialData setAppKey:@"553b7a5867e58e5b64000cc7"];
    
    
    [UMSocialWechatHandler setWXAppId:@"wx4555cf92f3ab6550" appSecret:@"3e6e6d20156505d96dac62c64b496090" url:@"http://www.umeng.com/social"];

    [UMSocialQQHandler setQQWithAppId:@"1104883138" appKey:@"1FdgC7ac77v0fnfm" url:@"http://www.umeng.com/social"];
    
    
    [WXApi registerApp:@"wx4555cf92f3ab6550" withDescription:@"demo 2.0"];
    
    return YES;
    
}

- (void)_registerRemoteNotification{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
//    application.applicationIconBadgeNumber = [EMConversation unreadMessagesCount];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}


- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    
}

- (void)setUpLoaduserInfo{
    self.userInfoDic = [PersistenceManager getLoginUser];
    self.userinfo = [[UserInfo alloc]initWithDictionary: [PersistenceManager getLoginUser]];
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    // 当用户通过支付宝客户端进行支付时,会回调该block:standbyCallback
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
        
    }];
    
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}
// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[EMClient sharedClient] bindDeviceToken:deviceToken];
}
// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"error -- %@",error);
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
//
//- (void)applicationDidEnterBackground:(UIApplication *)application {
//    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//}
//
//- (void)applicationWillEnterForeground:(UIApplication *)application {
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

//- (void)applicationWillTerminate:(UIApplication *)application {
//    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//}
#pragma mark - WXApiDelegate
-(void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp*response=(PayResp*)resp;  // 微信终端返回给第三方的关于支付结果的结构体
        switch (response.errCode) {
            case WXSuccess:
            {// 支付成功，向后台发送消息
                NSLog(@"支付成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"wx_paysuccess" object:nil];
            }
                break;
            case WXErrCodeCommon:
            { //签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
                
                
                NSLog(@"支付失败");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"wx_payfail" object:nil];
            }
                break;
            case WXErrCodeUserCancel:
            { //用户点击取消并返回
                [[NSNotificationCenter defaultCenter] postNotificationName:@"wx_paycancel" object:nil];
                NSLog(@"取消支付");
            }
                break;
            case WXErrCodeSentFail:
            { //发送失败
                [[NSNotificationCenter defaultCenter] postNotificationName:@"wx_paysendFail" object:nil];
                NSLog(@"发送失败");
            }
                break;
            case WXErrCodeUnsupport:
            { //微信不支持
                [[NSNotificationCenter defaultCenter] postNotificationName:@"wx_paynotsupport" object:nil];
                NSLog(@"微信不支持");
            }
                break;
            case WXErrCodeAuthDeny:
            { //授权失败
                [[NSNotificationCenter defaultCenter] postNotificationName:@"wx_payauthorizedfail" object:nil];
                NSLog(@"授权失败");
            }
                break;
            default:
                break;
        }
    }
}
@end
