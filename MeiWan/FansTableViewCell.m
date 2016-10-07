//
//  FansTableViewCell.m
//  MeiWan
//
//  Created by Fox on 16/7/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "FansTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation FansTableViewCell

- (void)setFansDic:(NSDictionary *)fansDic{
    
//    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
//    NSURL *headUrl = [NSURL URLWithString:[fansDic objectForKey:@"headUrl"]];
//    [headImage setImageWithURL:headUrl placeholderImage:nil];
//    headImage.layer.masksToBounds = YES;
//    headImage.layer.cornerRadius = 25.0f;
//    [self addSubview:headImage];
//    self.headImageView = headImage;
//    
//    UILabel *nameLabel = [[UILabel alloc] init];
//    nameLabel.text = [fansDic objectForKey:@"nickname"];
//    nameLabel.font = [UIFont systemFontOfSize:14.0f];
//    CGSize name2Size = [nameLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:nameLabel.font,NSFontAttributeName, nil]];
//    CGFloat nameH = name2Size.height;
//    CGFloat nameW = name2Size.width;
//    nameLabel.frame = CGRectMake(headImage.frame.origin.x+headImage.frame.size.width+4, (70-nameH)/2, nameW, nameH);
//    self.nameLabel = nameLabel;
//    [self addSubview:nameLabel];
//    
//    UIView *sexAge = [[UIView alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width+4, (70-14)/2, 30, 14)];
//    sexAge.layer.masksToBounds = YES;
//    sexAge.layer.cornerRadius = 3.0f;
//    [self addSubview:sexAge];
//    self.sexAgeView = sexAge;
//    
//    UIImageView *sexImage = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 10, 10)];
//    
//    if ([[fansDic objectForKey:@"gender"]intValue] == 0) {
//        sexImage.image = [UIImage imageNamed:@"peiwan_male"];
//        sexAge.backgroundColor = [CorlorTransform colorWithHexString:@"#007aff" andAlpha:88/255.0];
//    }else{
//        sexImage.image = [UIImage imageNamed:@"peiwan_female"];
//        sexAge.backgroundColor = [CorlorTransform colorWithHexString:@"#ffc0cb"];
//    }
//    [sexAge addSubview:sexImage];
//    self.sexImageView = sexImage;
//    
//    
//    UILabel *age = [[UILabel alloc] init];
//    NSDate *today = [NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    formatter.dateFormat = @"yyyy";
//    NSString *year = [formatter stringFromDate:today];
//    int yearnow = year.intValue;
//    int birthyear = [[fansDic objectForKey:@"year"]intValue];
//    int agenumber = yearnow - birthyear;
//    NSString *userAge = [NSString stringWithFormat:@"%d",agenumber];
//    age.textColor = [UIColor whiteColor];
//    age.text = userAge;
//    age.font = [UIFont systemFontOfSize:11.0f];
//    CGSize ageSize = [age.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:age.font,NSFontAttributeName, nil]];
//    CGFloat ageH = ageSize.height;
//    CGFloat ageW = ageSize.width;
//    age.frame = CGRectMake(sexImage.frame.origin.x+sexImage.frame.size.width+2, 1, ageW, ageH);
//    self.nameLabel = nameLabel;
//    [sexAge addSubview:age];
//    self.ageLabel = age;
    
    UIButton *fansButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-70, (70-20)/2, 60, 20)];
    [fansButton setTitle:@"取消关注" forState:UIControlStateNormal];
    fansButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    fansButton.layer.masksToBounds = YES;
    fansButton.layer.cornerRadius = 4.0f;
    fansButton.backgroundColor = [CorlorTransform colorWithHexString:@"#3f90a4"];
    [self addSubview:fansButton];
    self.fansButton = fansButton;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
