//
//  ConnectTableViewController.m
//  MeiWan
//
//  Created by apple on 15/10/8.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ConnectTableViewController.h"
#import "Meiwan-Swift.h"
#import "setting.h"
#import "ShowMessage.h"
#import "SBJson.h"
#import "LoginViewController.h"
#import "CorlorTransform.h"
#import "PlagerinfoViewController.h"
#import "InviteViewController.h"
#import "EaseConversationListViewController.h"
#import "MBProgressHUD.h"


@interface ConnectTableViewController ()<EMChatManagerDelegate,EMGroupManagerDelegate>
@property (strong, nonatomic) IBOutlet UITableViewCell *inviteMe;
@property (strong, nonatomic) IBOutlet UILabel *unreadImLab;
@property (strong, nonatomic) NSDictionary *playerInfo;
@property (strong, nonatomic) IBOutlet UITableView *messageTableView;
@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@property (strong, nonatomic) NSDictionary * sendPlayerDic;

@end

@implementation ConnectTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    /**
     *未读消息数量
     */
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    NSArray *items = self.tabBarController.tabBar.items;
    UITabBarItem *chatItem = items[3];
    if (unreadCount > 0) {
        chatItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
    }else{
        chatItem.badgeValue = nil;
    }
    
    if (unreadCount==0) {
        self.unreadImLab.hidden = YES;
    }else{
        [self didUnreadMessagesCountChanged];
    }
    self.tabBarController.tabBar.hidden = NO;
    
}
/**收到消息时调用此方法，环信代理*/
-(void)didReceiveMessages:(NSArray *)aMessages
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    self.unreadImLab.text = [NSString stringWithFormat:@"%i",(int)unreadCount];
}

- (void)didUnreadMessagesCountChanged{
    
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }

    self.unreadImLab.text = [NSString stringWithFormat:@"%ld",(long)unreadCount];
    self.unreadImLab.hidden = NO;
    [self.messageTableView reloadData];
}

- (void)viewDidLoad {
    
//    NSLog(@"消息");
    [super viewDidLoad];

    self.unreadImLab.layer.cornerRadius = 7;
    [self.unreadImLab.layer setMasksToBounds:YES];
    [self.navigationController.navigationBar setBarTintColor:[CorlorTransform colorWithHexString:@"#3f90a4"]];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor]           forKey:NSForegroundColorAttributeName];

    NSDictionary *userInfo = [PersistenceManager getLoginUser];
    NSString *thesame = [NSString stringWithFormat:@"%ld",[[userInfo objectForKey:@"id"]longValue]];
    int isAudit = [[userInfo objectForKey:@"isAudit"]intValue];
    if ([thesame isEqualToString:@"100000"] || [thesame isEqualToString:@"100001"]) {
        self.inviteMe.hidden = NO;
    }else{
        if (![setting canOpen]) {
            self.inviteMe.hidden = YES;
        }
        [setting getOpen];
    }
    if (isAudit == 0) {
        self.inviteMe.hidden = NO;
    }else{
        self.inviteMe.hidden = YES;
    }
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.row == 0) {

        __block BOOL show;
        
        EaseConversationListViewController *conversationList = [[EaseConversationListViewController alloc] init];
        conversationList.title = @"消息";
//        conversationList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:conversationList animated:YES];
            show = [setting canOpen];
            [setting getOpen];
    }
}

- (void)reloadUnReadMassages{
    
}
- (void)onRightavigationBarClick:(NSInteger)type andSId:(NSString *)sid{
    //NSLog(@"%@",sid);
    NSString *useridstr;
    NSString *session = [PersistenceManager getLoginSession];
    if (isTest) {
        useridstr = [sid substringFromIndex:5];
    }else{
        useridstr = [sid substringFromIndex:8];
    }
    NSInteger userId = [useridstr intValue];
    [UserConnector findPeiwanById:session userId:[NSNumber numberWithInteger:userId]receiver:^(NSData * data, NSError * error) {
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
            
        }else{
            
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSDictionary *json = [parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                NSDictionary * playerInfoDic = [json objectForKey:@"entity"];
                [self performSegueWithIdentifier:@"invide" sender:playerInfoDic];
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
- (void)getHeadurlBySession:(NSString *)mysession result:(void(^)(NSString *url))result{
    NSString *useridstr;
    NSString *session = [PersistenceManager getLoginSession];
    if (isTest) {
        useridstr = [mysession substringFromIndex:5];
    }else{
        useridstr = [mysession substringFromIndex:8];
    }
    NSInteger userId = [useridstr intValue];
    __block NSString *url = nil;
    [UserConnector findPeiwanById:session userId:[NSNumber numberWithInteger:userId]receiver:^(NSData * data, NSError * error) {
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];

        }else{
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSDictionary *json = [parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                NSDictionary *peiwanInfoDic = [json objectForKey:@"entity"];
                url = [peiwanInfoDic objectForKey:@"headUrl"];
                result(url);
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

- (void)getNicknameBySession:(NSString *)mysession result:(void(^)(NSString *nickname))result{
    NSString *useridstr;
    NSString *session = [PersistenceManager getLoginSession];
    if (isTest) {
        useridstr = [mysession substringFromIndex:5];
    }else{
        useridstr = [mysession substringFromIndex:8];
    }
    NSInteger userId = [useridstr intValue];
    __block NSString *nickname = nil;
    [UserConnector findPeiwanById:session userId:[NSNumber numberWithInteger:userId]receiver:^(NSData * data, NSError * error) {
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSDictionary *json = [parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                NSDictionary *peiwanInfoDic = [json objectForKey:@"entity"];
                nickname = [peiwanInfoDic objectForKey:@"nickname"];
                result(nickname);
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"invide"]) {
        InviteViewController *iv = segue.destinationViewController;
        iv.playerInfo = sender;
    }
    if ([segue.identifier isEqualToString:@"person"]) {
        PlagerinfoViewController *pv = segue.destinationViewController;
        pv.hidesBottomBarWhenPushed = YES;
        pv.playerInfo = sender;
    }

}

@end
