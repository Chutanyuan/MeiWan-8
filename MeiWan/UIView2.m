//
//  UIView2.m
//  MeiWan
//
//  Created by user_kevin on 16/10/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIView2.h"

@interface UIView2 ()<UITextViewDelegate>

@end

@implementation UIView2

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UITextView * textview = [[UITextView alloc]initWithFrame:CGRectMake(10, 100, frame.size.width-20, 130)];
        textview.layer.borderColor = [UIColor whiteColor].CGColor;
        textview.layer.borderWidth = 1;
        textview.backgroundColor = [UIColor clearColor];
        textview.delegate = self;
        [self addSubview:textview];
        self.textview = textview;
        
        UILabel * label = [[UILabel alloc]init];
        label.text = @"反馈问题意见时,请留下您的手机号码或其他联系方式,非常感谢您的宝贵意见!";
        label.numberOfLines = 2;
        label.font = [FontOutSystem fontWithFangZhengSize:13.0];
        CGSize size_label = [label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName, nil]];
        label.frame = CGRectMake(10, textview.frame.origin.y+textview.frame.size.height+5, textview.frame.size.width, size_label.height*2);
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        
    }
    return self;
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self.delegate textViewEndEdit:textView];
}
@end
