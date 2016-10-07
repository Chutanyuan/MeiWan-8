//
//  firstPage_scrollViewCell.h
//  beautity_play
//
//  Created by user_kevin on 16/6/26.
//  Copyright © 2016年 user_kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol firstPage_scrollViewCellDelegate <NSObject>

- (void)buttonClick:(UIButton *)sender;

@end

@interface firstPage_scrollViewCell : UITableViewCell

@property(nonatomic,weak)id<firstPage_scrollViewCellDelegate>delegate;

@end
