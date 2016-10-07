//
//  OrderLiseCell.h
//  MeiWan
//
//  Created by user_kevin on 16/8/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderLiseCell : UITableViewCell

@property(nonatomic,strong)NSDictionary * dictionary;

/**用户头像 昵称 时间 提成 点击响应个人详情*/
@property(nonatomic,strong)UIImageView * userHeaderImageView;
@property(nonatomic,strong)UILabel * nickName;
@property(nonatomic,strong)UILabel * ageLabel;
@property(nonatomic,strong)UIImageView * sexImage;

@property(nonatomic,strong)UILabel * timeLable;
@property(nonatomic,strong)UILabel * moneyLabel;

@end
