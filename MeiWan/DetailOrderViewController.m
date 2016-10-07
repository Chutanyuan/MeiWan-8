//
//  DetailOrderViewController.m
//  MeiWan
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "DetailOrderViewController.h"
#import "Meiwan-Swift.h"
#import "CWStarRateView.h"
#import "ShowMessage.h"
#import "SBJson.h"
#import "LoginViewController.h"
#import "AccusationViewController.h"
#import "AssessViewController.h"
#import "InviteRecordViewController.h"
#import "AliHelper.h"
#import "CorlorTransform.h"
#import "PlagerinfoViewController.h"
@interface DetailOrderViewController ()<UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *carFee;
@property (strong, nonatomic) IBOutlet UILabel *creatTime;
@property (strong, nonatomic) IBOutlet UILabel *peiwanNickname;
@property (strong, nonatomic) IBOutlet UILabel *choiceBar;
@property (strong, nonatomic) IBOutlet UILabel *hours;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *needPay;
@property (strong, nonatomic) IBOutlet UILabel *currentState;
@property (strong, nonatomic) IBOutlet UILabel *orderId;
@property (strong, nonatomic) IBOutlet UIButton *actionBtn;
@property (strong, nonatomic) IBOutlet UIView *actionView;
@property (nonatomic,strong) UIAlertView *payAlert;
@property (nonatomic,strong) UIAlertView *makeSureAlert;
@property (nonatomic,assign) double money;
@end

@implementation DetailOrderViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    double lastActiveTime = [[self.detailOrderDic objectForKey:@"createTime"]doubleValue];
    self.creatTime.text = [DateTool getTimeDescription:lastActiveTime];
    
    if (self.orderTag == 666) {
        NSDictionary *peiwan = [self.detailOrderDic objectForKey:@"user"];
        self.peiwanNickname.text = [peiwan objectForKey:@"nickname"];
    }else{
        NSDictionary *peiwan = [self.detailOrderDic objectForKey:@"peiwan"];
        self.peiwanNickname.text = [peiwan objectForKey:@"nickname"];
    }
    
    double typedouble = [[self.detailOrderDic objectForKey:@"tagIndex"]doubleValue];
    if (typedouble == 1) {
        self.choiceBar.text = @"线上点歌";
    }else if(typedouble == 2){
        self.choiceBar.text = @"视频聊天";
    }else if(typedouble == 3){
        self.choiceBar.text = @"聚餐";
    }else if(typedouble == 4){
        self.choiceBar.text = @"线下K歌";
    }else if(typedouble == 5){
        self.choiceBar.text = @"夜店达人";
    }else if(typedouble == 6){
        self.choiceBar.text= @"叫醒服务";
    }else if(typedouble == 7){
        self.choiceBar.text = @"影伴";
    }else if(typedouble == 8){
        self.choiceBar.text = @"运动健身";
    }else if(typedouble == 9){
        self.choiceBar.text = @"LOL";
    }
    
    self.hours.text = [NSString stringWithFormat:@"%d小时",[[self.detailOrderDic objectForKey:@"hours"]intValue]];
    
    self.price.text = [NSString stringWithFormat:@"%.1f",[[self.detailOrderDic objectForKey:@"price"]floatValue]];
    
    int hours = [[self.detailOrderDic objectForKey:@"hours"]intValue];
    float price = [[self.detailOrderDic objectForKey:@"price"]floatValue];
    self.money = hours * price;
    self.needPay.text = [NSString stringWithFormat:@"%.1f",self.money];
    /**车费*/
    self.carFee.text = [NSString stringWithFormat:@" %.1f",[self.detailOrderDic[@"carFee"] doubleValue]];
    NSDictionary *evaluationDic = [self.detailOrderDic objectForKey:@"evaluation"];

    int status = [[self.detailOrderDic objectForKey:@"status"]intValue];
    if (self.orderTag == 888) {
        /** 100 用户支付 等待陪玩接受 */
        if (status == 100) {
            
            self.currentState.text = @"等待接受";
            self.currentState.textColor = [UIColor grayColor];
            self.actionView.hidden = YES;
            
        }else if (status == 101){
            /** 等待支付没有了。不支付不形成订单 */
            self.currentState.text = @"已经撤回";
            self.currentState.textColor = [UIColor orangeColor];

        }else if (status == 200){
            /** 200 陪玩同意订单 用户可以选择确认 */
            self.currentState.text = @"等待确认";
            self.currentState.textColor = [UIColor orangeColor];
            
            self.actionBtn.enabled = NO;
            UIButton *makeSure = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 120, 40)];
            [makeSure setTitle:@"确认交易成功" forState:UIControlStateNormal];
            [makeSure setTitleColor:[CorlorTransform  colorWithHexString:@"#36C8FF"] forState:UIControlStateNormal];
            [makeSure addTarget:self action:@selector(makeSure) forControlEvents:UIControlEventTouchUpInside];
            UIButton *accusation = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-120, 0, 100, 40)];
            [accusation setTitle:@"申请退款" forState:UIControlStateNormal];
            [accusation setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [accusation addTarget:self action:@selector(accusation) forControlEvents:UIControlEventTouchUpInside];
             
            [self.actionView addSubview:makeSure];
            [self.actionView addSubview:accusation];
        }else if (status == 400 || status == 600){
            
            /** 交易完成或者是陪玩胜诉 等待用户去评价 */
            self.currentState.text = @"等待评价";
            self.currentState.textColor = [UIColor orangeColor];

            [self.actionBtn setTitle:@"评价" forState:UIControlStateNormal];
            [self.actionBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            
            
        }else if (status == 500){
            self.currentState.text = @"等待仲裁结果";
            self.currentState.textColor = [UIColor grayColor];
            self.actionView.hidden = YES;
        }else if (status == 600){
            self.currentState.text = @"教官胜诉";
            self.currentState.textColor = [UIColor grayColor];
            self.actionView.hidden = YES;
        }else if (status == 700){
            self.currentState.text = @"用户胜诉";
            self.currentState.textColor = [UIColor grayColor];
            self.actionView.hidden = YES;
        }else if (status == 300){
            self.currentState.text = @"已拒绝";
            self.currentState.textColor = [UIColor grayColor];
            self.actionView.hidden = YES;
        }else if (status == 800){
            self.currentState.text = @"已评价";
            self.currentState.textColor = [UIColor grayColor];
            self.actionView.hidden = YES;
            UIView *evaluationVi = [[UIView alloc]initWithFrame:CGRectMake(0, self.actionView.frame.origin.y, self.view.bounds.size.width, 60)];
            evaluationVi.backgroundColor = [UIColor whiteColor];
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 20)];
            lab.text = @"订单评价";
            lab.textColor = [UIColor orangeColor];
            
            UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 35, 50, 20)];
            lab1.text = @"评分 ：";
            lab1.font = [UIFont systemFontOfSize:14];
            [evaluationVi addSubview:lab];
            [evaluationVi addSubview:lab1];
            [self.view addSubview:evaluationVi];
            
            CWStarRateView *starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(55, 35, 70, 20) numberOfStars:5];
            starRateView.scorePercent = [[evaluationDic objectForKey:@"point"]floatValue]/5.0;
            starRateView.allowIncompleteStar = YES;
            starRateView.hasAnimation = YES;
            starRateView.userInteractionEnabled = NO;
            [evaluationVi addSubview:starRateView];

        }
    }else if(self.orderTag == 666){
        if (status == 100) {
            /** 玩家已经支付 */
            self.currentState.text = @"等待接受";
            self.currentState.textColor = [UIColor orangeColor];
            [self.actionBtn setTitle:@"接受" forState:UIControlStateNormal];
            [self.actionBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }else if (status == 200){
            self.currentState.text = @"已经接受";
            self.currentState.textColor = [UIColor orangeColor];
            [self.actionBtn setTitle:@"已接受" forState:UIControlStateNormal];
            [self.actionBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
        }else if (status == 101){
            self.currentState.text = @"对方撤回";
            self.currentState.textColor = [CorlorTransform  colorWithHexString:@"#00bb9c"];
            self.actionView.hidden = YES;
        }else if (status == 400|| status ==600){
            self.currentState.text = @"等待评价";
            self.currentState.textColor = [UIColor grayColor];
            self.actionView.hidden = YES;

            
        }else if (status == 500){
            self.currentState.text = @"等待仲裁结果";
            self.currentState.textColor = [UIColor grayColor];
            self.actionView.hidden = YES;
        }else if (status == 600){
            self.currentState.text = @"教官胜诉";
            self.currentState.textColor = [UIColor grayColor];
            self.actionView.hidden = YES;
        }else if (status == 700){
            self.currentState.text = @"用户胜诉";
            self.currentState.textColor = [UIColor grayColor];
            self.actionView.hidden = YES;
        }else if (status == 300){
            self.currentState.text = @"已拒绝";
            self.currentState.textColor = [UIColor grayColor];
            self.actionView.hidden = YES;
        }else if (status == 800){
            self.currentState.text = @"完成";
            self.actionView.hidden = YES;
            UIView *evaluationVi = [[UIView alloc]initWithFrame:CGRectMake(0, self.actionView.frame.origin.y, self.view.bounds.size.width, 60)];
            evaluationVi.backgroundColor = [UIColor whiteColor];
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 20)];
            lab.text = @"订单评价";
            lab.textColor = [UIColor orangeColor];
            
            UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 35, 50, 20)];
            lab1.text = @"评分 ：";
            lab1.font = [UIFont systemFontOfSize:14];
            [evaluationVi addSubview:lab];
            [evaluationVi addSubview:lab1];
            [self.view addSubview:evaluationVi];
            
            CWStarRateView *starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(55, 35, 70, 20) numberOfStars:5];
            starRateView.scorePercent = [[evaluationDic objectForKey:@"point"]floatValue]/5.0;
            starRateView.allowIncompleteStar = YES;
            starRateView.hasAnimation = YES;
            starRateView.userInteractionEnabled = NO;
            [evaluationVi addSubview:starRateView];

        }
    }
    self.orderId.text = [NSString stringWithFormat:@"%d",[[self.detailOrderDic objectForKey:@"id"]intValue]];

}

- (IBAction)userDetail:(UIButton *)sender {
    NSDictionary * peiwan = nil;
    if (self.orderTag == 666) {
        peiwan = [self.detailOrderDic objectForKey:@"user"];
    }else{
        peiwan = [self.detailOrderDic objectForKey:@"peiwan"];
    }
    [self performSegueWithIdentifier:@"personInfo" sender:peiwan];
}

- (IBAction)btnAction:(UIButton *)sender {
    int status = [[self.detailOrderDic objectForKey:@"status"]intValue];
    if (self.orderTag == 888) {
        if (status == 1){
            //NSLog(@"%@",self.detailOrderDic);
            NSDictionary *user = [self.detailOrderDic objectForKey:@"user"];
            double count = [[user objectForKey:@"money"]doubleValue];
   
            //NSLog(@"%f",count);
            
            NSString * money = [NSString stringWithFormat:@"余额（💰%.1f)",count];
            self.payAlert = [[UIAlertView alloc]initWithTitle:@"选择支付方式" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:money,@"支付宝",nil];
            [self.payAlert show];
        }else if (status == 400){
            //跳转到评价页面
            [self performSegueWithIdentifier:@"assess" sender:self.detailOrderDic];
        }else{
            
        }
    }else if(self.orderTag == 666){
        if (status == 100) {
            NSString *session = [PersistenceManager getLoginSession];
            [UserConnector acceptOrder:session orderId:[self.detailOrderDic objectForKey:@"id"] receiver:^(NSData *data, NSError *error){
                if (error) {
                    [ShowMessage showMessage:@"服务器未响应"];
                }else{
                    SBJsonParser *parser = [[SBJsonParser alloc]init];
                    NSMutableDictionary *json = [parser objectWithData:data];
                    int status = [[json objectForKey:@"status"]intValue];
                    if (status == 0) {
                        [ShowMessage showMessage:@"接受成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }else if (status == 1){
                       [PersistenceManager setLoginSession:@""];
                       LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                       lv.hidesBottomBarWhenPushed = YES;
                       [self.navigationController pushViewController:lv animated:YES];
                           
                        
                    }else{
                        
                    }
                    
                }
            }];
        }else if (status == 200){
            
            [ShowMessage showMessage:@"已经接受"];
            
        }else{
        
        }

    }
}
-(void)makeSure{
    self.makeSureAlert = [[UIAlertView alloc]initWithTitle:@"是否确认交易" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"是",@"否", nil];
    [self.makeSureAlert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == self.payAlert) {
        if (buttonIndex == 1) {
            
            
//            //余额支付
//            NSString *session = [PersistenceManager getLoginSession];
//            [UserConnector payWithAccountMoney:session orderId:[self.detailOrderDic objectForKey:@"id"] receiver:^(NSData *data, NSError *error){
//                if (error) {
//                    [ShowMessage showMessage:@"服务器未响应"];
//                }else{
//                    SBJsonParser *parser = [[SBJsonParser alloc]init];
//                    NSMutableDictionary *json = [parser objectWithData:data];
//                    int status = [[json objectForKey:@"status"]intValue];
//                     if (status == 0) {
//                        [ShowMessage showMessage:@"支付成功"];
//                        [self.navigationController popViewControllerAnimated:YES];
//                    }else if (status == 1){
//                        [PersistenceManager setLoginSession:@""];
//                       LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
//                       lv.hidesBottomBarWhenPushed = YES;
//                       [self.navigationController pushViewController:lv animated:YES];
//        
//                    }else if (status == 2){
//                        [ShowMessage showMessage:@"余额不足"];
//                    }else{
//                        
//                    }
//                    
//                }
//            }];
            
        }else if(buttonIndex == 2){
            //支付宝支付
            double money = [[self.detailOrderDic objectForKey:@"price"]doubleValue]*[[self.detailOrderDic objectForKey:@"hours"]intValue];
            //NSLog(@"%f",money);
            //money = 0.01;
            [AliHelper aliPay:[[self.detailOrderDic objectForKey:@"id"]integerValue] price:money callback:^(NSDictionary *result){
                NSInteger  resultNum= [[result objectForKey:@"resultStatus"]integerValue];
//                NSLog(@"%ld",(long)resultNum);
                if (resultNum == 9000) {
                    [ShowMessage showMessage:@"支付成功"];
                }else{
                    [ShowMessage showMessage:@"支付失败"];
                }
            }];
        }
    }else{
        if (buttonIndex == 0) {
            //是(是否确认交易)
            NSString *session = [PersistenceManager getLoginSession];
            [UserConnector orderOk:session orderId:[self.detailOrderDic objectForKey:@"id"] receiver:^(NSData *data, NSError *error){
                if (error) {
                    [ShowMessage showMessage:@"服务器未响应"];
                }else{
                    SBJsonParser *parser = [[SBJsonParser alloc]init];
                    NSMutableDictionary *json = [parser objectWithData:data];
                    int status = [[json objectForKey:@"status"]intValue];
                    if (status == 0) {
                        //NSLog(@"%@",json);
                        [ShowMessage showMessage:@"完成"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }else if (status == 1){
                        [PersistenceManager setLoginSession:@""];
                        LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                        lv.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:lv animated:YES];
                    }else{
                        
                    }
                    
                }
            }];

        }
    }
}

-(void)accusation{
    [self performSegueWithIdentifier:@"accusation" sender:self.detailOrderDic];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"assess"]) {
        AssessViewController *av = segue.destinationViewController;
        av.orderDic = sender;
    }
    if ([segue.identifier isEqualToString:@"accusation"]) {
        AccusationViewController *acv = segue.destinationViewController;
        acv.orderDic = sender;
    }
    if ([segue.identifier isEqualToString:@"personInfo"]) {
        PlagerinfoViewController *pv = segue.destinationViewController;
        pv.playerInfo = sender;
    }
}

@end
