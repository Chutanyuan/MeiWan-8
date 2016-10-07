//
//  daRenCell.h
//  MeiWan
//
//  Created by user_kevin on 16/8/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface daRenCell : UITableViewCell

@property(nonatomic,strong)UIImageView * darenHeader;
@property(nonatomic,strong)UILabel * nickName;
@property(nonatomic,strong)UILabel * ageLabel;
@property(nonatomic,strong)UIImageView * sexImage;

@property(nonatomic,strong)NSDictionary * dictionary;

@end
