//
//  DiscussCell.m
//  MeiWan
//
//  Created by apple on 15/11/12.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "DiscussCell.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "UIImageView+WebCache.h"
@implementation DiscussCell

- (void)awakeFromNib {
    // Initialization code
    self.nickName.font = [UIFont systemFontOfSize:14];
    self.content.font = [UIFont systemFontOfSize:14];
    self.publicationTime.font = [UIFont systemFontOfSize:14];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeadImg:)];
    self.headImg.userInteractionEnabled = YES;
    [self.headImg addGestureRecognizer:tap];
}
- (void)tapHeadImg:(UITapGestureRecognizer*)sender{
    [self.delegate tapHeadImg:self.discussDic];
}
- (void)setDiscussDic:(NSDictionary *)discussDic{
    _discussDic = discussDic;
    NSArray * stateReplies = [discussDic objectForKey:@"stateReplies"];
    if (stateReplies) {
        self.content.text = [discussDic objectForKey:@"content"];
    }else{
        NSDictionary * toUserDic = [discussDic objectForKey:@"toUser"];
        self.content.text = [NSString stringWithFormat:@"回复 %@ : %@",[toUserDic objectForKey:@"nickname"],[discussDic objectForKey:@"content"]];
    }
    NSDictionary * fromUserDic = [discussDic objectForKey:@"fromUser"];
    self.nickName.text = [fromUserDic objectForKey:@"nickname"];
    NSURL *headUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",[fromUserDic objectForKey:@"headUrl"]]];
    [self.headImg setImageWithURL:headUrl];
    double lastActiveTime = [[discussDic objectForKey:@"createTime"]doubleValue];
    //NSLog(@"%f",lastActiveTime) ;
    self.publicationTime.text = [DateTool getTimeDescription:lastActiveTime];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
