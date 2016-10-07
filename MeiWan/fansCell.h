//
//  fansCell.h
//  MeiWan
//
//  Created by user_kevin on 16/7/31.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface fansCell : UITableViewCell

@property(nonatomic,strong)UIImageView * headerImage;
@property(nonatomic,strong)UILabel * nickname;
@property(nonatomic,strong)UILabel * ageLabel;
@property(nonatomic,strong)UIImageView * sexImage;
@property(nonatomic,strong)UIButton * fansButton;

@end
