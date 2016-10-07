//
//  UserInfo.h
//  MeiWan
//
//  Created by apple on 15/8/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property(nonatomic,assign) long userId;
@property(nonatomic,copy) NSString *username;
@property(nonatomic,copy) NSString *password;
@property(nonatomic,assign) double money;
@property(nonatomic,copy) NSString *headUrl;
@property(nonatomic,copy) NSString *countryNumber;
@property(nonatomic,copy) NSString *mydescription;
@property(nonatomic,assign) double longitude;
@property(nonatomic,assign) double latitude;
@property(nonatomic,copy) NSString *nickname;
@property(nonatomic,assign)int gender;
@property(nonatomic,assign) int year;
@property(nonatomic,assign) int month;
@property(nonatomic,assign) int day;
@property(nonatomic,copy) NSString *soundUrl;
@property(nonatomic,assign) long lastActivetime;
@property(nonatomic,assign) double rateAmount;
@property(nonatomic,assign)  NSInteger rateNumber;
@property(nonatomic,assign) NSInteger isOnline;
@property(nonatomic,assign) NSInteger isOffline;
@property(nonatomic,copy) NSString *realName;
@property(nonatomic,copy) NSString *alipayUsername;
@property(nonatomic,copy) NSString *weixinUsername;
@property(nonatomic,assign) double onlinePrice;
@property(nonatomic,assign) double offlinePrice;
@property(nonatomic,assign) int isWin;
@property(nonatomic,assign) int isRecommend;
@property(nonatomic,assign) int orderAmount;
@property(nonatomic,assign) int isAudit;
@property(nonatomic,assign) double distance;
@property(nonatomic,strong) NSMutableArray *userStates;
@property(nonatomic,strong) NSMutableArray *userTags;
@property(nonatomic,strong) NSMutableArray *userTimeTags;
@property(nonatomic,assign) int hasUnion;//是否拥有工会
@property(nonatomic,assign) int canCreateUnion;//是否可以创建工会

-(id)initWithDictionary:(NSDictionary*)dictionary;

@end
