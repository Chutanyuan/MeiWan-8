//
//  MoveAction.h
//  MeiWan
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoveAction : NSObject

@property (nonatomic,assign) long stateId;
@property (nonatomic,copy) NSString *nackname;
@property (nonatomic,copy) NSString * unionTitle;
@property (nonatomic,assign) long userId;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *age;
@property (nonatomic,assign) int sex;
@property (nonatomic,copy) NSString *headImage;
@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) NSString *image1;
@property (nonatomic,copy) NSString *image2;
@property (nonatomic,copy) NSString *image3;
@property (nonatomic,strong) NSArray *images;
//点赞和评论
@property (nonatomic,assign) int praiseCount;
@property (nonatomic,assign) int discussCount;
@property (nonatomic,assign) BOOL isPraise;
@property (nonatomic,strong) NSDictionary * userInfo;
-(id)initWithDictionary:(NSDictionary*)moveDic andUser:(NSDictionary*)userInfoDic;

@end
