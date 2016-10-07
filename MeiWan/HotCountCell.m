//
//  HotCountCell.m
//  MeiWan
//
//  Created by apple on 15/11/23.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "HotCountCell.h"
#import "UIImageView+WebCache.h"
#import "CorlorTransform.h"
#import "Meiwan-Swift.h"

@implementation HotCountCell

- (void)awakeFromNib {
    self.ageAndSex.layer.cornerRadius = 3;
    self.ageAndSex.layer.masksToBounds = YES;
}
- (void)setPersonInfo:(NSDictionary *)personInfo{
    _personInfo = personInfo;
    self.hotCount.text = [NSString stringWithFormat:@"%d",[[personInfo objectForKey:@"hot"]intValue]];
    NSURL *headUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",[personInfo objectForKey:@"headUrl"]]];
    //NSLog(@"%@",headUrl);
    [self.headImage setImageWithURL:headUrl placeholderImage:nil];
    //self.Head.backgroundColor = [UIColor clearColor];
    self.signTure.font = [UIFont systemFontOfSize:15.0];
    self.signTure.text = [personInfo objectForKey:@"description"];
    self.signTure.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    self.nickName.text = [personInfo objectForKey:@"nickname"];
    
    if ([[personInfo objectForKey:@"gender"]intValue] == 0) {
        self.sexImage.image = [UIImage imageNamed:@"peiwan_male"];
        self.ageAndSex.backgroundColor = [CorlorTransform colorWithHexString:@"#007aff" andAlpha:88/255.0];
    }else{
        self.sexImage.image = [UIImage imageNamed:@"peiwan_female"];
        self.ageAndSex.backgroundColor = [CorlorTransform colorWithHexString:@"#ffc0cb"];
    }
    
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy";
    NSString *year = [formatter stringFromDate:today];
    int yearnow = year.intValue;
    int birthyear = [[personInfo objectForKey:@"year"]intValue];
    int age = yearnow - birthyear;
    NSString *userAge = [NSString stringWithFormat:@"%d",age];
    self.age.textColor = [UIColor whiteColor];
    self.age.text = userAge;
    
    NSString * distance = nil;
    if ([[personInfo objectForKey:@"distance"]intValue]>1000) {
        distance = [NSString stringWithFormat:@"%.1f km", [[personInfo objectForKey:@"distance"]doubleValue]/1000];
    }else{
        distance = [NSString stringWithFormat:@"%.1f m", [[personInfo objectForKey:@"distance"]doubleValue]];
    }
    double lastActiveTime = [[personInfo objectForKey:@"lastActiveTime"]doubleValue];
    //NSLog(@"%f",lastActiveTime) ;
    NSString * logintime = [DateTool getTimeDescription:lastActiveTime];
    
    self.distanceAndTime.text = [NSString stringWithFormat:@"%@|%@",distance,logintime];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
