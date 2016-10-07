//
//  GuildRankListViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/8/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GuildRankListViewController.h"
#import "GuildRankCell.h"
#import "MeiWan-Swift.h"
#import "ShowMessage.h"
#import "SBJsonParser.h"
#import "LoginViewController.h"
#import "MJRefresh.h"
#import "PlagerinfoViewController.h"

@interface GuildRankListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray * rankArray;
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,assign)int counts;

@end

@implementation GuildRankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self init_UI];
    _counts = 0;
    [self findUnionsRank:_counts];
}

-(void)init_UI
{
    UITableView * tableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableview];
    tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self headRefresh:0];
    }];
    tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self footRefresh:0];
    }];
    
    self.tableview = tableview;
}
- (void)headRefresh:(int)type
{
    _counts = 0;
    [self findUnionsRank:_counts];
}
- (void)footRefresh:(int)type
{
    _counts+=10;
    [self findUnionsRank:_counts];
}
#pragma marl----
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GuildRankCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[GuildRankCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
         cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (self.rankArray.count>0) {
        cell.dictionary = self.rankArray[indexPath.row];
        if ([self.rankArray[indexPath.row][@"isHide"] intValue]==1) {
            cell.shouYi.text = @"****";
            cell.shouYi.font = [UIFont systemFontOfSize:20.0];
        }
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rankArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSDictionary * dictionary = self.rankArray[indexPath.row];
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    PlagerinfoViewController *playerInfoCtr = [mainStoryboard instantiateViewControllerWithIdentifier:@"secondStory"];
//    playerInfoCtr.playerInfo= dictionary[@"user"];
//    [self.navigationController pushViewController:playerInfoCtr animated:YES];

}
- (void)findUnionsRank:(int )type
{
    
    if (type==0) {
        [self.rankArray removeAllObjects];
        [UserConnector findUnionsRank:type limit:10 receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (error) {
                [ShowMessage showMessage:@"服务器无法响应"];
            }else{
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSDictionary * json = [parser objectWithData:data];
                NSArray * testArray = json[@"entity"];
                int status = [json[@"status"] intValue];
                if (status==0) {
                    self.rankArray = json[@"entity"];
                    if ( self.rankArray.count == testArray.count) {
                        [self.tableview reloadData];
                    }
                    [self.tableview.mj_header endRefreshing];
                }else if (status==1) {
                    [PersistenceManager setLoginSession:@""];
                    LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                    lv.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:lv animated:YES];
                    
                }else{
                    
                }
            }
        }];

    }else{
        [UserConnector findUnionsRank:type limit:10 receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (error) {
                [ShowMessage showMessage:@"服务器无法响应"];
            }else{
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSDictionary * json = [parser objectWithData:data];

                int status = [json[@"status"] intValue];
                if (status==0) {

                    [json[@"entity"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [self.rankArray addObject:obj];
                        [self.tableview reloadData];
                    }];
                    [self.tableview.mj_footer endRefreshing];
                    
                }else if (status==1) {
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
@end
