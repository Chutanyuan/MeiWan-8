
//
//  XYView.m
//  XY键盘自适应
//
//  Created by qingyun on 16/6/4.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "XYView.h"

@implementation XYView

+(instancetype)XYveiw{
    NSArray *views = [[NSBundle mainBundle]loadNibNamed:@"XYView" owner:self options:nil];
    return views.firstObject;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
