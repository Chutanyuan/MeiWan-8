//
//  StateTableViewController.m
//  MeiWan
//
//  Created by apple on 15/9/12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "StateTableViewController.h"
#import "MoveActionViewCell.h"
#import "MoveAction.h"
#import "MoveActionFrame.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "ShowMessage.h"
#import "MJRefresh.h"
#import "ImageViewController.h"
#import "LoginViewController.h"
#import "DiscussTableViewController.h"
#import "PlagerinfoViewController.h"
#import "CorlorTransform.h"
#import "ButtonLable.h"

@interface StateTableViewController ()<MoveActionCellDelegate,DiscussTabViewDelegate>
@property (nonatomic,strong) MoveActionFrame *moveActionFrame;
@property (nonatomic,strong) MoveAction *moveAction;
@property (nonatomic,strong) NSMutableArray *myMoveArray;
@property (nonatomic,assign) int stateCount;
@property (nonatomic,assign) BOOL isdiscuss;
@property (nonatomic,assign) NSInteger indexpathRow;

@end

@implementation StateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stateCount = 5;
    [self setupRefresh];
    self.title = [NSString stringWithFormat:@"%@的动态",[self.myUserInfo objectForKey:@"nickname"]];
    [UserConnector findStates:[PersistenceManager getLoginSession]userId:[self.myUserInfo objectForKey:@"id"] offset:[NSNumber numberWithInt:0] limit:[NSNumber numberWithInt:5] receiver:^(NSData *data, NSError *error){
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableDictionary *json = [parser objectWithData:data];
            //NSLog(@"%@",json);
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                self.myMoveArray = [json objectForKey:@"entity"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    
                });
            }else if(status == 1){
            }else{
                
            }
        }
        
    }];
    
}
#pragma mark - tableView Refresh
- (void)setupRefresh
{
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [self headerRereshing];
    }];
    self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        [self footerRereshing];
    }];
    
}
//上拉刷新
- (void)headerRereshing
{
    self.stateCount = 5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UserConnector findStates:[PersistenceManager getLoginSession]userId:[self.myUserInfo objectForKey:@"id"] offset:[NSNumber numberWithInt:0] limit:[NSNumber numberWithInt:self.stateCount] receiver:^(NSData *data, NSError *error){
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser *parser = [[SBJsonParser alloc]init];
                NSMutableDictionary *json = [parser objectWithData:data];
                //NSLog(@"%@",json);
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    self.myMoveArray = [json objectForKey:@"entity"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }else if(status == 1){

                }else{
                    
                }
            }
            
        }];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView.mj_header endRefreshing];
    });
}
-(void)footerRereshing{
    self.stateCount += 5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UserConnector findStates:[PersistenceManager getLoginSession] userId:[self.myUserInfo objectForKey:@"id"] offset:[NSNumber numberWithInt:0] limit:[NSNumber numberWithInt:self.stateCount] receiver:^(NSData *data, NSError *error){
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser *parser = [[SBJsonParser alloc]init];
                NSMutableDictionary *json = [parser objectWithData:data];
                //NSLog(@"%@",json);
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    self.myMoveArray = [json objectForKey:@"entity"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }else if(status == 1){

                }else{
                    
                }
            }
            
        }];
        [self.tableView.mj_footer endRefreshing];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - discussTabDelegate
-(void)countDidChange:(int)count atIndexPathRow:(NSInteger)row{
    NSIndexPath * path = [NSIndexPath indexPathForRow:row inSection:0];
    MoveActionViewCell * changeCell = (MoveActionViewCell*)[self.tableView cellForRowAtIndexPath:path];
    changeCell.moveActionFrame.moveActionModel.discussCount = count;
    changeCell.discuss.lyTitleLable.text = [NSString stringWithFormat:@"%d",count];
}
-(void)praiseDidChange:(BOOL)isPraise atIndexPathRow:(NSInteger)row{
    NSIndexPath * path = [NSIndexPath indexPathForRow:row inSection:0];
    MoveActionViewCell * changeCell = (MoveActionViewCell*)[self.tableView cellForRowAtIndexPath:path];
    changeCell.praise.selected = isPraise;
    changeCell.moveActionFrame.moveActionModel.isPraise = isPraise;
    if (isPraise) {
        changeCell.moveActionFrame.moveActionModel.praiseCount += 1
        ;
        changeCell.praise.lyTitleLable.textColor = [CorlorTransform colorWithHexString:@"56abe4"];
    }else{
        changeCell.moveActionFrame.moveActionModel.praiseCount -= 1;
        changeCell.praise.lyTitleLable.textColor = [CorlorTransform colorWithHexString:@"a9b7b7"];
    }
    if (changeCell.moveActionFrame.moveActionModel.praiseCount == 0) {
        changeCell.praise.lyTitleLable.text = @"赞";
    }else{
        changeCell.praise.lyTitleLable.text = [NSString stringWithFormat:@"%d",changeCell.moveActionFrame.moveActionModel.praiseCount];
    }
}

#pragma mark - moveActionCell Delegate
-(void)tapHeadImg:(MoveActionFrame *)moveActionFrame{
    [self performSegueWithIdentifier:@"personInfo" sender:moveActionFrame.moveActionModel.userInfo];
}
-(void)tapImage:(NSInteger)imageTag AndMoveActionFrame:(MoveActionFrame *)moveActionFrame{
    ImageViewController *iv = [[ImageViewController alloc]init];
    iv.moveActionframe = moveActionFrame;
    iv.imageCount = (int)imageTag/111;
    [self.navigationController pushViewController:iv animated:NO];
    
}
-(void)discuss:(MoveActionFrame *)moveActionFrame andIndexPathRow:(NSInteger)row{
    self.isdiscuss = YES;
    self.indexpathRow = row;
    [self performSegueWithIdentifier:@"discuss" sender:moveActionFrame];
}
#pragma mark - tableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // Return the number of rows in the section.
    if (self.myMoveArray.count == 0) {
        return 1;
    }
    return self.myMoveArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.myMoveArray.count == 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        static NSString *noMessageCellid = @"sessionnomessageCellidentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noMessageCellid];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noMessageCellid];
            CGRect frame = cell.frame;
            cell.frame = CGRectMake(frame.origin.x, frame.origin.y, [[UIScreen mainScreen] applicationFrame].size.width, frame.size.height);
            UILabel *noMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 100.0f, cell.frame.size.width, 50.0f)];
            noMsgLabel.text = @"主人尚未发布动态";
            noMsgLabel.textColor = [UIColor darkGrayColor];
            noMsgLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:noMsgLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
        
    }
    MoveActionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell" forIndexPath:indexPath];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.moveActionFrame = [[MoveActionFrame alloc]init];
    self.moveAction = [[MoveAction alloc]initWithDictionary:self.myMoveArray[indexPath.row] andUser:self.myUserInfo];
    self.moveActionFrame.moveActionModel = self.moveAction;
    cell.moveActionFrame = self.moveActionFrame;
    cell.delegate = self;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.myMoveArray.count == 0) {
        return 44;
    }else{
        self.moveActionFrame = [[MoveActionFrame alloc]init];
        self.moveAction = [[MoveAction alloc]initWithDictionary:self.myMoveArray[indexPath.row] andUser:self.myUserInfo];
        self.moveActionFrame.moveActionModel = self.moveAction;
        return self.moveActionFrame.cellHeight;
        
    }

}

#pragma mark - tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MoveActionViewCell * changeCell = (MoveActionViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    self.isdiscuss = NO;
    self.indexpathRow = indexPath.row;
    [self performSegueWithIdentifier:@"discuss" sender:changeCell.moveActionFrame];
}

#pragma mark - prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"discuss"]) {
        DiscussTableViewController *dv = segue.destinationViewController;
        dv.maf = sender;
        dv.isFromDiscuss = self.isdiscuss;
        dv.indexPathrow = self.indexpathRow;
        dv.delegate = self;

    }
    if ([segue.identifier isEqualToString:@"personInfo"]) {
        PlagerinfoViewController * pv = segue.destinationViewController;
        pv.playerInfo = sender;
    }
}
@end
