//
//  UIView2.h
//  MeiWan
//
//  Created by user_kevin on 16/10/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIView2Delegate <NSObject>

-(void)textViewEndEdit:(UITextView *)textView;

@end

@interface UIView2 : UIView

@property(nonatomic,strong)UITextView * textview;
@property(nonatomic,weak)id<UIView2Delegate>delegate;

@end
