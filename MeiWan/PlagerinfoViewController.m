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
#import "PhotosHeaderView.h"

#define SCREEN_RECT [UIScreen mainScreen].bounds
static NSString *const kMXCellIdentifer = @"kMXCellIdentifer";


@interface PlagerinfoViewController ()<UITableViewDelegate,UITableViewDataSource,PhohtsHeaderViewDelegate>{
    NSInteger flag;
}
@property(nonatomic,strong)UIView * alphaView;
@property(nonatomic,strong)UIView * alphaView2;
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,assign)CGFloat oldOffset;
@property(nonatomic,assign)NSDictionary * getData;
@property(nonatomic,strong)PhotosHeaderView *headerImageView;
@property(nonatomic,strong)NSArray * array;
@property(nonatomic,strong)NSArray * array2;
@property(nonatomic,strong)NSArray * array3;
@property(nonatomic,strong)NSArray * array4;

@end

@implementation PlagerinfoViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.alpha = 0;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.alpha = 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
    self.title  = @"个人详情";
    _array  =@[@"个人详情",@"当地向导",@"身高",@"体重",@"职业",@"星座",@"签名"];
    _array4 = @[@"1",@"22",@"333"];
    flag = 1;
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableview];
    
    self.headerImageView = [[PhotosHeaderView alloc] initWithFrame:CGRectMake(0,0,dtScreenWidth , dtScreenWidth+40)];
    self.headerImageView.delegate = self;
    self.tableview.tableHeaderView = self.headerImageView;

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
    
    UIButton * moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton setImage:[UIImage imageNamed:@"MoreButtonImageW"] forState:UIControlStateNormal];
//    moreButton.imageView.image = [UIImage imageNamed:@"MoreButtonImageW"];
    moreButton.frame = CGRectMake(dtScreenWidth-20-24, 27, 24, 24);
    [self.alphaView addSubview:moreButton];
    
    
    self.alphaView2 = [[UIView alloc]initWithFrame:self.alphaView.frame];
    self.alphaView2.backgroundColor  = [CorlorTransform colorWithHexString:@"78cdf8"];
    self.alphaView2.alpha = 0;
    [self.view addSubview:self.alphaView2];

    [self.view addSubview:self.alphaView];
    
}

- (void)initBaseData {

    NSString * session = [PersistenceManager getLoginSession];
    [UserConnector findPeiwanById:session userId:[NSNumber numberWithDouble:[self.playerInfo[@"id"] doubleValue]] receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            SBJsonParser * parser = [[SBJsonParser alloc]init];
            NSDictionary * json = [parser objectWithData:data];
            int status = [json[@"status"] intValue];
            if (status==0) {
                self.getData = json[@"entity"];
                self.headerImageView.userMessage = self.getData;
            }else{
                
            }
        }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (flag==1) {
        return _array.count;
    }else if (flag==2){
        return _array2.count;
    }else if (flag==3){
        return _array3.count;
    }else{
        return _array4.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 40;
    }else{
        if (flag==1) {
             return 50;
        }else if (flag==2){
            return 70;
        }else if (flag==3){
            return 100;
        }else{
            return 44;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.row==0) {
        cell.backgroundColor = [CorlorTransform colorWithHexString:@"#f6f6f6"];
    }else{
        if (indexPath.row%2==1) {
            cell.backgroundColor = [UIColor whiteColor];
        }else{
            cell.backgroundColor = [CorlorTransform colorWithHexString:@"#e1e0e0"];
        }
    }
    if (flag==1) {
        cell.textLabel.text = _array[indexPath.row];
    }else if (flag==2){
        
    }else if (flag==3){
        
    }else{
        cell.textLabel.text =  _array4[indexPath.row];
    }
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.1 animations:^{
        self.alphaView2.alpha = scrollView.contentOffset.y*0.01-0.1;
    }];
}
#pragma mark----资料 动态 粉丝 认证
-(void)fourButtonWithTitle:(UIButton *)sender
{
    flag = sender.tag;
    [self.tableview reloadData];
}
@end
