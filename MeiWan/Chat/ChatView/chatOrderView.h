//
//  chatOrderView.h
//  MeiWan
//
//  Created by user_kevin on 16/8/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChatOrderViewDelegate <NSObject>

- (void)evaluateButtonClick:(UIButton *)sender;
- (void)pleaseEvaluateButtonClick:(UIButton *)sender;
- (void)acceptOrderButtonClick:(UIButton *)sender;
- (void)doneOrderButtonClick:(UIButton *)sender;
- (void)RejectButtonClick:(UIButton *)sender;
- (void)applyRequestButtonClick:(UIButton *)sender;
- (void)revokeRequestButtonClick:(UIButton *)sender;

@end
@interface chatOrderView : UIView

@property(nonatomic,strong)NSDictionary * orderMessage;
@property(nonatomic,strong)NSDictionary * PeiWanDic;
@property(nonatomic,strong)UIButton * DoneButton;
@property(nonatomic,strong)UIButton * evaluate;
@property(nonatomic,weak)id<ChatOrderViewDelegate>delegate;

@end
