//
//  ButtonLable.m
//  MeiWan
//
//  Created by apple on 15/11/12.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ButtonLable.h"

@implementation ButtonLable

+(instancetype)buttonWithType:(UIButtonType)buttonType{
    ButtonLable *btn = [super buttonWithType:buttonType];
    btn.lyTitleLable = [[UILabel alloc]initWithFrame:btn.frame];
    [btn addSubview:btn.lyTitleLable];
    return btn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
