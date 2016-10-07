//
//  FocusTableViewCell.h
//  MeiWan
//
//  Created by Fox on 16/7/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FocusTableViewCell;
@protocol FocusTableViewCellDelegate <NSObject>

-(void)focusTableViewCell:(FocusTableViewCell *)cell userID:(NSString *)userID;

@end

@interface FocusTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *headImageView;

@property (nonatomic, strong)UILabel *nameLabel;

@property (nonatomic, strong)UIView *sexAgeView;

@property (nonatomic, strong)UILabel *ageLabel;

@property (nonatomic, strong)UIImageView *sexImageView;

@property (nonatomic, strong)UIButton *focusButton;

@property (strong, nonatomic)NSDictionary *focusDic;
@property (strong,nonatomic)NSDictionary * friendDic;

@property (strong, nonatomic)id<FocusTableViewCellDelegate>delegate;

@end
