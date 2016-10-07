//
//  FindPassWordViewController.m
//  MeiWan
//
//  Created by apple on 15/10/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "FindPassWordViewController.h"
#import "JKCountDownButton.h"
#import "CorlorTransform.h"
#import "ShowMessage.h"
#import "MD5.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "registInfo.h"
@interface FindPassWordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *verityCode;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *country;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet JKCountDownButton *getcode;
@property (weak, nonatomic) IBOutlet UIButton *makeSureButton;
@property (strong,nonatomic) registInfo *myregistInfo;
@end

@implementation FindPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    self.getcode.layer.masksToBounds = YES;
    self.getcode.layer.cornerRadius = 6;
    self.number.layer.masksToBounds = YES;
    self.number.layer.cornerRadius = 6;
    self.makeSureButton.layer.masksToBounds = YES;
    self.makeSureButton.layer.cornerRadius = 6;
//    self.getcode.backgroundColor=[CorlorTransform colorWithHexString:@"F8F39F"];
//    self.country.backgroundColor = [CorlorTransform colorWithHexString:@"#ffb6c1"];
    // Do any additional setup after loading the view.
}
- (IBAction)registkeyboard:(UITextField *)sender {
    [self.password  resignFirstResponder];
}
- (IBAction)getCode:(JKCountDownButton *)sender {
    if (self.phone.text.length == 11) {
        [sender startWithSecond:60];
        
        [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
            NSString *title = [NSString stringWithFormat:@"已发送(%d)",second];
            countDownButton.enabled = NO;
            return title;
        }];
        [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
            countDownButton.enabled = YES;
            return @"获取验证码";
        }];
        NSString *sign = @"com.cj.peiwan";
        NSString *key = [NSString stringWithFormat:@"%@%@",sign,self.phone.text];
        NSString *md5Sign = [MD5 md5:key];
        [UserConnector sendCode2:self.phone.text sign:md5Sign receiver:^(NSData *data,NSError *error){
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            NSNumber *status=[json objectForKey:@"status"];
            if(status.intValue==0){
                 //NSLog(@"%@",code);
                
            }else if(status.intValue==1){
                [ShowMessage showMessage:@"发送短信失败"];
                [self.getcode stop];
                
            }else{
            }
        }];
    }else{
        [ShowMessage showMessage:@"用户名为您的手机号"];
    }
}
- (IBAction)makeSure:(UIButton *)sender {
    if (!(self.phone.text.length == 11)) {
        [ShowMessage showMessage:@"用户名是您的手机号"];
    }else if (self.phone.text.length == 11 && !(self.verityCode.text.length == 4)){
        [ShowMessage showMessage:@"验证码是四位数字"];
    }else if (self.phone.text.length == 11 && self.verityCode.text.length == 4 && !(self.password.text.length >= 6 && self.password.text.length <= 18)){
        [ShowMessage showMessage:@"密码长度需大于六位小于十八位"];
    }else if (self.phone.text.length == 11 && self.verityCode.text.length == 4 && self.password.text.length >= 6 && self.password.text.length <= 18){
        //NSLog(@"注册开始");
        [self.getcode stop];
        [UserConnector resetPwd:self.phone.text password:[MD5 md5:self.password.text] verifyCode:self.verityCode.text receiver:^(NSData * data, NSError * error) {
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser *parser = [[SBJsonParser alloc]init];
                NSDictionary *infoDic = [parser objectWithData:data];
                int status = [[infoDic objectForKey:@"status"]intValue];
                if (status == 0) {
                    [ShowMessage showMessage:@"修改密码成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }else if (status == 1){
                    [ShowMessage showMessage:@"验证码错误"];
                    
                }else if (status == 2){
                    [ShowMessage showMessage:@"用户不存在"];
                }else{
                    
                }
            }
        }];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
