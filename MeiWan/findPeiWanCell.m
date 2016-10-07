//
//  findPeiWanCell.m
//  MeiWan
//
//  Created by user_kevin on 16/8/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "findPeiWanCell.h"
#import "CorlorTransform.h"
@implementation findPeiWanCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _headerImage = [[UIImageView alloc]init];
        [self addSubview:_headerImage];
        
        _nickname = [[UILabel alloc]init];
        [self addSubview:_nickname];
        
        _sex = [[UIImageView alloc]init];
        [self addSubview:_sex];
        
        _age = [[UILabel alloc]init];
        [self addSubview:_age];
        
        _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatButton addTarget:self action:@selector(ChatWithFriend:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_chatButton];
        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton addTarget:self action:@selector(AddFriend:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addButton];
        
        _qianMing = [[UILabel alloc]init];
        [self addSubview:_qianMing];
        
    }
    return self;
}
-(void)setDictionary:(NSDictionary *)dictionary
{
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!1",dictionary[@"headUrl"]]]];
    _headerImage.frame = CGRectMake(20, 20, 60, 60);
    _headerImage.layer.cornerRadius = 30;
    _headerImage.clipsToBounds = YES;
    
    _nickname.text = dictionary[@"nickname"];
    _nickname.font = [UIFont systemFontOfSize:16.0];
    CGSize size_nickname = [_nickname.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_nickname.font,NSFontAttributeName, nil]];
    _nickname.frame = CGRectMake(_headerImage.frame.size.width+_headerImage.frame.origin.x+20, _headerImage.frame.origin.y+10, size_nickname.width, size_nickname.height);
    
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy";
    NSString *year = [formatter stringFromDate:today];
    int yearnow = year.intValue;
    int birthyear = [[dictionary objectForKey:@"year"]intValue];
    int age = yearnow - birthyear;
    _age.text = [NSString stringWithFormat:@"%d",age];
    _age.font = [UIFont systemFontOfSize:14.0];
    CGSize size_age = [_age.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_age.font,NSFontAttributeName, nil]];
    _age.frame = CGRectMake(_nickname.frame.origin.x+size_nickname.width+10, _nickname.center.y-size_age.height/2, size_age.width, size_age.height);
    
    if ([dictionary[@"sex"] isEqualToString:@"男"]) {
        _sex.image = [UIImage imageNamed:@"nansheng_logo"];
    }else{
        _sex.image = [UIImage imageNamed:@"nvsheng_logo"];
    }
    _sex.frame = CGRectMake(_age.frame.size.width+_age.frame.origin.x+5, _age.frame.origin.y, size_age.height, size_age.height);
    
    _qianMing.text = dictionary[@"description"];
    _qianMing.textColor = [UIColor grayColor];
    _qianMing.font = [UIFont systemFontOfSize:15.0];
    CGSize size_qianMing = [_qianMing.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_qianMing.font,NSFontAttributeName, nil]];
    _qianMing.frame = CGRectMake(_nickname.frame.origin.x, _nickname.frame.origin.y+_nickname.frame.size.height+10, size_qianMing.width-60, size_qianMing.height);
    
    [_chatButton setTitle:@"聊天" forState:UIControlStateNormal];
    _chatButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [_chatButton setBackgroundColor:[CorlorTransform colorWithHexString:@"ff6699"]];
    CGSize size_buttonTittle = [_chatButton.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_chatButton.titleLabel.font,NSFontAttributeName, nil]];
    _chatButton.layer.cornerRadius = 5;
    _chatButton.clipsToBounds = YES;
    _chatButton.frame = CGRectMake(dtScreenWidth-size_buttonTittle.width-60, 20, size_buttonTittle.width+40, size_buttonTittle.height+10);
    
    
    [_addButton setTitle:@"关注" forState:UIControlStateNormal];
    _addButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [_addButton setBackgroundColor:[CorlorTransform colorWithHexString:@"cc9966"]];
    CGSize size_addButton = [_addButton.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_addButton.titleLabel.font,NSFontAttributeName, nil]];
    _addButton.layer.cornerRadius = 5;
    _addButton.clipsToBounds = YES;
    _addButton.frame = CGRectMake(_chatButton.frame.origin.x, _headerImage.frame.size.height+_headerImage.frame.origin.y-size_addButton.height-10, size_buttonTittle.width+40, size_addButton.height+10);


}
- (void)ChatWithFriend:(UIButton *)sender{
    [self.delegate ChatWithFriend];
}
- (void)AddFriend:(UIButton *)sender{
    [self.delegate AddFriend];
}
@end
