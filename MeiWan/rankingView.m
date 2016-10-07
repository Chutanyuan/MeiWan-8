//
//  PlayerView.m
//  MeiWan
//
//  Created by apple on 15/8/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "rankingView.h"
#import "PalyListViewController.h"
#import "UIImageView+WebCache.h"
#import "Meiwan-Swift.h"
#import "CorlorTransform.h"

@implementation rankingView
- (void)setPlayerInfo:(NSDictionary *)playerInfo{
    _playerInfo = playerInfo;
    //NSLog(@"%@",playerInfo);
    self.hot.text = [NSString stringWithFormat:@"%d",[[playerInfo objectForKey:@"hot"]intValue]];
    NSURL *headUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",[playerInfo objectForKey:@"headUrl"]]];
    //NSLog(@"%@",headUrl);
    [self.Head setImageWithURL:headUrl placeholderImage:nil];
    //self.Head.backgroundColor = [UIColor clearColor];
    self.signature.text = [playerInfo objectForKey:@"description"];
     self.signature.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    self.nicename.text = [playerInfo objectForKey:@"nickname"];
    
    if ([[playerInfo objectForKey:@"gender"]intValue] == 0) {
        self.sex.image = [UIImage imageNamed:@"peiwan_male"];
        self.ageAndsex.backgroundColor = [CorlorTransform colorWithHexString:@"56abe4"];
    }else{
        self.sex.image = [UIImage imageNamed:@"peiwan_female"];
        self.ageAndsex.backgroundColor = [CorlorTransform colorWithHexString:@"#ffc0cb"];
    }
    
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy";
    NSString *year = [formatter stringFromDate:today];
    int yearnow = year.intValue;
    int birthyear = [[playerInfo objectForKey:@"year"]intValue];
    int age = yearnow - birthyear;
    NSString *userAge = [NSString stringWithFormat:@"%d",age];
    self.age.textColor = [UIColor whiteColor];
    self.age.text = userAge;
    
    if ([[playerInfo objectForKey:@"distance"]intValue]>1000) {
        self.distance.text = [NSString stringWithFormat:@"%.1f km", [[playerInfo objectForKey:@"distance"]doubleValue]/1000];
    }else{
    self.distance.text = [NSString stringWithFormat:@"%.1f m", [[playerInfo objectForKey:@"distance"]doubleValue]];
    }
    double lastActiveTime = [[playerInfo objectForKey:@"lastActiveTime"]doubleValue];
    //NSLog(@"%f",lastActiveTime) ;
    self.logintime.text = [DateTool getTimeDescription:lastActiveTime];
    //NSLog(@"%@",self.logintime.text);
        
}
- (IBAction)getPlayerInfo:(UITapGestureRecognizer *)sender {
    [self.delegate showPlayerInfo:self.playerInfo];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.ageAndsex.layer.cornerRadius = 3;
    self.ageAndsex.layer.masksToBounds = YES;
    self.grayColorView.backgroundColor = [UIColor blackColor];
    self.grayColorView.alpha = 0.5;
}
@end
