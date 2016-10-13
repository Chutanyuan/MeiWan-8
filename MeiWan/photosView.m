//
//  photosView.m
//  MeiWan
//
//  Created by user_kevin on 16/10/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "photosView.h"



@interface photosView()

@property(nonatomic,strong)UIImageView * imageview1;
@property(nonatomic,strong)UIImageView * imageview2;
@property(nonatomic,strong)UIImageView * imageview3;
@property(nonatomic,strong)UIImageView * imageview4;
@property(nonatomic,strong)UIImageView * imageview5;
@property(nonatomic,strong)UIImageView * imageview6;

@end

@implementation photosView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageview1 = [[UIImageView alloc]init];
        self.imageview1.backgroundColor = [CorlorTransform colorWithHexString:@"e7e7e7"];
        [self addSubview:self.imageview1];
        
        self.imageview2 = [[UIImageView alloc]init];
        self.imageview2.backgroundColor = [CorlorTransform colorWithHexString:@"e7e7e7"];
        [self addSubview:self.imageview2];
        
        self.imageview3 = [[UIImageView alloc]init];
        self.imageview3.backgroundColor = [CorlorTransform colorWithHexString:@"e7e7e7"];
        [self addSubview:self.imageview3];
        
        self.imageview4 = [[UIImageView alloc]init];
        self.imageview4.backgroundColor = [CorlorTransform colorWithHexString:@"e7e7e7"];
        [self addSubview:self.imageview4];
        
        self.imageview5 = [[UIImageView alloc]init];
        self.imageview5.backgroundColor = [CorlorTransform colorWithHexString:@"e7e7e7"];
        [self addSubview:self.imageview5];
        
        self.imageview6 = [[UIImageView alloc]init];
        self.imageview6.backgroundColor = [CorlorTransform colorWithHexString:@"e7e7e7"];
        [self addSubview:self.imageview6];
        
        self.imageview1.userInteractionEnabled = YES;
        self.imageview2.userInteractionEnabled = YES;
        self.imageview3.userInteractionEnabled = YES;
        self.imageview4.userInteractionEnabled = YES;
        self.imageview5.userInteractionEnabled = YES;
        self.imageview6.userInteractionEnabled = YES;
        
        self.imageview1.tag = 1;
        self.imageview2.tag = 2;
        self.imageview3.tag = 3;
        self.imageview4.tag = 4;
        self.imageview5.tag = 5;
        self.imageview6.tag = 6;
        
        UITapGestureRecognizer * Tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ImageTapGesture:)];
        UITapGestureRecognizer * Tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ImageTapGesture:)];
        UITapGestureRecognizer * Tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ImageTapGesture:)];
        UITapGestureRecognizer * Tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ImageTapGesture:)];
        UITapGestureRecognizer * Tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ImageTapGesture:)];
        UITapGestureRecognizer * Tap6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ImageTapGesture:)];
        
        [self.imageview1 addGestureRecognizer:Tap1];
        [self.imageview2 addGestureRecognizer:Tap2];
        [self.imageview3 addGestureRecognizer:Tap3];
        [self.imageview4 addGestureRecognizer:Tap4];
        [self.imageview5 addGestureRecognizer:Tap5];
        [self.imageview6 addGestureRecognizer:Tap6];
        
        
    
    }
    return self;
}

-(void)setUserMessage:(NSDictionary *)UserMessage
{
    NSArray * userPhotots = UserMessage[@"userPhotos"];
    NSLog(@"%@",userPhotots);
    if (userPhotots.count<1) {
        self.imageview1.frame = CGRectMake(0, 0, dtScreenWidth, dtScreenWidth);
        self.imageview1.image = [UIImage imageNamed:@"photoAdd"];
        self.imageview1.contentMode = UIViewContentModeCenter;
        
    }
    if (userPhotots.count==1) {
        self.imageview1.frame = CGRectMake(dtScreenWidth/3+1, 1, dtScreenWidth/3*2-2, dtScreenWidth/3*2-2);
        [self.imageview1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userPhotots[0][@"url"]]]];

        self.imageview1.tag = [userPhotots[0][@"id"] intValue];

        self.imageview1.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imageview2.frame = CGRectMake(1, 1, dtScreenWidth/3-2, dtScreenWidth/3-2);
        self.imageview2.image = [UIImage imageNamed:@"photoAdd"];
        self.imageview2.contentMode = UIViewContentModeCenter;
        
    }
    if (userPhotots.count==2) {
        self.imageview1.frame = CGRectMake(dtScreenWidth/3+1, 1, dtScreenWidth/3*2-2, dtScreenWidth/3*2-2);
        [self.imageview1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userPhotots[0][@"url"]]]];
        self.imageview1.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imageview2.frame = CGRectMake(1, 1, dtScreenWidth/3-2, dtScreenWidth/3-2);
        [self.imageview2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userPhotots[1][@"url"]]]];
        self.imageview2.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imageview3.frame = CGRectMake(1, dtScreenWidth/3, dtScreenWidth/3-2, dtScreenWidth/3-2);
        self.imageview3.image = [UIImage imageNamed:@"photoAdd"];
        self.imageview3.contentMode = UIViewContentModeCenter;
        
        self.imageview1.tag = [userPhotots[0][@"id"] intValue];
        self.imageview2.tag = [userPhotots[1][@"id"] intValue];
        

    }
    if (userPhotots.count==3) {
        self.imageview1.frame = CGRectMake(dtScreenWidth/3+1, 1, dtScreenWidth/3*2-2, dtScreenWidth/3*2-2);
        [self.imageview1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userPhotots[0][@"url"]]]];
        self.imageview1.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imageview2.frame = CGRectMake(1, 1, dtScreenWidth/3-2, dtScreenWidth/3-2);
        [self.imageview2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userPhotots[1][@"url"]]]];
        self.imageview2.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imageview3.frame = CGRectMake(1, dtScreenWidth/3, dtScreenWidth/3-2, dtScreenWidth/3-2);
        [self.imageview3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userPhotots[2][@"url"]]]];
        self.imageview3.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imageview4.frame = CGRectMake(1, dtScreenWidth/3*2, dtScreenWidth/3-2, dtScreenWidth/3-2);
        self.imageview4.image = [UIImage imageNamed:@"photoAdd"];
        self.imageview4.contentMode = UIViewContentModeCenter;
        
        self.imageview1.tag = [userPhotots[0][@"id"] intValue];
        self.imageview2.tag = [userPhotots[1][@"id"] intValue];
        self.imageview3.tag = [userPhotots[2][@"id"] intValue];
    }
    if (userPhotots.count==4) {
        self.imageview1.frame = CGRectMake(dtScreenWidth/3+1, 1, dtScreenWidth/3*2-2, dtScreenWidth/3*2-2);
        [self.imageview1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userPhotots[0][@"url"]]]];
        self.imageview1.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imageview2.frame = CGRectMake(1, 1, dtScreenWidth/3-2, dtScreenWidth/3-2);
        [self.imageview2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userPhotots[1][@"url"]]]];
        self.imageview2.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imageview3.frame = CGRectMake(1, dtScreenWidth/3, dtScreenWidth/3-2, dtScreenWidth/3-2);
        [self.imageview3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userPhotots[2][@"url"]]]];
        self.imageview3.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imageview4.frame = CGRectMake(1, dtScreenWidth/3*2, dtScreenWidth/3-2, dtScreenWidth/3-2);
        [self.imageview4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userPhotots[3][@"url"]]]];
        self.imageview4.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imageview5.frame = CGRectMake(dtScreenWidth/3, dtScreenWidth/3*2, dtScreenWidth/3-2, dtScreenWidth/3-2);
        self.imageview5.image = [UIImage imageNamed:@"photoAdd"];
        self.imageview5.contentMode = UIViewContentModeCenter;
        
        self.imageview1.tag = [userPhotots[0][@"id"] intValue];
        self.imageview2.tag = [userPhotots[1][@"id"] intValue];
        self.imageview3.tag = [userPhotots[2][@"id"] intValue];
        self.imageview4.tag = [userPhotots[3][@"id"] intValue];
        
    }
    if (userPhotots.count==5) {
        self.imageview1.frame = CGRectMake(dtScreenWidth/3+1, 1, dtScreenWidth/3*2-2, dtScreenWidth/3*2-2);
        [self.imageview1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userPhotots[0][@"url"]]]];
        self.imageview1.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imageview2.frame = CGRectMake(1, 1, dtScreenWidth/3-2, dtScreenWidth/3-2);
        [self.imageview2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userPhotots[1][@"url"]]]];
        self.imageview2.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imageview3.frame = CGRectMake(1, dtScreenWidth/3, dtScreenWidth/3-2, dtScreenWidth/3-2);
        [self.imageview3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userPhotots[2][@"url"]]]];
        self.imageview3.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imageview4.frame = CGRectMake(1, dtScreenWidth/3*2, dtScreenWidth/3-2, dtScreenWidth/3-2);
        [self.imageview4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userPhotots[3][@"url"]]]];
        self.imageview4.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imageview5.frame = CGRectMake(dtScreenWidth/3, dtScreenWidth/3*2, dtScreenWidth/3-2, dtScreenWidth/3-2);
        [self.imageview5 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userPhotots[4][@"url"]]]];
        self.imageview5.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imageview6.frame = CGRectMake(dtScreenWidth/3*2, dtScreenWidth/3*2, dtScreenWidth/3-2, dtScreenWidth/3-2);
        self.imageview6.image = [UIImage imageNamed:@"photoAdd"];
        self.imageview6.contentMode = UIViewContentModeCenter;
        
        self.imageview1.tag = [userPhotots[0][@"id"] intValue];
        self.imageview2.tag = [userPhotots[1][@"id"] intValue];
        self.imageview3.tag = [userPhotots[2][@"id"] intValue];
        self.imageview4.tag = [userPhotots[3][@"id"] intValue];
        self.imageview5.tag = [userPhotots[4][@"id"] intValue];
        
    }
    
    if (userPhotots.count>=6) {
        self.imageview1.frame = CGRectMake(dtScreenWidth/3+1, 1, dtScreenWidth/3*2-2, dtScreenWidth/3*2-2);
        [self.imageview1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userPhotots[0][@"url"]]]];
        self.imageview1.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imageview2.frame = CGRectMake(1, 1, dtScreenWidth/3-2, dtScreenWidth/3-2);
        [self.imageview2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userPhotots[1][@"url"]]]];
        self.imageview2.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imageview3.frame = CGRectMake(1, dtScreenWidth/3, dtScreenWidth/3-2, dtScreenWidth/3-2);
        [self.imageview3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userPhotots[2][@"url"]]]];
        self.imageview3.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imageview4.frame = CGRectMake(1, dtScreenWidth/3*2, dtScreenWidth/3-2, dtScreenWidth/3-2);
        [self.imageview4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userPhotots[3][@"url"]]]];
        self.imageview4.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imageview5.frame = CGRectMake(dtScreenWidth/3, dtScreenWidth/3*2, dtScreenWidth/3-2, dtScreenWidth/3-2);
        [self.imageview5 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userPhotots[4][@"url"]]]];
        self.imageview5.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imageview6.frame = CGRectMake(dtScreenWidth/3*2, dtScreenWidth/3*2, dtScreenWidth/3-2, dtScreenWidth/3-2);
        [self.imageview6 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userPhotots[5][@"url"]]]];
        self.imageview6.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imageview1.tag = [userPhotots[0][@"id"] intValue];
        self.imageview2.tag = [userPhotots[1][@"id"] intValue];
        self.imageview3.tag = [userPhotots[2][@"id"] intValue];
        self.imageview4.tag = [userPhotots[3][@"id"] intValue];
        self.imageview5.tag = [userPhotots[4][@"id"] intValue];
        self.imageview6.tag = [userPhotots[5][@"id"] intValue];
    }

}

- (void)ImageTapGesture:(UITapGestureRecognizer *)gesture
{
    UIImageView * imageview = (UIImageView *)[gesture view];

    [self.delegate phototsTouch:imageview];
    
}


@end
