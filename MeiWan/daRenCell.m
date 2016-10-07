//
//  daRenCell.m
//  MeiWan
//
//  Created by user_kevin on 16/8/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "daRenCell.h"
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@implementation daRenCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView * memberHeader = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        memberHeader.backgroundColor = [UIColor grayColor];
        memberHeader.layer.cornerRadius = 20;
        memberHeader.clipsToBounds = YES;
        [self addSubview:memberHeader];
        self.darenHeader = memberHeader;
        
        self.nickName = [[UILabel alloc]init];
        
        [self addSubview:_nickName];
        
        self.ageLabel = [[UILabel alloc]init];
        
        [self addSubview:_ageLabel];
        
        
        _sexImage = [[UIImageView alloc]init];
        
        [self addSubview:_sexImage];
        
        
    }
    return self;
}
-(void)setDictionary:(NSDictionary *)dictionary
{
    
    [self.darenHeader sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!1",dictionary[@"headUrl"]]]];
    
    self.nickName.text = dictionary[@"nickname"];
    self.nickName.font  = [UIFont systemFontOfSize:16.0];
    CGSize nicksize = [self.nickName.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.nickName.font,NSFontAttributeName, nil]];
    self.nickName.frame = CGRectMake(self.darenHeader.frame.origin.x+self.darenHeader.frame.size.width+10, self.darenHeader.center.y-nicksize.height/2, nicksize.width, nicksize.height);
    
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy";
    NSString *year = [formatter stringFromDate:today];
    int yearnow = year.intValue;
    int birthyear = [[dictionary objectForKey:@"year"]intValue];
    int age = yearnow - birthyear;
    self.ageLabel.text = [NSString stringWithFormat:@"%d",age];
    self.ageLabel.textColor = RGB(174, 174, 174);
    self.ageLabel.font = [UIFont systemFontOfSize:14.0];
    CGSize sizeAge = [self.ageLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.ageLabel.font,NSFontAttributeName, nil]];
    self.ageLabel.frame = CGRectMake(_nickName.frame.origin.x+_nickName.frame.size.width+10, _nickName.center.y-sizeAge.height/2, sizeAge.width, sizeAge.height);
    _sexImage.frame = CGRectMake(_ageLabel.frame.origin.x+_ageLabel.frame.size.width+5,self.ageLabel.center.y-7, 14, 14);
    if ([dictionary[@"sex"] isEqualToString:@"男"]) {
        _sexImage.image = [UIImage imageNamed:@"nansheng_logo"];
    }else{
        _sexImage.image = [UIImage imageNamed:@"nvsheng_logo"];
    }
    
}
@end
