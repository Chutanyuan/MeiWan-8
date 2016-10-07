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
#import "UserInfo.h"
#import "playerInfoTableViewCell.h"
#import "TimeLabelTableViewCell.h"
#import "UserDynamicTableViewCell.h"
#import "FootprintTableViewCell.h"
#import "CommentTableViewCell.h"
#import "LoginViewController.h"

#import "StateTableViewController.h"
#import "PeiwanHeadViewController.h"
#import "InviteViewController.h"
#import "AssesserInfoViewController.h"
#import "ExploitsTableViewController.h"
#import "NetBarViewController.h"
#import "ChatViewController.h"
#import "ShowMessage.h"
#import "SBJson.h"
//#import "EaseMessageReadManager.h"
#import "ImageViewController.h"
#import "dycussImageShow.h"
#import "showImageController.h"
#import "PreviewImageView.h"

@interface PlagerinfoViewController ()<UITableViewDataSource,UITableViewDelegate,UserDynamicDelegate,PhotosTouchImageDelegate>

@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) NSDictionary *userInfoDic;
@property (nonatomic, strong)UITableView *playerTableView;
@property (nonatomic, strong)UIView *editView;
@property (nonatomic, strong)UIButton *reportBtn;
@property (nonatomic, strong)UIButton *addFriend;
@property (nonatomic, strong)UIButton *blacklist;
@property (nonatomic, strong)UIView *buttonView;
@property (nonatomic, strong)UIView *orderButtonView;
@property (strong, nonatomic) UIView *moreVi;
@property (strong, nonatomic) UIView *btn;
@property (strong, nonatomic) UIView *tip;
@property (strong, nonatomic) UIView *tipclear;
@property (nonatomic, strong) NSDictionary *stateDatas;
@property (nonatomic, strong) UserDynamicTableViewCell *dynamicCell;
@property (nonatomic, strong) NSArray *arr1;
@property (nonatomic, strong) NSMutableArray * MyfriendArray;
@property (nonatomic,strong)NSMutableArray * myEvaluateArray;
@property (nonatomic,strong)NSMutableArray * userTimetagArray;
@property (nonatomic,strong)NSMutableArray * userPhotosArray;
@property (nonatomic,assign)int page;
@property (nonatomic,assign)NSString * headerImageUrl;

@end

@implementation PlagerinfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"用户信息:%@",self.playerInfo);
    
    self.page = 0;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(more)];
    
    self.title = [self.playerInfo objectForKey:@"nickname"];
    
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
                self.userTimetagArray = self.playerInfo[@"userTimeTags"];
                self.userPhotosArray = self.playerInfo[@"userPhotos"];
            }else if (status == 1){
                
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
                    self.dynamicCell.dynamicDatas = state;
                    
                }else{
                    self.dynamicCell.dynamicDatas = [NSDictionary dictionary];
                }
            }else if (status == 1){
            }else{
                
            }
        }
    }];
    
    [UserConnector findShopsByUser:[NSNumber numberWithDouble:[self.playerInfo[@"id"] doubleValue]] offset:0 limit:@3 receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status==0) {
                NSLog(@"json= %@",json);
            }else if (status==1){
                
            }else{
                
            }
        }
    }];
    /***/
    [self pinglunAFNetworking:self.page];
    self.playerTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.playerTableView.mj_header beginRefreshing];
        [self headerRereshing];
    }];
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    self.playerTableView.mj_footer = footer;
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.hidden = YES;
    
    [UserConnector findMyFriends:session receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [json[@"status"] intValue];
            if (status == 0) {
                
                self.MyfriendArray = json[@"entity"];
                
                NSDictionary *userInfo = [PersistenceManager getLoginUser];
                NSString *thesame = [NSString stringWithFormat:@"%ld",[[userInfo objectForKey:@"id"]longValue]];
                if ([thesame isEqualToString:@"100000"] || [thesame isEqualToString:@"100001"])
                {
                    [self orderButtonView];
                }else{
                    [self buttonView];
                }
                
            }else{}
            
        }
    }];
    
    
    [self playerTableView];
    [self headerRereshing];
    
}
/** 下拉刷新 */
- (void)headerRereshing
{
    self.page = 0;
    [self pinglunAFNetworking:self.page];
}
/** 上拉加载 */
- (void)footerRereshing
{
    self.page+=6;
    [self pinglunAFNetworking:self.page];
}
#pragma mark 返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==4) {
        if (self.myEvaluateArray.count==0) {
            return 1;
        }else{
            return self.myEvaluateArray.count;
        }
    }else{
        return 1;
    }
}
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;//section头部高度
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 66;
    }else if (indexPath.section == 1){
        if (self.userTimetagArray.count>0) {
            return 85;
        }else{
            return 0;
        }
    }else if (indexPath.section == 2){
        if (IS_IPHONE_6P) {
            return 180;
        }else if (IS_IPHONE_5){
            return 150;
        }else{
            return 155;
        }
    }else if (indexPath.section == 3){
        
        if (self.userPhotosArray.count>0) {
            return 160;
        }else{
            return 0;
        }
    }else if (indexPath.section == 4){
        return 80;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        playerInfoTableViewCell * infoCell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
        if (!infoCell) {
            infoCell = [[playerInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoCell"];
            infoCell.playerInfo = self.playerInfo;
            //            self.headerImageUrl = self.playerInfo[@"headUrl"];
        }
        infoCell.playerHeadImage.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [infoCell.playerHeadImage addGestureRecognizer:tapgesture];
        return infoCell;
    }else if (indexPath.section == 1){
        TimeLabelTableViewCell * timeCell = [tableView dequeueReusableCellWithIdentifier:@"timeCell"];
        if (!timeCell) {
            timeCell = [[TimeLabelTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timeCell"];
        }
        
        if (self.userTimetagArray.count>0) {
            timeCell.playerInfo = self.playerInfo;
            return timeCell;
        }else{
            timeCell.hidden = YES;
            return timeCell;
        }
        
    }else if (indexPath.section == 2){
        _dynamicCell = [tableView dequeueReusableCellWithIdentifier:@"dynamicCell"];
        if (!_dynamicCell) {
            _dynamicCell = [[UserDynamicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dynamicCell"];
        }
        _dynamicCell.delegate = self;
        return _dynamicCell;
    }else if (indexPath.section == 3){
        FootprintTableViewCell *FootprintCell = [tableView dequeueReusableCellWithIdentifier:@"FootprintCell"];
        if (!FootprintCell) {
            FootprintCell = [[FootprintTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FootprintCell"];
        }
        if (self.userPhotosArray.count>0) {
            FootprintCell.photos = self.playerInfo;
        }else{
            FootprintCell.hidden = YES;
        }
        FootprintCell.delegate = self;
        return FootprintCell;
    }else{
        CommentTableViewCell * Commentcell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
        if (!Commentcell) {
            Commentcell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commentCell"];
        }
        if (self.myEvaluateArray.count>0) {
            Commentcell.evaluateDictionary = self.myEvaluateArray[indexPath.row];
            Commentcell.commentLabel.hidden = YES;
            if (indexPath.row>0) {
                Commentcell.titleImage.hidden = YES;
                Commentcell.commentTitleLabel.hidden = YES;
            }
        }else{
            
            Commentcell.commentLabel.hidden = NO;
            
        }
        
        return Commentcell;
    }
}
//点击展览秀查看图片
-(void)PhotosTouchImage:(UITapGestureRecognizer *)gesture images:(NSArray *)imagesArray
{
    showImageController * showImage = [[showImageController alloc]init];
    showImage.imagesArray = imagesArray;
    showImage.imageNumber = [gesture view].tag-1;
    showImage.title = @"展览秀";
    [self.navigationController pushViewController:showImage animated:YES];
}
/**点击动态图片跳转*/
-(void)showPicture:(UITapGestureRecognizer *)gesture imageArray:(NSMutableArray *)array
{
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqual:[NSNull null]]) {
            [array removeObject:obj];
        }else{
            
        }
    }];
    
    dycussImageShow * showImage = [[dycussImageShow alloc]init];
    showImage.imagesArray = array;
    showImage.imageNumber = [gesture view].tag;
    showImage.title = @"展览秀";
    [self.navigationController pushViewController:showImage animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NSLog(@"资料");
    }else if (indexPath.row == 1){
        NSLog(@"标签");
    } else if (indexPath.section == 2){
        [self showState];
        NSLog(@"动态");
    }else if (indexPath.section == 3){
        NSLog(@"足迹");
    }else if (indexPath.section == 4){
        
        NSDictionary * CommentPerson = self.myEvaluateArray[indexPath.row];
        /** 跳转评价用户详情页 */
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PlagerinfoViewController *playerInfoCtr = [mainStoryboard instantiateViewControllerWithIdentifier:@"secondStory"];
        playerInfoCtr.playerInfo= CommentPerson[@"user"];
        [self.navigationController pushViewController:playerInfoCtr animated:YES];
    }
}

- (UITableView *)playerTableView{
    if (!_playerTableView) {
        _playerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-120) style:UITableViewStylePlain];
        _playerTableView.delegate = self;
        _playerTableView.dataSource = self;
        _playerTableView.backgroundColor = [UIColor whiteColor];
        _playerTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.view addSubview:_playerTableView];
    }
    return _playerTableView;
}

- (UIView *)buttonView{
    if (!_buttonView) {
        _buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60)];
        _buttonView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_buttonView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
        lineView.backgroundColor = [UIColor blackColor];
        lineView.alpha = 0.1;
        [_buttonView addSubview:lineView];
        
        UIButton *invitButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 90, 30)];
        [invitButton setTitle:@"约Ta" forState:UIControlStateNormal];
        [invitButton setTintColor:[UIColor whiteColor]];
        invitButton.backgroundColor = [CorlorTransform colorWithHexString:@"#db2442"];
        invitButton.layer.masksToBounds = YES;
        invitButton.layer.cornerRadius = 6.0f;
        [invitButton addTarget:self action:@selector(didTapInivtButton:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonView addSubview:invitButton];
        
        UIButton *focusButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-90)/2, 20, 90, 30)];
        [focusButton setTitle:@"关注" forState:UIControlStateNormal];
        focusButton.backgroundColor = [CorlorTransform colorWithHexString:@"#FF69B4"];
        if (self.playerInfo != nil) {
            
            
            [self.MyfriendArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj isEqualToDictionary:self.playerInfo]) {
                    [focusButton setTitle:@"取消关注" forState:UIControlStateNormal];
                    focusButton.backgroundColor = [CorlorTransform colorWithHexString:@"3366cc"];
                }
            }];
            
        }
        [focusButton setTintColor:[UIColor whiteColor]];
        focusButton.layer.masksToBounds = YES;
        focusButton.layer.cornerRadius = 6.0f;
        [focusButton addTarget:self action:@selector(didTipfocusButton:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonView addSubview:focusButton];
        
        UIButton *chatButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-100, 20, 90, 30)];
        [chatButton setTitle:@"找Ta聊天" forState:UIControlStateNormal];
        [chatButton setTintColor:[UIColor whiteColor]];
        chatButton.backgroundColor = [CorlorTransform colorWithHexString:@"#00537d"];
        chatButton.layer.masksToBounds = YES;
        chatButton.layer.cornerRadius = 6.0f;
        [chatButton addTarget:self action:@selector(didTipChatButton:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonView addSubview:chatButton];
    }
    return _buttonView;
}

- (UIView *)orderButtonView{
    if (!_orderButtonView) {
        _orderButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60)];
        _orderButtonView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_orderButtonView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
        lineView.backgroundColor = [UIColor blackColor];
        lineView.alpha = 0.1;
        [_orderButtonView addSubview:lineView];
        
        UIButton *chatButton = [[UIButton alloc] initWithFrame:CGRectMake(36, 20, 90, 30)];
        [chatButton setTitle:@"找Ta聊天" forState:UIControlStateNormal];
        [chatButton setTintColor:[UIColor whiteColor]];
        chatButton.backgroundColor = [CorlorTransform colorWithHexString:@"#00537d"];
        chatButton.layer.masksToBounds = YES;
        chatButton.layer.cornerRadius = 6.0f;
        [chatButton addTarget:self action:@selector(didTipChatButton:) forControlEvents:UIControlEventTouchUpInside];
        [_orderButtonView addSubview:chatButton];
        
        UIButton *focusButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-36-90, 20, 90, 30)];
        [focusButton setTitle:@"关注" forState:UIControlStateNormal];
        [focusButton setTintColor:[UIColor whiteColor]];
        focusButton.backgroundColor = [CorlorTransform colorWithHexString:@"#FF69B4"];
        focusButton.layer.masksToBounds = YES;
        focusButton.layer.cornerRadius = 6.0f;
        [focusButton addTarget:self action:@selector(didTipfocusButton:) forControlEvents:UIControlEventTouchUpInside];
        [_orderButtonView addSubview:focusButton];
        
    }
    return _orderButtonView;
}

#pragma did Tip segu传参跳转判断
-(void)showInvite{
    [self performSegueWithIdentifier:@"invite" sender:self.playerInfo];
}
-(void)showState{
    [self performSegueWithIdentifier:@"peiwanstate" sender:self.playerInfo];
}
- (void)showpicture{
    [self performSegueWithIdentifier:@"picture" sender:self.playerInfo];
}

- (void)didTapInivtButton:(UIButton *)sender{
    [ self performSegueWithIdentifier:@"invite" sender:self.playerInfo];
}

- (void)didTipChatButton:(UIButton *)sender{
    [self setUpLoaduserInfo];
    
    NSString *product = [NSString stringWithFormat:@"%@%ld",
                         [setting getRongLianYun],[[self.playerInfo objectForKey:@"id"]longValue]];
    
    ChatViewController *messageCtr = [[ChatViewController alloc] initWithConversationChatter:product conversationType:EMConversationTypeChat];
    messageCtr.title = [NSString stringWithFormat:@"%@",
                        [self.playerInfo objectForKey:@"nickname"]];
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
/**关注按钮*/
- (void)didTipfocusButton:(UIButton *)sender{
    
    NSString *sesstion = [PersistenceManager getLoginSession];
    
    if ([sender.titleLabel.text isEqualToString:@"取消关注"]) {
        NSLog(@"删除好友");
        
        
        [UserConnector deleteFriend:sesstion friendId:[self.playerInfo objectForKey:@"id"] receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];
                //NSLog(@"%@",json);
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    [ShowMessage showMessage:@"取消关注成功"];
                    [sender setTitle:@"关注" forState:UIControlStateNormal];
                    [sender setBackgroundColor:[CorlorTransform colorWithHexString:@"#FF69B4"]];
                }else if (status == 1){
                    [self jumpout];
                }else{
                    
                }
            }
        }];
    }else{
        NSLog(@"添加好友");
        [UserConnector addFriend:sesstion friendId:[self.playerInfo objectForKey:@"id"] receiver:^(NSData *data,NSError *error){
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];
                //NSLog(@"%@",json);
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    [ShowMessage showMessage:@"关注成功"];
                    [sender setTitle:@"取消关注" forState:UIControlStateNormal];
                    [sender setBackgroundColor:[CorlorTransform colorWithHexString:@"3366cc"]];
                }else if (status == 1){
                    [self jumpout];
                }else{
                    
                }
            }
        }];
        
    }
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"userAssess"]) {
        AssesserInfoViewController *av = segue.destinationViewController;
        av.playerInfo = sender;
    }
    if ([segue.identifier isEqualToString:@"netBar"]) {
        NetBarViewController *nv = segue.destinationViewController;
        nv.barInfo = sender;
    }
    if ([segue.identifier isEqualToString:@"exploits"]) {
        ExploitsTableViewController *ev = segue.destinationViewController;
        ev.hidesBottomBarWhenPushed = YES;
        ev.exploitsInfo = sender;
    }
    if ([segue.identifier isEqualToString:@"invite"]) {
        InviteViewController *iv = segue.destinationViewController;
        iv.playerInfo = sender;
    }
    if ([segue.identifier isEqualToString:@"peiwanstate"]) {
        StateTableViewController *mv = segue.destinationViewController;
        mv.hidesBottomBarWhenPushed = YES;
        mv.myUserInfo = sender;
    }
    if ([segue.identifier isEqualToString:@"picture"]) {
        PeiwanHeadViewController *cv = segue.destinationViewController;
        cv.hidesBottomBarWhenPushed = YES;
        cv.peiwanInfoDic = sender;
    }
}

//重加载网络请求
- (void)setUpLoaduserInfo{
    self.userInfo = [[UserInfo alloc]initWithDictionary: [PersistenceManager getLoginUser]];
}

//举报和加为好友；
-(void)more{
    self.moreVi = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-60, 55, 60, 61)];
    self.moreVi.backgroundColor = [UIColor whiteColor];
    self.moreVi.layer.cornerRadius = 5;
    self.moreVi.layer.masksToBounds = YES;
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    lab1.text = @"举报";
    lab1.font = [UIFont systemFontOfSize:12.0f];
    lab1.textColor = [UIColor whiteColor];
    lab1.userInteractionEnabled = YES;
    lab1.textAlignment = NSTextAlignmentCenter;;
    lab1.backgroundColor = [CorlorTransform colorWithHexString:@"#3f90a4"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taplab1)];
    tap.numberOfTapsRequired = 1;
    [lab1 addGestureRecognizer:tap];
    [self.moreVi addSubview:lab1];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 31, 60, 30)];
    label2.text = @"拉黑";
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:12.0f];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.userInteractionEnabled = YES;
    label2.backgroundColor = [CorlorTransform colorWithHexString:@"#3f90a4"];
    UITapGestureRecognizer *touch1= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addBlackTableView)];
    [label2 addGestureRecognizer:touch1];
    
    [self.moreVi addSubview:label2];
    
    UITapGestureRecognizer *remove = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(remove)];
    //[self.view addGestureRecognizer:remove];
    self.btn = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.btn addGestureRecognizer:remove];
    self.btn.backgroundColor = [UIColor clearColor];
    [[ShowMessage mainWindow]addSubview:self.btn];
    [[ShowMessage mainWindow] addSubview:self.moreVi];
}

//加入黑名单
-(void)addBlackTableView
{
    [self remove];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
    }];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        
        EMError *error = [[EMClient sharedClient].contactManager addUserToBlackList:[NSString stringWithFormat:@"product_%@",self.playerInfo[@"id"]] relationshipBoth:YES];
        if (!error) {
            NSLog(@"发送成功");
        }
    }];
    alertController.message = @"确定拉黑？拉黑之后可以在聊天界面黑名单中设置";
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
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

//取消举报和加为好友；
-(void)remove{
    [self.btn removeFromSuperview];
    [self.moreVi removeFromSuperview];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self remove];
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

/**点击头像展示图片*/
- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
    UIImageView * imageview = (UIImageView *)[gesture view];
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    CGRect startRect = [imageview convertRect:imageview.bounds toView:windows];
    [PreviewImageView showPreviewImage:imageview.image startImageFrame:startRect inView:windows viewFrame:self.view.bounds];
    
    NSString * imageUrl = [NSString stringWithFormat:@"%@",imageview.sd_imageURL];
    
    self.headerImageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"!1" withString:@""];
    NSLog(@"%@",self.headerImageUrl);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"image_url" object:self.headerImageUrl];
}
- (void)pinglunAFNetworking:(int)page
{
    NSNumber * pageNumber = [NSNumber numberWithInt:page];
    [UserConnector findOrderEvaluationByUserId:[NSNumber numberWithFloat:[self.playerInfo[@"id"] floatValue]] offset:pageNumber limit:@6 receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSDictionary *json=[parser objectWithData:data];
            int status = [json[@"status"] intValue];
            if (status==0) {
                if (page==0) {
                    [self.myEvaluateArray removeAllObjects];
                    self.myEvaluateArray = json[@"entity"];
                }else{
                    NSArray * array = json[@"entity"];
                    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [self.myEvaluateArray addObject:obj];
                    }];
                }
                [self.playerTableView.mj_header endRefreshing];
                [self.playerTableView.mj_footer endRefreshing];
                [self.playerTableView reloadData];
                
            }
        }
    }];
    
}
@end
