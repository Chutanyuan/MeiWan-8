//
//  GetinViewController.m
//  MeiWan
//
//  Created by apple on 15/8/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GetinViewController.h"
#import "CorlorTransform.h"
#import "SBJson.h"
#import "ShowMessage.h"
#import "MD5.h"
#import "UserInfo.h"
#import "setting.h"
#import "Meiwan-Swift.h"
#import "MBProgressHUD.h"

@interface GetinViewController ()<MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *password;

//@property (weak, nonatomic) IBOutlet UILabel *number;
//@property (weak, nonatomic) IBOutlet UILabel *background;
//@property (weak, nonatomic) IBOutlet UILabel *tellphoneBackground;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *infoImage;

@end

@implementation GetinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"登录";
    [self.navigationController.navigationBar setBarTintColor:[CorlorTransform colorWithHexString:@"#3f90a4"]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor]forKey:NSForegroundColorAttributeName];
    self.loginButton.layer.cornerRadius = 8;
    self.loginButton.layer.masksToBounds = YES;
    
    self.phone.layer.borderColor = (__bridge CGColorRef _Nullable)([CorlorTransform colorWithHexString:@"#3f90a4"]);
    self.phone.layer.borderWidth = 0.1f;
    
    self.password.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor clearColor]);
    self.password.layer.borderWidth = 0.1f;
    
//    self.number.backgroundColor = [CorlorTransform colorWithHexString:@"#ffb6c1"];
//    self.background.backgroundColor=[CorlorTransform colorWithHexString:@"D1EFF7"];
    
    self.phone.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"peiwan_ok"] style:UIBarButtonItemStylePlain target:self action:nil];
     // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    [self.phone becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.phone resignFirstResponder];
}
- (IBAction)moveKeyboard:(id)sender {
    [self.phone resignFirstResponder];
    [self.password resignFirstResponder];
}
- (IBAction)getIn:(UIButton *)sender {
    
//    [self performSegueWithIdentifier:@"players" sender:nil];
//    if (self.phone.text.length != 11) {
//        [self showMessage:@"用户名是您的手机号码"];
//    }else if (self.phone.text.length == 11 && (self.password.text.length < 6 || self.password.text.length > 18)){
//        [self showMessage:@"密码长度需要大于6位小于18位"];
//        
//    }else{
//       
//    }

    /**
     
     限制手机号码位数更改 目前不限制手机号码
     
     */
    
    NSString *password = [NSString stringWithString:[MD5 md5:self.password.text]];
    [UserConnector login:self.phone.text password:password receiver:^(NSData *data,NSError *error){
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser *parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [[json objectForKey:@"status"] intValue];
            if (status==1) {
                [self showMessage:@"账号或密码错误"];
            }else{
                
                MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                HUD.delegate = self;
                HUD.labelText = @"登录中";
                
                NSDictionary *userDict = [json objectForKey:@"entity"];
                NSString *session=[json objectForKey:@"extra"];
                [PersistenceManager setLoginUser:userDict];
                [PersistenceManager setLoginSession:session];
                [[NSUserDefaults standardUserDefaults]setObject:self.phone.text forKey:@"username"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                NSString * product = [NSString stringWithFormat:@"product_%@",userDict[@"id"]];
                NSString * passMD5 = [NSString stringWithString:[MD5 md5:product]];
                
                //环信用户组
                EMError *error = [[EMClient sharedClient] loginWithUsername:product password:passMD5];
                if (!error) {
                    NSLog(@"登录成功");
                    [self performSegueWithIdentifier:@"players" sender:nil];
                    [HUD hide:YES afterDelay:0];
                    [[EMClient sharedClient].chatManager getAllConversations];
                }else{
                    [ShowMessage showMessage:@"登录失败，请重新登录"];
                }
                
            }
        }
    }];
}

- (void)showMessage:(NSString *)string
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
    }];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    alertController.message = string;
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //NSLog(@"%@",segue.destinationViewController);
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
