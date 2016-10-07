//
//  FriendListTableViewController.m
//  MeiWan
//
//  Created by apple on 15/8/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "FriendListTableViewController.h"
#import "FriendListTableViewCell.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "PlagerinfoViewController.h"
#import "ShowMessage.h"
#import "LoginViewController.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "CorlorTransform.h"
@interface FriendListTableViewController ()<UIActionSheetDelegate>
@property (nonatomic,strong) NSMutableArray *myfriendsArray;
@property (nonatomic,assign) int stateCount;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addFriend;
@property (strong, nonatomic) UITextField *idtext;
@property (nonatomic ,strong) NSNumber *peiwanId;
@property (nonatomic ,strong) UIView *peiwanView;
@property (nonatomic ,strong) UIView *clearView;
@property (nonatomic ,strong) UIImageView *head;
@property (nonatomic ,strong) UILabel *nickname;
@property (nonatomic ,strong) UILabel *gender;
@property (nonatomic,strong) FriendListTableViewCell *memoryCell;
@end

@implementation FriendListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRefresh];
    //添加长按删除动作
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [self.tableView addGestureRecognizer:longPressGr];

}
//长按动作的实现
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
        
        if(indexPath == nil) return ;
        if (self.myfriendsArray.count == 0) return;
        FriendListTableViewCell * selectCell = (FriendListTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"确认删除该好友" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
        [sheet showInView:selectCell];
        self.memoryCell = selectCell;
    }
}
//删除好友
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;{
    if (buttonIndex == 0) {
        NSIndexPath * path = [self.tableView indexPathForCell:self.memoryCell];
        NSDictionary * friendDic = [self.myfriendsArray objectAtIndex:path.row];
        [self.myfriendsArray removeObjectAtIndex:path.row];
        //NSLog(@"%@",stateDic);
        //NSLog(@"%ld",path.row);
        NSString *session = [PersistenceManager getLoginSession];
        [UserConnector deleteFriend:session friendId:[friendDic objectForKey:@"id"] receiver:^(NSData *data,NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.memoryCell = nil;
                if (self.myfriendsArray.count == 0) {
                     [self.tableView reloadData];
                }else{
                  [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
                }
            });
            
        }];
        
    }
    
}
- (IBAction)addFriendAction:(UIBarButtonItem *)sender {
    _peiwanView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 240,130)];
    _peiwanView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _peiwanView.layer.cornerRadius = 5;
    _peiwanView.layer.masksToBounds = YES;
    _idtext = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 180, 30)];
    _idtext.keyboardType = UIKeyboardTypeNumberPad;
    _idtext.placeholder = @"请输入ID";
    _idtext.backgroundColor = [UIColor whiteColor];
    [_peiwanView addSubview:_idtext];
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(186, 0, 54, 30)];
    searchBtn.backgroundColor = [UIColor whiteColor];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [_peiwanView addSubview:searchBtn];
    
    _head = [[UIImageView alloc]initWithFrame:CGRectMake(5, 35, 60, 60)];
    _head.layer.cornerRadius = 5;
    _head.layer.masksToBounds = YES;
    //_head.contentMode = UIViewContentModeScaleAspectFit;
    [_peiwanView addSubview:_head];

    _nickname = [[UILabel alloc]initWithFrame:CGRectMake(80, 45, 160, 20)];
    _nickname.font = [UIFont systemFontOfSize:14];
    _nickname.textColor = [UIColor grayColor];
    [_peiwanView addSubview:_nickname];
    
    _gender = [[UILabel alloc]initWithFrame:CGRectMake(80, 70, 160, 20)];
    _gender.textColor = [UIColor grayColor];
    _gender.font = [UIFont systemFontOfSize:14];    UIButton *disAction = [[UIButton alloc]initWithFrame:CGRectMake(0, 100, 120, 30)];
    [_peiwanView addSubview:_gender];

    disAction.layer.cornerRadius = 5;
    disAction.layer.masksToBounds = YES;
    disAction.backgroundColor = [UIColor whiteColor];
    [disAction setTitle:@"取消" forState:UIControlStateNormal];
    [disAction setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [disAction addTarget:self action:@selector(disaction) forControlEvents:UIControlEventTouchUpInside];
    [_peiwanView addSubview:disAction];
    UIButton *makeSure = [[UIButton alloc]initWithFrame:CGRectMake(121, 100, 119, 30)];
    [makeSure setTitle:@"确定" forState:UIControlStateNormal];
    makeSure.layer.cornerRadius = 5;
    makeSure.layer.masksToBounds = YES;
    makeSure.backgroundColor = [UIColor whiteColor];
    [makeSure setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [makeSure addTarget:self action:@selector(makeSure) forControlEvents:UIControlEventTouchUpInside];
    [_peiwanView addSubview:makeSure];
    
    _clearView = [[UIView alloc]initWithFrame:self.view.bounds];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disaction)];
    [_clearView addGestureRecognizer:tap];
    self.view.alpha = 0.5;
    [[ShowMessage mainWindow] addSubview:_clearView];
    [[ShowMessage mainWindow] addSubview:_peiwanView];
    
    _peiwanView.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
}
-(void)search{
    NSString *input = _idtext.text;
    long inputNum = [input doubleValue];
    self.peiwanId = [NSNumber numberWithLong:inputNum];
    if (input.length == 0) {
       [ShowMessage showMessage:@"输入不能为空"];
       return;
    }else{
       NSString *sesstion = [PersistenceManager getLoginSession];
      [UserConnector findPeiwanById:sesstion userId:self.peiwanId receiver:^(NSData * data, NSError * error) {
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            //NSLog(@"%@",json);
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                NSDictionary *peiwanInfoDic = [json objectForKey:@"entity"];
                //NSLog(@"%@",peiwanInfoDic);
                if (peiwanInfoDic) {


                    if ([peiwanInfoDic objectForKey:@"headUrl"]) {
                        NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@!1",[peiwanInfoDic objectForKey:@"headUrl"]]];
                        [_head setImageWithURL:url];

                    }
                    _nickname.text = [peiwanInfoDic objectForKey:@"nickname"];

                    if ([[peiwanInfoDic objectForKey:@"gender"]intValue] == 0) {
                        _gender.text = @"男";
                    }else{
                        _gender.text = @"女";
                    }

                }else{
                    [ShowMessage showMessage:@"查无此人"];
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
}
- (void)disaction{
    self.view.alpha = 1;
    [_clearView removeFromSuperview];
    [_peiwanView removeFromSuperview];
}
- (void)makeSure{
    //NSLog(@"%@",self.peiwanId);
    if (self.peiwanId) {
        self.view.alpha = 1;
        [_clearView removeFromSuperview];
        [_peiwanView removeFromSuperview];
        NSString *sesstion = [PersistenceManager getLoginSession];
        [UserConnector addFriend:sesstion friendId:self.peiwanId receiver:^(NSData *data,NSError *error){
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];
                //NSLog(@"%@",json);
                int status = [[json objectForKey:@"status"]intValue];
                //NSLog(@"%d",status);
                if (status == 0) {
                    [self reloadFriends];
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
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self reloadFriends];
}
- (void)reloadFriends{
    NSString *sesstion = [PersistenceManager getLoginSession];
    [UserConnector findMyFriends:sesstion receiver:^(NSData *data,NSError *error){
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                self.myfriendsArray = [json objectForKey:@"entity"];
                for (int i = 0;  i < self.myfriendsArray.count; i++) {
                    if ([self.myfriendsArray[i] isKindOfClass:[NSNull class]]) {
                        [self.myfriendsArray removeObjectAtIndex:i];
                    }
                }
                //NSLog(@"%@++++++",self.myfriendsArray);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
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
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [self headerRereshing];
    }];

}
//上拉刷新
- (void)headerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *sesstion = [PersistenceManager getLoginSession];
        [UserConnector findMyFriends:sesstion receiver:^(NSData *data,NSError *error){
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    self.myfriendsArray = [json objectForKey:@"entity"];
                    for (int i = 0;  i < self.myfriendsArray.count; i++) {
                        if ([self.myfriendsArray[i] isKindOfClass:[NSNull class]]) {
                            [self.myfriendsArray removeObjectAtIndex:i];
                        }
                    }
                    //NSLog(@"%@",self.myfriendsArray);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }else if (status == 1){
                    [PersistenceManager setLoginSession:@""];
                    LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                    lv.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:lv animated:YES];
                

                }else{
                    
                }
            }
        }];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView.mj_header endRefreshing];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.myfriendsArray.count == 0 ) {
        return 1;
    }
    return self.myfriendsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.myfriendsArray.count == 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        static NSString *noMessageCellid = @"sessionnomessageCellidentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noMessageCellid];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noMessageCellid];
            CGRect frame = cell.frame;
            cell.frame = CGRectMake(frame.origin.x, frame.origin.y, [[UIScreen mainScreen] applicationFrame].size.width, frame.size.height);
            [[UIScreen mainScreen] applicationFrame];
            UILabel *noMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 100.0f, cell.frame.size.width, 50.0f)];
            noMsgLabel.text = @"您尚未添加好友";
            noMsgLabel.textColor = [UIColor darkGrayColor];
            noMsgLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:noMsgLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;

    }
    
    FriendListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    cell.friendInfoDic = self.myfriendsArray[indexPath.row];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    self.hidesBottomBarWhenPushed = YES;
    if (!(self.myfriendsArray.count == 1)) {
        [self performSegueWithIdentifier:@"moreAbout" sender:self.myfriendsArray[indexPath.row]];
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!(self.myfriendsArray.count == 0)) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            NSString *sesstion = [PersistenceManager getLoginSession];
            [UserConnector deleteFriend:sesstion friendId:[self.myfriendsArray[indexPath.row] objectForKey:@"id"] receiver:^(NSData *data,NSError *error){
            }];
            if (self.myfriendsArray.count == 1) {
                [self.myfriendsArray removeObjectAtIndex:indexPath.row];
                [tableView reloadData];
             }else{
                [self.myfriendsArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        } else if (editingStyle == UITableViewCellEditingStyleInsert) {

        }

    }

}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"moreAbout"]) {
        PlagerinfoViewController *pv = segue.destinationViewController;
//        pv.friendList = 1;
//        NSUserDefaults *defaultslist =[NSUserDefaults standardUserDefaults];
////        NSDictionary *playerinfos = sender;
//        [defaultslist setObject:sender forKey:@"playerinfofrist"];
        pv.playerInfo = sender;
    }
}


@end
