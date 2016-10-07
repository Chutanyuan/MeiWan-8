//
//  musicChooseVC.m
//  MeiWan
//
//  Created by user_kevin on 16/9/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "musicChooseVC.h"
#import "MeiWan-Swift.h"
#import "ShowMessage.h"
#import "SBJsonParser.h"
@interface musicChooseVC ()
{
    UITextField* textfile;
}
@end

@implementation musicChooseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray * statusArray = @[@"治愈",@"流行",@"摇滚",@"民谣",@"电子",@"轻音乐",@"影视原声",@"AGG",@"怀旧"];
    
    self.view.backgroundColor  = [UIColor whiteColor];
    CGFloat ButtonWidth = (dtScreenWidth-15)/3;
    for (int i = 0; i<statusArray.count; i++) {
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
    textfile = [[UITextField alloc]initWithFrame:CGRectMake(10, 75+3*45, dtScreenWidth-20-100, 40)];
    textfile.placeholder = @"   其他";
    textfile.backgroundColor =  [CorlorTransform colorWithHexString:@"#EEE8CD"];
    textfile.layer.cornerRadius = 5;
    textfile.clipsToBounds = YES;
    [self.view addSubview:textfile];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(textfile.frame.origin.x+textfile.frame.size.width+10, textfile.frame.origin.y, 90, textfile.frame.size.height);
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [button setTitle:@"确认" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    button.backgroundColor = [CorlorTransform colorWithHexString:@"009999"];
    [button addTarget:self action:@selector(textfileTextSave:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}
- (void)textfileTextSave:(UIButton *)sender
{
    NSLog(@"%@",textfile.text);
    if ([textfile.text isEqualToString:@""]) {
        
        [ShowMessage showMessage:@"字符不能为空"];
        
    }else{
        
        NSString * session = [PersistenceManager getLoginSession];
        NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:textfile.text,@"music", nil];
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
}
- (void)buttonClick:(UIButton *)sender
{
    NSString * session = [PersistenceManager getLoginSession];
    NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:sender.titleLabel.text,@"music", nil];
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
