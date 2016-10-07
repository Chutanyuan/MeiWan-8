//
//  RecordTableViewController.m
//  MeiWan
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RecordTableViewController.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "ShowMessage.h"
#import "LoginViewController.h"
#import "RecordTableViewCell.h"
#import "MJRefresh.h"
@interface RecordTableViewController ()
@property (nonatomic,strong)NSMutableArray *recordsArray;
@property (nonatomic,assign) int infoCount;
@end

@implementation RecordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.infoCount = 5;
    NSString *session = [PersistenceManager getLoginSession];
    [UserConnector myCashRequests:session offset:[NSNumber numberWithInt:0] limit:[NSNumber numberWithInt:5] receiver:^(NSData *data, NSError *error){
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            //NSLog(@"%@",json);
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                self.recordsArray = [json objectForKey:@"entity"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    
                });
                
            }else if(status == 1){
                [PersistenceManager setLoginSession:@""];
                LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                lv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:lv animated:YES];
                
            }else if (status == 2){
                
            }else{
                
            }
        }
        
    }];
    [self setupRefresh];
}
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self headerRereshing];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self footerRereshing];
    }];
}
//下拉刷新
- (void)headerRereshing
{
    self.infoCount += 5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *session = [PersistenceManager getLoginSession];
        [UserConnector myCashRequests:session offset:[NSNumber numberWithInt:0] limit:[NSNumber numberWithInt:self.infoCount] receiver:^(NSData *data, NSError *error){
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];
                //NSLog(@"%@",json);
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    self.recordsArray = [json objectForKey:@"entity"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                    
                }else if(status == 1){
                    [PersistenceManager setLoginSession:@""];
                    LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                    lv.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:lv animated:YES];
                                       
                }else if (status == 2){
                    
                }else{
                    
                }
            }
            
        }];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView.mj_header endRefreshing];
    });
}
//上拉刷新
- (void)footerRereshing
{
    self.infoCount += 5;
    //NSLog(@"%d",self.infoCount);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *session = [PersistenceManager getLoginSession];
        [UserConnector myCashRequests:session offset:[NSNumber numberWithInt:0] limit:[NSNumber numberWithInt:self.infoCount] receiver:^(NSData *data, NSError *error){
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];
                //NSLog(@"%@",json);
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    self.recordsArray = [json objectForKey:@"entity"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                        
                    });
                    
                }else if(status == 1){
                    [PersistenceManager setLoginSession:@""];
                    LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                    lv.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:lv animated:YES];
                                       
                }else if (status == 2){
                    
                }else{
                    
                }
            }
            
        }];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView.mj_footer endRefreshing];
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.recordsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.infodic = self.recordsArray[indexPath.row];
    
    return cell;
}



@end
