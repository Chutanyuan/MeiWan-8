//
//  GuildMembersViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/8/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GuildMembersViewController.h"
#import "guildMementCell.h"
#import "daRenCell.h"
#import "subGuildCell.h"
#import "LastGuildViewController.h"
#import "Meiwan-Swift.h"
#import "ShowMessage.h"
#import "SBJsonParser.h"
#import "LoginViewController.h"
#import "PlagerinfoViewController.h"
#import "newViewController.h"
@interface GuildMembersViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIView * lineView;
    UIScrollView * scrollview;
    UITableView * guildMemberTableView;
    UITableView * DaRenTableView;
    UITableView * subGuildTableView;
    /**子公会组*/
    
}
/**公会成员组*/
@property(nonatomic,strong)NSMutableArray * memberArray;
/**达人组*/
@property(nonatomic,strong)NSMutableArray * darenArray;
/**子公会组*/
@property(nonatomic,strong)NSMutableArray * subGuildArray;
@property(nonatomic,assign)CGFloat lastScrollOffset;
@end

@implementation GuildMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self init_UI];
    [self beginNetWorking];
}

- (void)init_UI
{
    NSArray * buttonArray = @[@"公会成员",@"达人",@"子公会"];
    for (int a = 0; a < 3; a++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(a*(dtScreenWidth/3), 64, dtScreenWidth/3, 44);
        [button setTitle:buttonArray[a] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = a;
        [button addTarget:self action:@selector(lineViewMove:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 107, dtScreenWidth/3, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineView];
    
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 108, dtScreenWidth, dtScreenHeight-108)];
    scrollview.contentSize = CGSizeMake(dtScreenWidth*3, dtScreenHeight-108);
    scrollview.pagingEnabled = YES;
    scrollview.delegate = self;
    
    [self.view addSubview:scrollview];
    guildMemberTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight-108) style:UITableViewStyleGrouped];
    guildMemberTableView.delegate = self;
    guildMemberTableView.dataSource = self;
    guildMemberTableView.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:guildMemberTableView];
  
    
    DaRenTableView = [[UITableView alloc]initWithFrame:CGRectMake(dtScreenWidth, 0, dtScreenWidth, dtScreenHeight-108) style:UITableViewStyleGrouped];
    DaRenTableView.delegate = self;
    DaRenTableView.dataSource = self;
    DaRenTableView.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:DaRenTableView];
    
    subGuildTableView = [[UITableView alloc]initWithFrame:CGRectMake(dtScreenWidth*2, 0, dtScreenWidth, dtScreenHeight-108) style:UITableViewStyleGrouped];
    subGuildTableView.delegate = self;
    subGuildTableView.dataSource = self;
    subGuildTableView.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:subGuildTableView];
    
}

- (void)lineViewMove:(UIButton *)sender
{
    [self viewAnimation:sender.tag];
    scrollview.contentOffset = CGPointMake(sender.tag*dtScreenWidth, 0);
}
- (void)viewAnimation:(NSInteger)integer
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame = CGRectMake(dtScreenWidth/3*integer, 107, dtScreenWidth/3, 1);
    [UIView commitAnimations];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        CGFloat y = scrollView.contentOffset.y;
        if (y > self.lastScrollOffset) {
                //shang
        } else {
            
                //xia
        }
        self.lastScrollOffset = y;
    } else {
        [self viewAnimation:scrollView.contentOffset.x/dtScreenWidth];
    }
}

#pragma mark === tableview delegate datasource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==guildMemberTableView) {
        return self.memberArray.count;
    }else if (tableView == DaRenTableView){
        return self.darenArray.count;
    }else{
        return self.subGuildArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == guildMemberTableView) {
        guildMementCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[guildMementCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        if (self.memberArray.count>0) {
            cell.dictionary = self.memberArray[indexPath.row];
        }
        return cell;
    }else if (tableView == DaRenTableView){
        daRenCell * cell = [tableView dequeueReusableCellWithIdentifier:@"daren"];
        if (!cell) {
            cell = [[daRenCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"daren"];
        }
        if (self.darenArray.count>0) {
            cell.dictionary = self.darenArray[indexPath.row];
        }
        return cell;
    }else{
        subGuildCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[subGuildCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        if (self.subGuildArray.count>0) {
            cell.dictionary = self.subGuildArray[indexPath.row];
        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    PlagerinfoViewController *playerInfoCtr = [mainStoryboard instantiateViewControllerWithIdentifier:@"secondStory"];
//
//    if (tableView == guildMemberTableView) {
//
//        playerInfoCtr.playerInfo= _memberArray[indexPath.row];
//        
//    }else if (tableView == DaRenTableView){
//        
//        playerInfoCtr.playerInfo= _darenArray[indexPath.row];
//
//    }else{
//        NSDictionary * playerInfo = _subGuildArray[indexPath.row];
//        playerInfoCtr.playerInfo= playerInfo[@"user"];
//    }
//    
//    [self.navigationController pushViewController:playerInfoCtr animated:YES];
}

#pragma mark----netWorking

-(void)beginNetWorking
{
    NSString *session= [PersistenceManager getLoginSession];
    [UserConnector findMyUnionMembers:session offset:0 limit:20 receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            NSLog(@"%@",json);
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                self.memberArray = [json objectForKey:@"entity"];
                [guildMemberTableView reloadData];
                [self performSelector:@selector(darenNetWorking) withObject:nil afterDelay:0.5];
            }else if(status == 1){
                
                [PersistenceManager setLoginSession:@""];
                LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                lv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:lv animated:YES];
                
            }else{
               
            }

        }
    }];
}
- (void)darenNetWorking
{
    NSString *session= [PersistenceManager getLoginSession];
    [UserConnector findMyUnionDarens:session offset:0 limit:20 receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            NSLog(@"%@",json);
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                self.darenArray = [json objectForKey:@"entity"];
                [DaRenTableView reloadData];
                [self performSelector:@selector(guildNetWorking) withObject:nil afterDelay:0.5];
            }else if(status == 1){
                
                [PersistenceManager setLoginSession:@""];
                LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                lv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:lv animated:YES];
                
            }else{
                
            }
        }
    }];
}
- (void)guildNetWorking
{
    NSString *session= [PersistenceManager getLoginSession];
    [UserConnector findMySubUnions:session offset:0 limit:20 receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            NSLog(@"%@",json);
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                self.subGuildArray = [json objectForKey:@"entity"];
                [subGuildTableView reloadData];
            }else if(status == 1){
                
                [PersistenceManager setLoginSession:@""];
                LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                lv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:lv animated:YES];
                
            }else{
                
            }
            
        }
    }];

}
- (void)init_guildTableview
{
    
}
@end
