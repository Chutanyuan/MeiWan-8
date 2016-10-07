//
//  RandNumber.h
//  MeiWan
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RandNumber : NSObject
@property(nonatomic,strong)NSMutableArray *oddNums;
@property(nonatomic,assign)int oddCounts;
@property(nonatomic,strong)NSMutableArray *evenNums;
@property(nonatomic,assign)int evenCounts;

-(id)init;
-(int)getOddRandNumber;
-(int)getEvenRandNumber;
+(NSString*)getRandNumberString;
+(NSString*)getRandNumberString:(int)length;
@end
