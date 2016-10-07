//
//  SettingPlayWithUIViewController.h
//  MeiWan
//
//  Created by apple on 15/9/5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
@protocol SettingUserInfoDelegate <NSObject>

-(void)settingUserInfo:(NSDictionary*)userInfo;
-(void)settingPushTologin;
@end

@interface SettingPlayWithUIViewController : UIViewController
@property (nonatomic,strong) UserInfo *userInfo;
@property (nonatomic, weak)id <SettingUserInfoDelegate>delegate;
@end
