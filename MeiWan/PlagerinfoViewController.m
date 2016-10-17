//
//  PlagerinfoViewController.m
//  MeiWan
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "PlagerinfoViewController.h"
#import "Meiwan-Swift.h"
#import "MJRefresh.h"
#import "MXNavigationBarManager.h"

#define SCREEN_RECT [UIScreen mainScreen].bounds
static NSString *const kMXCellIdentifer = @"kMXCellIdentifer";
static const CGFloat headerImageHeight = 260.0f;


@interface PlagerinfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIView * alphaView;
@property(nonatomic,strong)UIView * alphaView2;
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,assign)CGFloat oldOffset;
@property(nonatomic,assign)NSDictionary * getData;

@end

@implementation PlagerinfoViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.alpha = 0;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
    self.title  = @"个人详情";
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableview];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,dtScreenWidth , dtScreenWidth)];
    headerImageView.image = [UIImage imageNamed:@"headerImage"];
    self.tableview.tableHeaderView = headerImageView;

    self.alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, 64)];
    self.alphaView.backgroundColor = [UIColor clearColor];
    
    UILabel * label = [[UILabel alloc]init];
    label.text = @"个人";
    label.textColor = [UIColor whiteColor];
    label.font = [FontOutSystem fontWithFangZhengSize:18.0];
    CGSize size_label = [label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName, nil]];
    label.frame  =CGRectMake(self.alphaView.center.x-size_label.width/2, self.alphaView.center.y-size_label.height/2+10, size_label.width, size_label.height);
    [self.alphaView addSubview:label];
    
    UIButton * backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backbutton setImage:[UIImage imageNamed:@"peiwan_back"] forState:UIControlStateNormal];
    backbutton.frame  = CGRectMake(25, 25, 34, 34);
    [self.alphaView addSubview:backbutton];
    
    
    self.alphaView2 = [[UIView alloc]initWithFrame:self.alphaView.frame];
    self.alphaView2.backgroundColor  = [CorlorTransform colorWithHexString:@"78cdf8"];
    self.alphaView2.alpha = 0;
    [self.view addSubview:self.alphaView2];

    [self.view addSubview:self.alphaView];
}

- (void)initBaseData {

    NSString * session = [PersistenceManager getLoginSession];
    [UserConnector findPeiwanById:session userId:[NSNumber numberWithDouble:[[PersistenceManager getLoginUser][@"id"] doubleValue]] receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            SBJsonParser * parser = [[SBJsonParser alloc]init];
            NSDictionary * json = [parser objectWithData:data];
            int status = [json[@"status"] intValue];
            if (status==0) {
                self.getData = json[@"entity"];
                
            }else{
                
            }
        }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.contentOffset.y);
    [UIView animateWithDuration:0.1 animations:^{
        self.alphaView2.alpha = scrollView.contentOffset.y*0.01-0.1;
    }];
}

@end
