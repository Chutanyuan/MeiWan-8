//
//  CJKCollectionViewCell.h
//  beautity_play
//
//  Created by user_kevin on 16/6/26.
//  Copyright © 2016年 user_kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJKCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView * userImage;
@property(nonatomic,strong)UILabel * hotNumber;
@property(nonatomic,strong)UILabel * nickNameLabel;
@property(nonatomic,strong)UILabel * ageLabel;
@property(nonatomic,strong)UILabel * locationLabel;
@property(nonatomic,strong)UILabel * priceLabel;
@property(nonatomic,strong)UILabel * loginTime;

@property(nonatomic,strong)UILabel * rightlabel;
@property(nonatomic,strong)UILabel * centerlabel;
@property(nonatomic,strong)UILabel * leftlabel;

@end
