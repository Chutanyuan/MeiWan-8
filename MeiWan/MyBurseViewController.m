//
//  MyBurseViewController.m
//  MeiWan
//
//  Created by apple on 15/8/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MyBurseViewController.h"
#import "ShowMessage.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "LoginViewController.h"
#import "BanlanceViewController.h"
#import "RecordTableViewController.h"
#import "AliHelper.h"
#import "MBProgressHUD.h"
#import "PrepaidViewController.h"
@interface MyBurseViewController ()<MBProgressHUDDelegate>{
    MBProgressHUD * HUD;
}
@property (weak, nonatomic) IBOutlet UILabel *TopUp;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (nonatomic,strong) NSDictionary *userDic;

@end

@implementation MyBurseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.tabBarController.tabBar.hidden = YES;

}
- (void)refreshMoney{
    
    NSString *session = [PersistenceManager getLoginSession];
    NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionary];
    [UserConnector update:session parameters:userInfoDic receiver:^(NSData *data, NSError *error){
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];

            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                self.userDic = [json objectForKey:@"entity"];
                self.balance.text = [NSString stringWithFormat:@"%.1f",[[self.userDic objectForKey:@"money"]doubleValue]];
                self.TopUp.text = [NSString stringWithFormat:@"%.2f",[self.userDic[@"money2"] doubleValue]];
                self.phone.text = self.userDic[@"alipayUsername"];

            }else if(status == 1){
                [PersistenceManager setLoginSession:@""];
                LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                lv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:lv animated:YES];
                
            }
        }
        
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self refreshMoney];
}
- (IBAction)change:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"更换账号" message:@"请输入账号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}
- (IBAction)TOPUP:(id)sender {
    
    PrepaidViewController * prepaid = [[PrepaidViewController alloc]init];
    prepaid.userMessage = self.userDic;
    [self.navigationController pushViewController:prepaid animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *input = [alertView textFieldAtIndex:0].text;
    if (buttonIndex == 1) {
        if (input.length == 0) {
            [ShowMessage showMessage:@"账号不能为空"];
            return;
        }else{
            NSString *session = [PersistenceManager getLoginSession];
            NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:input,@"alipayUsername",nil];
            [UserConnector update:session parameters:userInfoDic receiver:^(NSData *data, NSError *error){
                if (error) {
                    [ShowMessage showMessage:@"服务器未响应"];
                }else{
                    SBJsonParser*parser=[[SBJsonParser alloc]init];
                    NSMutableDictionary *json=[parser objectWithData:data];
                    //NSLog(@"%@",json);
                    int status = [[json objectForKey:@"status"]intValue];
                    if (status == 0) {
                        self.userDic = [json objectForKey:@"entity"];
                        [self.delegate burseInfo:self.userDic];
                        self.phone.text = input;
                        [ShowMessage showMessage:@"更换成功"];
                    }else if(status == 1){
                        [PersistenceManager setLoginSession:@""];
                        LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                        lv.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:lv animated:YES];

                    }
                }
                
            }];
         }
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"getmoney"]) {
        BanlanceViewController *bv = segue.destinationViewController;
        bv.infoDic = self.userDic;
    }
    if ([segue.identifier isEqualToString:@"record"]) {
        RecordTableViewController *rv = segue.destinationViewController;
        rv.hidesBottomBarWhenPushed = YES;
    }
}

@end
