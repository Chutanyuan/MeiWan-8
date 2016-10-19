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
    
    UIView * alphaview = [[UIView alloc]initWithFrame:window.frame];
    alphaview.backgroundColor = [UIColor blackColor];
    alphaview.alpha = 0.2;
    [window addSubview:alphaview];
    
    UIView * view = [[UIView alloc]init];
    view.center = CGPointMake(dtScreenWidth/2, dtScreenHeight/2);
    view.bounds = CGRectMake(0, 0, dtScreenWidth-80, 200);
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 5;
    view.clipsToBounds = YES;
    view.layer.borderColor = [CorlorTransform colorWithHexString:@"#e8e8e8"].CGColor;
    view.layer.borderWidth = 0.5;
    [window addSubview:view];
    
    UILabel * titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 40)];
    titlelabel.font = [FontOutSystem fontWithFangZhengSize:17.0];
    titlelabel.text = @"温馨提示";
    titlelabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titlelabel];
    
    UILabel * contentText = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, view.frame.size.width, view.frame.size.height-44-40)];
    contentText.textAlignment = NSTextAlignmentCenter;
    contentText.numberOfLines = 0;
    contentText.text = message;
    contentText.backgroundColor = [CorlorTransform colorWithHexString:@"#e8e8e8"];
    contentText.font = [FontOutSystem fontWithFangZhengSize:15.0];
    [view addSubview:contentText];
    UIButton * cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(0,view.frame.size.height-44, view.frame.size.width/2, 44);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[CorlorTransform colorWithHexString:@"#b2b2b2"] forState:UIControlStateNormal];
    [view addSubview:cancel];
    
    UIButton * sure = [UIButton buttonWithType:UIButtonTypeCustom];
    [sure setTitleColor:[CorlorTransform colorWithHexString:@"#78cdf8"] forState:UIControlStateNormal];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    sure.frame = CGRectMake(view.frame.size.width/2, view.frame.size.height-44, view.frame.size.width/2, 44);
    [sure setImage:[UIImage imageNamed:@"OK"] forState:UIControlStateSelected];
    [sure addTarget:self action:@selector(sureButton:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sure];
}
- (void)sureButton:(UIButton *)sender
{
    NSLog(@"%@",sender.titleLabel.text);
}
@end
