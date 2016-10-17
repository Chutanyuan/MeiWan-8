//
//  EditpersonalMessageTableViewCell.m
//  MeiWan
//
//  Created by user_kevin on 16/10/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "EditpersonalMessageTableViewCell.h"

@implementation EditpersonalMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel * rightlabel = [[UILabel alloc]initWithFrame:CGRectMake(dtScreenWidth/2, 0, dtScreenWidth/2-40, 44)];
        rightlabel.font = [FontOutSystem fontWithFangZhengSize:15.0];
        rightlabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:rightlabel];
        self.rightlabel = rightlabel;
        UIImageView * jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(dtScreenWidth-35, self.frame.size.height/2-7.5, 15, 15)];
        jiantou.image = [UIImage imageNamed:@"jiantou"];
        [self.contentView addSubview:jiantou];

        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
