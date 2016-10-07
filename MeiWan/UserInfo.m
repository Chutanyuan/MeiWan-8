//
//  UserInfo.m
//  MeiWan
//
//  Created by apple on 15/8/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
-(id)initWithDictionary:(NSDictionary*)dictionary{

    if (self = [super init]) {
        NSDictionary *userInfo = dictionary;
        self.userId = [[userInfo objectForKey:@"id"]longValue];
        self.username = [userInfo objectForKey:@"username"];
        self.password = [userInfo objectForKey:@"password"];
        self.money = [[userInfo objectForKey:@"money"]doubleValue];
        self.headUrl = [userInfo objectForKey:@"headUrl"];
        self.countryNumber = [userInfo objectForKey:@"countryNumber"];
        self.mydescription = [userInfo objectForKey:@"description"];
        self.longitude = [[userInfo objectForKey:@"longitude"]doubleValue];
        self.latitude = [[userInfo objectForKey:@"latitude"]doubleValue];
        self.nickname = [userInfo objectForKey:@"nickname"];
        self.gender = [[userInfo objectForKey:@"gender"]intValue];
        self.year = [[userInfo objectForKey:@"year"]intValue];
        self.month = [[userInfo objectForKey:@"month"]intValue];
        self.day = [[userInfo objectForKey:@"day"]intValue];
        self.lastActivetime = [[userInfo objectForKey:@"lastActiveTime"]longValue];
        self.rateAmount = [[userInfo objectForKey:@"rateAmount"]intValue];
        self.rateNumber = [[userInfo objectForKey:@"rateNumber"]intValue];
        self.isOnline  = [[userInfo objectForKey:@"isOnline"]intValue];
        self.isOffline  = [[userInfo objectForKey:@"isOffline"]intValue];
        self.onlinePrice = [[userInfo objectForKey:@"onlinePrice"]doubleValue];
        self.offlinePrice = [[userInfo objectForKey:@"offlinePrice"]doubleValue];
        self.isWin = [[userInfo objectForKey:@"isWin"]intValue];
        self.isRecommend = [[userInfo objectForKey:@"isRecommend"]intValue];
        self.orderAmount = [[userInfo objectForKey:@"orderAmount"]intValue];
        self.isAudit = [[userInfo objectForKey:@"isAudit"]intValue];
        self.soundUrl = [userInfo objectForKey:@"soundUrl"];
        self.realName = [userInfo objectForKey:@"realname"];
        self.alipayUsername = [userInfo objectForKey:@"alipayUsername"];
        self.weixinUsername = [userInfo objectForKey:@"weixinUsername"];
        self.distance = [[userInfo objectForKey:@"distance"]doubleValue];
        self.userStates = [userInfo objectForKey:@"userStates"];
        self.userTags = [userInfo objectForKey:@"userTags"];
        self.userTimeTags = [userInfo objectForKey:@"userTimeTags"];
        self.hasUnion = [[userInfo objectForKey:@"hasUnion"] doubleValue];
        self.canCreateUnion = [[userInfo objectForKey:@"canCreateUnion"] doubleValue];
}
    
    return self;
}
@end
