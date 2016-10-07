//
//  PrepaidViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/7/26.
//  Copyright © 2016年 apple. All rights reserved.
//
#import <AlipaySDK/AlipaySDK.h>
#import "PrepaidViewController.h"
#import "AliHelper.h"
#import "MeiWan-Swift.h"
#import "MBProgressHUD.h"
#import "SBJson.h"
#import "LoginViewController.h"
#import "AliHelper.h"
#import "WXApi.h"
#import "MD5.h"

@interface PrepaidViewController()<MBProgressHUDDelegate>
{
    NSArray *  array;
    NSArray * littleArray;
    MBProgressHUD * HUD;
    NSNumber * _newMoney;
}
@property(nonatomic,strong)UITextField * textfiled;
@property(nonatomic,strong)NSDictionary * userInfoDic;

@end

@implementation PrepaidViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"充值";
    self.view.backgroundColor = [UIColor whiteColor];
    array = @[@"10",@"20",@"30",@"50",@"100",@"200",@"300",@"500",@"1000"];

    [self somePrepainSubViews];
    
}

-(void)somePrepainSubViews
{
    
    for (int i = 0; i<9; i++) {
        UILabel * someSubviews = [[UILabel alloc]initWithFrame:CGRectMake(20+i%3*((dtScreenWidth-40)/3), 84+i/3*(55), (dtScreenWidth-40)/3-5, 50)];
        someSubviews.backgroundColor = [UIColor whiteColor];
        someSubviews.layer.cornerRadius = 5;
        someSubviews.clipsToBounds = YES;
        [someSubviews.layer setBorderColor:[UIColor blackColor].CGColor];
        [someSubviews.layer setBorderWidth:0.3];
        someSubviews.textAlignment = NSTextAlignmentCenter;
        someSubviews.userInteractionEnabled = YES;
        someSubviews.tag = i;
        someSubviews.font = [UIFont systemFontOfSize:17.0];
        someSubviews.textColor = [UIColor blackColor];
        someSubviews.numberOfLines = 0;

        NSMutableAttributedString * change = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥：%@",array[i]]];
        NSRange range = [[change string]rangeOfString:[NSString stringWithFormat:@"%@",array[i]]];
        [change addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0] range:range];
        [change addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:range];
        someSubviews.attributedText = change;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [someSubviews addGestureRecognizer:tapGesture];
        [self.view addSubview:someSubviews];
    }
    
}
-(void)tapGesture:(UIGestureRecognizer *)gesture
{
    
    UILabel * label = (UILabel *)[gesture view];
    double money = [array[label.tag] doubleValue];
    NSNumber * newMoney = [NSNumber numberWithDouble:money];
    _newMoney = newMoney;
    
    UIAlertView *payAlertView = [[UIAlertView alloc]initWithTitle:@"选择充值方式" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"微信",@"支付宝",nil];
    
    [payAlertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  
    NSString *session = [PersistenceManager getLoginSession];
    
    if (buttonIndex==1) {
        /** 微信 */
        [UserConnector wxRechargeSigh:session price:_newMoney receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
            
            if (error) {
                [self showMessageAlert:@"服务器未响应"];
            }else{
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];
                int status = [json[@"status"] intValue];
                if (status==0) {
                    NSString * sign = json[@"entity"];
                    
                    //发起微信支付，设置参数
                    PayReq *request = [[PayReq alloc] init];
                    request.openID = @"wx4555cf92f3ab6550";
                    request.partnerId = @"1383665402";
                    request.prepayId= sign;
                    request.package = @"Sign=WXPay";
                    //将当前事件转化成时间戳
                    NSDate *datenow = [NSDate date];
                    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
                    UInt32 timeStamp =[timeSp intValue];
                    request.timeStamp= timeStamp;
                    
                    /** 随机字符串 */
                    ;
                    NSString * str = [NSString stringWithFormat:@"appid=%@&package=Sign=WXPay&partnerid=%@&prepayid=%@&timestamp=%u",request.openID,request.partnerId,request.prepayId,(unsigned int)request.timeStamp];
                    NSString * str2 = [NSString stringWithFormat:@"%@&key=IJR4681LYNZD1QHZOC3MOHL3KGW42W96",str];
                    request.nonceStr= [[MD5 md5:str2] uppercaseString];
                    // 签名加密
                    
                    
                    NSString * string = [NSString stringWithFormat:@"appid=%@&noncestr=%@&package=Sign=WXPay&partnerid=%@&prepayid=%@&timestamp=%u",request.openID,request.nonceStr,request.partnerId,request.prepayId,(unsigned int)request.timeStamp];
                    NSString * string2 = [NSString stringWithFormat:@"%@&key=IJR4681LYNZD1QHZOC3MOHL3KGW42W96",string];
                    request.sign = [[MD5 md5:string2] uppercaseString];
                
                    NSLog(@"%@",request.sign);
                    [WXApi sendReq:request];

                    
                }else{
                    /** status=1 没有登录 */
                    [self pushLoginPage];
                }
            }
            
            
        }];

    }
    if (buttonIndex==2) {
        /** 支付宝 */
        
        /*创建充值订单*/
        [UserConnector aliRechargeSigh:session price:_newMoney receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
            
            if (error) {
                [self showMessageAlert:@"服务器未响应"];
            }else{
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];
                int status = [json[@"status"] intValue];
                if (status==0) {
                    NSString * sign = json[@"entity"];
                    [[AlipaySDK defaultService] payOrder:sign fromScheme:@"meiwan" callback:^(NSDictionary *resultDic) {
                        
                        NSInteger  resultNum= [[resultDic objectForKey:@"resultStatus"]integerValue];
                        if (resultNum == 9000) {
                            [self showMessageAlert:@"支付成功"];
                            [self.navigationController popViewControllerAnimated:YES];
                            
                        }else{
                            [self showMessageAlert:@"支付失败"];
                            
                        }
                        
                    }];
                }else{
                    /** status=1 没有登录 */
                    [self pushLoginPage];
                }
            }
            
        }];

    }

}
- (void)showMessageAlert:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
    }];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
/**未登录跳出登陆页面*/
- (void)pushLoginPage
{
    [PersistenceManager setLoginSession:@""];
    LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    lv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:lv animated:YES];

}


#pragma mark - 产生随机订单号
- (NSString *)generateTradeNO {
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0)); // 此行代码有警告:
    for (int i = 0; i < kNumber; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
@end
