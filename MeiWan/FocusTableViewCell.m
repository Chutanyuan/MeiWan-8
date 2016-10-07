//
//  FocusTableViewCell.m
//  MeiWan
//
//  Created by Fox on 16/7/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "FocusTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Meiwan-Swift.h"

@implementation FocusTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        self.headImageView.layer.masksToBounds = YES;
        self.headImageView.layer.cornerRadius = 25.0f;

        [self addSubview:self.headImageView];
        
        
        self.nameLabel = [[UILabel alloc] init];
        [self addSubview:self.nameLabel];
        
        self.sexAgeView = [[UIView alloc] init];
        [self addSubview:self.sexAgeView];
        
        
        self.sexImageView = [[UIImageView alloc]init];
        [self.sexAgeView addSubview:self.sexImageView];


        self.ageLabel = [[UILabel alloc] init];
        [self.sexAgeView addSubview:self.ageLabel];
        
        
        UIButton *focusButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width -70, (70-20)/2, 60, 20)];
        [focusButton setTitle:@"关注" forState:UIControlStateNormal];
        focusButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        focusButton.layer.masksToBounds = YES;
        focusButton.layer.cornerRadius = 4.0f;
        focusButton.backgroundColor = [CorlorTransform colorWithHexString:@"#3f90a4"];
        [focusButton addTarget:self action:@selector(chlikFocusButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:focusButton];
        self.focusButton = focusButton;
    }
    return self;
}

- (void)setFocusDic:(NSDictionary *)focusDic{
    
    _focusDic = focusDic;
    
    NSURL *headUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",[focusDic objectForKey:@"headUrl"]]];
    [self.headImageView setImageWithURL:headUrl placeholderImage:nil];

    self.nameLabel.text = [focusDic objectForKey:@"nickname"];
    self.nameLabel.font = [UIFont systemFontOfSize:14.0f];
    CGSize name2Size = [self.nameLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.nameLabel.font,NSFontAttributeName, nil]];
    CGFloat nameH = name2Size.height;
    CGFloat nameW = name2Size.width;
    self.nameLabel.frame = CGRectMake(self.headImageView.frame.origin.x+self.headImageView.frame.size.width+4, (70-nameH)/2, nameW, nameH);
    
    self.sexAgeView.frame = CGRectMake(self.nameLabel.frame.origin.x+self.nameLabel.frame.size.width+4, (70-14)/2, 30, 14);
    self.sexAgeView.layer.masksToBounds = YES;
    self.sexAgeView.layer.cornerRadius = 3.0f;

    
    self.sexImageView.frame = CGRectMake(2, 2, 10, 10);
    
    if ([[focusDic objectForKey:@"gender"]intValue] == 0) {
        self.sexImageView.image = [UIImage imageNamed:@"peiwan_male"];
        self.sexAgeView.backgroundColor = [CorlorTransform colorWithHexString:@"#007aff" andAlpha:88/255.0];
    }else{
        self.sexImageView.image = [UIImage imageNamed:@"peiwan_female"];
        self.sexAgeView.backgroundColor = [CorlorTransform colorWithHexString:@"#ffc0cb"];
    }
    
        NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy";
    NSString *year = [formatter stringFromDate:today];
    int yearnow = year.intValue;
    int birthyear = [[focusDic objectForKey:@"year"]intValue];
    int agenumber = yearnow - birthyear;
    NSString *userAge = [NSString stringWithFormat:@"%d",agenumber];
    self.ageLabel.textColor = [UIColor whiteColor];
    self.ageLabel.text = userAge;
    self.ageLabel.font = [UIFont systemFontOfSize:11.0f];
    CGSize ageSize = [self.ageLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.ageLabel.font,NSFontAttributeName, nil]];
    CGFloat ageH = ageSize.height;
    CGFloat ageW = ageSize.width;
    self.ageLabel.frame = CGRectMake(self.sexImageView.frame.origin.x+self.sexImageView.frame.size.width+2, 1, ageW, ageH);
}

- (void)chlikFocusButton:(UIButton *)sender{
    
    NSString * userID =[self.focusDic objectForKey:@"id"];
//    if ([self.delegate respondsToSelector:@selector(focusTableViewCell:userID:)]) {
//        
//    }
    [self.delegate focusTableViewCell:self userID:userID];

    
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
