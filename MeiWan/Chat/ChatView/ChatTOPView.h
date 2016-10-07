//
//  ChatTOPView.h
//  MeiWan
//
//  Created by user_kevin on 16/8/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol chatInviteDelegate <NSObject>

- (void)inviteButtonClick:(UIButton *)sender;

@end

@interface ChatTOPView : UIView

@property(nonatomic,strong)NSArray * userTimeTags;
@property(nonatomic,weak)id<chatInviteDelegate>delegate;

@end
