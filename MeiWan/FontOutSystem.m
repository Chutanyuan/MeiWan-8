//
//  FontOutSystem.m
//  MeiWan
//
//  Created by user_kevin on 16/10/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "FontOutSystem.h"

@implementation FontOutSystem
+(UIFont *)fontWithFangZhengSize:(CGFloat)fontSize
{
    UIFont * font = [[UIFont alloc]init];
    font = [UIFont fontWithName:@"FZZhongDengXian-Z07S" size:fontSize];
    return font;
}
@end
