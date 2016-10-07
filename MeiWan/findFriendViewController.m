//
//  findFriendViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/8/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "findFriendViewController.h"
#import "CorlorTransform.h"
#import "MeiWan-Swift.h"
#import "SBJsonParser.h"
#import "findPeiWanCell.h"
#import "ChatViewController.h"
#import "ShowMessage.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "PlagerinfoViewController.h"

@interface findFriendViewController ()<UITableViewDelegate,UITableViewDataSource,findPeiWanDelegate,MBProgressHUDDelegate>
{
    findPeiWanCell * findcell;
    MBProgressHUD * HUD;
}

@property(nonatomic,strong)UITextField * tf;
@property(nonatomic,strong)NSDictionary * findDic;
@property(nonatomic,strong)NSArray * MyfriendArray;

@end

@implementation findFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITextField * tf = [[UITextField alloc]initWithFrame:CGRectMake(20, 84, dtScreenWidth-100-30, 44)];
    [tf.layer setBorderColor:[UIColor grayColor].CGColor];
    tf.layer.cornerRadius = 5;
    tf.clipsToBounds = YES;
    [tf.layer setBorderWidth:0.5];
    tf.placeholder = @" ID账号";
    tf.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:tf];
    self.tf = tf;
    
    UIButton * buton = [UIButton buttonWithType:UIButtonTypeCustom];
    buton.frame = CGRectMake(dtScreenWidth-90, 84, 70, 44);
    buton.backgroundColor = [CorlorTransform colorWithHexString:@"#3f90a4"];
    buton.layer.cornerRadius = 5;
    buton.clipsToBounds = YES;
    [buton setTitle:@"搜索" forState:UIControlStateNormal];
    [buton addTarget:self action:@selector(searchbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buton];
    
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)searchbuttonClick:(UIButton *)sender
{
    [self.tf resignFirstResponder];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"加载中";
    
    if (self.tf.text.length>0) {
        NSString *session = [PersistenceManager getLoginSession];
        [UserConnector findPeiwanById:session userId:[NSNumber numberWithInteger:[self.tf.text integerValue]] receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
            
            if (error) {
                
            }else{
                SBJsonParser * parser = [[SBJsonParser alloc]init];
                NSDictionary * json = [parser objectWithData:data];
                NSLog(@"%@",json);
                int status = [json[@"status"] intValue];
                if (status==0) {
                    
                    self.findDic = json[@"entity"];
                    
                    if (self.findDic == nil) {
                        [self showMessageAlert:@"未检测到用户，请查看输入信息"];
                    }else{
                        [self findMyFriendList];
                        [self creatTableView];
                    }
                    [HUD hide:YES afterDelay:0.1];
                }else if (status==1){
                    
                }else{
                    
                }
            }
            
        }];

    }else{
        /**提示*/
        [self showMessageAlert:@"输入不能为空"];
    }
}
- (void)creatTableView
{
    UITableView * tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, self.tf.frame.size.height+self.tf.frame.origin.y+20, dtScreenWidth, dtScreenHeight-(self.tf.frame.size.height+self.tf.frame.origin.y+20)) style:UITableViewStyleGrouped];
    tableview.dataSource = self;
    tableview.delegate = self;
    [self.view addSubview:tableview];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    findcell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!findcell) {
        findcell = [[findPeiWanCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    findcell.dictionary = self.findDic;
    findcell.delegate = self;
    [self.MyfriendArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isEqualToDictionary:self.findDic]) {
            [findcell.addButton setTitle:@"已关注" forState:UIControlStateNormal];
        }
    }];
    return findcell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlagerinfoViewController *playerInfoCtr = [mainStoryboard instantiateViewControllerWithIdentifier:@"secondStory"];
    playerInfoCtr.playerInfo= self.findDic;
    [self.navigationController pushViewController:playerInfoCtr animated:YES];
}

#pragma mark--键盘
- (void)showMessageAlert:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
    }];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark--代理
-(void)ChatWithFriend{
    
    NSString *product = [NSString stringWithFormat:@"%@%ld",
                         [setting getRongLianYun],[[self.findDic objectForKey:@"id"]longValue]];
    
    ChatViewController *messageCtr = [[ChatViewController alloc] initWithConversationChatter:product conversationType:EMConversationTypeChat];
    messageCtr.title = [NSString stringWithFormat:@"%@",
                        [self.findDic objectForKey:@"nickname"]];
    [self.navigationController pushViewController:messageCtr animated:YES];
    __block BOOL show;
    NSDictionary *userInfo = [PersistenceManager getLoginUser];
    NSString *thesame = [NSString stringWithFormat:@"%ld",[[userInfo objectForKey:@"id"]longValue]];
    if ([thesame isEqualToString:@"100000"] || [thesame isEqualToString:@"100001"]) {
        show = NO;
        
    }else{
        show = [setting canOpen];
        
        [setting getOpen];
    }

}
-(void)AddFriend{
    
    NSString *sesstion = [PersistenceManager getLoginSession];
    [UserConnector addFriend:sesstion friendId:self.findDic[@"id"] receiver:^(NSData *data,NSError *error){
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                
                [ShowMessage showMessage:@"关注成功"];
                [findcell.addButton setTitle:@"已关注" forState:UIControlStateNormal];
                
                
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
/**获取好友*/
- (void)findMyFriendList
{
    NSString * session = [PersistenceManager getLoginSession];
    [UserConnector findMyFriends:session receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            [self showMessageAlert:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            self.MyfriendArray = json[@"entity"];
        }
    }];
}

@end
