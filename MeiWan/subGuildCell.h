//
//  subGuildCell.h
//  MeiWan
//
//  Created by user_kevin on 16/8/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface subGuildCell : UITableViewCell

@property(nonatomic,strong)UIImageView * guildImage;
@property(nonatomic,strong)UILabel * guildName;
@property(nonatomic,strong)UILabel * huiZhang;
@property(nonatomic,strong)UILabel * accumulate;

@property(nonatomic,strong)NSDictionary * dictionary;

@end
