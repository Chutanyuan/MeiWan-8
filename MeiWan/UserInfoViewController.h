//
//  UserInfoViewController.h
//  MeiWan
//
//  Created by apple on 15/8/21.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
@protocol UserInfoDelegate <NSObject>

-(void)userInfo:(NSDictionary*)userInfo;
-(void)pushToLogin;
@end

@interface UserInfoViewController : UIViewController
@property (nonatomic, strong) UserInfo *myuserInfo;
@property (nonatomic, weak)id <UserInfoDelegate>delegate;
@end
