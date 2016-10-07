//
//  TimeLabelTableViewCell.h
//  beautity_play
//
//  Created by Fox on 16/7/13.
//  Copyright © 2016年 user_kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLabelTableViewCell : UITableViewCell

@property(nonatomic, strong)NSDictionary *playerInfo;

@property (nonatomic, strong)UILabel * noneLabel;

@property (nonatomic, strong)UIImageView *titleImage;
@property (nonatomic, strong)UILabel *timeTitleLabel;

@property (nonatomic, strong)UIImageView *timeImage1;
@property (nonatomic, strong)UILabel *timeTitle1;
@property (nonatomic, strong)UILabel *priseLabel1;

@property (nonatomic, strong)UIImageView *timeImage2;
@property (nonatomic, strong)UILabel *timeTitle2;
@property (nonatomic, strong)UILabel *priseLabel2;

@property (nonatomic, strong)UIImageView *timeImage3;
@property (nonatomic, strong)UILabel *timeTitle3;
@property (nonatomic, strong)UILabel *priseLabel3;

@end
