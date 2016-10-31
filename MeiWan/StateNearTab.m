//
//  StateNearTab.m
//  MeiWan
//
//  Created by apple on 15/11/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "StateNearTab.h"
#import "CorlorTransform.h"
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
#import "ButtonLable.h"
#import "MBProgressHUD.h"
#import "MoveActionViewController.h"

@interface StateNearTab ()<MoveActionCellDelegate,DiscussTabViewDelegate,MBProgressHUDDelegate,moveAction>
{
    MBProgressHUD * HUD;
}
@property (nonatomic,strong) MoveActionFrame *moveActionFrame;
@property (nonatomic,strong) MoveAction *moveAction;
@property (nonatomic,strong) NSMutableArray *myMoveArray;
@property (nonatomic,assign) int stateCount;
@property (nonatomic,assign) BOOL isDiscuss;
@property (nonatomic,assign) NSInteger indexpathRow;
//@property (nonatomic,assign) NSMutableArray *moveActionFrames;
@end

@implementation StateNearTab

- (IBAction)addNewStatus:(id)sender {
    [self performSegueWithIdentifier:@"newStatus" sender:nil];
}
-(void)back
{
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"加载中";
    HUD.delegate = self;
    [HUD showAnimated:YES whileExecutingBlock:^{
        //NSLog(@"什么时候调用");
    }];
    [self.navigationController.navigationBar setBarTintColor:[CorlorTransform colorWithHexString:@"78cdf8"]];
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor]           forKey:NSForegroundColorAttributeName];
    self.stateCount = 5;
    //self.moveActionFrames = [NSMutableArray array];
    [self setupRefresh];
    [self getDataWithNumber:self.stateCount];
    
}
#pragma mark - getData
-(void)getDataWithNumber:(int)limit{
    
    [UserConnector findAroundStates:[PersistenceManager getLoginSession] offset:[NSNumber numberWithInt:0] limit:[NSNumber numberWithInt:limit] receiver:^(NSData *data, NSError *error){
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            [HUD hide:YES afterDelay:0];
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableDictionary *json = [parser objectWithData:data];
            //NSLog(@"%@",json);
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                self.myMoveArray = [json objectForKey:@"entity"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [HUD hide:YES afterDelay:0.5];
                });
            }else if(status == 1){
                [self loginPush];
            }else{
                
            }
        }
        
    }];

}
- (void)loginPush
{
    [PersistenceManager setLoginSession:@""];
    LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    lv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:lv animated:YES];
}
#pragma mark - refresh
- (void)setupRefresh
{
    
    //2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    
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
    self.stateCount = 5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [self getDataWithNumber:self.stateCount];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView.mj_header endRefreshing];

     });
}
-(void)footerRereshing{
    self.stateCount += 5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getDataWithNumber:self.stateCount];
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
#pragma mark - moveActionCellDelegate
//点击用户头像storyboard连线跳转
-(void)tapHeadImg:(MoveActionFrame *)moveActionFrame{
    NSDictionary *personInfoDic = moveActionFrame.moveActionModel.userInfo;
    [self performSegueWithIdentifier:@"personInfo" sender:personInfoDic];
    
}
//点击图片push
-(void)tapImage:(NSInteger)imageTag AndMoveActionFrame:(MoveActionFrame *)moveActionFrame{
    ImageViewController *iv = [[ImageViewController alloc]init];
    iv.moveActionframe = moveActionFrame;
    iv.imageCount = (int)imageTag/111;
    iv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:iv animated:NO];
}
//点击单元格storyboard连线跳转
-(void)discuss:(MoveActionFrame*)moveActionFrame andIndexPathRow:(NSInteger)row{
     self.isDiscuss = YES;
    self.indexpathRow = row;
     [self performSegueWithIdentifier:@"discuss" sender:moveActionFrame];
}

#pragma mark - tableviewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
            noMsgLabel.text = @"尚无动态";
            noMsgLabel.textColor = [UIColor darkGrayColor];
            noMsgLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:noMsgLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
        
    }
    
    self.moveActionFrame = [[MoveActionFrame alloc]init];
    self.moveAction = [[MoveAction alloc]initWithDictionary:self.myMoveArray[indexPath.row] andUser:[self.myMoveArray[indexPath.row] objectForKey:@"user"]];
    self.moveActionFrame.moveActionModel = self.moveAction;
    MoveActionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell" forIndexPath:indexPath];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    cell.moveActionFrame = self.moveActionFrame;
    cell.indexRow = indexPath.row;
    cell.delegate = self;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.myMoveArray.count == 0) {
        return 44;
    }else{
        self.moveActionFrame = [[MoveActionFrame alloc]init];
        self.moveAction = [[MoveAction alloc]initWithDictionary:self.myMoveArray[indexPath.row] andUser:[self.myMoveArray[indexPath.row] objectForKey:@"user"]];
        self.moveActionFrame.moveActionModel = self.moveAction;
        return self.moveActionFrame.cellHeight;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.myMoveArray.count == 0) {
        return ;
    }else{
        MoveActionViewCell * changeCell = (MoveActionViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        self.isDiscuss = NO;
        self.indexpathRow = indexPath.row;
        [self performSegueWithIdentifier:@"discuss" sender:changeCell.moveActionFrame];
        
    }

}
//storyBoard连线跳转
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"discuss"]) {
        DiscussTableViewController *dv = segue.destinationViewController;
        dv.maf = sender;
        dv.isFromDiscuss = self.isDiscuss;
        dv.indexPathrow = self.indexpathRow;
        dv.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"personInfo"]) {
        PlagerinfoViewController *pv = segue.destinationViewController;
        pv.playerInfo = sender;
    }
    if ([segue.identifier isEqualToString:@"newStatus"]) {
        MoveActionViewController * mv = segue.destinationViewController;
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
