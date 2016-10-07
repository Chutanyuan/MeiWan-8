//
//  books.m
//  MeiWan
//
//  Created by user_kevin on 16/9/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "books.h"

@implementation books

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (dtScreenWidth-20)/3, 40)];

        label.font = [UIFont systemFontOfSize:15.0];
        label.textAlignment = NSTextAlignmentCenter;

        [self addSubview:label];
        self.label = label;
        
    }
    return self;
}

@end
