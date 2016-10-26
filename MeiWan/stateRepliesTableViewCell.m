//
//  stateRepliesTableViewCell.m
//  MeiWan
//
//  Created by user_kevin on 16/10/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "stateRepliesTableViewCell.h"

@interface stateRepliesTableViewCell ()

@property(nonatomic,strong)UILabel * fromNickname;
@property(nonatomic,strong)UILabel * contentText;
@property(nonatomic,strong)UILabel * RepliesFromUser;
@property(nonatomic,strong)UILabel * RepliesToUser;
@property(nonatomic,strong)UILabel * RepliesContentText;

@end

@implementation stateRepliesTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.fromNickname = [[UILabel alloc]init];
        [self addSubview:_fromNickname];
        
        _contentText = [[UILabel alloc]init];
        [self addSubview:_contentText];
        
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setStateMessage:(NSDictionary *)stateMessage
{
    CGRect frame = [self frame];
    NSLog(@"%@",stateMessage);
    NSDictionary * fromUser = stateMessage[@"fromUser"];
    NSDictionary * toUser = stateMessage[@"toUser"];
    NSString * userNickname;
    self.fromNickname.textColor = [CorlorTransform colorWithHexString:@"#79D3FA"];
    if (toUser != nil) {
         userNickname = [NSString stringWithFormat:@"%@ 回复  %@:",fromUser[@"nickname"],toUser[@"nickname"]];
        NSMutableAttributedString * changeText = [[NSMutableAttributedString alloc]initWithString:userNickname];
        NSRange range = [[changeText string]rangeOfString:@"回复"];
        [changeText addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
        self.fromNickname.attributedText = changeText;
    }else{
         userNickname = [NSString stringWithFormat:@"%@ :",fromUser[@"nickname"]];
        self.fromNickname.text = userNickname;
    }
    
    self.fromNickname.font = [FontOutSystem fontWithFangZhengSize:15.0];
    CGSize size_userNickname = [userNickname sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.fromNickname.font,NSFontAttributeName, nil]];
    self.fromNickname.frame = CGRectMake(10, 15-size_userNickname.height/2, size_userNickname.width, size_userNickname.height);
    self.contentText.numberOfLines = 0;
    self.contentText.text = [NSString stringWithFormat:@"%@",stateMessage[@"content"]];
    self.contentText.font = [FontOutSystem fontWithFangZhengSize:15.0];
    CGSize size = CGSizeMake(dtScreenWidth-(self.fromNickname.frame.origin.x+self.fromNickname.frame.size.width+10)-10, 1000);
    
    CGSize size_congtentText = [self.contentText.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:_contentText.font,NSFontAttributeName, nil] context:nil].size;
    self.contentText.frame = CGRectMake(self.fromNickname.frame.origin.x+self.fromNickname.frame.size.width+5, self.fromNickname.frame.origin.y, size_congtentText.width, size_congtentText.height);
    
    frame.size.height = self.fromNickname.frame.origin.y+size_congtentText.height+10;
    self.frame = frame;
}

@end
