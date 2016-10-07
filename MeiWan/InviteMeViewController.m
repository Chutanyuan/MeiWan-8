//
//  InviteMeViewController.m
//  MeiWan
//
//  Created by apple on 15/11/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "InviteMeViewController.h"
#import "Myorder.h"
#import "Meiwan-Swift.h"
#import "ShowMessage.h"
#import "SBJson.h"
#import "LoginViewController.h"
#import "MJRefresh.h"
#import "DetailOrderViewController.h"
#import "PlagerinfoViewController.h"
@interface InviteMeViewController ()<myorderViewDelegate>
@property (strong, nonatomic) UIScrollView *inSv;
@property (strong, nonatomic) NSMutableArray *inSvSubViews;
@property (assign, nonatomic) int inSvcount;
@property (strong, nonatomic) NSMutableArray *inviteMeOrder;
@property (strong, nonatomic) Myorder *inviteMeorder;
@property (assign, nonatomic) int theTag;
@end

@implementation InviteMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:view];
    self.inSvcount = 5;
    self.inSv = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    self.inSv.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-60);
    //NSLog(@"%f",self.recordSv.bounds.size.width);
    self.inSv.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.inSvSubViews = [NSMutableArray array];
    [self.view addSubview:self.inSv];
    
    [self setupRefresh];
    
    NSString *session = [PersistenceManager getLoginSession];
    [UserConnector inviteMeOrders:session offset:[NSNumber numberWithInt:0] limit:[NSNumber numberWithInt:self.inSvcount] receiver:^(NSData *data,NSError *error){
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableDictionary *json = [parser objectWithData:data];
            //            NSLog(@"%@",json);
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                self.inviteMeOrder = [json objectForKey:@"entity"];
                [self addsubviewsMyorder];
            }else if(status == 1){
                
            }else{
                
            }
        }
    }];

    // Do any additional setup after loading the view.
}



- (void)setupRefresh
{
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    self.inSv.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [self inSvHeaderRereshing];
    }];
    self.inSv.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        [self inSvFooterRereshing];
    }];

//    [self.inSv addHeaderWithTarget:self action:@selector(inSvHeaderRereshing)];
//    [self.inSv addFooterWithTarget:self action:@selector(inSvFooterRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    
//    self.inSv.headerPullToRefreshText = @"上拉刷新";
//    self.inSv.headerReleaseToRefreshText = @"松开马上刷新";
//    self.inSv.headerRefreshingText = @"刷新中";
//    
//    
//    self.inSv.footerPullToRefreshText = @"更多";
//    self.inSv.footerReleaseToRefreshText = @"松开马上加载";
//    self.inSv.footerRefreshingText = @"正在帮您加载中";
    
}
- (void)inSvHeaderRereshing
{
    self.inSvcount += 5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *session = [PersistenceManager getLoginSession];
        [UserConnector inviteMeOrders:session offset:[NSNumber numberWithInt:0] limit:[NSNumber numberWithInt:self.inSvcount] receiver:^(NSData *data,NSError *error){
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser *parser = [[SBJsonParser alloc]init];
                NSMutableDictionary *json = [parser objectWithData:data];
                //            NSLog(@"%@",json);
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    self.inviteMeOrder = [json objectForKey:@"entity"];
                    for (Myorder *orderView in self.inSvSubViews) {
                        [orderView removeFromSuperview];
                    }
                    
                    [self addsubviewsMyorder];
                }else if(status == 1){
                    [PersistenceManager setLoginSession:@""];
                    LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                    lv.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:lv animated:YES];
                }else{
                    
                }
            }
        }];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.inSv.mj_header endRefreshing];
    });
}
-(void)inSvFooterRereshing{
    self.inSvcount += 5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *session = [PersistenceManager getLoginSession];
        [UserConnector inviteMeOrders:session offset:[NSNumber numberWithInt:0] limit:[NSNumber numberWithInt:self.inSvcount] receiver:^(NSData *data,NSError *error){
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser *parser = [[SBJsonParser alloc]init];
                NSMutableDictionary *json = [parser objectWithData:data];
                //            NSLog(@"%@",json);
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    self.inviteMeOrder = [json objectForKey:@"entity"];
                    for (Myorder *orderView in self.inSvSubViews) {
                        [orderView removeFromSuperview];
                    }
                    [self addsubviewsMyorder];
                }else if(status == 1){
                    [PersistenceManager setLoginSession:@""];
                    LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                    lv.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:lv animated:YES];
                    
                }else{
                    
                }
            }
        }];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.inSv.mj_footer endRefreshing];
    });
}

- (void)addsubviewsMyorder{
    if (self.inviteMeOrder.count == 0) {
        UILabel *noMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 100.0f, self.view.frame.size.width, 50.0f)];
        noMsgLabel.text = @"暂无订单数据";
        noMsgLabel.textColor = [UIColor darkGrayColor];
        noMsgLabel.textAlignment = NSTextAlignmentCenter;
        [self.inSv addSubview:noMsgLabel];
    }
    //float sum ;
    for (int i=0; i<self.inviteMeOrder.count; i++) {
        self.inviteMeorder = [[[NSBundle mainBundle]loadNibNamed:@"Myorder" owner:self options:nil]firstObject];
        self.inviteMeorder.mytag = 666;
        self.inviteMeorder.orderDic = self.inviteMeOrder[i];
        self.inviteMeorder.frame = CGRectMake(0, 160*i, self.inSv.bounds.size.width, 150);
        self.inviteMeorder.delegate = self;
        [self.inSv addSubview:self.inviteMeorder];
        [self.inSvSubViews addObject:self.inviteMeorder];
        
    }
    CGFloat height = self.inviteMeorder.frame.origin.y + self.inviteMeorder.frame.size.height;
    CGFloat insvHeight = self.inSv.contentSize.height;
    if (height > insvHeight) {
        self.inSv.contentSize = CGSizeMake(self.inSv.bounds.size.width,self.inviteMeorder.frame.origin.y+self.inviteMeorder.frame.size.height);
    }
    
}
#pragma mark - OrderView delegate
-(void)userdetail:(NSDictionary *)orderDic AndTag:(int)mytag{
    [self performSegueWithIdentifier:@"personInfo" sender:orderDic];
}
-(void)detailOrder:(NSDictionary *)orderDic AndTag:(int)mytag{
    self.theTag = mytag;
    //NSLog(@"%@",orderDic);
    [self performSegueWithIdentifier:@"detailOrder" sender:orderDic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailOrder"]) {
        DetailOrderViewController *dv = segue.destinationViewController;
        dv.detailOrderDic = sender;
        dv.orderTag = self.theTag;
    }
    if ([segue.identifier isEqualToString:@"personInfo"]) {
        PlagerinfoViewController *pv = segue.destinationViewController;
        pv.playerInfo = sender;
    }
}


@end
