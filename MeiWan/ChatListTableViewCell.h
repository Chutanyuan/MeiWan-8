//
//  ChatListTableViewCell.h
//  MeiWan
//
//  Created by MacBook Air on 16/10/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatListTableViewCell : UITableViewCell

@property(nonatomic,strong)NSDictionary * playInfo;

@property(nonatomic,strong)UIImageView * chatHeader;
@property(nonatomic,strong)UILabel * chatNickname;

@end
