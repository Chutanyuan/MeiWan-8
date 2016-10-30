//
//  insterestChooseVC.m
//  MeiWan
//
//  Created by user_kevin on 16/9/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "insterestChooseVC.h"
#import "MeiWan-Swift.h"
#import "ShowMessage.h"
#import "SBJsonParser.h"
@interface insterestChooseVC ()
{
    
    UIImageView * StarSign;
    NSArray * starSignImage;
}
@end

@implementation insterestChooseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray * statusArray = @[@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"魔羯座",@"水瓶座",@"双鱼座"];
    starSignImage = @[@"baiyang",@"jinniu",@"shuangzi",@"juxie",@"shizi",@"chunv",@"tiancheng",@"tianxie",@"sheshou",@"mojie",@"shuiping",@"shuangyu"];
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
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
    }
    
    StarSign = [[UIImageView alloc]initWithFrame:CGRectMake(dtScreenWidth/2-35, 74+4*45+52, 70, 70)];
    StarSign.layer.cornerRadius = 35;
    StarSign.clipsToBounds = YES;
    [self.view addSubview:StarSign];

}
- (void)buttonClick:(UIButton *)sender
{
    NSString * session = [PersistenceManager getLoginSession];
    NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:sender.titleLabel.text,@"xingzuo", nil];
    [UserConnector update:session parameters:userInfoDic receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            SBJsonParser * parser = [[SBJsonParser alloc]init];
            NSDictionary * json = [parser objectWithData:data];
            int status = [json[@"status"] intValue];
            if (status==0) {
                [PersistenceManager setLoginUser:json[@"entity"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"finish_zodiac" object:sender.titleLabel.text];
//                [self.navigationController popViewControllerAnimated:YES];
                
            }
        }
    }];
    [UIView animateWithDuration:0.3 animations:^{
        StarSign.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",starSignImage[sender.tag]]];
    }];
    
}
@end
