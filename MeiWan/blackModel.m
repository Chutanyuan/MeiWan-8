//
//  blackModel.m
//  MeiWan
//
//  Created by user_kevin on 16/6/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "blackModel.h"

@implementation blackModel

-(id)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        
        self.headerUrl = dic[@"headUrl"];
        self.nickName = dic[@"nickname"];
        self.ID = dic[@"id"];
    }
    return self;
}

@end
