//
//  MyMoveActionTableViewController.m
//  MeiWan
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MyMoveActionTableViewController.h"
#import "MoveActionViewController.h"
#import "MoveActionViewCell.h"
#import "MoveAction.h"
#import "MoveActionFrame.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "ShowMessage.h"
#import "MJRefresh.h"
#import "ImageViewController.h"
#import "LoginViewController.h"
#import "ButtonLable.h"
#import "DiscussTableViewController.h"
#import "PlagerinfoViewController.h"
#import "CorlorTransform.h"
@interface MyMoveActionTableViewController ()<moveAction,MoveActionCellDelegate,UIActionSheetDelegate,DiscussTabViewDelegate>
@property (nonatomic,strong) MoveActionFrame *moveActionFrame;
@property (nonatomic,strong) MoveAction *moveAction;
@property (nonatomic,strong) NSMutableArray *myMoveArray;
@property (nonatomic,assign) int stateCount;
@property (nonatomic,strong) MoveActionViewCell * memoryCell;
@property (nonatomic,assign) BOOL isdiscuss;
@property (nonatomic,assign) NSInteger indexpathRow;

@end

@implementation MyMoveActionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stateCount = 5;
    [self setupRefresh];
    //self.tableView.backgroundColor = [UIColor redColor];
    //NSLog(@"%@",self.myUserInfo);
    //添加长按删除动作
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [self.tableView addGestureRecognizer:longPressGr];
    
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
//长按动作的实现
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
        
        if(indexPath == nil) return ;
        if (self.myMoveArray.count == 0) return;
        
        MoveActionViewCell * selectCell = (MoveActionViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"确认删除该动态" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
        [sheet showInView:selectCell];
        self.memoryCell = selectCell;
    }
}
//删除动态
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;{
    
    if (buttonIndex == 0) {
        NSIndexPath * path = [self.tableView indexPathForCell:self.memoryCell];
        NSDictionary * stateDic = [self.myMoveArray objectAtIndex:path.row];
        [self.myMoveArray removeObjectAtIndex:path.row];
        //NSLog(@"%@",stateDic);
        //NSLog(@"%ld",path.row);
        NSString *session = [PersistenceManager getLoginSession];
        [UserConnector deleteState:session stateId:[stateDic objectForKey:@"id"] receiver:^(NSData *data, NSError *error) {
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser *parser = [[SBJsonParser alloc]init];
                NSMutableDictionary *json = [parser objectWithData:data];
                //NSLog(@"%@",json);
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                        self.memoryCell = nil;
                         if (self.myMoveArray.count == 0) {
                             [self.tableView reloadData];
                         }else{
                             [self.tableView reloadData];
                         }

                    });
                }else if(status == 1){
                    
                }else{
                    
                }
            }

        }];

    }
}


- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self headerRereshing];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self footerRereshing];
    }];
}
//上拉刷新
- (void)headerRereshing
{
    //self.stateCount += 5;
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
        [self.tableView.mj_footer endRefreshing];
    });
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - moveActionCell delegate
-(void)tapHeadImg:(MoveActionFrame *)moveActionFrame{
    NSDictionary * infoDic = moveActionFrame.moveActionModel.userInfo;
    [self performSegueWithIdentifier:@"mepersonInfo" sender:infoDic];
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
#pragma mark - sendMoveAction delegate
-(void)back{
    self.stateCount += 1;
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

}
#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
            noMsgLabel.text = @"您尚未发布动态";
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
    }else if ([segue.identifier isEqualToString:@"mepersonInfo"]) {
        PlagerinfoViewController *pv = segue.destinationViewController;
        pv.playerInfo = sender;
    }else{
        MoveActionViewController *mv = segue.destinationViewController;
        mv.delegate = self;

    }

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
