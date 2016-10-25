//
//  DetailWithPlayerTableViewCell.h
//  MeiWan
//
//  Created by user_kevin on 16/10/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol dongtaiZanDelegate <NSObject>

- (void)zanClickForNetAndAnimation:(UIButton *)sender userid:(double)userID statusID:(double)statusid;
- (void)KeyBoardLoadWithUserid:(double)userID statusID:(double)statusid;

@end

@interface DetailWithPlayerTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel * countlabel;

@property(nonatomic,strong)NSDictionary * detailDictionary;
@property(nonatomic,weak)id<dongtaiZanDelegate>delegate;

@end
