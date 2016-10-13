//
//  showAlertView.m
//  MeiWan
//
//  Created by user_kevin on 16/10/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "showAlertView.h"

@implementation showAlertView

+ (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }
    else
    {
        return [app keyWindow];
    }
    
}

+ (UIWindow *)lastWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    return app.windows.lastObject;
}

+(void)showAlertView:(NSString *)message
{
    
    UIWindow * window = [self lastWindow];//[UIApplication sharedApplication].keyWindow;


    
    UIView * view = [[UIView alloc]init];
    view.center = CGPointMake(dtScreenWidth/2, dtScreenHeight/2);
    view.bounds = CGRectMake(0, 0, dtScreenWidth-80, 200);
    view.backgroundColor = [UIColor redColor];
    view.layer.cornerRadius = 5;
    view.clipsToBounds = YES;
    
    [window addSubview:view];

}

@end
