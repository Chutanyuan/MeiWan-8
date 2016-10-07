//
//  CollectionViewCell.m
//  MeiWan
//
//  Created by user_kevin on 16/8/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        UIImageView * mallShowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, (dtScreenWidth-100-30)/2-10, (dtScreenWidth-100-30)/2-10)];
        mallShowImageView.image = [UIImage imageNamed:@"baijin"];
        [self addSubview:mallShowImageView];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, (dtScreenWidth-100-30)/2-10, (dtScreenWidth-100-30)/2, 40)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15.0];
        label.numberOfLines = 2;
        label.text = @"商家名称";
        [self addSubview:label];
        self.label = label;
    }
    return self;
}

@end
