//
//  FansTableViewCell.h
//  MeiWan
//
//  Created by Fox on 16/7/28.
//  Copyright © 2016年 apple. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^FansTableViewCellBlock)(NSDictionary * fansDic,NSIndexPath * indexPath);

@interface FansTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *headImageView;

@property (nonatomic, strong)UILabel *nameLabel;

@property (nonatomic, strong)UIView *sexAgeView;

@property (nonatomic, strong)UILabel *ageLabel;

@property (nonatomic, strong)UIImageView *sexImageView;

@property (nonatomic, strong)UIButton *fansButton;

@property (strong, nonatomic)NSDictionary *fansDic;

@property (strong,nonatomic)NSIndexPath * indexPath;

@property (strong,nonatomic)FansTableViewCellBlock tappedBlock;

@end
