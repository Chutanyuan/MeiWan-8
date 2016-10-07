//
//  CJKNavigationView.m
//  text
//
//  Created by user_kevin on 16/6/23.
//  Copyright © 2016年 user_kevin. All rights reserved.
//

#import "CJKNavigationView.h"

#define height_screen [UIScreen mainScreen].bounds.size.height
#define width_screen [UIScreen mainScreen].bounds.size.width
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]


@implementation CJKNavigationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = RGB(64, 144, 164);
        /**左侧按钮*/
        UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.center = CGPointMake(20, frame.size.height/2);
        leftButton.bounds = CGRectMake(0, 0, 20, 20);
        [leftButton setBackgroundImage:[UIImage imageNamed:@"list_2"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftButton];
        self.leftButton = leftButton;
        
        /**右侧按钮*/
        UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.center = CGPointMake(width_screen-20, frame.size.height/2);
        rightButton.bounds = CGRectMake(0, 0, 20, 20);
        [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightButton];
        self.rightButton = rightButton;
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, width_screen-80, 30)];
        titleLabel.text = @"title";
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        titleLabel.bounds = CGRectMake(0, 0, width_screen-80, frame.size.height);
        titleLabel.font = [UIFont systemFontOfSize:15.0];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    return self;
}
-(void)leftButtonClick:(UIButton *)sender
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:sender cache:YES];
    static int i = 0;
    i++;
    if (i%2==0) {
        [sender setBackgroundImage:[UIImage imageNamed:@"list_2"] forState:UIControlStateNormal];
    }else{
        [sender setBackgroundImage:[UIImage imageNamed:@"list3"] forState:UIControlStateNormal];
    }
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.delegate leftButtonClick:self.leftButton];
}
-(void)rightButtonClick:(UIButton *)sender
{
    [self.delegate rightButtonClick:sender];
}
@end
