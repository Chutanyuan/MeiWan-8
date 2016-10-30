//
//  RegistViewController.m
//  MeiWan
//
//  Created by apple on 15/8/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RegistViewController.h"
#import "CorlorTransform.h"
#import "ShowMessage.h"
#import "MD5.h"
#import "setting.h"
#import "SBJson.h"
#import "JKCountDownButton.h"
#import "SaveUserInfoViewController.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "UserInfo.h"

@interface RegistViewController ()<UIWebViewDelegate,UITextFieldDelegate>
/** 手机号码 */
@property (weak, nonatomic) IBOutlet UITextField *phone;
/**  */
@property (weak, nonatomic) IBOutlet UITextField *code;
/**  */
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (nonatomic, strong) UIWebView *wb;
@property (weak, nonatomic) IBOutlet UILabel *userProtocol;
@property (weak, nonatomic) IBOutlet UILabel *agreement;
@property (weak, nonatomic) IBOutlet JKCountDownButton *getcode;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (nonatomic ,strong) NSTimer *mytimer;
@property (nonatomic ,assign) int seconds;
@property (nonatomic , strong) NSDictionary *userInfoDic;
@property (nonatomic , strong) UserInfo *userinfo;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[CorlorTransform colorWithHexString:@"78cdf8"]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.userProtocol.userInteractionEnabled=YES;
//    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor]forKey:NSForegroundColorAttributeName];
    self.getcode.layer.masksToBounds = YES;
    self.getcode.layer.cornerRadius = 6;
    self.number.layer.masksToBounds = YES;
    self.number.layer.cornerRadius = 6;
//    self.getcode.backgroundColor=[CorlorTransform colorWithHexString:@"F8F39F"];
    self.userProtocol.userInteractionEnabled=YES;
//    self.number.backgroundColor = [CorlorTransform colorWithHexString:@"#ffb6c1"];
    self.userProtocol.textColor = [CorlorTransform colorWithHexString:@"#36C8FF"];

    self.myregistInfo = [[registInfo alloc]init];

    NSString *agreementStr = @"当你注册本软件代表你同意";
    NSMutableAttributedString *agreementAs = [[NSMutableAttributedString alloc]initWithString:agreementStr];
    [agreementAs addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:12]  range:NSMakeRange(0, agreementStr.length)];
    [agreementAs addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 10)];
    [agreementAs addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(10, 2)];
    self.agreement.attributedText = agreementAs;
    
    NSString *promptStr = @"《用户协议》";
    NSMutableAttributedString *promptAs = [[NSMutableAttributedString alloc]initWithString:promptStr];
    [promptAs addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:12]  range:NSMakeRange(0, promptStr.length)];
    
    [promptAs addAttribute:NSForegroundColorAttributeName value:[CorlorTransform colorWithHexString:@"#36C8FF"] range:NSMakeRange(0, 6)];
    [promptAs addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, 6)];
    self.userProtocol.attributedText = promptAs;
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"peiwan_ok"] style:UIBarButtonItemStylePlain target:self action:nil];
    
}

-(IBAction)moveKeyboard{
    [self.phone  resignFirstResponder];
    [self.code  resignFirstResponder];
}

- (IBAction)regist:(UIBarButtonItem *)sender {

    if (!(self.phone.text.length == 11)) {
        [ShowMessage showMessage:@"用户名是您的手机号"];
    }else if (self.phone.text.length == 11 && !(self.code.text.length == 4)){
        [ShowMessage showMessage:@"验证码是四位数字"];
    }else if (self.phone.text.length == 11 && self.code.text.length == 4 && !(self.passWord.text.length >= 6 && self.passWord.text.length <= 18)){
        [ShowMessage showMessage:@"密码长度需大于六位小于十八位"];
    }else if (self.phone.text.length == 11 && self.code.text.length == 4 && self.passWord.text.length >= 6 && self.passWord.text.length <= 18 && ![self.code.text isEqualToString:self.myregistInfo.verifyCode]){
        [ShowMessage showMessage:@"验证码错误"];
    }else if (self.phone.text.length == 11 && self.code.text.length == 4 && self.passWord.text.length >= 6 && self.passWord.text.length <= 18 && [self.code.text isEqualToString:self.myregistInfo.verifyCode]){
        //NSLog(@"注册开始");
        [self.getcode stop];
        self.myregistInfo.username = self.phone.text;
        self.myregistInfo.password = [MD5 md5:self.passWord.text];
        
        [self performSegueWithIdentifier:@"personInfo" sender:nil];
     }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"personInfo"]) {
        SaveUserInfoViewController *sv = segue.destinationViewController;
        sv.myregistInfo = self.myregistInfo;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    [self.phone becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [super viewWillAppear:YES];
    [self.phone resignFirstResponder];
}
- (IBAction)getCode:(JKCountDownButton*)sender{
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
        [UserConnector sendCode:self.phone.text sign:md5Sign receiver:^(NSData *data,NSError *error){
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            NSString *code = [json objectForKey:@"entity"];
            NSNumber *status=[json objectForKey:@"status"];
            if(status.intValue==0){
                self.myregistInfo.verifyCode = code;
                //NSLog(@"%@",code);

            }else if(status.intValue==1){
                [ShowMessage showMessage:@"发送短信失败"];
                [self.getcode stop];
                
            }else if(status.intValue==2){
                [ShowMessage showMessage:@"用户已经存在"];
                [self.getcode stop];
            }else{
            }
        }];
    }else{
        [ShowMessage showMessage:@"填写正确的用户信息"];
    }
}

- (IBAction)userprotocol:(id)sender {
    self.wb=[[UIWebView alloc]initWithFrame:CGRectMake(10, 20, self.view.bounds.size.width-20,self.view.bounds.size.height-50)];
    self.wb.delegate = self;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"usermy_protocol" ofType:@"htm"];

    
    
    NSURL *baseURL = [NSURL fileURLWithPath:path];
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];

    [self.wb loadHTMLString:html baseURL:baseURL];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.layer.cornerRadius = 5;
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, self.wb.bounds.size.height-30, self.wb.bounds.size.width, 30);
    [btn addTarget:self action:@selector(MakeSure) forControlEvents:UIControlEventTouchUpInside];
    
    [self.wb addSubview:btn];
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.hidden = YES;
    self.view.userInteractionEnabled = NO;
    [[ShowMessage mainWindow] addSubview:self.wb];
}

//void TTAlertNoTitle(NSString* message) {
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
//                                                    message:message
//                                                   delegate:nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
//}

- (void)setUpLoaduserInfo{
    self.userInfoDic = [PersistenceManager getLoginUser];
    self.userinfo = [[UserInfo alloc] initWithDictionary:[PersistenceManager getLoginUser]];
}

-(void)MakeSure{
    self.view.alpha = 1;
    self.view.userInteractionEnabled = YES;
    self.navigationController.navigationBar.hidden = NO;
    [self.wb removeFromSuperview];
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
