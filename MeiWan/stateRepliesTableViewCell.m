//
//  stateRepliesTableViewCell.m
//  MeiWan
//
//  Created by user_kevin on 16/10/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "stateRepliesTableViewCell.h"

@implementation stateRepliesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setStateMessage:(NSDictionary *)stateMessage
{
    NSLog(@"%@",stateMessage);
}

@end
