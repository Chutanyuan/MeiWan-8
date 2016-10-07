//
//  HTMView.m
//  MeiWan
//
//  Created by MacBook Air on 16/9/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HTMView.h"

@interface HTMView()<UIWebViewDelegate>

//
@property(nonatomic,strong)UILabel * showlabel;

@end

@implementation HTMView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
      
        UIWebView * webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth-40, dtScreenHeight-200)];
        webview.delegate = self;
  
        webview.scrollView.showsVerticalScrollIndicator = NO;
        webview.scrollView.showsHorizontalScrollIndicator = NO;
        
        NSString * htmPath = [[NSBundle mainBundle]pathForResource:@"useruse_protocol" ofType:@"htm"];
        NSURL * baseURL = [NSURL fileURLWithPath:htmPath];
        NSString * htm = [NSString stringWithContentsOfFile:htmPath encoding:NSUTF8StringEncoding error:nil];
        [webview loadHTMLString:htm baseURL:baseURL];
        [self addSubview:webview];
        
        self.showlabel = [[UILabel alloc]init];
        self.showlabel.center = webview.center;
        self.showlabel.bounds = CGRectMake(0, 0, 100, 100);
        [webview addSubview:self.showlabel];
   
        self.showlabel.hidden = YES;
        
        UIButton * DontAgreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [DontAgreeButton setTitle:@"不同意" forState:UIControlStateNormal];
        [DontAgreeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        DontAgreeButton.backgroundColor = [UIColor whiteColor];
        DontAgreeButton.frame = CGRectMake(0, webview.frame.origin.y+webview.frame.size.height, (dtScreenWidth-40)/2, 60);
        [DontAgreeButton addTarget:self action:@selector(dontAgreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:DontAgreeButton];
        
        UIButton * agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [agreeButton setTitle:@"同意" forState:UIControlStateNormal];
        [agreeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        agreeButton.backgroundColor = [UIColor whiteColor];
        agreeButton.frame = CGRectMake((dtScreenWidth-40)/2, webview.frame.origin.y+webview.frame.size.height, (dtScreenWidth-40)/2, 60);
        [agreeButton addTarget:self action:@selector(agreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:agreeButton];
        
        
        UIView * lineview = [[UIView alloc]initWithFrame:CGRectMake((dtScreenWidth-40)/2, agreeButton.frame.origin.y, 1, 60)];
        lineview.backgroundColor = [UIColor blackColor];
        [self addSubview:lineview];
        
        __block NSInteger timeOut = 5;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        //每秒执行一次
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_timer, ^{
            
            //倒计时结束，关闭
            if (timeOut <= 0) {
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    DontAgreeButton.backgroundColor = [UIColor whiteColor];
                    agreeButton.backgroundColor = [UIColor whiteColor];
                    DontAgreeButton.userInteractionEnabled = YES;
                    agreeButton.userInteractionEnabled = YES;
                });
            } else {

                dispatch_async(dispatch_get_main_queue(), ^{
                    DontAgreeButton.backgroundColor = [UIColor grayColor];
                    agreeButton.backgroundColor = [UIColor grayColor];
                    DontAgreeButton.userInteractionEnabled = NO;
                    agreeButton.userInteractionEnabled = NO;
                });
                timeOut--;
            }
        });
        dispatch_resume(_timer);
    }
    return self;
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
//    self.showlabel.hidden = NO;
//    self.showlabel.text = @"加载中";
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    self.showlabel.hidden = NO;
//    self.showlabel.text = @"加载完成";
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    self.showlabel.hidden = NO;
//    self.showlabel.text = @"加载失败";
}
- (void)dontAgreeButtonClick:(UIButton *)sender
{
    [self.delegate dontAgreeButtonAction:sender];
}
- (void)agreeButtonClick:(UIButton *)sender
{
    NSUserDefaults * userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:@"yes" forKey:@"userAgreeDelegate"];
    [userdefaults synchronize];
    [self.delegate agreeButtonAction:sender];
}
@end
