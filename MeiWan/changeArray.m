//
//  changeArray.m
//  MeiWan
//
//  Created by user_kevin on 16/8/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "changeArray.h"
#import "NSMutableArray_Shuffling.h"
@implementation changeArray

-(void)setChanges:(NSMutableArray *)changes
{
    
}
-(NSMutableArray *)changes
{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    [array addObject:@"https://web.chuangjk.com:8443/"];
    [array addObject:@"https://chuangjk.com:8443/"];
    [array shuffle];
    return array;
}

@end
