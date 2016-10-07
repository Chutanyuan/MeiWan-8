//
//  emotionalState.m
//  MeiWan
//
//  Created by user_kevin on 16/9/6.
//  Copyright © 2016年 apple. All rights reserved.
//
//
//  editdescription.m
//  MeiWan
//
//  Created by user_kevin on 16/9/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "emotionalState.h"
#import "MeiWan-Swift.h"
#import "ShowMessage.h"
#import "SBJsonParser.h"

@interface emotionalState ()<UITextViewDelegate>

@end

@implementation emotionalState

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray * statusArray = @[@"单身",@"恋爱中",@"已婚",@"同性"];
    self.view.backgroundColor  = [UIColor whiteColor];
    CGFloat ButtonWidth = (dtScreenWidth-15)/3;
    for (int i = 0; i<4; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10+i%3*ButtonWidth, 74+i/3*45,ButtonWidth-5, 40);
        [button setTitle:[NSString stringWithFormat:@"%@",statusArray[i]] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 3;
        [button.layer setBorderColor:[UIColor grayColor].CGColor];
        [button.layer setBorderWidth:0.4];
        button.clipsToBounds = YES;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];

    }

}
- (void)buttonClick:(UIButton *)sender
{
    NSString * session = [PersistenceManager getLoginSession];
    NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:sender.titleLabel.text,@"love", nil];
    [UserConnector update:session parameters:userInfoDic receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            SBJsonParser * parser = [[SBJsonParser alloc]init];
            NSDictionary * json = [parser objectWithData:data];
            int status = [json[@"status"] intValue];
            if (status==0) {
                [PersistenceManager setLoginUser:json[@"entity"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"finish_nickname" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        }
    }];
}

@end

