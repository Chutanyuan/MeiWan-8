//
//  userEditCell.m
//  MeiWan
//
//  Created by user_kevin on 16/9/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "userEditCell.h"

@implementation userEditCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.showMessage = [[UILabel alloc]init];
        self.showMessage.frame = CGRectMake(150, 0, dtScreenWidth-30-150, self.frame.size.height);
        self.showMessage.textAlignment = NSTextAlignmentRight;
        self.showMessage.font = [UIFont systemFontOfSize:12.0];
        self.showMessage.textColor = [UIColor blackColor];
        [self addSubview:_showMessage];
        
    }
    return self;
}

-(void)setDic:(NSDictionary *)dic
{
    
}

@end
