//
//  changeImageCollectionViewCell.m
//  MeiWan
//
//  Created by user_kevin on 16/9/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "changeImageCollectionViewCell.h"

@implementation changeImageCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (dtScreenWidth-15)/2, (dtScreenWidth-15)/2)];
        imageview.layer.cornerRadius = 5;
        imageview.clipsToBounds = YES;
        [self.contentView addSubview:imageview];
        self.imageview = imageview;

    }
    return self;
}
-(void)setImagename:(NSString *)imagename
{
    NSLog(@"%@",imagename);
    self.imageview.image = [UIImage imageNamed:imagename];
    
}

@end
