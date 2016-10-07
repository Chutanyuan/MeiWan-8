//
//  FocusViewController.m
//  MeiWan
//
//  Created by Fox on 16/7/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "FocusViewController.h"
#import "FocusTableViewCell.h"
#import "LoginViewController.h"
#import "PlagerinfoViewController.h"

#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "CorlorTransform.h"
#import "MJRefresh.h"
#import "ShowMessage.h"

@interface FocusViewController ()<UITableViewDelegate,UITableViewDataSource,FocusTableViewCellDelegate>

@property (nonatomic, strong) UITableView *focusTableView;
@property (nonatomic, strong) NSMutableArray * focusArray;
@property (nonatomic, strong) NSNumber *peiwanId;
@property (nonatomic, strong) NSMutableArray * MyfriendArray;
@property (nonatomic, assign) int offset;

@end

@implementation FocusViewController

-(void)viewWillAppear:(BOOL)animated{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.offset = 0;
    self.title = @"我的粉丝";

    [self focusFollowersBy:self.offset];
    [self findMyFriendList];
    [self CreatTableView];
    
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.focusArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];//以indexPath来唯一确定cell

    if (self.focusArray.count == 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            CGRect frame = cell.frame;
            cell.frame = CGRectMake(frame.origin.x, frame.origin.y, [[UIScreen mainScreen] applicationFrame].size.width, frame.size.height);
            [[UIScreen mainScreen] applicationFrame];
            UILabel *noMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 100.0f, cell.frame.size.width, 50.0f)];
            noMsgLabel.text = @"您尚未关注用户";
            noMsgLabel.textColor = [UIColor darkGrayColor];
            noMsgLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:noMsgLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
        
    }
    FocusTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[FocusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.focusDic = self.focusArray[indexPath.row];
    
    cell.delegate =self;
    [self.MyfriendArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isEqualToDictionary:self.focusArray[indexPath.row]]) {
            [cell.focusButton setTitle:@"互相关注" forState:UIControlStateNormal];

        }
    }];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
    self.hidesBottomBarWhenPushed = YES;
    
    [self performSegueWithIdentifier:@"focusDetail" sender:self.focusArray[indexPath.row]];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

#pragma mark -FocusTableViewCellDelegate
-(void)focusTableViewCell:(FocusTableViewCell *)cell userID:(NSString *)userID{
    
        NSInteger userNumber =[userID integerValue];
        NSNumber * number =[NSNumber numberWithUnsignedInteger:userNumber];
        NSString *sesstion = [PersistenceManager getLoginSession];
        [UserConnector addFriend:sesstion friendId:number receiver:^(NSData *data,NSError *error){
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {

                    [ShowMessage showMessage:@"关注成功"];
                    [cell.focusButton setTitle:@"互相关注" forState:UIControlStateNormal];

                    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"focusDetail"]) {
        PlagerinfoViewController *pv = segue.destinationViewController;
        pv.playerInfo = sender;
    }
}

/**获取粉丝列表*/
- (void)focusFollowersBy:(int)offset{
    NSString *sesstion = [PersistenceManager getLoginSession];
    [UserConnector findMyFocus:sesstion offset:offset limit:10 receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                
                if (offset==0) {
                    [self.focusArray removeAllObjects];
                    self.focusArray = [json objectForKey:@"entity"];
                    for (int i = 0;  i < self.focusArray.count; i++) {
                        if ([self.focusArray[i] isKindOfClass:[NSNull class]]) {
                            [self.focusArray removeObjectAtIndex:i];
                        }
                    }
                    [_focusTableView reloadData];
                    [_focusTableView.mj_header endRefreshing];

                }else{
                    [self.focusArray addObjectsFromArray:json[@"entity"]];
                    [_focusTableView reloadData];
                    [_focusTableView.mj_footer endRefreshing];
                }
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
            [_focusTableView reloadData];
        }
    }];
}

/**提示框*/
- (void)showMessageAlert:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
    }];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**创建tableView*/
- (void)CreatTableView
{
    _focusTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight) style:UITableViewStylePlain];
    _focusTableView.delegate = self;
    _focusTableView.dataSource = self;
    _focusTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_focusTableView];
    _focusTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        self.offset = 0;
        [self focusFollowersBy:self.offset];
        [_focusTableView.mj_header beginRefreshing];
        
    }];
    _focusTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
       
        self.offset+=10;
        [self focusFollowersBy:self.offset];
        [_focusTableView.mj_footer beginRefreshing];
        
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
