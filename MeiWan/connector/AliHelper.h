//
//  AliHelper.h
//  MeiWan
//
//  Created by mac on 15/9/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^Callback)(NSDictionary *resultDic);
@interface AliHelper : NSObject 
+(void)aliPay:(NSInteger)orderId price:(double)price callback:(Callback)callback;
+(void)aliRecharge:(NSInteger)rechargeId price:(double)price callback:(Callback)callback;
@end
