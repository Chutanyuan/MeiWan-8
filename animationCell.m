//
//  animationCell.m
//  MeiWan
//
//  Created by user_kevin on 16/7/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "animationCell.h"

@implementation animationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView * shanchu = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shanchu"]];
        if (IS_IPHONE_4_OR_LESS) {
            shanchu.frame = CGRectMake(0, 0, 20, 20);
        }else if (IS_IPHONE_5){
            shanchu.frame = CGRectMake(0, 0, 25, 25);
        }else if (IS_IPHONE_6){
            shanchu.frame = CGRectMake(0, 0, 30, 30);
        }else if (IS_IPHONE_6P){
            shanchu.frame = CGRectMake(0, 0, 35, 35);
        }
        
        [self addSubview:shanchu];
        self.shanchu = shanchu;
        UIImageView * tianjia = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tianjia"]];
        if (IS_IPHONE_4_OR_LESS) {
            tianjia.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-20, 0, 20, 20);
        }else if (IS_IPHONE_5){
            tianjia.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-25, 0, 25, 25);
        }else if (IS_IPHONE_6){
            tianjia.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-30, 0, 30, 30);
        }else if (IS_IPHONE_6P){
            tianjia.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-35, 0, 35, 35);
        }
        
        [self addSubview:tianjia];
        self.tianjia = tianjia;
        UIImageView * imageView = [[UIImageView alloc]init];
        
        imageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, (dtScreenHeight-100)/9/2);
        if (IS_IPHONE_5) {
            imageView.bounds = CGRectMake(0, 0, (dtScreenHeight-100)/9-15, (dtScreenHeight-100)/9-15);
        }else if (IS_IPHONE_6){
            imageView.bounds = CGRectMake(0, 0, (dtScreenHeight-100)/9-20, (dtScreenHeight-100)/9-20);
        }else if (IS_IPHONE_6P) {
            imageView.bounds = CGRectMake(0, 0, (dtScreenHeight-100)/9-25, (dtScreenHeight-100)/9-25);
        }else{
            imageView.bounds = CGRectMake(0, 0, (dtScreenHeight-100)/9-10, (dtScreenHeight-100)/9-10);
        }
        [self addSubview:imageView];
        self.showImage = imageView;
        
        UILabel * label = [[UILabel alloc]init];
        label.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, (dtScreenHeight-100)/9/2);
        label.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 45);
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.priceLabel = label;

        
    }
    return self;
}

@end
