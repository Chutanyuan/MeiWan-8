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
#import "ShowMessage.h"
#import "LoginViewController.h"
#import "FocusTableViewCell.h"
#import "DetailWithPlayerTableViewCell.h"
#import "StateOneViewController.h"
#import "RatedViewController.h"
#import "showImageController.h"


#define limit_Num 6
#define SCREEN_RECT [UIScreen mainScreen].bounds
static NSString *const kMXCellIdentifer = @"kMXCellIdentifer";


@interface PlagerinfoViewController ()<UITableViewDelegate,UITableViewDataSource,PhohtsHeaderViewDelegate,dongtaiZanDelegate,FocusTableViewCellDelegate>{
    NSInteger flag;
    int pages;
    int statusPages;
}
@property(nonatomic,strong)UIView * alphaView;
@property(nonatomic,strong)UIView * alphaView2;
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,assign)CGFloat oldOffset;
@property(nonatomic,strong)NSDictionary * getData;
@property(nonatomic,strong)PhotosHeaderView *headerImageView;
@property(nonatomic,strong)NSArray * array;
@property(nonatomic,strong)NSMutableArray * statusArray;
@property(nonatomic,strong)NSMutableArray * array3;
@property(nonatomic,strong)NSArray * array4;
@property(nonatomic,strong)NSArray * pinglunCount;
@property (nonatomic, strong) NSMutableArray * MyfriendArray;


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
    pages=0;
    statusPages=0;
    _array  =@[@"个人详情",@"当地向导",@"身高",@"体重",@"职业",@"星座",@"个性签名",@"常出没地",@"用户评价信息"];
    _statusArray = [[NSMutableArray alloc]initWithCapacity:0];
    _array3 = [[NSMutableArray alloc]initWithCapacity:0];
    _array4 = @[@"Ta的认证",@"",@"商家认证",@""];
    flag = 1;
    _MyfriendArray = [[NSMutableArray alloc]initWithCapacity:0];
    [self findMyFriendList];
    [self initBaseData];
    [self focusFollowersBy:pages];
    [self findStatusBy:[NSNumber numberWithInt:statusPages] limit:[NSNumber numberWithInt:limit_Num]];
    
}
- (void)initBaseData {
    
    [UserConnector findOrderEvaluationByUserId:[NSNumber numberWithInteger:[self.playerInfo[@"id"] integerValue]] offset:@0 limit:@100000 receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            SBJsonParser * parser = [[SBJsonParser alloc] init];
            NSDictionary * json = [parser objectWithData:data];
            int status = [json[@"status"] intValue];
            if (status==0) {
                self.pinglunCount = [[NSArray alloc]initWithArray:json[@"entity"]];
            }
        }
    }];
    
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
                self.headerImageView.redLine.frame = CGRectMake((flag-1)*dtScreenWidth/4, dtScreenWidth+39, dtScreenWidth/4, 2);
                [self.tableview.mj_header endRefreshing];
                
            }else{
                [ShowMessage showMessage:@"服务器未响应"];
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
    
    //viewdidload的时候要独自写一次网络请求，只在里面写一次没有效果，因为没有下啦所以没有刷新不走里面的函数
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.tableview.mj_header beginRefreshing];
        //开始网络请求
        self.getData = nil;
        [self initBaseData];
        [self.MyfriendArray removeAllObjects];
        [self findMyFriendList];

        if (flag==1) {
            
        }else if (flag==2){
            statusPages=0;
            [self.statusArray removeAllObjects];
            [self  findStatusBy:[NSNumber numberWithInt:statusPages] limit:[NSNumber numberWithInt:limit_Num]];
        }else if (flag==3){
            pages=0;
            [self.array3 removeAllObjects];
            [self focusFollowersBy:pages];

        }else if (flag==4){
        
        }
    }];
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (flag==3) {
            [self.tableview.mj_footer beginRefreshing];
            pages+=limit_Num;
            [self focusFollowersBy:pages];
        }
        if (flag==2) {
            [self.tableview.mj_footer beginRefreshing];
            statusPages+=limit_Num;
            [self findStatusBy:[NSNumber numberWithInt:statusPages] limit:[NSNumber numberWithInt:limit_Num]];
        }
    }];
    self.headerImageView = [[PhotosHeaderView alloc] initWithFrame:CGRectMake(0,0,dtScreenWidth , dtScreenWidth+40)];
    self.headerImageView.delegate = self;
    self.tableview.tableHeaderView = self.headerImageView;
    self.alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, 64)];
    self.alphaView.backgroundColor = [UIColor clearColor];
    
    UILabel * label = [[UILabel alloc]init];
    label.text = @"个人";
    label.textColor = [UIColor whiteColor];
    label.font = [FontOutSystem fontWithFangZhengSize:20];
    CGSize size_label = [label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName, nil]];
    label.frame  =CGRectMake(self.alphaView.center.x-size_label.width/2, self.alphaView.center.y-size_label.height/2+10, size_label.width, size_label.height);
    [self.alphaView addSubview:label];
    
    UIButton * backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backbutton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    backbutton.frame  = CGRectMake(10, 32, 10, 20);
    [backbutton addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [self.alphaView addSubview:backbutton];
    
    UIButton * moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton setImage:[UIImage imageNamed:@"MoreButtonImageW"] forState:UIControlStateNormal];
    moreButton.frame = CGRectMake(dtScreenWidth-10-20, 32, 20, 20);
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
        return _statusArray.count+1;
    }else if (flag==3){
        return _array3.count+1;
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
            DetailWithPlayerTableViewCell * cell = [self tableView:self.tableview cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height;
        }else if (flag==3){
            return 70;
        }else{
            if (indexPath.row%2==0) {
                return 44;
            }else{
                if (indexPath.row==1) {
                    return 120;
                }else{
                    return 200;
                }
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
            if (indexPath.row==1) {
                if (self.headerImageView.biaoqian3.text != nil) {
                    ziliao.textLabel.text = [NSString stringWithFormat:@"%@、%@、%@",self.headerImageView.biaoqian1.text,self.headerImageView.biaoqian2.text,self.headerImageView.biaoqian3.text];
                    NSInteger a;
                    if (self.headerImageView.biaoqian1.tag<=self.headerImageView.biaoqian2.tag) {
                        
                        if (self.headerImageView.biaoqian1.tag<=self.headerImageView.biaoqian3.tag) {
                            a = self.headerImageView.biaoqian1.tag;
                        }else{
                            a = self.headerImageView.biaoqian3.tag;
                        }
                    }else{
                        if (self.headerImageView.biaoqian2.tag<=self.headerImageView.biaoqian3.tag) {
                            a = self.headerImageView.biaoqian2.tag;
                        }else{
                            a = self.headerImageView.biaoqian3.tag;
                        }
                    }
                    
                    if (a<20) {
                        NSString * textForRightLabel = [NSString stringWithFormat:@"最低 %ld元/次",(long)a];
                        NSMutableAttributedString * changeText = [[NSMutableAttributedString alloc]initWithString:textForRightLabel];
                        NSRange range = [[changeText string]rangeOfString:[NSString stringWithFormat:@" %ld元/次",(long)a]];
                        [changeText addAttribute:NSForegroundColorAttributeName value:[CorlorTransform colorWithHexString:@"#ed5b5b"] range:range];
                        rightlabel.attributedText = changeText;
                    }else{
                        
                        NSString * textForRightLabel = [NSString stringWithFormat:@"最低 %ld元/小时",(long)a];
                        NSMutableAttributedString * changeText = [[NSMutableAttributedString alloc]initWithString:textForRightLabel];
                        NSRange range = [[changeText string]rangeOfString:[NSString stringWithFormat:@" %ld元/小时",(long)a]];
                        [changeText addAttribute:NSForegroundColorAttributeName value:[CorlorTransform colorWithHexString:@"#ed5b5b"] range:range];
                        rightlabel.attributedText = changeText;
                    }
 
                }else{
                    if (self.headerImageView.biaoqian2.text!=nil)
                    {
                        ziliao.textLabel.text = [NSString stringWithFormat:@"%@、%@",self.headerImageView.biaoqian1.text,self.headerImageView.biaoqian2.text];
                        NSInteger a;
                        if (self.headerImageView.biaoqian1.tag<=self.headerImageView.biaoqian2.tag) {
                            
                            a = self.headerImageView.biaoqian1.tag;
                        }else{
                            
                            a = self.headerImageView.biaoqian2.tag;
                        }
                        
                        if (a<20) {
                            NSString * textForRightLabel = [NSString stringWithFormat:@"最低 %ld元/次",(long)a];
                            NSMutableAttributedString * changeText = [[NSMutableAttributedString alloc]initWithString:textForRightLabel];
                            NSRange range = [[changeText string]rangeOfString:[NSString stringWithFormat:@" %ld元/次",(long)a]];
                            [changeText addAttribute:NSForegroundColorAttributeName value:[CorlorTransform colorWithHexString:@"#ed5b5b"] range:range];
                            rightlabel.attributedText = changeText;
                        }else{
                            
                            NSString * textForRightLabel = [NSString stringWithFormat:@"最低 %ld元/小时",(long)a];
                            NSMutableAttributedString * changeText = [[NSMutableAttributedString alloc]initWithString:textForRightLabel];
                            NSRange range = [[changeText string]rangeOfString:[NSString stringWithFormat:@" %ld元/小时",(long)a]];
                            [changeText addAttribute:NSForegroundColorAttributeName value:[CorlorTransform colorWithHexString:@"#ed5b5b"] range:range];
                            rightlabel.attributedText = changeText;
                        }

                    }else{
                        if (self.headerImageView.biaoqian1.text!=nil) {
                            ziliao.textLabel.text = [NSString stringWithFormat:@"%@",self.headerImageView.biaoqian1.text];
                            NSInteger a;
                            
                            a = self.headerImageView.biaoqian1.tag;
                            
                            if (a<20) {
                                NSString * textForRightLabel = [NSString stringWithFormat:@"最低 %ld元/次",(long)a];
                                NSMutableAttributedString * changeText = [[NSMutableAttributedString alloc]initWithString:textForRightLabel];
                                NSRange range = [[changeText string]rangeOfString:[NSString stringWithFormat:@" %ld元/次",(long)a]];
                                [changeText addAttribute:NSForegroundColorAttributeName value:[CorlorTransform colorWithHexString:@"#ed5b5b"] range:range];
                                rightlabel.attributedText = changeText;
                            }else{
                                
                                NSString * textForRightLabel = [NSString stringWithFormat:@"最低 %ld元/小时",(long)a];
                                NSMutableAttributedString * changeText = [[NSMutableAttributedString alloc]initWithString:textForRightLabel];
                                NSRange range = [[changeText string]rangeOfString:[NSString stringWithFormat:@" %ld元/小时",(long)a]];
                                [changeText addAttribute:NSForegroundColorAttributeName value:[CorlorTransform colorWithHexString:@"#ed5b5b"] range:range];
                                rightlabel.attributedText = changeText;
                            }

                        }else{
                            //none
                        }
                    }
                }
                
            }else{
                ziliao.textLabel.text = _array[indexPath.row];
            }
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
            }else if (indexPath.row==8){
                rightlabel.text  = [NSString stringWithFormat:@"%lu ➡️",(unsigned long)self.pinglunCount.count];
                rightlabel.alpha = 0.7;
            }
            
        }
        
        return ziliao;
    }else if (flag==2){
        DetailWithPlayerTableViewCell * dongtai = [tableView dequeueReusableCellWithIdentifier:@"dongtai"];
        if (!dongtai) {
            dongtai = [[DetailWithPlayerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dongtai"];
        }
        if (indexPath.row==0) {
           UITableViewCell* dongtaicell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dontai"];
            dongtaicell.textLabel.text = @"全部动态";
            dongtaicell.backgroundColor = [CorlorTransform colorWithHexString:@"#f6f6f6"];
            dongtaicell.textLabel.textColor = [CorlorTransform colorWithHexString:@"#d5d5d5"];
            return dongtaicell;
        }else{
            dongtai.delegate = self;
            dongtai.backgroundColor = [UIColor whiteColor];
            [dongtai.photosImage removeFromSuperview];
            dongtai.detailDictionary = self.statusArray[indexPath.row-1];
        }
        return dongtai;
    }else if (flag==3){
        FocusTableViewCell * fensi = [tableView cellForRowAtIndexPath:indexPath];
        if (!fensi) {
            fensi = [[FocusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fensi"];
            fensi.delegate = self;
        }
        if (indexPath.row==0) {
            fensi.textLabel.text = @"全部粉丝";
            fensi.backgroundColor = [CorlorTransform colorWithHexString:@"#f6f6f6"];
            fensi.textLabel.textColor = [CorlorTransform colorWithHexString:@"#d5d5d5"];
            fensi.focusButton.hidden = YES;
        }else{
            if (self.array3.count>0) {
                fensi.focusDic = self.array3[indexPath.row-1];
            }
            [_MyfriendArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj[@"id"] isEqual:fensi.focusDic[@"id"]]) {
                    [fensi.focusButton setTitle:@"已关注" forState:UIControlStateNormal];
                }
            }];
            [fensi.focusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            fensi.focusButton.backgroundColor = [CorlorTransform colorWithHexString:@"#ffcccc"];
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
    if (flag==2) {
        StateOneViewController * oneMessage = [[StateOneViewController alloc]init];
        oneMessage.stateMessage = self.statusArray[indexPath.row-1];
        [self.navigationController pushViewController:oneMessage animated:YES];
    }else if (flag==1){
        if (indexPath.row==8) {
            RatedViewController * rated = [[RatedViewController alloc]init];
            rated.title = @"用户评价";
            rated.playerInfo = self.playerInfo;
            [self.navigationController pushViewController:rated animated:YES];
        }
    }
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


#pragma mark----获取粉丝列表

- (void)focusFollowersBy:(int)offset{

    [UserConnector findMyFocus:[NSNumber numberWithInteger:[self.playerInfo[@"id"] integerValue]] offset:offset limit:limit_Num receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                
                if (offset==0) {
                    [self.array3 removeAllObjects];
                    self.array3 = [json objectForKey:@"entity"];
                    for (int i = 0;  i < self.array3.count; i++) {
                        if ([self.array3[i] isKindOfClass:[NSNull class]]) {
                            [self.array3 removeObjectAtIndex:i];
                        }
                    }
                    [_tableview reloadData];
                    [_tableview.mj_header endRefreshing];
                    
                }else{
                    [self.array3 addObjectsFromArray:json[@"entity"]];
                    [self.tableview reloadData];
                    [_tableview.mj_footer endRefreshing];
                }
            }else if (status == 1){
                
                [self loginPush];
                
            }else{
                
            }
            
        }

    }];
}
#pragma mark----用户动态
- (void)findStatusBy:(NSNumber *)offset limit:(NSNumber*)limit
{
    NSString * session = [PersistenceManager getLoginSession];
    [UserConnector findStates:session userId:[NSNumber numberWithDouble:[self.playerInfo[@"id"] doubleValue]] offset:offset limit:limit receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            SBJsonParser * parser = [[SBJsonParser alloc]init];
            NSDictionary * json = [parser objectWithData:data];
            int status = [json[@"status"] intValue];
            if (status==0) {
                if (offset==0) {
                    self.statusArray = json[@"entity"];
                    [self.tableview reloadData];
                    [self.tableview.mj_header endRefreshing];
                    
                }else{
                    [self.statusArray addObjectsFromArray:json[@"entity"]];
                    [self.tableview reloadData];
                    [self.tableview.mj_footer endRefreshing];
                }
            }else{
                if (status==1) {
                    [self loginPush];
                }
            }
        }else{
            [ShowMessage showMessage:@"服务器未响应"];
        }
    }];
}
- (void)loginPush
{
    [PersistenceManager setLoginSession:@""];
    LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    lv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:lv animated:YES];
}
-(void)KeyBoardLoadWithUserid:(double)userID statusID:(double)statusid
{
    
}
/** 展示图片 */
-(void)touchUpInsidImageView:(NSMutableArray *)photos PhotosTag:(NSInteger)PhotosTag
{
    NSLog(@"%ld--%@",PhotosTag,photos);
    showImageController * showimage = [[showImageController alloc]init];
    showimage.imagesArray = photos;
    showimage.imageNumber = PhotosTag;
    showimage.flagType = 1000;
    [self.navigationController pushViewController:showimage animated:NO];
}
-(void)focusTableViewCell:(FocusTableViewCell *)cell userID:(NSString *)userID
{
    NSString * session  = [PersistenceManager getLoginSession];
    [UserConnector addFriend:session friendId:[NSNumber numberWithInteger:[userID integerValue]] receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            SBJsonParser * parser = [[SBJsonParser alloc]init];
            NSDictionary * json = [parser objectWithData:data];
            int status = [json[@"status"] intValue];
            if (status==0) {
                [cell.focusButton setTitle:@"已关注" forState:UIControlStateNormal];
            }else if (status==1){
                [self loginPush];
            }
        }else{
            [ShowMessage showMessage:@"服务器未响应"];
        }
    }];
}

/**获取好友*/
- (void)findMyFriendList
{
    NSString * session = [PersistenceManager getLoginSession];
    [UserConnector findMyFans:session offset:0 limit:99 receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            self.MyfriendArray = json[@"entity"];
            [self.tableview reloadData];
        }

    }];
}
@end
