//
//  TAauthenticateCell.m
//  MeiWan
//
//  Created by user_kevin on 16/10/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TAauthenticateCell.h"

@implementation TAauthenticateCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        if ([reuseIdentifier isEqualToString:@"indexpath1"]) {
            NSLog(@"QQ 微信 身份认证");
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(300, 0, 100, 100)];
            label.backgroundColor = [UIColor blackColor];
            [self addSubview:label];
        }else{
            NSLog(@"商家认证");
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
            label.backgroundColor = [UIColor redColor];
            [self addSubview:label];
        }
    }
    return self;
}

@end
