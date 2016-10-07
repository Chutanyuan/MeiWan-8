//
//  registInfo.h
//  MeiWan
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface registInfo : NSObject
@property(nonatomic,copy) NSString *username;
@property(nonatomic,copy) NSString *password;
@property(nonatomic,copy) NSString *headUrl;
@property(nonatomic,copy) NSString *verifyCode;
@property(nonatomic,copy) NSString *nickname;
@property(nonatomic,assign)int gender;
@property(nonatomic,assign) int year;
@property(nonatomic,assign) int month;
@property(nonatomic,assign) int day;







@end
