//
//  blackNameTableViewCell.m
//  MeiWan
//
//  Created by user_kevin on 16/6/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "blackNameTableViewCell.h"

@implementation blackNameTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView * headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        headerImage.layer.cornerRadius = 20;
        headerImage.clipsToBounds = YES;
        [self addSubview:headerImage];
        self.headerImage = headerImage;
        
        UILabel * nickname = [[UILabel alloc]initWithFrame:CGRectMake(headerImage.frame.origin.x+headerImage.frame.size.width +10, 0, [UIScreen mainScreen].bounds.size.width - (headerImage.frame.origin.x+headerImage.frame.size.width +10), 60)];
        nickname.textColor = [UIColor whiteColor];
        self.nickName = nickname;
        [self addSubview:nickname];
        
    }
    return self;
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
