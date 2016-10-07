//
//  HTMView.h
//  MeiWan
//
//  Created by MacBook Air on 16/9/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTMViewButtonAction <NSObject>

- (void)agreeButtonAction:(UIButton *)sender;
- (void)dontAgreeButtonAction:(UIButton *)sender;

@end

@interface HTMView : UIView
@property(nonatomic,weak)id<HTMViewButtonAction>delegate;
@end
