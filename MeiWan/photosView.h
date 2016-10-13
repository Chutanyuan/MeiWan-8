//
//  photosView.h
//  MeiWan
//
//  Created by user_kevin on 16/10/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol photosTouchUpdataDelegate <NSObject>

- (void)phototsTouch:(UIImageView *)imageview;

@end

@interface photosView : UIView

@property(nonatomic,strong)NSDictionary * UserMessage;

@property(nonatomic,weak)id<photosTouchUpdataDelegate>delegate;

@end
