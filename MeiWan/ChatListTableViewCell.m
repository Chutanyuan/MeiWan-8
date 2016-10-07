//
//  ChatListTableViewCell.m
//  MeiWan
//
//  Created by MacBook Air on 16/10/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ChatListTableViewCell.h"

@implementation ChatListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.chatHeader = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        [self.contentView addSubview:self.chatHeader];
        self.chatNickname = [[UILabel alloc]initWithFrame:CGRectMake(60,0, dtScreenWidth-60, 60)];
        self.chatNickname.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:self.chatNickname];
        
    }
    return self;
}
-(void)setPlayInfo:(NSDictionary *)playInfo
{
    [self.chatHeader sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!1",playInfo[@"headUrl"]]]];
    self.chatNickname.text = [NSString stringWithFormat:@"%@",playInfo[@"nickname"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
