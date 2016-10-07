//
//  InviteRecordViewController.m
//  MeiWan
//
//  Created by apple on 15/8/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "InviteRecordViewController.h"
#import "Myorder.h"
#import "Meiwan-Swift.h"
#import "ShowMessage.h"
#import "SBJson.h"
#import "LoginViewController.h"
#import "MJRefresh.h"
#import "DetailOrderViewController.h"
#import "CorlorTransform.h"
#import "PlagerinfoViewController.h"
@interface InviteRecordViewController ()<UIScrollViewDelegate,myorderViewDelegate>
@property (strong, nonatomic)  UIScrollView *recordSv;
@property (strong, nonatomic) UIScrollView *reSv;
@property (strong, nonatomic) NSMutableArray *reSvSubViews;
@property (strong, nonatomic) UIScrollView *inSv;
@property (strong, nonatomic) NSMutableArray *inSvSubViews;
@property (weak, nonatomic) IBOutlet UIView *lineOfBtn;
@property (weak, nonatomic) IBOutlet UIView *lineOfBtn2;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (strong, nonatomic) Myorder *myorder;
@property (strong, nonatomic) Myorder *inviteMeorder;
@property (strong, nonatomic) NSMutableArray *myOrders;
@property (strong, nonatomic) NSMutableArray *inviteMeOrder;
@property (assign, nonatomic) int theTag;
@property (assign, nonatomic) int reSvcount;
@property (assign, nonatomic) int inSvcount;

@end

@implementation InviteRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.reSvcount = 5;
    self.inSvcount = 5;
    
    self.recordSv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.lineOfBtn.frame.origin.y+2, self.view.bounds.size.width, self.view.bounds.size.height-self.lineOfBtn.frame.origin.y+2)];
    self.recordSv.backgroundColor = [UIColor whiteColor];
    self.recordSv.contentSize  = CGSizeMake(self.recordSv.bounds.size.width*2, 0);
    self.recordSv.showsHorizontalScrollIndicator = NO;
    self.recordSv.bounces = NO;
    self.recordSv.pagingEnabled = YES;
    
    [self.view addSubview:self.recordSv];
    
    self.lineOfBtn.backgroundColor = [CorlorTransform colorWithHexString:@"#36C8FF"];
    self.lineOfBtn2.backgroundColor = [CorlorTransform colorWithHexString:@"#36C8FF"];
    self.lineOfBtn2.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    self.recordSv.delegate = self;
    
    self.inSv = [[UIScrollView alloc]initWithFrame:CGRectMake( self.view.bounds.size.width,0, self.recordSv.bounds.size.width, self.recordSv.bounds.size.height)];
    //NSLog(@"%f",self.recordSv.bounds.size.width);
    self.inSv.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.inSvSubViews = [NSMutableArray array];
    [self.recordSv addSubview:self.inSv];

    self.reSv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.recordSv.bounds.size.width, self.recordSv.bounds.size.height)];
    //NSLog(@"%f",self.recordSv.bounds.size.width);
    self.reSv.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.reSvSubViews = [NSMutableArray array];
    [self.recordSv addSubview:self.reSv];

    [self setupRefresh];

    NSString *session = [PersistenceManager getLoginSession];
    [UserConnector myOrders:session offset:[NSNumber numberWithInt:0] limit:[NSNumber numberWithInt:self.reSvcount] receiver:^(NSData *data,NSError *error){
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableDictionary *json = [parser objectWithData:data];
            //NSLog(@"%@",json);
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
               self.myOrders = [json objectForKey:@"entity"];
               [self addsubviews];
             }else if(status == 1){
             }else{
                 
             }
        }
    }];
    
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
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self reloadData];
    self.inSv.contentOffset = CGPointMake(0, 0);
    self.reSv.contentOffset = CGPointMake(0, 0);
}
- (void)reloadData{
    NSString *session = [PersistenceManager getLoginSession];
    [UserConnector myOrders:session offset:[NSNumber numberWithInt:0] limit:[NSNumber numberWithInt:self.reSvcount] receiver:^(NSData *data,NSError *error){
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableDictionary *json = [parser objectWithData:data];
            //            NSLog(@"%@",json);
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                self.myOrders = [json objectForKey:@"entity"];
                for (Myorder *orderView in self.reSvSubViews) {
                    [orderView removeFromSuperview];
                }
                [self addsubviews];
            }else if(status == 1){
                [PersistenceManager setLoginSession:@""];
               LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
               lv.hidesBottomBarWhenPushed = YES;
               [self.navigationController pushViewController:lv animated:YES];                
            }else{
                
            }
        }
    }];
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
                
            }else{
                
            }
        }
    }];

}
- (void)setupRefresh
{
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    self.reSv.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reSvHeaderRereshing];
    }];
    self.reSv.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self reSvFooterRereshing];
    }];
    self.inSv.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self inSvHeaderRereshing];
    }];
    self.inSv.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self inSvFooterRereshing];
    }];
}
//上拉刷新
- (void)reSvHeaderRereshing
{
    self.reSvcount += 5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *session = [PersistenceManager getLoginSession];
        [UserConnector myOrders:session offset:[NSNumber numberWithInt:0] limit:[NSNumber numberWithInt:self.reSvcount] receiver:^(NSData *data,NSError *error){
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser *parser = [[SBJsonParser alloc]init];
                NSMutableDictionary *json = [parser objectWithData:data];
                //            NSLog(@"%@",json);
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    self.myOrders = [json objectForKey:@"entity"];
                    for (Myorder *orderView in self.reSvSubViews) {
                        [orderView removeFromSuperview];
                    }
                     [self addsubviews];
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
        [self.reSv.mj_header endRefreshing];
    });
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
-(void)reSvFooterRereshing{
    self.reSvcount += 5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *session = [PersistenceManager getLoginSession];
        [UserConnector myOrders:session offset:[NSNumber numberWithInt:0] limit:[NSNumber numberWithInt:self.reSvcount] receiver:^(NSData *data,NSError *error){
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser *parser = [[SBJsonParser alloc]init];
                NSMutableDictionary *json = [parser objectWithData:data];
                //            NSLog(@"%@",json);
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    self.myOrders = [json objectForKey:@"entity"];
                    for (Myorder *orderView in self.reSvSubViews) {
                        [orderView removeFromSuperview];
                    }
                    [self addsubviews];
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
        [self.reSv.mj_footer endRefreshing];
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

- (void)addsubviews{
    //float sum ;
    for (int i=0; i<self.myOrders.count; i++) {
        self.myorder = [[[NSBundle mainBundle]loadNibNamed:@"Myorder" owner:self options:nil]firstObject];
        self.myorder.mytag = 888;
        self.myorder.delegate = self;
        self.myorder.orderDic = self.myOrders[i];
        self.myorder.frame = CGRectMake(0, 190*i, self.reSv.bounds.size.width, 190);
        //sum += self.myorder.frame.size.height+10;
        [self.reSv addSubview:self.myorder];
        [self.reSvSubViews addObject:self.myorder];
        
    }
    self.reSv.contentSize = CGSizeMake(self.reSv.bounds.size.width,self.myorder.frame.origin.y+self.myorder.frame.size.height);
    
}
- (void)addsubviewsMyorder{
    
    //float sum ;
    for (int i=0; i<self.inviteMeOrder.count; i++) {
        self.inviteMeorder = [[[NSBundle mainBundle]loadNibNamed:@"Myorder" owner:self options:nil]firstObject];
        self.inviteMeorder.mytag = 666;
        self.inviteMeorder.orderDic = self.inviteMeOrder[i];
        self.inviteMeorder.frame = CGRectMake(0, 190*i, self.inSv.bounds.size.width, 190);
        self.inviteMeorder.delegate = self;
        [self.inSv addSubview:self.inviteMeorder];
        [self.inSvSubViews addObject:self.inviteMeorder];
        
    }
    self.inSv.contentSize = CGSizeMake(self.inSv.bounds.size.width,self.inviteMeorder.frame.origin.y+self.inviteMeorder.frame.size.height);
    
}
#pragma mark - orderView delegate
- (void)userdetail:(NSDictionary *)orderDic AndTag:(int)mytag{
    [self performSegueWithIdentifier:@"personInfo" sender:orderDic];
}
- (void)detailOrder:(NSDictionary *)orderDic AndTag:(int)mytag{
     self.theTag = mytag;
    [self performSegueWithIdentifier:@"orderDetail" sender:orderDic];
}
- (IBAction)recordBtn:(UIButton *)sender {
    sender.enabled = NO;
    self.inviteBtn .enabled = YES;
    CGPoint offset = self.recordSv.contentOffset;
    offset.x = 0;
    self.recordSv.contentOffset = offset;
    self.lineOfBtn2.hidden = YES;
    self.lineOfBtn.hidden = NO;
}
- (IBAction)inviteBtn:(UIButton *)sender {
    sender.enabled = NO;
    self.recordBtn.enabled = YES;
    CGPoint offset = self.recordSv.contentOffset;
    offset.x = self.recordSv.bounds.size.width;
    self.recordSv.contentOffset = offset;
    self.lineOfBtn.hidden = YES;
    self.lineOfBtn2.hidden = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.recordSv) {
        if (scrollView.contentOffset.x == 0) {
            self.recordBtn.enabled = NO;
            self.inviteBtn .enabled = YES;
            self.lineOfBtn2.hidden = YES;
            self.lineOfBtn.hidden = NO;
            
        }else{
            self.recordBtn.enabled = YES;
            self.inviteBtn .enabled = NO;
            self.lineOfBtn2.hidden = NO;
            self.lineOfBtn.hidden = YES;
        }

    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"orderDetail"]) {
        DetailOrderViewController *dv = segue.destinationViewController;
        dv.detailOrderDic = sender;
        dv.orderTag = self.theTag;
    }
    if ([segue.identifier isEqualToString:@"personInfo"]) {
        PlagerinfoViewController * pv = segue.destinationViewController;
        pv.playerInfo = sender;
    }
}


@end
