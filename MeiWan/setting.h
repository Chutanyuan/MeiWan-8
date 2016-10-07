//
//  setting.h
//  MeiWan
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableArray_Shuffling.h"
#import <UIKit/UIKit.h>
static const BOOL isTest = NO;
@interface setting : NSObject
{
    NSMutableArray * changeArray;
}

+(NSMutableArray*) ips;
+(void) adjustIps;
+(NSString*)getIp;
+(NSString*)getImgBuketName;
+(NSString*)getSecret;
+(NSString*)getImgLinkUrl;
+(NSString*)getRongLianYun;
+(void)getOpen;
+(BOOL)canOpen;
@end
