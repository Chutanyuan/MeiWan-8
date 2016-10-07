//
//  BanlanceViewController.m
//  MeiWan
//
//  Created by apple on 15/10/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "BanlanceViewController.h"
#import "ShowMessage.h"
#import "UserInfo.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "LoginViewController.h"
#import "CorlorTransform.h"
@interface BanlanceViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *money;
@property (weak, nonatomic) IBOutlet UILabel *listMoney;
@property (weak, nonatomic) IBOutlet UIButton *getMoney;
@property (nonatomic,strong) UserInfo *userinfo;
@end

@implementation BanlanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userinfo = [[UserInfo alloc]initWithDictionary:self.infoDic];
    self.getMoney.backgroundColor = [CorlorTransform colorWithHexString:@"#36C8FF"];
    self.getMoney.layer.cornerRadius = 5;
    self.listMoney.text = [NSString stringWithFormat:@"%.1f",self.userinfo.money];

    // Do any additional setup after loading the view.
}
- (IBAction)getMoney:(UIButton *)sender {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提现" message:@"请输入金额" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *inputTF = [alert textFieldAtIndex:0];
        inputTF.keyboardType = UIKeyboardTypeNumberPad;
        [alert show];
   
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UITextField *inputTF = [alertView textFieldAtIndex:0];
    NSString *input = inputTF.text;
    int inputNum = [input intValue];
    if (inputNum < 300) {
        [ShowMessage showMessage:@"提现金额最低金额为300元"];
        return;
    }
    if (buttonIndex == 1) {
        if (input.length == 0) {
            [ShowMessage showMessage:@"输入不能为空"];
            return;
        }else if (inputNum%100==0){
            NSString *session = [PersistenceManager getLoginSession];
            [UserConnector createCashRequest:session money:[NSNumber numberWithDouble:inputNum] receiver:^(NSData *data, NSError *error){
                if (error) {
                    [ShowMessage showMessage:@"服务器未响应"];
                }else{
                    SBJsonParser*parser=[[SBJsonParser alloc]init];
                    NSMutableDictionary *json=[parser objectWithData:data];
                    //NSLog(@"%f",inputNum);
                    //NSLog(@"%@",json);
                    int status = [[json objectForKey:@"status"]intValue];
                    if (status == 0) {
                        self.listMoney.text = [NSString stringWithFormat:@"%.1f",
                                               self.userinfo.money - inputNum];
                        self.userinfo.money -= inputNum;
                        [ShowMessage showMessage:@"提现成功，三天内到账"];
                    }else if(status == 1){
                        [PersistenceManager setLoginSession:@""];
                        
                        LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                        lv.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:lv animated:YES];
                        
                        
                    }else if (status == 2){
                        [ShowMessage showMessage:@"余额不足"];
                    }else if (status == 3){
                        
                    }else{
                        
                    }
                }
                
            }];
            
        }else{
            [ShowMessage showMessage:@"提现金额需要是100的整值"];
        }
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
