//
//  guildCenterViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/8/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "guildCenterViewController.h"
#import "QRCodeViewController.h"
#import "GuildMembersViewController.h"
#import "GuildRankListViewController.h"
#import "CashManagementViewController.h"
#import "GreatGuildViewController.h"

#import "UserInfo.h"
#import "Meiwan-Swift.h"
#import "ShowMessage.h"
#import "CorlorTransform.h"
#import "setting.h"
#import "SBJson.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "CorlorTransform.h"
//#import "RecordTableViewController.h"
#import "ShowMessage.h"
#import "LoginViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "MBProgressHUD.h"

@interface guildCenterViewController ()<UITableViewDelegate,UITableViewDataSource,greatGuildDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD * HUD;
}

@property (nonatomic, strong)UIView *createGuild;

@property (nonatomic, strong)UIView *guildCenter;

@property (nonatomic, strong)UITableView *guildCenterTableView;

@property (nonatomic, strong)NSArray *dataSource;
@property (nonatomic, strong)NSArray *dataUnionImage;

@property (nonatomic, strong)NSDictionary *userInfoDic;

@property (nonatomic, strong)UserInfo *userInfo;

@property (nonatomic, strong) NSMutableDictionary * guildArray;
@property (nonatomic, strong) UIImageView * hideImageView;

@end

@implementation guildCenterViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"加载中";
    
    _dataUnionImage = @[@"pw_qr",@"pw_group",@"pw_rank",@"qianbao"];
    
    [self loadNet];
    
    [self loadDatasource];
    
}
- (void)loadNet{
    NSString * session = [PersistenceManager getLoginSession];
    [UserConnector getLoginedUser:session receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [json[@"status"] intValue];
            if (status==0) {
                self.userInfo = [[UserInfo alloc]initWithDictionary:json[@"entity"]];
                if (self.userInfo.hasUnion == 1) {
                    [self loadFindGuildData];
                }else if (self.userInfo.hasUnion == 0){
                    [self createGuild];
                }
            }else if (status==1){
                [self pushLoginPage];
            }
            
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *sectionArray = self.dataSource[section];
    return sectionArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSArray *sectionArray = self.dataSource[indexPath.section];
    NSDictionary *dic = sectionArray[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_dataUnionImage[indexPath.row]]];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            QRCodeViewController *orCodeVC = [[QRCodeViewController alloc] init];
            orCodeVC.title = @"公会二维码";
            orCodeVC.guildID = self.guildArray[@"id"];
            orCodeVC.headerURL = self.guildArray[@"headUrl"];
            orCodeVC.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:orCodeVC animated:YES];
        }break;
        case 1:
        {
            GuildMembersViewController *guildMemberVC = [[GuildMembersViewController alloc] init];
            guildMemberVC.title = @"公会成员";
            guildMemberVC.view.backgroundColor = [UIColor whiteColor];
            guildMemberVC.title = @"公会成员";
            [self.navigationController pushViewController:guildMemberVC animated:YES];
        }break;
        case 2:{
            GuildRankListViewController *guildBankListVC = [[GuildRankListViewController alloc] init];
            guildBankListVC.view.backgroundColor = [UIColor whiteColor];
            guildBankListVC.title = @"公会排行";
            [self.navigationController pushViewController:guildBankListVC animated:YES];
        }break;
        case 3:{
            CashManagementViewController *cashManageMentVC = [[CashManagementViewController alloc] init];
            cashManageMentVC.title = @"提现管理";
            cashManageMentVC.dictionary = self.guildArray;
            cashManageMentVC.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:cashManageMentVC animated:YES];
        }break;
        default:
            break;
    }
}

- (void)loadFindGuildData{
    NSString *session = [PersistenceManager getLoginSession];
    [UserConnector findMyUnion:session receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error!=nil) {
            [ShowMessage showMessage:@"服务器未连接"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            self.guildArray = json[@"entity"];
            self.guildCenterTableView.tableHeaderView = self.guildCenter;
            [self.guildCenterTableView reloadData];
            [HUD hide:YES afterDelay:0.1];
        }
    }];
}

#pragma mark Get Set

- (UITableView *)guildCenterTableView{
    if (!_guildCenterTableView) {
        _guildCenterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, dtScreenWidth, dtScreenHeight) style:UITableViewStylePlain];
        _guildCenterTableView.dataSource = self;
        _guildCenterTableView.delegate = self;
        _guildCenterTableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_guildCenterTableView];
    }
    return _guildCenterTableView;
}

//工会
- (UIView *)guildCenter{
    if (!_guildCenter) {
        _guildCenter = [[UIView alloc] initWithFrame:CGRectMake(0, dtNavBarDefaultHeight, dtScreenWidth, 160)];
        _guildCenter.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_guildCenter];
        
        UIView *guildInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dtScreenWidth, 150)];
        guildInfo.backgroundColor = [UIColor whiteColor];
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, dtScreenWidth, 1)];
        line.backgroundColor = [UIColor grayColor];
        [guildInfo addSubview:line];
        [_guildCenter addSubview:guildInfo];
        
        UIImageView *guildHeadImage = [[UIImageView alloc]initWithFrame:CGRectMake((100-60)/2, 20, 60, 60)];
        NSURL *url = [NSURL URLWithString:[self.guildArray objectForKey:@"headUrl"]];
        [guildHeadImage setImageWithURL:url];
        guildHeadImage.layer.masksToBounds = YES;
        guildHeadImage.layer.cornerRadius = 30.0f;
        [guildInfo addSubview:guildHeadImage];

        UILabel *guildNick = [[UILabel alloc] init];
        guildNick.text = [self.guildArray objectForKey:@"name"];
        guildNick.textColor = [CorlorTransform colorWithHexString:@"ff6600"];
        guildNick.font = [UIFont systemFontOfSize:14.0];
        CGSize NickSize = [guildNick.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:guildNick.font,NSFontAttributeName, nil]];
        CGFloat nickSizeH = NickSize.height;
        CGFloat nickSizeW = NickSize.width;
        guildNick.frame = CGRectMake(guildHeadImage.frame.origin.y+guildHeadImage.frame.size.width+10,(100-nickSizeH)/3, nickSizeW, nickSizeH);
        [guildInfo addSubview:guildNick];
        
        
        /**经验条*/
        UILabel *experienceLabel = [[UILabel alloc] initWithFrame:CGRectMake(guildHeadImage.frame.origin.y+guildHeadImage.frame.size.width+10, guildNick.frame.origin.y+guildNick.frame.size.height+5, 100, 10)];
        experienceLabel.layer.cornerRadius = 5;
        experienceLabel.layer.borderColor = [UIColor blackColor].CGColor;
        experienceLabel.layer.borderWidth = 1;
        experienceLabel.clipsToBounds = YES;
        [guildInfo addSubview:experienceLabel];
        CGFloat allNeedPeople;
        CGFloat people = [self.guildArray[@"exp"] integerValue];
        int level = [self.guildArray[@"level"] intValue];
        if (level==1){
            allNeedPeople = 200;
        }else if (level==2){
            allNeedPeople = 2000;
        }else if (level==3){
            allNeedPeople = 40000;
        }else if (level==4){
            allNeedPeople = 400000;
        }else if (level==5){
            allNeedPeople = 4000000;
        }else{
            
        }

        CGFloat baifenbi = people/allNeedPeople;
        /**公会人数比例*/
        UILabel * people_allNeedPeople = [[UILabel alloc]init];
        people_allNeedPeople.text = [NSString stringWithFormat:@"%ld/%ld",(long)people,(long)allNeedPeople];
        people_allNeedPeople.textColor = [UIColor grayColor];
        people_allNeedPeople.font = [UIFont systemFontOfSize:14.0];
        CGSize size_people = [people_allNeedPeople.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:people_allNeedPeople.font,NSFontAttributeName, nil]];
        people_allNeedPeople.frame = CGRectMake(experienceLabel.frame.origin.x+experienceLabel.frame.size.width+10, experienceLabel.frame.origin.y-2, size_people.width, size_people.height);
        [guildInfo addSubview:people_allNeedPeople];
        
        /**升级按钮*/
        UIButton * levelUP = [UIButton buttonWithType:UIButtonTypeCustom];
        levelUP.frame = CGRectMake(people_allNeedPeople.frame.size.width+people_allNeedPeople.frame.origin.x+10, people_allNeedPeople.center.y-15, dtScreenWidth-(people_allNeedPeople.frame.size.width+people_allNeedPeople.frame.origin.x+10)-10, 30);
        [levelUP setTitle:@"升级" forState:UIControlStateNormal];
        levelUP.titleLabel.font = [UIFont systemFontOfSize:15.0];
        levelUP.layer.cornerRadius = 5;
        levelUP.clipsToBounds = YES;
        if (level==1) {
            if (people<200) {
                levelUP.backgroundColor = [UIColor grayColor];
            }else{
                levelUP.backgroundColor = [CorlorTransform colorWithHexString:@"0066ff"];
            }
        }else if (level == 2){
            if (people<2000) {
                levelUP.backgroundColor = [UIColor grayColor];
            }else{
                levelUP.backgroundColor = [CorlorTransform colorWithHexString:@"0066ff"];
            }
        }else if (level == 3){
            if (people<40000) {
                levelUP.backgroundColor = [UIColor grayColor];
            }else{
                levelUP.backgroundColor = [CorlorTransform colorWithHexString:@"0066ff"];
            }
        }else if (level == 4){
            if (people<400000) {
                levelUP.backgroundColor = [UIColor grayColor];
            }else{
                levelUP.backgroundColor = [CorlorTransform colorWithHexString:@"0066ff"];
            }
        }else if (level == 5){
            if (people<4000000) {
                levelUP.backgroundColor = [UIColor grayColor];
            }else{
                levelUP.backgroundColor = [CorlorTransform colorWithHexString:@"0066ff"];
            }
        }else{
            levelUP.hidden = YES;
        }
        [levelUP addTarget:self action:@selector(levelUPRequest:) forControlEvents:UIControlEventTouchUpInside];
        [guildInfo addSubview:levelUP];
        
        UILabel * colorLabel = [[UILabel alloc]initWithFrame:CGRectMake(experienceLabel.frame.origin.x+1, experienceLabel.frame.origin.y+1, (experienceLabel.frame.size.width-2)*baifenbi, experienceLabel.frame.size.height-2)];
        colorLabel.backgroundColor = [CorlorTransform colorWithHexString:@"#3399cc"];
        colorLabel.layer.cornerRadius = 4;
        colorLabel.clipsToBounds = YES;
        [guildInfo addSubview:colorLabel];
        
        UILabel *levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(guildHeadImage.frame.origin.y+guildHeadImage.frame.size.width+10, experienceLabel.frame.origin.y+experienceLabel.frame.size.height+5, 80, 10)];
        levelLabel.text = [NSString stringWithFormat:@"%d 级公会",level];
        levelLabel.font = [UIFont systemFontOfSize:14.0];
        levelLabel.textColor = [CorlorTransform colorWithHexString:@"#ffd700"];
        UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, dtScreenWidth, 1)];
        line2.backgroundColor = [UIColor grayColor];
        [guildInfo addSubview:line2];
        [guildInfo addSubview:levelLabel];
        
        UILabel *today = [[UILabel alloc] init];
        today.textColor = [UIColor blackColor];
//        NSString *earningsText = [self.guildArray objectForKey:@"todayMoney"];
        today.text = [NSString stringWithFormat:@"今日收益:%.2f",[self.guildArray[@"todayMoney"] doubleValue]];
        today.font = [UIFont systemFontOfSize:16.0];
        today.textAlignment = NSTextAlignmentCenter;
        today.frame = CGRectMake(0, 101, dtScreenWidth/2-1, 49);
        [_guildCenter addSubview:today];
        
        UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(today.frame.origin.x+today.frame.size.width, 110, 2, 30)];
        line3.backgroundColor = [UIColor blackColor];
        [guildInfo addSubview:line3];
        
        UILabel *sum = [[UILabel alloc] init];
        sum.textColor = [UIColor blackColor];
//        NSString *sumText = [self.guildArray objectForKey:@"totalMoney"];
        sum.font = [UIFont systemFontOfSize:16.0];

        _hideImageView = [[UIImageView alloc]init];

        if ([self.guildArray[@"isHide"] intValue]==0) {
            sum.text = [NSString stringWithFormat:@"总收益:%.2f",[self.guildArray[@"totalMoney"] doubleValue]];
            _hideImageView.image = [UIImage imageNamed:@"pw_visible"];

        }else{
            sum.text = @"****";
            _hideImageView.image = [UIImage imageNamed:@"pw_hide"];

        }
        sum.textAlignment = NSTextAlignmentCenter;

        sum.frame = CGRectMake(dtScreenWidth/2+2, today.frame.origin.y, dtScreenWidth/2-1, 49);
        [_guildCenter addSubview:sum];
        sum.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureLabel:)];
        [sum addGestureRecognizer:tapGesture];
        
        
        /**隐藏的眼睛*/
        CGSize size_imageFrame = [sum.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:sum.font,NSFontAttributeName, nil]];
        _hideImageView.frame = CGRectMake(sum.frame.size.width/2+size_imageFrame.width/2+10, sum.frame.size.height/2-size_imageFrame.height/2, size_imageFrame.height, size_imageFrame.height);
        [sum addSubview:_hideImageView];
    }
    return _guildCenter;
}
- (void)tapGestureLabel:(UITapGestureRecognizer *)gesture
{
    UILabel * label = (UILabel *)[gesture view];

    static int i = 0;
    i++;
    NSLog(@"%d",i);
    int counts = i%2;
    if (counts == 1) {
        label.text = @"****";
        _hideImageView.image = [UIImage imageNamed:@"pw_hide"];
        CGSize size_imageFrame = [label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName, nil]];

        _hideImageView.frame = CGRectMake(label.frame.size.width/2+size_imageFrame.width/2+10, label.frame.size.height/2-size_imageFrame.height/2, size_imageFrame.height, size_imageFrame.height);

    }else{
        label.text = [NSString stringWithFormat:@"总收益:%.2f",[self.guildArray[@"totalMoney"] doubleValue]];
        _hideImageView.image = [UIImage imageNamed:@"pw_visible"];
        CGSize size_imageFrame = [label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName, nil]];
        
        _hideImageView.frame = CGRectMake(label.frame.size.width/2+size_imageFrame.width/2+10, label.frame.size.height/2-size_imageFrame.height/2, size_imageFrame.height, size_imageFrame.height);
    }
    
    NSString * session = [PersistenceManager getLoginSession];
    [UserConnector updateUnion:session isHide:counts receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            
        }else{
            SBJsonParser * parser = [[SBJsonParser alloc]init];
            NSDictionary * json = [parser objectWithData:data];
            int status = [json[@"status"] intValue];
            if (status == 0) {
                
            }else{
                
            }
        }
    }];
}
//创建工会view
- (UIView *)createGuild{
    if (!_createGuild) {
        _createGuild = [[UIView alloc] initWithFrame:CGRectMake(0, dtNavBarDefaultHeight, dtScreenWidth, dtScreenHeight-dtNavBarDefaultHeight)];
        _createGuild.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_createGuild];
        
        UIImageView *guildHeadImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-80)/2, 30, 80, 80)];
        guildHeadImage.image = [UIImage imageNamed:@"black2"];
        guildHeadImage.layer.masksToBounds = YES;
        guildHeadImage.layer.cornerRadius = 40.0F;
        [_createGuild addSubview:guildHeadImage];
        
        UIButton *createGuildButton = [[UIButton alloc] initWithFrame:CGRectMake(20,guildHeadImage.frame.origin.y+guildHeadImage.frame.size.height+30, dtScreenWidth-40, 44)];
        [createGuildButton setTitle:@"创建公会" forState:UIControlStateNormal];
        [createGuildButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        createGuildButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        createGuildButton.layer.masksToBounds = YES;
        createGuildButton.layer.cornerRadius = 5.0;
        createGuildButton.backgroundColor = [CorlorTransform colorWithHexString:@"#3f90a4"];
        [createGuildButton addTarget:self action:@selector(didTipcreateGuild:) forControlEvents:UIControlEventTouchUpInside];

        [_createGuild addSubview:createGuildButton];
        
        UITextView *textview = [[UITextView alloc] init];
        textview.backgroundColor=[UIColor whiteColor];
        textview.scrollEnabled = YES;
        textview.editable = NO;
        textview.font = [UIFont systemFontOfSize:15.0f];
        textview.textColor = [UIColor grayColor];
        textview.text = @"1.公会会长拥有专属公会二维码。\n\n2.通过公会二维码下载APP的用户即可成为公会会员。\n\n3.公会成员接单、买单，会长均可拥有平台返现。\n\n4.创建公会需要充值200元平台余额，余额可以在平台内进行消费使用。\n\n5.若公会成员成立公会将成为公会的子公会，子公会增加可以获得公会等级提升，提升公会等级可以获得更高额度的返现以及其他奖励。";//设置显示的文本内容
        textview.frame = CGRectMake(20, createGuildButton.frame.origin.y+createGuildButton.frame.size.height+20, dtScreenWidth-40, dtScreenHeight-(createGuildButton.frame.origin.y+createGuildButton.frame.size.height+20));
        [_createGuild addSubview:textview];
    }
    [HUD hide:YES afterDelay:0.1];
    return _createGuild;
}

- (void)loadDatasource{
    NSArray *data = @[@{@"title":@"公会二维码"},
                      @{@"title":@"公会成员"},
                      @{@"title":@"公会排行榜"},
                      @{@"title":@"资金管理"}];
    self.dataSource = @[data];
}

#pragma did Tip

- (void)didTipcreateGuild:(UIButton *)sender{
    NSLog(@"创建工会");
    if (self.userInfo.canCreateUnion == 0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你没有创建公会的资格，充值两百元获得创建公会的资格是否去充值" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
            
        }];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"GO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            /**直接去支付宝充值200*/
            [self aliPayTWO];
            
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:sureAction];
        [self presentViewController:alertController animated:YES completion:nil];

    }else{
        GreatGuildViewController *greatGuild = [[GreatGuildViewController alloc] init];
        greatGuild.title = @"创建公会";
        greatGuild.delegate = self;
        [self.navigationController pushViewController:greatGuild animated:YES];
    }
}
- (void)aliPayTWO
{
    /*创建充值订单*/
    NSString *session = [PersistenceManager getLoginSession];
    [UserConnector aliRechargeSigh:session price:@200 receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [json[@"status"] intValue];
            if (status==0) {
                NSString * sign = json[@"entity"];
                [[AlipaySDK defaultService] payOrder:sign fromScheme:@"meiwan" callback:^(NSDictionary *resultDic) {
                    NSInteger  resultNum= [[resultDic objectForKey:@"resultStatus"]integerValue];
                    NSLog(@"%@",resultDic);
                    if (resultNum == 9000) {
                        [ShowMessage showMessage:@"支付成功"];
                        GreatGuildViewController *greatGuild = [[GreatGuildViewController alloc] init];
                        greatGuild.delegate = self;
                        greatGuild.title = @"创建公会";
                        [self.navigationController pushViewController:greatGuild animated:YES];
                        [self viewDidLoad];
                    }else{
                        
                        [self showMessageAlert:@"支付失败"];
                        
                    }
                }];
               
                
            }else if (status==1){
                /** status=1 没有登录 */
                [self pushLoginPage];
            }else{
                /** status=2 参数错误 */
            }
        }

    }];
}
- (void)showMessageAlert:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
    }];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**未登录跳出登陆页面*/
- (void)pushLoginPage
{
    [PersistenceManager setLoginSession:@""];
    LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    lv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:lv animated:YES];
    
}
-(void)popViewLoadView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)levelUPRequest:(UIButton *)sender
{
    NSString * session = [PersistenceManager getLoginSession];
    [UserConnector upgradeUnion:session receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            
        }else{
            
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
             NSLog(@"%@",dic);
            int status = [dic[@"status"] intValue];
            if (status==0) {
                [ShowMessage showMessage:@"升级成功"];
                [self.guildCenterTableView reloadData];
            }else{
                [ShowMessage showMessage:@"升级失败,经验点不足"];
            }

        }
    }];
}

@end
