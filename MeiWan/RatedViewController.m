//
//  RatedViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/10/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RatedViewController.h"
#import "MeiWan-Swift.h"
#import "CommentTableViewCell.h"
#import "MJRefresh.h"

#define LIMIT 10

@interface RatedViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger offSet;
}
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)UITableView * tableview;

@end

@implementation RatedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    offSet = 0;
    self.dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.view.backgroundColor = [UIColor whiteColor];
    [self ratedNetWorking:offSet limit:LIMIT];
    
    UITableView * tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight) style:UITableViewStylePlain];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        offSet = 0;
        [tableview.mj_header beginRefreshing];
        [self ratedNetWorking:offSet limit:LIMIT];
    }];
    tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        offSet += LIMIT;
        [tableview.mj_footer beginRefreshing];
        [self ratedNetWorking:offSet limit:LIMIT];
    }];
    self.tableview = tableview;

}

- (void)ratedNetWorking:(NSInteger)offset limit:(NSInteger)limit
{
    [UserConnector findOrderEvaluationByUserId:[NSNumber numberWithInteger:[self.playerInfo[@"id"] integerValue]] offset:[NSNumber numberWithInteger:offset] limit:[NSNumber numberWithInteger:limit] receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            SBJsonParser * parser = [[SBJsonParser alloc] init];
            NSDictionary * json = [parser objectWithData:data];
            int status = [json[@"status"] intValue];
            if (status==0) {
                if (offset==0) {
                    [self.dataArray removeAllObjects];
                    [self.dataArray addObjectsFromArray:json[@"entity"]];
                    [self.tableview.mj_header endRefreshing];
                }else{
                    [self.dataArray addObjectsFromArray:json[@"entity"]];
                    [self.tableview.mj_footer endRefreshing];
                }
                [self.tableview reloadData];
            }
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (self.dataArray.count>0) {
        cell.evaluateDictionary = self.dataArray[indexPath.row];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
