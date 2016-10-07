//
//  ChatListViewController.m
//  MeiWan
//
//  Created by MacBook Air on 16/10/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ChatListViewController.h"
#import "MeiWan-Swift.h"
#import "SBJsonParser.h"
#import "ChatListTableViewCell.h"
#import "ChatViewController.h"
#import "EaseUI.h"
#import "ChatDemoHelper.h"

@interface ChatListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation ChatListViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[CorlorTransform colorWithHexString:@"#3f90a4"]];

    NSArray *conversations =  [[EMClient sharedClient].chatManager getAllConversations];
    self.dataArray = [NSMutableArray arrayWithArray:conversations];

    UITableView * tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight) style:UITableViewStylePlain];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    
    // Do any additional setup after loading the view.
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ChatListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    EMConversation * model = [self.dataArray objectAtIndex:indexPath.row];
    
    /**
     头像设置圆角
     */
    NSString * chatId =  model.conversationId;
    NSString* userIdStr= [chatId stringByReplacingOccurrencesOfString:@"product_" withString:@""];
    NSNumber* userId =[NSNumber numberWithLong: [userIdStr integerValue]];
    NSString *session= [PersistenceManager getLoginSession];
    [UserConnector findPeiwanById:session userId:userId receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                NSMutableDictionary* user  = [json objectForKey:@"entity"];
                
                cell.playInfo = user;
            }
            
        }else{
            
        }
    }];

    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMConversation * model = [self.dataArray objectAtIndex:indexPath.row];
    
    /**
     头像设置圆角
     */
    NSString * chatId =  model.conversationId;

    
    ChatViewController *messageCtr = [[ChatViewController alloc] initWithConversationChatter:chatId conversationType:EMConversationTypeChat];
    
    NSString* userIdStr= [chatId stringByReplacingOccurrencesOfString:@"product_" withString:@""];
    NSNumber* userId =[NSNumber numberWithLong: [userIdStr integerValue]];
    NSString *session= [PersistenceManager getLoginSession];
    [UserConnector findPeiwanById:session userId:userId receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                NSMutableDictionary* user  = [json objectForKey:@"entity"];
                messageCtr.title = [NSString stringWithFormat:@"%@",
                                    [user objectForKey:@"nickname"]];
                self.navigationController.hidesBottomBarWhenPushed = YES;
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
            
        }else{
            
        }
    }];

    


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
