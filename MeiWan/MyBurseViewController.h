//
//  MyBurseViewController.h
//  MeiWan
//
//  Created by apple on 15/8/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
@protocol MyburseDelegate <NSObject>

-(void)burseInfo:(NSDictionary*)userInfo;

@end

@interface MyBurseViewController : UIViewController
@property (nonatomic,weak) id<MyburseDelegate>delegate;
@property (nonatomic,strong) UserInfo *userinfo;
@end
