//
//  AssesserInfoViewController.m
//  MeiWan
//
//  Created by apple on 15/8/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AssesserInfoViewController.h"
#import "GameRloeTableViewCell.h"
#import "UserAssessTableViewCell.h"
#import "ShowMessage.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "MJRefresh.h"
#import "PlayerInfoView.h"
#import "NetBarViewController.h"
#import "UIImageView+WebCache.h"
#import "ExploitsTableViewController.h"
#import "InviteViewController.h"
#import "LoginViewController.h"
#import "StateTableViewController.h"
#import "PeiwanHeadViewController.h"
#import "setting.h"
#import "EaseMessageViewController.h"
#import "ChatViewController.h"
#import "MJRefresh.h"

@interface AssesserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,pageJumpDelegate,userAssessTapdelegate>

@property (strong, nonatomic) UIScrollView *assesserInfoSv;
@property (strong, nonatomic) PlayerInfoView *pi;
@property (strong, nonatomic) UITableView *gameRole;
@property (strong, nonatomic) UITableView *userAssess;
@property (strong, nonatomic) UIView *moreVi;
@property (strong, nonatomic) UIView *btn;
@property (strong, nonatomic) UIView *tip;
@property (strong, nonatomic) UIView *tipclear;
@property (strong, nonatomic) CWStarRateView *starRateView;
@property (strong, nonatomic) NSMutableArray *playerRoleArray;
@property (strong, nonatomic) NSMutableArray *playerRoleInfoArray;

@property (strong, nonatomic) NSMutableArray *playerOrderArray;
@property (strong, nonatomic) UIView *alwaysInNetBar;
@property (strong, nonatomic) NSMutableArray *playerNetBarArray;
@property (nonatomic,strong) NSString* isFriend;
@property (nonatomic,assign) int limit;

@end

@implementation AssesserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.title = [self.playerInfo objectForKey:@"nickname"];
    self.limit = 5;
    self.assesserInfoSv = [[UIScrollView alloc]initWithFrame:CGRectMake(0,20+self.navigationController.navigationBar.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height-20)];
    self.assesserInfoSv.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.assesserInfoSv];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(more)];

    self.pi = [[[NSBundle mainBundle]loadNibNamed:@"PlayerInfoView" owner:self options:nil] firstObject];
    self.pi.frame = CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height);
    self.pi.playerInfoDic = self.playerInfo;
    NSString *session= [PersistenceManager getLoginSession];
    [UserConnector findPeiwanById:session userId:[self.playerInfo objectForKey:@"id"] receiver:^(NSData *data,NSError *error){
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                self.playerInfo = [json objectForKey:@"entity"];
                self.pi.playerInfoDic = self.playerInfo;
            }else if(status == 1){
            }else{
                
            }
        }
    }];
    [UserConnector findStates:[PersistenceManager getLoginSession]userId:[self.playerInfo objectForKey:@"id"] offset:[NSNumber numberWithInt:0] limit:[NSNumber numberWithInt:1] receiver:^(NSData *data,NSError *error){
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                NSArray *states = [json objectForKey:@"entity"];
                if (states.count >= 1) {
                    NSDictionary *state = states[0];
                    self.pi.stateDic = state;
                }else{
                    self.pi.stateDic = [NSDictionary dictionary];
                }

            }else if (status == 1){
            }else{
                
            }
        }

    }];

    self.pi.delegate = self;
    [self.assesserInfoSv addSubview:self.pi];
    
    self.playerRoleArray = [NSMutableArray array];
    self.playerRoleInfoArray = [NSMutableArray array];
    [UserConnector findRoles:[self.playerInfo objectForKey:@"id"] receiver:^(NSData *data,NSError *error){
        SBJsonParser*parser=[[SBJsonParser alloc]init];
        NSMutableDictionary *json=[parser objectWithData:data];
        self.playerRoleArray = [json objectForKey:@"entity"];

        [self addGameRoleTableview];
        [UserConnector peiwanNetbars:[self.playerInfo objectForKey:@"id"] receiver:^(NSData *data,NSError *error){
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            self.playerNetBarArray = [json objectForKey:@"entity"];

            if (self.playerNetBarArray.count != 0) {
                [self addAlwaysNetBar];
            }
            int offset = 0;
            [UserConnector findOrderEvaluationByUserId:[self.playerInfo objectForKey:@"id"] offset:[NSNumber numberWithInt:offset ] limit:[NSNumber numberWithInt:self.limit] receiver:^(NSData *data,NSError *error){
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];
                self.playerOrderArray = [json objectForKey:@"entity"];

                [self addUserAssessTableview];
                [self setupRefresh];
            }];
        }];
    }];

}
- (void)setupRefresh
{

//    [self.assesserInfoSv addFooterWithTarget:self action:@selector(footerRereshing)];
    self.assesserInfoSv.mj_footer =  [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self footerRereshing];
    }];
    
    
}
//上拉刷新
- (void)footerRereshing
{    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UserConnector findOrderEvaluationByUserId:[self.playerInfo objectForKey:@"id"] offset:[NSNumber numberWithInteger:self.playerOrderArray.count] limit:[NSNumber numberWithInt:self.limit] receiver:^(NSData *data,NSError *error){
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    NSArray *more = [json objectForKey:@"entity"];
                    [self.playerOrderArray addObjectsFromArray:more];
                    float y = 0;
                    if (self.playerNetBarArray.count != 0) {
                        y = self.gameRole.frame.origin.y+self.gameRole.frame.size.height+108;
                    }else{
                        y = self.gameRole.frame.origin.y+self.gameRole.frame.size.height+8;
                    }
                    self.userAssess.frame = CGRectMake(0, y, self.view.bounds.size.width,self.playerOrderArray.count*100+40);
                    float height = 0;
                    if ((self.userAssess.frame.origin.y+self.userAssess.frame.size.height) < (self.view.bounds.size.height-60)) {
                        height = self.view.bounds.size.height - 60;
                    }else{
                        height = self.userAssess.frame.origin.y+self.userAssess.frame.size.height;
                    }
                    self.assesserInfoSv.contentSize = CGSizeMake(self.view.bounds.size.width, height);
                    [self.userAssess reloadData];
                }else if (status == 1){

                }else{
                    
                }
            }

        }];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.assesserInfoSv.mj_footer endRefreshing];
    });
}
- (void)judgeisFriend{
    NSString *sesstion = [PersistenceManager getLoginSession];
    [UserConnector findMyFriends:sesstion receiver:^(NSData *data,NSError *error){
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                NSMutableArray *myFriendsArray = [json objectForKey:@"entity"];
                self.isFriend = @"no";
                for (int i = 0; i < myFriendsArray.count; i++) {
                    long friendId = [[myFriendsArray[i] objectForKey:@"id"]longValue];
                    long playerId = [[self.playerInfo objectForKey:@"id"]longValue];
                    if (friendId == playerId) {
                        self.isFriend = @"yes";
                    }
                }
            }else if(status == 1){
                [self jumpout];
            }else{
                
            }
        }

    }];
}
//举报和加为好友；
-(void)more{
    self.moreVi = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-200, 55, 190, 80)];
    self.moreVi.backgroundColor = [UIColor grayColor];
    self.moreVi.layer.cornerRadius = 5;
    self.moreVi.layer.masksToBounds = YES;
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 190, 39)];
    lab1.text = @"举报";
    lab1.userInteractionEnabled = YES;
    lab1.textAlignment = NSTextAlignmentCenter;;
    lab1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taplab1)];
    tap.numberOfTapsRequired = 1;
    [lab1 addGestureRecognizer:tap];
    [self.moreVi addSubview:lab1];
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 41, 190, 39)];
    if (self.isFriend) {
        if ([self.isFriend isEqualToString:@"no"]) {
            lab2.text = @"添加好友";
        }else{
            lab2.text = @"删除好友";
        }
    }else{
        NSString *sesstion = [PersistenceManager getLoginSession];
        [UserConnector findMyFriends:sesstion receiver:^(NSData *data,NSError *error){
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    NSMutableArray *myFriendsArray = [json objectForKey:@"entity"];
                    lab2.text = @"添加好友";
                    self.isFriend = @"no";
                    for (int i = 0; i < myFriendsArray.count; i++) {
                        long friendId = [[myFriendsArray[i] objectForKey:@"id"]longValue];
                        long playerId = [[self.playerInfo objectForKey:@"id"]longValue];
                        if (friendId == playerId) {
                            lab2.text = @"删除好友";
                            self.isFriend = @"yes";
                        }
                    }
                }else if(status == 1){
                    [self jumpout];
                }else{
                        
                }
            }

        }];
    }
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taplab2)];
    tap.numberOfTapsRequired = 1;
    lab2.userInteractionEnabled = YES;
    lab2.textAlignment = NSTextAlignmentCenter;
    [lab2 addGestureRecognizer:tap1];
    lab2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.moreVi addSubview:lab2];
    
    UITapGestureRecognizer *remove = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(remove)];
    //[self.view addGestureRecognizer:remove];
    self.btn = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.btn addGestureRecognizer:remove];
    self.btn.backgroundColor = [UIColor clearColor];
    [[ShowMessage mainWindow]addSubview:self.btn];
    [[ShowMessage mainWindow] addSubview:self.moreVi];
}
//举报
-(void)taplab1{
    [self.btn removeFromSuperview];
    [self.moreVi removeFromSuperview];
    self.tip = [[UIView alloc]initWithFrame:CGRectMake(20,self.view.bounds.size.height/5, self.view.bounds.size.width-40, self.view.bounds.size.height/5*3)];
    self.tip.backgroundColor = [UIColor grayColor];
    
    UILabel *tiplab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.tip.bounds.size.width, (self.tip.bounds.size.height-5)/6)];
    tiplab1.text = @"  色情低俗";
    tiplab1.userInteractionEnabled = YES;
    tiplab1.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tiptap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tiplab1action)];
    tiptap1.numberOfTapsRequired = 1;
    [tiplab1 addGestureRecognizer:tiptap1];
    [self.tip addSubview:tiplab1];
    
    UILabel *tiplab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.tip.bounds.size.height-5)/6+1, self.tip.bounds.size.width, (self.tip.bounds.size.height-5)/6)];
    tiplab2.text = @"  广告骚扰";
    tiplab2.userInteractionEnabled = YES;
    tiplab2.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tiptap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tiplab2action)];
    tiptap2.numberOfTapsRequired = 1;
    [tiplab2 addGestureRecognizer:tiptap2];
    [self.tip addSubview:tiplab2];
    
    UILabel *tiplab3 = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.tip.bounds.size.height-5)/6*2+2, self.tip.bounds.size.width, (self.tip.bounds.size.height-5)/6)];
    tiplab3.text = @"  政治敏感";
    tiplab3.userInteractionEnabled = YES;
    tiplab3.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tiptap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tiplab3action)];
    tiptap3.numberOfTapsRequired = 1;
    [tiplab3 addGestureRecognizer:tiptap3];
    [self.tip addSubview:tiplab3];
    
    UILabel *tiplab4 = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.tip.bounds.size.height-5)/6*3+3, self.tip.bounds.size.width, (self.tip.bounds.size.height-5)/6)];
    tiplab4.text = @"  欺诈骗钱";
    tiplab4.userInteractionEnabled = YES;
    tiplab4.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tiptap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tiplab4action)];
    tiptap4.numberOfTapsRequired = 1;
    [tiplab4 addGestureRecognizer:tiptap4];
    [self.tip addSubview:tiplab4];
    
    UILabel *tiplab5 = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.tip.bounds.size.height-5)/6*4+4, self.tip.bounds.size.width, (self.tip.bounds.size.height-5)/6)];
    tiplab5.text = @"  个人资料不符";
    tiplab5.userInteractionEnabled = YES;
    tiplab5.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tiptap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tiplab5action)];
    tiptap5.numberOfTapsRequired = 1;
    [tiplab5 addGestureRecognizer:tiptap5];
    [self.tip addSubview:tiplab5];
    
    UILabel *tiplab6 = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.tip.bounds.size.height-5)/6*5+5, self.tip.bounds.size.width, (self.tip.bounds.size.height-5)/6)];
    tiplab6.text = @"  其他";
    tiplab6.userInteractionEnabled = YES;
    tiplab6.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tiptap6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tiplab6action)];
    tiptap6.numberOfTapsRequired = 1;
    [tiplab6 addGestureRecognizer:tiptap6];
    [self.tip addSubview:tiplab6];
    
    self.tipclear = [[UIView alloc]initWithFrame:self.view.bounds];
    self.tipclear.backgroundColor = [UIColor blackColor];
    self.tipclear.alpha = 0.5;
    UITapGestureRecognizer *tipcleartap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tipcleartap)];
    [self.tipclear addGestureRecognizer:tipcleartap];
    
    [[ShowMessage mainWindow]addSubview:self.tipclear];
    [[ShowMessage mainWindow]addSubview:self.tip];
}

//取消举报
-(void)tipcleartap{
    [self.tip removeFromSuperview];
    [self.tipclear removeFromSuperview];
}

//举报信息
-(void)tiplab1action{
    //色情低俗
    [self.tip removeFromSuperview];
    [self.tipclear removeFromSuperview];
    [self accusation:[NSNumber numberWithInt:0]];
}
-(void)tiplab2action{
    // 广告骚扰
    [self.tip removeFromSuperview];
    [self.tipclear removeFromSuperview];
    [self accusation:[NSNumber numberWithInt:1]];
}
-(void)tiplab3action{
    //政治敏感
    [self.tip removeFromSuperview];
    [self.tipclear removeFromSuperview];
    [self accusation:[NSNumber numberWithInt:2]];
}
-(void)tiplab4action{
    //其诈骗钱
    [self.tip removeFromSuperview];
    [self.tipclear removeFromSuperview];
    [self accusation:[NSNumber numberWithInt:3]];
}
-(void)tiplab5action{
    //个人资料不符
    [self.tip removeFromSuperview];
    [self.tipclear removeFromSuperview];
    [self accusation:[NSNumber numberWithInt:4]];
    
}
-(void)tiplab6action{
    //其他
    [self.tip removeFromSuperview];
    [self.tipclear removeFromSuperview];
    [self accusation:[NSNumber numberWithInt:5]];
}
- (void)accusation:(NSNumber*)num{
    NSString *session= [PersistenceManager getLoginSession];
    [UserConnector accusation:session peiwanId:[self.playerInfo objectForKey:@"id"] contentIndex:num receiver:^(NSData *data,NSError *error){
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            //NSLog(@"%@",json);
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                [ShowMessage showMessage:@"举报成功"];
            }else if (status == 1){
                [self jumpout];
            }else{
                
            }
        }
    }];
}
//加为好友
-(void)taplab2{
    [self.btn removeFromSuperview];
    [self.moreVi removeFromSuperview];
    NSString *title;
    NSString *nickname = [self.playerInfo objectForKey:@"nickname"];
    if ([self.isFriend isEqualToString:@"yes"]) {
        title = [NSString stringWithFormat:@"您将删除好友%@",nickname];
    } else {
        title = [NSString stringWithFormat:@"您将添加%@为好友",nickname];
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if ([self.isFriend isEqualToString:@"yes"]) {
            NSString *sesstion = [PersistenceManager getLoginSession];
            [UserConnector deleteFriend:sesstion friendId:[self.playerInfo objectForKey:@"id"] receiver:^(NSData *data,NSError *error){
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];

                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    self.isFriend = @"no";
                }else if (status == 1){
                    [self jumpout];
                }else{
                    
                }
            }
            }];
        }else{
            NSString *sesstion = [PersistenceManager getLoginSession];
            [UserConnector addFriend:sesstion friendId:[self.playerInfo objectForKey:@"id"] receiver:^(NSData *data,NSError *error){
                if (error) {
                    [ShowMessage showMessage:@"服务器未响应"];
                }else{
                    SBJsonParser*parser=[[SBJsonParser alloc]init];
                    NSMutableDictionary *json=[parser objectWithData:data];

                    int status = [[json objectForKey:@"status"]intValue];
                    if (status == 0) {
                        self.isFriend = @"yes";
                    }else if (status == 1){
                        [self jumpout];
                    }else{
                        
                    }
                }
            }];
            
        }

    }
}
//取消举报和加为好友；
-(void)remove{
    [self.btn removeFromSuperview];
    [self.moreVi removeFromSuperview];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self remove];
}

-(void)addGameRoleTableview{
    self.gameRole = [[UITableView alloc]initWithFrame:CGRectMake(0, self.pi.playWithView.frame.origin.y+self.pi.playWithView.frame.size.height+1, self.view.bounds.size.width,self.playerRoleArray.count*90+40)];
    self.gameRole.dataSource = self;
    self.gameRole.delegate = self;
    self.gameRole.separatorStyle = NO;
    UIView *gameRoleHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.gameRole.bounds.size.width,40)];
    UILabel *Rolelb = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 120, 20)];
    Rolelb.text = @"游戏角色";
    Rolelb.textColor = [UIColor orangeColor];
    [gameRoleHead addSubview:Rolelb];
    self.gameRole.tableHeaderView = gameRoleHead;
    [self.assesserInfoSv addSubview:self.gameRole];
}
-(void)addAlwaysNetBar{
    self.alwaysInNetBar = [[UIView alloc]initWithFrame:CGRectMake(0, self.gameRole.frame.origin.y+self.gameRole.frame.size.height+1, self.view.bounds.size.width, 100)];
    self.alwaysInNetBar.backgroundColor = [UIColor whiteColor];
    UILabel *netBarlab = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 70, 20)];
    netBarlab.text = @"常去网吧";
    netBarlab.textColor = [UIColor orangeColor];
    [self.alwaysInNetBar addSubview:netBarlab];
    UIScrollView *netBarSv = [[UIScrollView alloc]initWithFrame:CGRectMake(100, 10, self.view.bounds.size.width - 120, 80)];
    for (int i = 0; i<self.playerNetBarArray.count; i++) {
        NSDictionary *InfoDic = self.playerNetBarArray[i];
        NSDictionary *barInfoDic = [InfoDic objectForKey:@"netbar"];
        UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(i*70, 0, 65, 80)];
        vi.tag = i+100;
        UITapGestureRecognizer *tapBar = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapNetBar:)];
        [vi addGestureRecognizer:tapBar];
        UIImageView *barImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 65, 65)];
        barImage.contentMode = UIViewContentModeScaleToFill;
        NSString *url = [barInfoDic objectForKey:@"photoUrl"];
        NSURL *phurl = [NSURL URLWithString:url];
        [barImage setImageWithURL:phurl placeholderImage:nil];
        UILabel *barLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 65, 65, 15)];
        barLab.text = [barInfoDic objectForKey:@"name"];
        barLab.font = [UIFont systemFontOfSize:12];
        barLab.textAlignment = NSTextAlignmentCenter;
        [vi addSubview:barImage];
        [vi addSubview:barLab];
        [netBarSv addSubview:vi];
    }
    netBarSv.contentSize = CGSizeMake(70*self.playerNetBarArray.count, 80);
    [self.alwaysInNetBar addSubview:netBarSv];
    [self.assesserInfoSv addSubview:self.alwaysInNetBar];
}
-(void)tapNetBar:(UITapGestureRecognizer*)sender{
    NSInteger  i = sender.view.tag - 100;
    [self performSegueWithIdentifier:@"netbar" sender:self.playerNetBarArray[i]];
}

-(void)addUserAssessTableview{
    float y = 0;
    if (self.playerNetBarArray.count != 0) {
        y = self.gameRole.frame.origin.y+self.gameRole.frame.size.height+108;
    }else{
        y = self.gameRole.frame.origin.y+self.gameRole.frame.size.height+8;
    }

    self.userAssess = [[UITableView alloc]initWithFrame:CGRectMake(0, y, self.view.bounds.size.width,self.playerOrderArray.count*100+40)];
    self.userAssess.dataSource = self;
    self.userAssess.delegate = self;
    self.userAssess.separatorStyle = NO;
    UIView *userAssessHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.userAssess.bounds.size.width,40)];
    UILabel *assesslb = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 120, 20)];
    assesslb.text = @"用户评价";
    assesslb.textColor = [UIColor orangeColor];
    [userAssessHead addSubview:assesslb];
    self.userAssess.tableHeaderView = userAssessHead;
    [self.assesserInfoSv addSubview:self.userAssess];
    float height = 0;
    if ((self.userAssess.frame.origin.y+self.userAssess.frame.size.height) < (self.view.bounds.size.height-60)) {
        height = self.view.bounds.size.height - 60;
    }else{
        height = self.userAssess.frame.origin.y+self.userAssess.frame.size.height;
    }
    self.assesserInfoSv.contentSize = CGSizeMake(self.view.bounds.size.width, height);
}
-(void)showChat{
    ChatViewController *messageCtr = [[ChatViewController alloc] initWithConversationChatter:@"123" conversationType:EMConversationTypeChat];
    messageCtr.title = @"123";
    [self.navigationController pushViewController:messageCtr animated:YES];

}
-(void)onRightavigationBarClick:(NSInteger)type andSId:(NSString *)sid{
    [self performSegueWithIdentifier:@"invite" sender:self.playerInfo];
    
}
-(void)showInvite{
    [self performSegueWithIdentifier:@"invite" sender:self.playerInfo];
}
-(void)showState{
    [self performSegueWithIdentifier:@"peiwanstate" sender:self.playerInfo];
}
- (void)showpicture{
    [self performSegueWithIdentifier:@"picture" sender:self.playerInfo];
    
}

- (void)tapUserAssessImage:assessDic{
    NSDictionary *user = [assessDic objectForKey:@"user"];
    [self performSegueWithIdentifier:@"userAssess" sender:user];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.userAssess) {

        return self.playerOrderArray.count;
    }else{
        return self.playerRoleArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identyfier = @"mycell";
    if (tableView == self.gameRole) {
        GameRloeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identyfier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"GameRloeTableViewCell" owner:self options:nil]firstObject];
        }
        cell.roleInfo = self.playerRoleArray[indexPath.row];
        [LOLHelper queryRoleInfo:[self.playerRoleArray[indexPath.row] objectForKey:@"name"] departion:[self.playerRoleArray[indexPath.row] objectForKey:@"part"] receiver:^(LOLInfo *lolInfo,NSError *error){
            NSString *url = lolInfo.headUrl;
            NSURL *headurl = [NSURL URLWithString:url];
            [cell.headig setImageWithURL:headurl];
            cell.sword.text = lolInfo.capacity;
            [self.playerRoleInfoArray addObject:lolInfo];
        }];
        return cell;
    }else{
        UserAssessTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identyfier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UserAssessTableViewCell" owner:self options:nil]firstObject];
        }
        cell.delegate = self;
        cell.assessDic = self.playerOrderArray[indexPath.row];
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.gameRole) {
         NSDictionary *roleInfo = self.playerRoleArray[indexPath.row];
        [self performSegueWithIdentifier:@"exploits" sender:roleInfo];

    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"userAssess"]) {
        AssesserInfoViewController *av = segue.destinationViewController;
        av.playerInfo = sender;
    }
    if ([segue.identifier isEqualToString:@"netbar"]) {
        NetBarViewController *nv = segue.destinationViewController;
        nv.barInfo = sender;
    }
    if ([segue.identifier isEqualToString:@"exploits"]) {
        ExploitsTableViewController *ev = segue.destinationViewController;
        ev.exploitsInfo = sender;
    }
    if ([segue.identifier isEqualToString:@"invite"]) {
        InviteViewController *iv = segue.destinationViewController;
        iv.playerInfo = sender;
    }
    if ([segue.identifier isEqualToString:@"peiwanstate"]) {
        StateTableViewController *mv = segue.destinationViewController;
        mv.myUserInfo = sender;

    }

    if ([segue.identifier isEqualToString:@"picture"]) {
        PeiwanHeadViewController *cv = segue.destinationViewController;
        cv.hidesBottomBarWhenPushed = YES;
        cv.peiwanInfoDic = sender;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.gameRole) {
        return 90.0;
    }else{
        return 100;
    }
}
- (void)jumpout{
    [PersistenceManager setLoginSession:@""];
    LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    lv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:lv animated:YES];
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
