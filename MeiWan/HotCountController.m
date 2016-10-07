//
//  HotCountController.m
//  MeiWan
//
//  Created by apple on 15/11/23.
//  Copyright © 2015年 apple. All rights reserved.
//
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#import "HotCountController.h"
#import "CorlorTransform.h"
#import "rankingView.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "ShowMessage.h"
#import "LoginViewController.h"
#import "HotCountCell.h"
#import "HotCountCellChange.h"

#import "PlagerinfoViewController.h"
#import "MJRefresh.h"
#import "setting.h"
#import "MBProgressHUD.h"

@interface HotCountController ()<rankingviewdelegate,MBProgressHUDDelegate>
{
    MBProgressHUD * HUD;
}
@property (nonatomic, strong) NSMutableArray * tableDataArray;
@property (nonatomic, strong) NSMutableArray * headViewDataArray;
@property (nonatomic, assign) int infoCount;
@end

@implementation HotCountController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"加载中";
    //设置导航条颜色 标题颜色
    [self.navigationController.navigationBar setBarTintColor:[CorlorTransform colorWithHexString:@"#3f90a4"]];
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor]           forKey:NSForegroundColorAttributeName];
    //获取数据
    self.infoCount = 10;
    self.tableDataArray = [NSMutableArray array];
    self.headViewDataArray = [NSMutableArray array];
    [self getData];
    
    //添加刷新
    [self setupRefresh];
    
    NSDictionary *userInfo = [PersistenceManager getLoginUser];
    NSString *thesame = [NSString stringWithFormat:@"%ld",[[userInfo objectForKey:@"id"]longValue]];
    if ([thesame isEqualToString:@"100000"] || [thesame isEqualToString:@"100001"] ) {
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        if (![setting canOpen]) {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
    //第一次进入刷新
    [self.tableView.mj_header beginRefreshing];

}
- (IBAction)hotRole:(UIBarButtonItem *)sender {
    UIAlertView *hotRuleView = [[UIAlertView alloc]initWithTitle:@"热度规则" message:@"热度规则：每成交一单，获取订单金额除以10的热度；每发表一篇动态，获得1热度，4小时不重复增加；动态每增加一个赞，获得1热度，动态每有1个新的用户评论，获得1热度。另每隔1天未上线，会减少5热度。如果受到投诉，会酌情减少热度。" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [hotRuleView show];
}

//设置tableHeadView
- (UIView*)createTableHeadView{
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*1.5+5)];
    if (self.headViewDataArray.count == 3) {
        rankingView * firstView = [[[NSBundle mainBundle]loadNibNamed:@"rankingView" owner:self options:nil]firstObject];
        firstView.delegate = self;
        firstView.playerInfo = self.headViewDataArray[0];
        firstView.ranklab.text = @"1";
        firstView.ranklab.textColor = [UIColor whiteColor];
        [firstView.ranklab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        
        firstView.rankImage.image = [UIImage imageNamed:@"first_1"];
        firstView.frame = CGRectMake(5, 5,ScreenWidth-10, ScreenWidth-10);
        
        rankingView * secondView = [[[NSBundle mainBundle]loadNibNamed:@"rankingView" owner:self options:nil]firstObject];
        secondView.delegate = self;
        secondView.playerInfo = self.headViewDataArray[1];
        secondView.ranklab.text = @"2";
        secondView.ranklab.textColor = [CorlorTransform colorWithHexString:@"888888"];
        [secondView.ranklab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        secondView.rankImage.image = [UIImage imageNamed:@"first_4"];
        secondView.frame = CGRectMake(5, ScreenWidth, (ScreenWidth-15)/2.0, (ScreenWidth-15)/2.0);
        
        rankingView * thirdView = [[[NSBundle mainBundle]loadNibNamed:@"rankingView" owner:self options:nil]firstObject];
        thirdView.delegate = self;
        thirdView.playerInfo = self.headViewDataArray[2];
        thirdView.ranklab.text = @"3";
        [thirdView.ranklab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        thirdView.ranklab.textColor = [UIColor whiteColor];
        thirdView.rankImage.image = [UIImage imageNamed:@"first_2"];
        thirdView.frame = CGRectMake((ScreenWidth-15)/2.0+10, ScreenWidth, (ScreenWidth-15)/2.0, (ScreenWidth-15)/2.0);
        [headView addSubview:firstView];
        [headView addSubview:secondView];
        [headView addSubview:thirdView];
        
    }
    return headView;
}
- (void)setupRefresh
{
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
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
    self.infoCount = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView.mj_header endRefreshing];

    });
}
-(void)footerRereshing{
    self.infoCount += 10;
    if (self.infoCount > 20) {
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getData];
        [self.tableView.mj_footer endRefreshing];
    });
}

- (void)getData{
     [UserConnector rankUsers:[PersistenceManager getLoginSession] offset:[NSNumber numberWithInt:self.infoCount] limit:[NSNumber numberWithInt:10] receiver:^(NSData *data,NSError *error){
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];

            if (status == 0) {
                
                NSArray * infoArray = [json objectForKey:@"entity"];

                if (_infoCount==0) {
                    
                    [self.headViewDataArray removeAllObjects];
                    [self.tableDataArray removeAllObjects];
                    if (infoArray.count > 3) {
                        for (int i = 0; i<infoArray.count; i++) {
                            if (i < 3) {
                                [self.headViewDataArray addObject:infoArray[i]];
                            }else{
                                [self.tableDataArray addObject:infoArray[i]];
                            }
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //设置tableHeadView
                            self.tableView.tableHeaderView = [self createTableHeadView];
                            [self.tableView reloadData];
                        });
                        
                        [HUD hide:YES afterDelay:1];
                    }

                }else{
                
                    [infoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                       
                        [self.tableDataArray addObject:obj];
                        [self.tableView reloadData];
                        [HUD hide:YES afterDelay:0.1];

                        
                    }];
                    
                }
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
#pragma mark playerViewDelegate
- (void)showPlayerInfo:(NSDictionary *)PlayerInfo{
    [self performSegueWithIdentifier:@"personInfo" sender: PlayerInfo];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotCountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotCountCell" forIndexPath:indexPath];
    cell.rank.text = [NSString stringWithFormat:@"%d", indexPath.row+4];
    cell.personInfo = self.tableDataArray[indexPath.row];
    
    return cell;
}

#pragma mark - tableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"personInfo" sender:self.tableDataArray[indexPath.row]];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"personInfo"]) {
        PlagerinfoViewController * pv = segue.destinationViewController;
        pv.playerInfo = sender;
    }
}

@end
