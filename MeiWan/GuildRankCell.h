//
//  GuildRankCell.h
//  MeiWan
//
//  Created by user_kevin on 16/8/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuildRankCell : UITableViewCell

@property(nonatomic,strong)NSDictionary * dictionary;

@property(nonatomic,strong)UIImageView * guildLogo;
@property(nonatomic,strong)UILabel * guidName;
@property(nonatomic,strong)UILabel * shouYi;
@property(nonatomic,strong)UILabel * huiZhang;

@end
