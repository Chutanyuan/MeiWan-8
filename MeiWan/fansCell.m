//
//  fansCell.m
//  MeiWan
//
//  Created by user_kevin on 16/7/31.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "fansCell.h"

@implementation fansCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView * headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        headerImage.layer.cornerRadius = 25;
        headerImage.clipsToBounds = YES;
        [self addSubview:headerImage];
        self.headerImage = headerImage;
        
        self.nickname = [[UILabel alloc]init];
        
        [self addSubview:self.nickname];
        self.sexImage = [[UIImageView alloc]init];
        [self addSubview:self.sexImage];
        
        self.ageLabel = [[UILabel alloc]init];
        self.ageLabel.font = [UIFont systemFontOfSize:15.0];
        self.ageLabel.textColor = [UIColor grayColor];
        [self addSubview:_ageLabel];
        
        UIButton *fansButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-70, (70-20)/2, 60, 20)];
        [fansButton setTitle:@"取消关注" forState:UIControlStateNormal];
        fansButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        fansButton.layer.masksToBounds = YES;
        fansButton.layer.cornerRadius = 4.0f;
        fansButton.backgroundColor = [CorlorTransform colorWithHexString:@"#3f90a4"];
        [self addSubview:fansButton];
        self.fansButton = fansButton;

    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
