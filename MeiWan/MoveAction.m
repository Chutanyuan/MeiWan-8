//
//  MoveAction.m
//  MeiWan
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MoveAction.h"
#import "meiwan-Swift.h"
@implementation MoveAction
-(id)initWithDictionary:(NSDictionary*)moveDic andUser:(NSDictionary*)userInfoDic{
    if (self = [super init]) {
//        NSUserDefaults * userdefaules = [NSUserDefaults standardUserDefaults];
//        userInfoDic = [userdefaules objectForKey:@"playerinfo"];
        _userInfo = userInfoDic;
//        [userdefaules synchronize];
        //NSLog(@"%@",moveDic);
        self.discussCount = [[moveDic objectForKey:@"count"]intValue];
        self.praiseCount = [[moveDic objectForKey:@"likes"]intValue];
        self.isPraise = [[moveDic objectForKey:@"isLike"]boolValue];
        
        if ([moveDic objectForKey:@"user"][@"unionLevel"]!=nil) {
            self.unionTitle = [NSString stringWithFormat:@"%@级公会会长",[moveDic objectForKey:@"user"][@"unionLevel"]];
        }else{
            self.unionTitle = @"";
        }
        self.nackname = [userInfoDic objectForKey:@"nickname"];
        
        self.userId = [[userInfoDic objectForKey:@"id"]longValue];
        self.stateId = [[moveDic objectForKey:@"id"]longValue];
        NSDate *today = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy";
        NSString *year = [formatter stringFromDate:today];
        int yearnow = year.intValue;
        int birthyear = [[userInfoDic objectForKey:@"year"]intValue];
        int age = yearnow - birthyear;
        NSString *userAge = [NSString stringWithFormat:@"%d",age];
        self.age = userAge;
        
        self.sex = [[userInfoDic objectForKey:@"gender"]intValue];
        
        double lastActiveTime = [[moveDic objectForKey:@"createTime"]doubleValue];
        self.time = [DateTool getTimeDescription:lastActiveTime];
        
        self.headImage = [userInfoDic objectForKey:@"headUrl"];
        
        self.text = [moveDic objectForKey:@"content"];
        
        NSArray *images = [moveDic objectForKey:@"statePhotos"];
        //NSLog(@"%@",images);
        if (images.count == 3) {
            if (![images[0] isKindOfClass:[NSNull class]] && [images[1] isKindOfClass:[NSNull class]] && [images[2] isKindOfClass:[NSNull class]]){
                self.image1 = images[0];
                self.images = [NSArray arrayWithObjects:self.image1, nil];
            }else if (![images[0] isKindOfClass:[NSNull class]] && ![images[1] isKindOfClass:[NSNull class]] && [images[2] isKindOfClass:[NSNull class]]){
                self.image1 = images[0];
                self.image2 = images[1];
                self.images = [NSArray arrayWithObjects:self.image1,self.image2, nil];
            }else if (![images[0] isKindOfClass:[NSNull class]] && ![images[0] isKindOfClass:[NSNull class]] && ![images[0] isKindOfClass:[NSNull class]]){
                self.image1 = images[0];
                self.image2 = images[1];
                self.image3 = images[2];
                self.images = [NSArray arrayWithObjects:self.image1,self.image2,self.image3, nil];
            }else{
            }
        }else if (images.count == 1){
            self.image1 = images[0];
            self.images = [NSArray arrayWithObjects:self.image1, nil];
        }
    }
    return self;
}
@end
