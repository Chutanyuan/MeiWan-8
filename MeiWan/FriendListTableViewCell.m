//
//  FriendListTableViewCell.m
//  MeiWan
//
//  Created by apple on 15/8/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "FriendListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CorlorTransform.h"
@implementation FriendListTableViewCell

- (void)awakeFromNib {
    self.headIg.layer.cornerRadius = self.headIg.bounds.size.width/2;
    self.headIg.layer.masksToBounds = YES;
    self.ageAndSex.layer.cornerRadius = 3;
    
}
-(void)setFriendInfoDic:(NSDictionary *)friendInfoDic{
    _friendInfoDic = friendInfoDic;
    NSURL *headUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",[friendInfoDic objectForKey:@"headUrl"]]];
    [self.headIg setImageWithURL:headUrl placeholderImage:nil];
    
    self.nickname.text = [friendInfoDic objectForKey:@"nickname"];
    
    if ([[friendInfoDic objectForKey:@"gender"]intValue] == 0) {
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
    int birthyear = [[friendInfoDic objectForKey:@"year"]intValue];
    int age = yearnow - birthyear;
    NSString *userAge = [NSString stringWithFormat:@"%d",age];
    self.age.textColor = [UIColor whiteColor];
    self.age.text = userAge;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
