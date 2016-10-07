//
//  findPeiWanCell.h
//  MeiWan
//
//  Created by user_kevin on 16/8/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol findPeiWanDelegate <NSObject>

- (void)ChatWithFriend;
- (void)AddFriend;

@end

@interface findPeiWanCell : UITableViewCell

@property(nonatomic,strong)NSDictionary * dictionary;
@property(nonatomic,strong)UIImageView * headerImage;
@property(nonatomic,strong)UILabel * nickname;
@property(nonatomic,strong)UILabel * age;
@property(nonatomic,strong)UIImageView * sex;
@property(nonatomic,strong)UIButton * chatButton;
@property(nonatomic,strong)UIButton * addButton;
@property(nonatomic,strong)UILabel * qianMing;

@property(nonatomic,weak)id<findPeiWanDelegate>delegate;

@end
