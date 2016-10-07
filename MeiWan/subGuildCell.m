//
//  subGuildCell.m
//  MeiWan
//
//  Created by user_kevin on 16/8/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "subGuildCell.h"
#import "CorlorTransform.h"
@implementation subGuildCell

-(void)setDictionary:(NSDictionary *)dictionary
{
    NSLog(@"%@",dictionary);
    [_guildImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!1",dictionary[@"headUrl"]]]];
    _guildImage.frame = CGRectMake(10, 10, 40, 40);
    _guildImage.layer.cornerRadius = 20;
    _guildImage.clipsToBounds = YES;
    _guildName.font = [UIFont systemFontOfSize:14.0];
    _guildName.textColor = [CorlorTransform colorWithHexString:@"ff6633"];

    NSMutableAttributedString * changeText = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n累积收益:%.2f",dictionary[@"name"],[dictionary[@"totalMoney"] doubleValue]]];
    NSRange range = [[changeText string]rangeOfString:dictionary[@"name"]];
    [changeText addAttribute:NSForegroundColorAttributeName value:[CorlorTransform colorWithHexString:@"cc9900"] range:range];
    [changeText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:range];
    _guildName.numberOfLines = 2;
    _guildName.attributedText = changeText;
    CGSize sizeName = [_guildName.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_guildName.font,NSFontAttributeName, nil]];
    _guildName.frame = CGRectMake(_guildImage.frame.origin.x+_guildImage.frame.size.width+10, _guildImage.center.y-sizeName.height/2, sizeName.width, sizeName.height);
    
    NSDictionary * user = dictionary[@"user"];
    _huiZhang.text = [NSString stringWithFormat:@"会长:\n%@",user[@"nickname"]];
    _huiZhang.textColor = [CorlorTransform colorWithHexString:@"ffcc00"];
    _huiZhang.font = [UIFont systemFontOfSize:14.0];
    _huiZhang.numberOfLines = 2;
    CGSize size_huiZhang = [_huiZhang.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_huiZhang.font,NSFontAttributeName, nil]];
    _huiZhang.frame = CGRectMake(dtScreenWidth-10-size_huiZhang.width, _guildName.center.y-size_huiZhang.height/2, size_huiZhang.width, size_huiZhang.height);
    
    
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _guildImage = [[UIImageView alloc]init];
        _guildImage.backgroundColor = [UIColor grayColor];
        [self addSubview:_guildImage];
        _guildName = [[UILabel alloc]init];
        [self addSubview:_guildName];
        _huiZhang = [[UILabel alloc]init];
        [self addSubview:_huiZhang];
        
    }
    return self;
}
@end
