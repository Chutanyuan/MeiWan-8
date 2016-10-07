//
//  RecordTableViewCell.m
//  MeiWan
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RecordTableViewCell.h"
#import "Meiwan-Swift.h"
@implementation RecordTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setInfodic:(NSDictionary *)infodic{
    _infodic = infodic;
    self.howMany.text = [NSString stringWithFormat:@"💰%.1f",[[infodic objectForKey:@"money"]doubleValue]];
    int status = [[infodic objectForKey:@"status"]intValue];
    if (status == 0) {
        self.status.text = @"处理中";
        self.status.textColor = [UIColor grayColor];
    }else if(status == 1){
        self.status.text = @"已处理";
        self.status.textColor = [UIColor greenColor];
    }else if(status == 2){
        self.status.text = @"已驳回";
        self.status.textColor = [UIColor redColor];
    }
    double time = [[infodic objectForKey:@"createTime"]doubleValue];
    self.time.text = [DateTool getTimeDescription:time];
    self.time.textColor = [UIColor grayColor];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
