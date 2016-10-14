//
//  view1.h
//  MeiWan
//
//  Created by user_kevin on 16/10/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIView1Delegate <NSObject>

-(void)textFieldEndEditing:(UITextField *)textField;

@end

@interface UIView1 : UIView

@property(nonatomic,strong)UITextField * textfiled;
@property(nonatomic,weak)id<UIView1Delegate>delegate;

@end
