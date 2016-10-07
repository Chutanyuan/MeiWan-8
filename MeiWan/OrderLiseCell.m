//
//  OrderLiseCell.m
//  MeiWan
//
//  Created by user_kevin on 16/8/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OrderLiseCell.h"
#import "MeiWan-Swift.h"
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@implementation OrderLiseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        /**
         
         */
        _userHeaderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 40, 40)];
        _userHeaderImageView.layer.cornerRadius = 20;
        _userHeaderImageView.clipsToBounds = YES;
        [self addSubview:_userHeaderImageView];
        
        _nickName = [[UILabel alloc]init];
        [self addSubview:_nickName];
        
        
        _moneyLabel = [[UILabel alloc]init];
        [self addSubview:_moneyLabel];
        
        _timeLable = [[UILabel alloc]init];
        [self addSubview:_timeLable];
        
        
    }
    return self;
}
-(void)setDictionary:(NSDictionary *)dictionary
{
    NSDictionary * formUser = dictionary[@"fromUser"];
    [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!1",formUser[@"headUrl"]]]];
    self.userHeaderImageView.backgroundColor = [UIColor grayColor];
    self.nickName.text = formUser[@"nickname"];
    self.nickName.font  = [UIFont systemFontOfSize:16.0];
    CGSize nicksize = [self.nickName.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.nickName.font,NSFontAttributeName, nil]];
    self.nickName.frame = CGRectMake(self.userHeaderImageView.frame.origin.x+self.userHeaderImageView.frame.size.width+10, self.userHeaderImageView.center.y-nicksize.height/2, nicksize.width, nicksize.height);
    

    double lastActiveTime = [[dictionary objectForKey:@"time"]doubleValue];
    _timeLable.text = [DateTool getTimeDescription:lastActiveTime];
    _timeLable.font = [UIFont systemFontOfSize:16.0];
    CGSize size_time = [_timeLable.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_timeLable.font,NSFontAttributeName, nil]];
    _timeLable.frame = CGRectMake(dtScreenWidth/2, 0, size_time.width, 60);
    
    _moneyLabel.text = [NSString stringWithFormat:@"￥%@",dictionary[@"monney"]];
    _moneyLabel.font = [UIFont systemFontOfSize:16.0];
    CGSize size_money = [_moneyLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_moneyLabel.font,NSFontAttributeName, nil]];
    _moneyLabel.frame = CGRectMake(dtScreenWidth-size_money.width-20, 0, size_money.width, 60);
    
}
@end
