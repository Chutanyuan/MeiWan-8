//
//  PalyListViewController.m
//  MeiWan
//
//  Created by apple on 15/8/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "PalyListViewController.h"
#import "PlayerView.h"
#import "PayInfo.h"
#import "CorlorTransform.h"
#import "RandNumber.h"
#import "ShowMessage.h"
#import "MJRefresh.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "PlagerinfoViewController.h"
#import "LoginViewController.h"
#import "setting.h"
#import <MAMapKit/MAMapKit.h>
#import "MD5.h"
#import "MBProgressHUD.h"
#import "WGS84TOGCJ02.h"
#import "creatAlbum.h"


#define width_screen [UIScreen mainScreen].bounds.size.width

@interface PalyListViewController ()<playerviewdelegate,superviewdelegate,MBProgressHUDDelegate,CLLocationManagerDelegate,EaseMessageViewControllerDelegate,EMChatManagerDelegate,EMClientDelegate>
{
    MBProgressHUD * HUD;
    NSArray * titlelabel;
    NSArray * imageArray;
    UIImageView * iconImage;
    UILabel * iconlabel;
    NSNumber * tagIndexNumber;
    CLLocationManager *_locationManager;
    
    PalyListViewController * mainViewController;
    
}
@property (strong, nonatomic) NSDictionary * sendPlayerDic;
@property (strong, nonatomic)  UIScrollView *playersScollview;
@property (nonatomic,strong) RandNumber *myRandNumber;
@property (nonatomic,strong) NSMutableArray *playerviews;
@property (nonatomic,strong) NSArray *addArray;
@property (nonatomic,strong) PlayerView *myPv;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) NSMutableArray *playerInfoArray;
@property (nonatomic,assign) BOOL isLeft;
@property (nonatomic,assign) float sum;
@property (nonatomic,assign) float sumodd;
@property (nonatomic,assign) float sumeven;
@property (nonatomic,assign) float heightFodd;
@property (nonatomic,assign) float heightFeven;
@property (nonatomic,strong) NSMutableDictionary *searchDic;
@property (nonatomic,assign) int infoCount;
@property (nonatomic,strong) CLLocationManager * locationManager;

@end

@implementation PalyListViewController

#pragma mark - mapView Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //    NSLog(@"%@",locations);
    //取出当前位置的坐标
    static int i = 0;
    i++;
    NSLog(@"**************************************定位开始*****************************************%d",i);
    NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:locations.lastObject.coordinate.latitude],@"latitude",[NSNumber numberWithDouble:locations.lastObject.coordinate.longitude],@"longitude",nil];
    NSString *session = [PersistenceManager getLoginSession];
    [UserConnector update:session parameters:userInfoDic receiver:^(NSData *data, NSError *error){
        if (error) {
            if(!isTest){
                [ShowMessage showMessage:@"服务器未响应"];
            }
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            //                NSLog(@"%@",json);
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
            }else if(status == 1){
                
            }else{
                
            }
        }
    }];
    [manager stopUpdatingLocation];
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}
- (void)loginHuanxin
{
    NSString *product = [NSString stringWithFormat:@"product_%@",[[PersistenceManager getLoginUser] objectForKey:@"id"]];
    NSString *password = [NSString stringWithString:[MD5 md5:product]];
    //　　测试AppKey
    
    
    if (!product){
        //环信用户组
        
        EMError *error = [[EMClient sharedClient] loginWithUsername:product password:password];
        if (!error) {

            NSLog(@"环信登录成功");
            [[EMClient sharedClient].options setIsAutoLogin:YES];
        }
    }else{
        EMError *error = [[EMClient sharedClient] loginWithUsername:product password:password];
        if (!error) {
            NSLog(@"设置的环信自动登录");
            [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
            [[EMClient sharedClient].options setIsAutoLogin:YES];
        }
    }
}
- (void)initializeLocationService {
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    // 请求访问使用地理位置
    [_locationManager requestWhenInUseAuthorization];
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    [_locationManager startUpdatingLocation];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initializeLocationService];
    
    
    
    tagIndexNumber = [[NSNumber alloc]init];
    tagIndexNumber = nil;
    titlelabel = @[@"线上点歌",@"视屏聊天",@"聚餐",@"线下K歌",@"夜店达人",@"叫醒服务",@"影伴",@"运动健身",@"LOL",@"全部"];
    imageArray =  @[@"sing",@"video-chat",@"dining",@"sing-expert",@"go-nightclubbing",@"clock",@"shadow-with",@"sports",@"lol",@"all"];
    [self loginHuanxin];
    
    self.infoCount = 6;
    self.playerviews = [NSMutableArray array];
    self.myRandNumber = [[RandNumber alloc]init];
    self.searchDic = [NSMutableDictionary dictionary];
    
    self.playersScollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64, width_screen, [UIScreen mainScreen].bounds.size.height-104)];
    //这个颜色设置没起作用
    self.playersScollview.showsHorizontalScrollIndicator = NO;
    self.playersScollview.showsVerticalScrollIndicator = NO;
    self.playersScollview.backgroundColor = [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1];
    //    self.playersScollview.backgroundColor = [UIColor blackColor];
    //self.playersScollview.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.playersScollview];
    [self setBanImageView];
    //集成刷新控件
    [self setupRefresh];
    
    //设置导航条颜色 标题颜色
    [self.navigationController.navigationBar setBarTintColor:[CorlorTransform colorWithHexString:@"#3f90a4"]];
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor]           forKey:NSForegroundColorAttributeName];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"加载中";
    [HUD showAnimated:YES whileExecutingBlock:^{
        [self beginNetWorking];
        
    }];
    
}

- (void)beginNetWorking
{
    NSString *session= [PersistenceManager getLoginSession];
    [UserConnector aroundPeiwan:session gender:[self.searchDic objectForKey:@"gender"] minPrice:[self.searchDic objectForKey:@"minPrice"] maxPrice:[self.searchDic objectForKey:@"maxPrice"] isWin:nil offset:0 limit:self.infoCount
                    isRecommend:nil mode:[self.searchDic objectForKey:@"mode"] tagIndex:tagIndexNumber receiver:^(NSData *data,NSError *error){
                        if (error) {
                            [ShowMessage showMessage:@"服务器未响应"];
                            [self beginNetWorking];
                        }else{
                            SBJsonParser*parser=[[SBJsonParser alloc]init];
                            NSMutableDictionary *json=[parser objectWithData:data];
                            int status = [[json objectForKey:@"status"]intValue];
                            if (status == 0) {
                                self.playerInfoArray = [json objectForKey:@"entity"];
                                //NSLog(@"%lu",(unsigned long)self.playerInfoArray.count);
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    //布局滚动页面子视图
                                    [self layoutSubviews];
                                    [HUD hide:YES afterDelay:0];

                                });
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
#pragma mark - setTabBarItem
-(void)setTabBar{
    //设置tabbarItem图片
    NSArray *items = self.tabBarController.tabBar.items;
    UITabBarItem *homeItem = items[0];
    //homeItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0);
    [homeItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[CorlorTransform colorWithHexString:@"#3f90a4"] forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
    homeItem.image = [[UIImage imageNamed:@"near@2x"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeItem.selectedImage = [[UIImage imageNamed:@"near2@2x"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *stateItem = items[1];
    //stateItem.imageInsets = UIEdgeInsetsMake(6,0,-6,0);
    [stateItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[CorlorTransform colorWithHexString:@"#3f90a4"] forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
    stateItem.image = [[UIImage imageNamed:@"dongtai2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    stateItem.selectedImage = [[UIImage imageNamed:@"dongtai"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *hotItem = items[2];
    //hotItem.imageInsets = UIEdgeInsetsMake(6,6,6,6);
    [hotItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[CorlorTransform colorWithHexString:@"#3f90a4"] forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
    
    //    hotItem.image = [[UIImage imageNamed:@"peiwan_rank"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    hotItem.selectedImage = [[UIImage imageNamed:@"peiwan_rank_dark"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    hotItem.image = [[UIImage imageNamed:@"pai-hang-bang@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    hotItem.selectedImage = [[UIImage imageNamed:@"pai-hang-bang2@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UITabBarItem *chatItem = items[3];
    //chatItem.imageInsets = UIEdgeInsetsMake(6,6,6, 6);
    [chatItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[CorlorTransform colorWithHexString:@"#3f90a4"] forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
    
    
    chatItem.image = [[UIImage imageNamed:@"information"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    chatItem.selectedImage = [[UIImage imageNamed:@"information2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    
    UITabBarItem *personItem = items[4];
    //personItem.imageInsets = UIEdgeInsetsMake(6,6,6,6);
    [personItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[CorlorTransform colorWithHexString:@"#3f90a4"] forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
    
    personItem.image = [[UIImage imageNamed:@"personal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    personItem.selectedImage = [[UIImage imageNamed:@"personal2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

#pragma mark - Set up Refresh
//集成刷新控件
- (void)setupRefresh
{
    
    self.playersScollview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.playersScollview.mj_header beginRefreshing];
        [self headerRereshing];
    }];
    self.playersScollview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self.playersScollview.mj_footer beginRefreshing];
        [self footerRereshing];
    }];
}
//下拉刷新
- (void)headerRereshing
{
    [HUD show:YES];
    //self.infoCount += 5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //删除旧视图
        //NSLog(@"%@",self.playerviews);
        for (PlayerView *pv in self.playerviews) {
            [pv removeFromSuperview];
        }
        [self .playerviews removeAllObjects];
        //NSLog(@"%@",self.playerviews);
        
        //刷新表格
        NSString *session= [PersistenceManager getLoginSession];
        // NSLog(@"%@",session);
        [UserConnector aroundPeiwan:session gender:[self.searchDic objectForKey:@"gender"] minPrice:[self.searchDic objectForKey:@"minPrice"] maxPrice:[self.searchDic objectForKey:@"maxPrice"] isWin:nil offset:0 limit:self.playerInfoArray.count isRecommend:nil mode:[self.searchDic objectForKey:@"mode"] tagIndex:tagIndexNumber receiver:^(NSData *data,NSError *error){
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
                
            }else{
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    self.playerInfoArray = [json objectForKey:@"entity"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //布局滚动页面子视图
                        [self layoutSubviews];
                        [HUD hide:YES afterDelay:0.5];
                    });
                    if (tagIndexNumber == nil) {
                        iconlabel.text = [NSString stringWithFormat:@"%@",titlelabel[9]];
                        iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[9]]];
                    }else{
                        iconlabel.text = [NSString stringWithFormat:@"%@",titlelabel[[tagIndexNumber intValue]-1]];
                        iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[[tagIndexNumber intValue]-1]]];
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
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.playersScollview.mj_header endRefreshing];
    });
    
    iconlabel.text = @"全部";
    iconImage.image = [UIImage imageNamed:@"all"];
    
}
//上拉刷新
- (void)footerRereshing
{
    self.infoCount += 6;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *session= [PersistenceManager getLoginSession];
        [UserConnector aroundPeiwan:session gender:[self.searchDic objectForKey:@"gender"] minPrice:[self.searchDic objectForKey:@"minPrice"] maxPrice:[self.searchDic objectForKey:@"maxPrice"] isWin:nil offset:self.infoCount limit:6 isRecommend:nil mode:[self.searchDic objectForKey:@"mode"] tagIndex:tagIndexNumber receiver:^(NSData *data,NSError *error){
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    if (self.playerInfoArray.count%2) {
                        self.isLeft = NO;
                    }else {
                        self.isLeft = YES;
                    }
                    self.addArray = [json objectForKey:@"entity"];
                    [self.playerInfoArray addObjectsFromArray:self.addArray];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //布局滚动页面子视图
                        [self AddlayoutSubviews];
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
        [self.playersScollview.mj_footer endRefreshing];
    });
}
//从跳转页面返回时显示隐藏的tabbar
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
    NSArray *items = self.tabBarController.tabBar.items;
    UITabBarItem *chatItem = items[3];
    
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    if (unreadCount > 0) {
        chatItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
    }else{
        chatItem.badgeValue = nil;
    }
    [self setTabBar];
}
#pragma mark - Search PeiWan
//弹出玩家搜索页
- (IBAction)search:(UIBarButtonItem *)sender {
    PayInfo *pi = [[PayInfo alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    pi.delegate = self;
    pi.layer.masksToBounds = YES;
    pi.layer.cornerRadius = 10.0f;
    //NSLog(@"%@",pi.searchDic);
    //NSLog(@"%f",self.view.bounds.size.width);
    self.backView = [[UIView alloc]initWithFrame: [UIScreen mainScreen].bounds];
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.2;
    [[ShowMessage mainWindow]addSubview:self.backView];
    [[ShowMessage mainWindow]addSubview:pi];
}
#pragma mark - superviewdelegate
-(void)moveBackview{
    [self.backView removeFromSuperview];
}
-(void)resetSuperview:(NSMutableDictionary*)search{
    self.searchDic = search;
    [self.backView removeFromSuperview];
    
    NSLog(@"%@",search);
    
    NSString *session= [PersistenceManager getLoginSession];
    [UserConnector aroundPeiwan:session gender:[self.searchDic objectForKey:@"gender"] minPrice:[self.searchDic objectForKey:@"minPrice"] maxPrice:[self.searchDic objectForKey:@"maxPrice"] isWin:nil offset:0 limit:self.infoCount isRecommend:nil mode:[self.searchDic objectForKey:@"mode"] tagIndex:tagIndexNumber receiver:^(NSData *data,NSError *error){
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0){
                self.playerInfoArray = [json objectForKey:@"entity"];
                //NSLog(@"%ld",self.playerInfoArray.count);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //布局滚动页面子视图
                    for (PlayerView *pv in self.playerviews) {
                        [pv removeFromSuperview];
                    }
                    [self .playerviews removeAllObjects];
                    
                    [self layoutSubviews];
                    
                });
            }else if(status == 1){
                [PersistenceManager setLoginSession:@""];
                LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                lv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:lv animated:YES];
            }else{
                
            }
            
        }
        //NSDictionary *playerInfoDic = peiwans[0];
        
    }];
}

#pragma mark - playerviewdelegate
//跳转到玩家信息页面
-(void)showPlayerInfo:PlayerInfo{
    [self performSegueWithIdentifier:@"playerinfo" sender:PlayerInfo];
}

#pragma mark - LayoutSubView
//布局滚动页面子视图
-(void)layoutSubviews{
    
    self.sum = 0; //总和
    self.sumodd = 0;    //奇数？
    self.sumeven = 0;  //偶数？
    //self.heightFodd = 0;
    //self.heightFeven = 0;
    //NSLog(@"%ld",self.playerInfoArray.count);
    
    for (int i=0; i<self.playerInfoArray.count; i++) {
        self.myPv=[[[NSBundle mainBundle]loadNibNamed:@"PlayerView" owner:self options:nil]firstObject];
        self.myPv.layer.cornerRadius = 5;
        self.myPv.clipsToBounds = YES;
        self.myPv.layer.cornerRadius = 5;
        self.myPv.layer.masksToBounds = YES;
        self.myPv.playerInfo = self.playerInfoArray[i];
        self.myPv.delegate = self;
        if (i%2) {
            float odd = 0;
            odd = [self.myRandNumber getOddRandNumber];
            //            self.myPv.frame = CGRectMake(10+(self.playersScollview.bounds.size.width-15)/2.0, 210+self.sumodd, dtScreenWidth/2-5, 200);
            if (IS_IPHONE_4_OR_LESS) {
                self.myPv.frame = CGRectMake(10+(self.playersScollview.bounds.size.width-15)/2.0, 210+self.sumodd, dtScreenWidth/2-5, 215);
            }else if (IS_IPHONE_5){
                self.myPv.frame = CGRectMake(10+(self.playersScollview.bounds.size.width-15)/2.0, 210+self.sumodd, dtScreenWidth/2-5, 215);
            }else if (IS_IPHONE_6){
                self.myPv.frame = CGRectMake(10+(self.playersScollview.bounds.size.width-15)/2.0, 210+self.sumodd, dtScreenWidth/2-5, 230);
            }else if (IS_IPHONE_6P){
                self.myPv.frame = CGRectMake(10+(self.playersScollview.bounds.size.width-15)/2.0, 210+self.sumodd, dtScreenWidth/2-5, 230);
            }
            //            self.myPv.frame = CGRectMake(10+(self.playersScollview.bounds.size.width-15)/2.0, 100+self.sumodd, (self.playersScollview.bounds.size.width-15)/2, (self.playersScollview.bounds.size.width-15)/2.0+odd);
            self.sumodd += (self.myPv.frame.size.height+5);
        }else{
            float even = 0;
            even = [self.myRandNumber getEvenRandNumber];
            //            self.myPv.frame = CGRectMake(5, 210+self.sumeven, dtScreenWidth/2-5, 230);
            if (IS_IPHONE_4_OR_LESS) {
                self.myPv.frame = CGRectMake(5, 210+self.sumeven, dtScreenWidth/2-5, 215);
            }else if (IS_IPHONE_5){
                self.myPv.frame = CGRectMake(5, 210+self.sumeven, dtScreenWidth/2-5, 215);
            }else if (IS_IPHONE_6){
                self.myPv.frame = CGRectMake(5, 210+self.sumeven, dtScreenWidth/2-5, 230);
            }else if (IS_IPHONE_6P){
                self.myPv.frame = CGRectMake(5, 210+self.sumeven, dtScreenWidth/2-5, 230);
            }
            //            self.myPv.frame = CGRectMake(5, 105+self.sumeven, (self.playersScollview.bounds.size.width-15)/2, (self.playersScollview.bounds.size.width-15)/2+even);
            self.sumeven += (self.myPv.frame.size.height+5);
        }
        if(self.sumeven>=self.sumodd){
            self.sum = self.sumeven;
        }else{
            self.sum = self.sumodd;
        }
        if (self.sum < self.playersScollview.bounds.size.height) {
            self.sum = self.playersScollview.bounds.size.height;
        }
        self.playersScollview.contentSize = CGSizeMake(self.playersScollview.bounds.size.width, self.sum+170);
        [self.playerviews addObject:self.myPv];
        [self.playersScollview addSubview:self.myPv];
    }
}

#pragma mark - AddLayoutSubView

-(void)AddlayoutSubviews{
    
    for (int i=0; i<self.addArray.count; i++) {
        
        self.myPv=[[[NSBundle mainBundle]loadNibNamed:@"PlayerView" owner:self options:nil]firstObject];
        self.myPv.layer.cornerRadius = 5;
        self.myPv.clipsToBounds = YES;
        self.myPv.playerInfo = self.addArray[i];
        self.myPv.delegate = self;
        self.myPv.userInteractionEnabled = YES;
        int k = 0;
        if (self.isLeft) {
            k = i;
        }else{
            k = i + 1;
        }
        if (k % 2) {
            float odd = 0;
            odd = [self.myRandNumber getOddRandNumber];
            //            self.myPv.frame = CGRectMake(10+(self.playersScollview.bounds.size.width-15)/2.0, 210+self.sumodd, dtScreenWidth/2-5,230);
            if (IS_IPHONE_4_OR_LESS) {
                self.myPv.frame = CGRectMake(10+(self.playersScollview.bounds.size.width-15)/2.0, 210+self.sumodd, dtScreenWidth/2-5, 215);
            }else if (IS_IPHONE_5){
                self.myPv.frame = CGRectMake(10+(self.playersScollview.bounds.size.width-15)/2.0, 210+self.sumodd, dtScreenWidth/2-5, 215);
            }else if (IS_IPHONE_6){
                self.myPv.frame = CGRectMake(10+(self.playersScollview.bounds.size.width-15)/2.0, 210+self.sumodd, dtScreenWidth/2-5, 230);
            }else if (IS_IPHONE_6P){
                self.myPv.frame = CGRectMake(10+(self.playersScollview.bounds.size.width-15)/2.0, 210+self.sumodd, dtScreenWidth/2-5, 230);
            }
            
            self.sumodd += (self.myPv.frame.size.height+5);
            
        }else{
            float even = 0;
            even = [self.myRandNumber getEvenRandNumber];
            //            self.myPv.frame = CGRectMake(5, 210+self.sumeven, dtScreenWidth/2-5, 230);
            if (IS_IPHONE_4_OR_LESS) {
                self.myPv.frame = CGRectMake(5, 210+self.sumeven, dtScreenWidth/2-5, 215);
            }else if (IS_IPHONE_5){
                self.myPv.frame = CGRectMake(5, 210+self.sumeven, dtScreenWidth/2-5, 215);
            }else if (IS_IPHONE_6){
                self.myPv.frame = CGRectMake(5, 210+self.sumeven, dtScreenWidth/2-5, 230);
            }else if (IS_IPHONE_6P){
                self.myPv.frame = CGRectMake(5, 210+self.sumeven, dtScreenWidth/2-5, 230);
            }
            self.sumeven += (self.myPv.frame.size.height+5);
        }
        if(self.sumeven>=self.sumodd){
            self.sum = self.sumeven;
        }else{
            self.sum = self.sumodd;
        }
        if (self.sum < self.playersScollview.bounds.size.height) {
            self.sum = self.playersScollview.bounds.size.height+1;
        }
        self.playersScollview.contentSize = CGSizeMake(self.playersScollview.bounds.size.width, self.sum + 170);
        [self.playerviews addObject:self.myPv];
        [self.playersScollview addSubview:self.myPv];
    }
}

#pragma mark----

- (void)setBanImageView{
    
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width_screen, 161)];
    for (int i = 0; i<10; i++) {
        
        UIButton * styleButton = [UIButton  buttonWithType:UIButtonTypeCustom];
        if (IS_IPHONE_5) {
            styleButton.frame =CGRectMake(12+i%5*width_screen/5, 15+i/5*(72), 42, 42);
        }else if (IS_IPHONE_6){
            styleButton.frame =CGRectMake(15+i%5*width_screen/5, 15+i/5*(72), 42, 42);
        }else if (IS_IPHONE_6P){
            styleButton.frame =CGRectMake(20+i%5*width_screen/5, 15+i/5*(72), 42, 42);
        }else if (IS_IPHONE_4_OR_LESS){
            styleButton.frame =CGRectMake(10+i%5*width_screen/5, 15+i/5*(72), 42, 42);
        }
        styleButton.layer.cornerRadius = 20;
        styleButton.clipsToBounds = YES;
        styleButton.tag = i+1;
        if (styleButton.tag==10) {
            styleButton.tag = nil;
        }
        [styleButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[i]]] forState:UIControlStateNormal];
        [styleButton addTarget:self action:@selector(styleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:styleButton];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(i%5*(width_screen/5), 62+i/5*(72), width_screen/5, 12)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:11.0];
        label.text = titlelabel[i];
        
        label.textColor = [CorlorTransform colorWithHexString:@"#6e6e6e"];
        
        [view addSubview:label];
    }
    [self.playersScollview addSubview:view];
    
    UIView * collectionTopView = [[UIView alloc]initWithFrame:CGRectMake(0, 160, width_screen, 50)];
    collectionTopView.backgroundColor = [UIColor whiteColor];
    [self.playersScollview addSubview:collectionTopView];
    
    iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(width_screen/2-20-21, collectionTopView.center.y-10.5, 21, 21)];
    iconImage.image = [UIImage imageNamed:@"all"];
    [self.playersScollview addSubview:iconImage];
    
    iconlabel = [[UILabel alloc]initWithFrame:CGRectMake(iconImage.frame.origin.x+iconImage.frame.size.width+10, iconImage.center.y-6, 60, 12)];
    iconlabel.font = [UIFont systemFontOfSize:11.0];
    iconlabel.textColor = [CorlorTransform colorWithHexString:@"#6e6e6e"];
    iconlabel.text = @"全部";
    [self.playersScollview addSubview:iconlabel];
    
    int i = [tagIndexNumber intValue];
    if (i==1) {
        iconlabel.text = [NSString stringWithFormat:@"%@",titlelabel[i-1]];
        iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[i-1]]];
    }else if (i==2){
        iconlabel.text = [NSString stringWithFormat:@"%@",titlelabel[i-1]];
        iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[i-1]]];
    }else if (i==3){
        iconlabel.text = [NSString stringWithFormat:@"%@",titlelabel[i-1]];
        iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[i-1]]];
    }else if (i==4){
        iconlabel.text = [NSString stringWithFormat:@"%@",titlelabel[i-1]];
        iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[i-1]]];
    }else if (i==5){
        iconlabel.text = [NSString stringWithFormat:@"%@",titlelabel[i-1]];
        iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[i-1]]];
    }else if (i==6){
        iconlabel.text = [NSString stringWithFormat:@"%@",titlelabel[i-1]];
        iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[i-1]]];
    }else if (i==7){
        iconlabel.text = [NSString stringWithFormat:@"%@",titlelabel[i-1]];
        iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[i-1]]];
    }else if (i==8){
        iconlabel.text = [NSString stringWithFormat:@"%@",titlelabel[i-1]];
        iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[i-1]]];
    }else if (i==9){
        iconlabel.text = [NSString stringWithFormat:@"%@",titlelabel[i-1]];
        iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[i-1]]];
    }
    
    //左右两个线
    UIImageView * line_left = [[UIImageView alloc]initWithFrame:CGRectMake(10, collectionTopView.center.y, width_screen/3-20, 1)];
    line_left.backgroundColor = [CorlorTransform colorWithHexString:@"#e7e7e7"];
    [self.playersScollview addSubview:line_left];
    
    UIImageView * line_right = [[UIImageView alloc]initWithFrame:CGRectMake(width_screen/3*2+10, collectionTopView.center.y, width_screen/3-20, 1)];
    line_right.backgroundColor = [CorlorTransform colorWithHexString:@"#e7e7e7"];
    [self.playersScollview addSubview:line_right];
    
}

- (void)styleButtonClick:(UIButton *)sender
{
    if (sender.tag == nil) {
        [self shuaxin:nil];
    }else{
        [self shuaxin:[NSNumber numberWithInteger:sender.tag]];
    }
}
- (void)shuaxin:(NSNumber *)number
{
    for (PlayerView *pv in self.playerviews) {
        [pv removeFromSuperview];
    }
    [self .playerviews removeAllObjects];
    
    NSString *session= [PersistenceManager getLoginSession];
    [UserConnector aroundPeiwan:session gender:[self.searchDic objectForKey:@"gender"] minPrice:[self.searchDic objectForKey:@"minPrice"] maxPrice:[self.searchDic objectForKey:@"maxPrice"] isWin:nil offset:0 limit:self.infoCount
                    isRecommend:nil mode:[self.searchDic objectForKey:@"mode"] tagIndex:number receiver:^(NSData *data,NSError *error){
                        
                        tagIndexNumber = number;
                        
                        if (error) {
                            [ShowMessage showMessage:@"服务器未响应"];
                        }else{
                            SBJsonParser*parser=[[SBJsonParser alloc]init];
                            NSMutableDictionary *json=[parser objectWithData:data];
                            int status = [[json objectForKey:@"status"]intValue];
                            if (status == 0) {
                                self.playerInfoArray = [json objectForKey:@"entity"];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    //布局滚动页面子视图
                                    [self layoutSubviews];
                                    [HUD hide:YES afterDelay:0];
                                });
                                
                                
                                if (number==nil) {
                                    iconlabel.text = [NSString stringWithFormat:@"%@",titlelabel[9]];
                                    iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[9]]];
                                }else{
                                    iconlabel.text = [NSString stringWithFormat:@"%@",titlelabel[[number intValue]-1]];
                                    iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[[number intValue]-1]]];
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
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"playerinfo"]) {
        PlagerinfoViewController *pv = segue.destinationViewController;
        pv.hidesBottomBarWhenPushed = YES;
        pv.playerInfo = sender;
    }
}-(void)didReceiveMessages:(NSArray *)aMessages
{
    [ShowMessage showMessage:@"收到新信息"];

    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    options.displayName = @"亲爱的,有人在美玩中呼叫您呢。我是您的美玩小助手";/**然而并没有什么用*/
    NSArray *items = self.tabBarController.tabBar.items;
    UITabBarItem *chatItem = items[3];
    
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    
    
    if (unreadCount>0) {
        chatItem.badgeValue = [NSString stringWithFormat:@"%d",unreadCount];
        /**震动提示,当收到消息时震动*/
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        for (EMMessage *message in aMessages) {
            
            NSString * numberstring = [message.conversationId substringFromIndex:8];
            NSNumber * userID = [NSNumber numberWithInteger:[numberstring integerValue]];
            NSString * session = [PersistenceManager getLoginSession];
            [UserConnector findPeiwanById:session userId:userID receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
                if (error) {
                    
                }else{
                    SBJsonParser * json = [[SBJsonParser alloc]init];
                    NSDictionary * jsonDictionary = [json objectWithData:data];
                    self.sendPlayerDic = jsonDictionary[@"entity"];
                }
            }];
            /**本地通知，程序进入后台时调用，彻底死掉时使用的是远程推送*/
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:0.1];
            notification.timeZone=[NSTimeZone defaultTimeZone];
            notification.applicationIconBadgeNumber = unreadCount;
            notification.soundName= UILocalNotificationDefaultSoundName;
            
            EMMessageBody *msgBody = message.body;
            switch (msgBody.type) {
                case EMMessageBodyTypeText:
                {
                    NSLog(@"%@",message.conversationId);
                    
                    // 收到的文字消息
                    EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
                    NSString *txt = textBody.text;
                    
                    notification.alertBody = [NSString stringWithFormat:@"%@:%@",_sendPlayerDic[@"nickname"],txt];
                    [[UIApplication sharedApplication]  scheduleLocalNotification:notification];
                    
                    
                }
                    break;
                case EMMessageBodyTypeImage:
                {
                    // 得到一个图片消息body
                    notification.alertBody = [NSString stringWithFormat:@"%@发来一张图片",_sendPlayerDic[@"nickname"]];
                    [[UIApplication sharedApplication]  scheduleLocalNotification:notification];
                    
                    
                }
                    break;
                case EMMessageBodyTypeLocation:
                {
                    notification.alertBody = [NSString stringWithFormat:@"%@发来一个地理位置",_sendPlayerDic[@"nickname"]];
                    [[UIApplication sharedApplication]  scheduleLocalNotification:notification];
                    
                }
                    break;
                case EMMessageBodyTypeVoice:
                {
                    // 音频sdk会自动下载
                    notification.alertBody = [NSString stringWithFormat:@"%@发来一段语音",_sendPlayerDic[@"nickname"]];
                    [[UIApplication sharedApplication]  scheduleLocalNotification:notification];
                    
                    
                }
                    break;
                case EMMessageBodyTypeVideo:
                {
                    notification.alertBody = [NSString stringWithFormat:@"%@发来一段视频",_sendPlayerDic[@"nickname"]];
                    [[UIApplication sharedApplication]  scheduleLocalNotification:notification];
                    
                }
                    break;
                case EMMessageBodyTypeFile:
                {
                    notification.alertBody = [NSString stringWithFormat:@"%@发来一份文件",_sendPlayerDic[@"nickname"]];
                    [[UIApplication sharedApplication]  scheduleLocalNotification:notification];
                    
                    
                }
                    break;
                    
                default:
                    break;
                    
                    
            }
        }
        
        
    }else{
        chatItem.badgeValue = nil;
    }
    
   
}

@end
