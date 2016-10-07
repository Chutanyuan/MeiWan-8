//
//  UserAssessTableViewCell.m
//  MeiWan
//
//  Created by apple on 15/8/12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UserAssessTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Meiwan-Swift.h"
@implementation UserAssessTableViewCell

-(void)setAssessDic:(NSDictionary *)assessDic{
    _assessDic = assessDic;
    
    NSDictionary *user = [assessDic objectForKey:@"user"];
    NSURL *headUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",[user objectForKey:@"headUrl"]]];
    [self.headIg setImageWithURL:headUrl placeholderImage:nil];
    
    self.nicename.text = [user objectForKey:@"nickname"];
    
    float point = [[assessDic objectForKey:@"point"]floatValue];
    //NSLog(@"%f",point);

    self.starRateView = [[CWStarRateView alloc] initWithFrame:self.starView.bounds numberOfStars:5];
    self.starRateView.scorePercent = point/5;
    self.starRateView.allowIncompleteStar = YES;
    self.starRateView.hasAnimation = YES;
    self.starRateView.userInteractionEnabled = NO;
    [self.starView addSubview:self.starRateView];
    
    double lastActiveTime = [[assessDic objectForKey:@"createTime"]doubleValue];
    self.assessTime.text = [DateTool getTimeDescription:lastActiveTime];
    
    NSString *content = [assessDic objectForKey:@"content"];
    if (content.length == 0) {
        self.assessText.text = @"没有评论内容";
    }else {
        self.assessText.text = content;
    }
}
- (void)awakeFromNib {
    // Initialization code
    self.headIg.layer.cornerRadius = self.headIg.bounds.size.width/2;
    self.headIg.layer.masksToBounds = YES;
    self.assessText.layer.cornerRadius = 5;
    self.assessText.layer.borderWidth = 2;
    self.assessText.layer.borderColor = [[UIColor groupTableViewBackgroundColor]CGColor];
}
- (IBAction)UserAssessTap:(UITapGestureRecognizer *)sender {
    [self.delegate tapUserAssessImage:self.assessDic];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
