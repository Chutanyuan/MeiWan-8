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
#import "TAauthenticateCell.h"
#import "ChatViewController.h"
#import "InviteViewController.h"

#define SCREEN_RECT [UIScreen mainScreen].bounds
static NSString *const kMXCellIdentifer = @"kMXCellIdentifer";


@interface PlagerinfoViewController ()<UITableViewDelegate,UITableViewDataSource,PhohtsHeaderViewDelegate>{
    NSInteger flag;
}
@property(nonatomic,strong)UIView * alphaView;
@property(nonatomic,strong)UIView * alphaView2;
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,assign)CGFloat oldOffset;
@property(nonatomic,strong)NSDictionary * getData;
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
    self.title  = @"个人详情";
    _array  =@[@"个人详情",@"当地向导",@"身高",@"体重",@"职业",@"星座",@"个性签名",@"常出没地"];
    _array2 = @[@"动态"];
    _array3 = @[@"粉丝"];
    _array4 = @[@"Ta的认证",@"",@"商家认证",@""];
    flag = 1;
    [self initBaseData];

    
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
                [self initView];
                self.headerImageView.userMessage = self.getData;

            }else{
                
            }
        }
    }];
}

-(void)initView
{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight-10) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableview];
    
    self.headerImageView = [[PhotosHeaderView alloc] initWithFrame:CGRectMake(0,0,dtScreenWidth , dtScreenWidth+40)];
    self.headerImageView.delegate = self;
    self.tableview.tableHeaderView = self.headerImageView;
    
    self.alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, 64)];
    self.alphaView.backgroundColor = [UIColor clearColor];
    
    UILabel * label = [[UILabel alloc]init];
    label.text = @"个人";
    label.textColor = [UIColor whiteColor];
    label.font = [FontOutSystem fontWithFangZhengSize:26];
    CGSize size_label = [label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName, nil]];
    label.frame  =CGRectMake(self.alphaView.center.x-size_label.width/2, self.alphaView.center.y-size_label.height/2+10, size_label.width, size_label.height);
    [self.alphaView addSubview:label];
    
    UIButton * backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backbutton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    backbutton.frame  = CGRectMake(10, 20, 40, 40);
    [backbutton addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [self.alphaView addSubview:backbutton];
    
    UIButton * moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton setImage:[UIImage imageNamed:@"MoreButtonImageW"] forState:UIControlStateNormal];
    moreButton.frame = CGRectMake(dtScreenWidth-10-30, 25, 30, 30);
    [self.alphaView addSubview:moreButton];
    
    
    self.alphaView2 = [[UIView alloc]initWithFrame:self.alphaView.frame];
    self.alphaView2.backgroundColor  = [CorlorTransform colorWithHexString:@"78cdf8"];
    self.alphaView2.alpha = 0;
    [self.view addSubview:self.alphaView2];
    
    [self.view addSubview:self.alphaView];

    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, dtScreenHeight-50, dtScreenWidth, 50)];
    bottomView.backgroundColor = [CorlorTransform colorWithHexString:@"#d1d1d1"];
    [self.view addSubview:bottomView];
    
    UIButton * liao = [UIButton buttonWithType:UIButtonTypeCustom];
    [liao setTitle:@"找Ta聊天" forState:UIControlStateNormal];
    [liao setTitleColor:[CorlorTransform colorWithHexString:@"#ed5b5b"] forState:UIControlStateNormal];
    liao.frame = CGRectMake((dtScreenWidth/2-102)/2, 10, 102, 30);
    liao.layer.cornerRadius = 5;
    liao.backgroundColor = [UIColor whiteColor];
    [liao addTarget:self action:@selector(liaoMei) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:liao];
    
    UIButton * yue = [UIButton buttonWithType:UIButtonTypeCustom];
    [yue setTitleColor:[CorlorTransform colorWithHexString:@"#ed5b5b"] forState:UIControlStateNormal];
    [yue setTitle:@"约Ta" forState:UIControlStateNormal];
    yue.backgroundColor = [UIColor whiteColor];
    yue.layer.cornerRadius = 5;
    yue.frame  = CGRectMake(dtScreenWidth/2+liao.frame.origin.x, 10, 102, 30);
    [yue addTarget:self action:@selector(yueMei) forControlEvents:UIControlEventTouchUpInside];

    [bottomView addSubview:yue];
    
}
- (void)liaoMei
{
    NSString *product = [NSString stringWithFormat:@"%@%ld",
                         [setting getRongLianYun],[[self.getData objectForKey:@"id"]longValue]];
    ChatViewController *messageCtr = [[ChatViewController alloc] initWithConversationChatter:product conversationType:EMConversationTypeChat];
    messageCtr.title = [NSString stringWithFormat:@"%@",
                        [self.getData objectForKey:@"nickname"]];
    [self.navigationController pushViewController:messageCtr animated:YES];
    __block BOOL show;
    NSDictionary *userInfo = [PersistenceManager getLoginUser];
    NSString *thesame = [NSString stringWithFormat:@"%ld",[[userInfo objectForKey:@"id"]longValue]];
    if ([thesame isEqualToString:@"100000"] || [thesame isEqualToString:@"100001"]) {
        show = NO;
        
    }else{
        show = [setting canOpen];
        
        [setting getOpen];
    }

}
- (void)yueMei
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InviteViewController *playerInfoCtr = [mainStoryboard instantiateViewControllerWithIdentifier:@"inviteSomeOne"];
    playerInfoCtr.playerInfo= self.getData;
    [self.navigationController pushViewController:playerInfoCtr animated:YES];

}
- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
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
            if (indexPath.row%2==0) {
                return 44;
            }else{
                return 80;
            }
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (flag==1) {
        UILabel * rightlabel = [[UILabel alloc]initWithFrame:CGRectMake(dtScreenWidth/2, 0, dtScreenWidth/2-20, 50)];
        rightlabel.textAlignment = NSTextAlignmentRight;
        rightlabel.font = [FontOutSystem fontWithFangZhengSize:15.0];
        rightlabel.textColor = [UIColor blackColor];

        
        UITableViewCell * ziliao = [tableView dequeueReusableCellWithIdentifier:@"ziliao"];
        if (!ziliao) {
            ziliao = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ziliao"];
            [ziliao addSubview:rightlabel];
        }
        if (indexPath.row==0) {
            ziliao.backgroundColor = [CorlorTransform colorWithHexString:@"#f6f6f6"];
            ziliao.textLabel.textColor = [CorlorTransform colorWithHexString:@"#d5d5d5"];
            ziliao.textLabel.text = @"Ta的资料";
        }else{
            if (indexPath.row%2==0) {
                ziliao.backgroundColor = [CorlorTransform colorWithHexString:@"#e1e0e0"];
                ziliao.textLabel.textColor = [UIColor whiteColor];

            }else{
                ziliao.backgroundColor = [UIColor whiteColor];
                ziliao.textLabel.textColor = [CorlorTransform colorWithHexString:@"#d5d5d5"];
            }
            ziliao.textLabel.text = _array[indexPath.row];
            ziliao.textLabel.font = [FontOutSystem fontWithFangZhengSize:17.0];
            
            if (indexPath.row==2){
                if ([self.getData[@"height"] intValue]==0) {
                    rightlabel.text = @"未设置";
                }else{
                    rightlabel.text = [NSString stringWithFormat:@"%@cm",self.getData[@"height"]];
                }
            }else if (indexPath.row==3){
                if ([self.getData[@"weight"] intValue]==0) {
                    rightlabel.text = @"未设置";
                }else{
                    rightlabel.text = [NSString stringWithFormat:@"%@kg",self.getData[@"weight"]];
                }
            }else if (indexPath.row==4){
                if (self.getData[@"job"] == nil) {
                    rightlabel.text = @"未设置";
                }else{
                    rightlabel.text = self.getData[@"job"];
                }
            }else if (indexPath.row==5){
                if (self.getData[@"xingzuo"] == nil) {
                    rightlabel.text = @"未设置";
                }else{
                    rightlabel.text = self.getData[@"xingzuo"];
                }
            }else if (indexPath.row==6){
                rightlabel.text = self.getData[@"description"];
            }else if (indexPath.row==7){
                rightlabel.text = self.getData[@"location"];
            }
        }
        
        return ziliao;
    }else if (flag==2){
        UITableViewCell * dongtai = [tableView dequeueReusableCellWithIdentifier:@"dongtai"];
        if (!dongtai) {
            dongtai = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dongtai"];
        }
        return dongtai;
    }else if (flag==3){
        UITableViewCell * fensi = [tableView dequeueReusableCellWithIdentifier:@"fensi"];
        if (!fensi) {
            fensi = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"v"];
        }
        return fensi;
    }else if (flag==4){
        UITableViewCell * renzheng = [tableView dequeueReusableCellWithIdentifier:@"renzheng"];
        if (!renzheng) {
            renzheng = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"renzheng"];
        }
        if (indexPath.row%2==0) {
            renzheng.backgroundColor = [CorlorTransform colorWithHexString:@"#f6f6f6"];
            renzheng.textLabel.textColor = [CorlorTransform colorWithHexString:@"#d5d5d5"];
        }else{
            if (indexPath.row==1) {
                renzheng = [[TAauthenticateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"indexpath1"];
            }else{
                renzheng = [[TAauthenticateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"indexpath2"];
            }
        }

        renzheng.textLabel.text = _array4[indexPath.row];
        return renzheng;
    }else{
        return nil;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
