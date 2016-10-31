//
//  setting.m
//  MeiWan
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "setting.h"
#import "NSMutableArray_Shuffling.h"

@implementation setting

+(NSMutableArray *)ips{
    NSMutableArray * array = [[NSMutableArray alloc]init];

    /**
     正式版本  IP地址
     "https://chuangjk.com:8443/"
     "https://web.chuangjk.com:8443/"
     */
    /**
     测试版本  IP地址
     "https://chuangjk.com:8444/"
     */
//    [array addObject:@"https://chuangjk.com:8444/"];
//
    [array addObject:@"https://chuangjk.com:8443/"];
    
    [array addObject:@"https://web.chuangjk.com:8443/"];
    
    [array shuffle];
    
    return array;
}

+ (void) adjustIps{
    NSString* firstIp = [self.ips firstObject];
    [self.ips addObject:firstIp];
    [self.ips removeObjectAtIndex:0];
}

+(NSString*)getIp{
    if (isTest) {
        return @"https://120.26.107.177:8443/";
    }
    return [self.ips firstObject];
}
+(NSString*)getImgBuketName {
    if (isTest) {
        return @"chuangjike-img";
    }
    return @"chuangjike-img-real";
}

+(NSString*)getSecret {
    if (isTest) {
        return @"pWmcKQvwKKcqiggf6PS3M/7rsjg=";
    }
    return @"iJZljKWijOVdEKj8AsoBPc3Z654=";
}

+(NSString*)getImgLinkUrl{
    if (isTest) {
        return @"http://chuangjike-img.b0.upaiyun.com";
    }
    return @"http://chuangjike-img-real.b0.upaiyun.com";
}
+(NSString*)getRongLianYun{
    if (isTest) {
        return @"test_";
    }
    return @"product_";
}
+(void)getOpen{
    NSURL *url = [NSURL URLWithString:@"http://web.chuangjk.com/config.txt"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData * data = [NSData dataWithContentsOfURL:url];
        NSString *open = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        [[NSUserDefaults standardUserDefaults]setObject:open forKey:@"setting"];
    });
}
+(BOOL)canOpen{
    NSString *open = [[NSUserDefaults standardUserDefaults] objectForKey:@"setting"];
    //NSLog(@"%@",open);
    if (open) {
        if ([open containsString:@"open=0"]) {
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}

@end
