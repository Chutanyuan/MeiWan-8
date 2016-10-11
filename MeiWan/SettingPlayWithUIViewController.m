//
//  SettingPlayWithUIViewController.m
//  MeiWan
//
//  Created by apple on 15/9/5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SettingPlayWithUIViewController.h"
#import "ShowMessage.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "LoginViewController.h"
#import "CorlorTransform.h"
#import "setting.h"
#import "CorlorTransform.h"
#import "animationCell.h"
#import "MBProgressHUD.h"

#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@interface SettingPlayWithUIViewController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
{
    NSArray * priceArray;
    /**线上点歌-叫醒服务*/
    NSArray * changePriceArray;
    /**视频聊天*/
    NSArray * VideoChatArray;
    /**线下点歌*/
    NSArray * downLineVoiceArray;
    
    NSArray * colorArray;
    NSArray * titleArray;
    UITableView * tableview;
    UITableView * priceTableview;
    animationCell * cell;
    UITableViewCell* cell1;
    NSIndexPath * indexpath;
    NSInteger indexpathother;
    NSIndexPath * cellIndexPath;
    
    NSUserDefaults * userdefaults;
    
    NSMutableArray * numberArray;
    NSMutableArray * getArray;
    NSMutableArray * usertimeTags;
    int level;
    UIView * Jiaoview;
    
    MBProgressHUD * HUD;
    
}

@property (weak, nonatomic) IBOutlet UILabel *showText;
@property (retain, nonatomic)UIView * priceView;
@property (retain, nonatomic)UIView * backGroundView;
@end

@implementation SettingPlayWithUIViewController
-(void)viewDidLoad
{
    
    [super viewDidLoad];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.labelText = @"加载中";
    
    usertimeTags = [[NSMutableArray alloc]initWithCapacity:0];
    NSString *session = [PersistenceManager getLoginSession];
    self.userInfo = [[UserInfo alloc]initWithDictionary:[PersistenceManager getLoginUser]];
    
    [UserConnector findPeiwanById:session userId:[NSNumber numberWithInteger:self.userInfo.userId]receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            NSDictionary * entity  =[json objectForKey:@"entity"];
            level = [[entity objectForKey:@"level"] intValue];
            if (level==0) {
                level = 1;
            }
            usertimeTags = [entity objectForKey:@"userTimeTags"];
            [self creatTableView];
            [HUD hide:YES afterDelay:0.1];
        }else{
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        

    } ];

    colorArray = @[@"#ff5d90",@"eb4f38",@"#ff6f36",@"#fdd32d",@"#36cdff",@"#ff3674",@"#7667e5",@"#f55d52",@"#ff5d90"];
    priceArray = @[@39,@69,@99,@129,@159,@199];
    titleArray = @[@"线上点歌",@"视屏聊天",@"聚餐",@"线下K歌",@"夜店达人",@"叫醒服务",@"影伴",@"运动健身",@"LOL"];
    /**线上点歌-叫醒服务*/
    changePriceArray = @[@5,@10,@15,@20];
    /**视频聊天*/
    VideoChatArray = @[@39,@69,@99,@129,@159,@199];
    /**线下点歌*/
    downLineVoiceArray = @[@39,@69,@99,@129,@159,@199];
    
    numberArray = [[NSMutableArray alloc]initWithCapacity:0];
    getArray  = [[NSMutableArray alloc]initWithCapacity:0];
    userdefaults  = [NSUserDefaults standardUserDefaults];
    
}

-(void)creatTableView
{
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, Width, Height-100) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.scrollEnabled = NO;
    [self.view addSubview:tableview];
    
    UIView * backGroundView = [[UIView alloc]initWithFrame:self.view.bounds];
    backGroundView.backgroundColor = [UIColor blackColor];
    backGroundView.alpha = 0.5;
    [self.view addSubview:backGroundView];
    self.backGroundView = backGroundView;
    self.backGroundView.hidden = YES;
    
    UIView * showView = [[UIView alloc]init];
    showView.center = self.view.center;
    showView.bounds = CGRectMake(0, 0, 250, 200);
    showView.backgroundColor = [UIColor whiteColor];
    showView.hidden = YES;
    [self.view addSubview:showView];
    
    
    priceTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 250, 240)];
    priceTableview.delegate = self;
    priceTableview.dataSource = self;
    priceTableview.scrollEnabled = NO;
    priceTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [showView addSubview:priceTableview];
    self.priceView = showView;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tableview){
        return titleArray.count;
    }else{
        return priceArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tableview) {
        return (Height-100)/9;
    }else{
        return 40;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray * imageArray = @[@"sing",@"video-chat",@"dining",@"sing-expert",@"go-nightclubbing",@"clock",@"shadow-with",@"sports",@"lol",@"all"];
    if (tableView == tableview) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell_index"];
        if (!cell) {
            cell = [[animationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_index"];
        }
        cell.backgroundColor = [CorlorTransform colorWithHexString:[NSString stringWithFormat:@"%@",colorArray[indexPath.row]]];
        cell.priceLabel.text = [NSString stringWithFormat:@"%@",titleArray[indexPath.row]];
        cell.showImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[indexPath.row]]];
        cell.showImage.hidden = YES;
        cell.shanchu.hidden = YES;
        cell.tag = indexPath.row;
        
        if (usertimeTags==nil) {
            
        }else{
            [usertimeTags enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (indexPath.row == [obj[@"index"] integerValue]-1) {
                    cell.showImage.hidden = NO;
                    cell.priceLabel.hidden = YES;
                    cell.shanchu.hidden = NO;
                    cell.tianjia.hidden = YES;
                    cell.priceLabel.text = [NSString stringWithFormat:@"%@",titleArray[[obj[@"index"] integerValue]-1]];
                }else{
                    
                }
            }];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        
        cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell1) {
            cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        if (level<indexPath.row+1) {
            cell1.textLabel.text = [NSString stringWithFormat:@"%@ 元／时 等级不足",priceArray[indexPath.row]];
            cell1.userInteractionEnabled = NO;
        }else{
            cell1.textLabel.text = [NSString stringWithFormat:@"%@ 元／时",priceArray[indexPath.row]];
        }
        cell1.textLabel.textAlignment = NSTextAlignmentCenter;

        cell1.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
        return cell1;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *userInfo = [PersistenceManager getLoginUser];
    NSString *thesame = [NSString stringWithFormat:@"%ld",[[userInfo objectForKey:@"id"]longValue]];
    if ([thesame isEqualToString:@"100000"] || [thesame isEqualToString:@"100001"]) {
        cell = [tableview cellForRowAtIndexPath:indexPath];
        indexpath = indexPath;

        if (tableview == tableView) {
            cell = [tableview cellForRowAtIndexPath:indexPath];
            static int i = 0 ;i++;
            if (i%2==1) {
                
                [self animationView:cell index:indexPath];
               
            }else{
            
                [self animationView:cell index:indexPath];
                
            }
        }
        
    }else{
        if (tableView==tableview) {
            cell = [tableview cellForRowAtIndexPath:indexPath];
            indexpath = indexPath;
            
            if (indexPath.row==5||indexPath.row==0||indexPath.row==1||indexPath.row==3) {
                
                if (cell.shanchu.hidden==NO) {
                    self.backGroundView.hidden = YES;
                    [self animationView:cell index:indexPath];
                    [usertimeTags removeLastObject];
                }else{
                    
                    self.backGroundView.hidden = NO;
                    
                    if (usertimeTags.count>=3) {
                    
                    }else{
                        [usertimeTags addObject:[NSString stringWithFormat:@"%ld",indexPath.row+1]];
                        Jiaoview = [[UIView alloc]initWithFrame:self.priceView.frame];
                        Jiaoview.backgroundColor = [UIColor blackColor];
                        [self.view addSubview:Jiaoview];
                       
                        switch (indexPath.row) {
                            case 0:
                            {
                                /**线上点歌*/
                                priceArray = changePriceArray;
                                for (int i = 0; i<priceArray.count; i++) {
                                    UIButton * jiaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                    jiaoButton.frame = CGRectMake(0, i*(Jiaoview.frame.size.height/priceArray.count), Jiaoview.frame.size.width, Jiaoview.frame.size.height/priceArray.count);
                                    if (i+1>level) {
                                        [jiaoButton setTitle:[NSString stringWithFormat:@"%@元／次 等级不足",priceArray[i]] forState:UIControlStateNormal];

                                    }else{
                                        [jiaoButton setTitle:[NSString stringWithFormat:@"%@元／次",priceArray[i]] forState:UIControlStateNormal];
    
                                    }
                                    
                                    jiaoButton.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
                                    jiaoButton.tag = i;
                                    [jiaoButton addTarget:self action:@selector(jiaoChuangButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                    [Jiaoview addSubview:jiaoButton];
                                }

                            }
                                break;
                              
                            case 1:
                            {
                                /**视频聊天*/
                                priceArray = VideoChatArray;
                                for (int i = 0; i<VideoChatArray.count; i++) {
                                    UIButton * jiaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                    jiaoButton.frame = CGRectMake(0, i*(Jiaoview.frame.size.height/priceArray.count), Jiaoview.frame.size.width, Jiaoview.frame.size.height/priceArray.count);
                                    if (i+1>level) {
                                        [jiaoButton setTitle:[NSString stringWithFormat:@"%@元／时 等级不足",priceArray[i]] forState:UIControlStateNormal];
                                        
                                    }else{
                                        [jiaoButton setTitle:[NSString stringWithFormat:@"%@元／时",priceArray[i]] forState:UIControlStateNormal];
                                        
                                    }
                                    jiaoButton.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
                                    jiaoButton.tag = i;
                                    [jiaoButton addTarget:self action:@selector(jiaoChuangButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                    [Jiaoview addSubview:jiaoButton];
                                }

                            }
                                break;
                               
                            case 5:
                            {
                                /**叫醒服务*/
                                priceArray = changePriceArray;
                                for (int i = 0; i<4; i++) {
                                    UIButton * jiaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                    jiaoButton.frame = CGRectMake(0, i*(Jiaoview.frame.size.height/4), Jiaoview.frame.size.width, Jiaoview.frame.size.height/4);
                                    if (i+1>level) {
                                        [jiaoButton setTitle:[NSString stringWithFormat:@"%@元／次 等级不足",priceArray[i]] forState:UIControlStateNormal];
                                        
                                    }else{
                                        [jiaoButton setTitle:[NSString stringWithFormat:@"%@元／次",priceArray[i]] forState:UIControlStateNormal];
                                        
                                    }
                                    jiaoButton.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
                                    jiaoButton.tag = i;
                                    [jiaoButton addTarget:self action:@selector(jiaoChuangButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                    [Jiaoview addSubview:jiaoButton];
                                }

                            }
                                break;
                                
                            case 3:
                            {
                                /**线下K歌*/
                                priceArray = downLineVoiceArray;
                                for (int i = 0; i<downLineVoiceArray.count; i++) {
                                    UIButton * jiaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                    jiaoButton.frame = CGRectMake(0, i*(Jiaoview.frame.size.height/priceArray.count), Jiaoview.frame.size.width, Jiaoview.frame.size.height/priceArray.count);
                                    if (i+1>level) {
                                        [jiaoButton setTitle:[NSString stringWithFormat:@"%@元／时 等级不足",priceArray[i]] forState:UIControlStateNormal];
                                        
                                    }else{
                                        [jiaoButton setTitle:[NSString stringWithFormat:@"%@元／时",priceArray[i]] forState:UIControlStateNormal];
                                        
                                    }
                                    jiaoButton.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
                                    jiaoButton.tag = i;
                                    [jiaoButton addTarget:self action:@selector(jiaoChuangButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                                    [Jiaoview addSubview:jiaoButton];
                                }

                            }
                                break;
                            default:
                                break;
                        }
                    }
                }

            }else{
                if (cell.shanchu.hidden==NO) {
                    [self animationView:cell index:indexPath];
                    [usertimeTags removeLastObject];
                }else{
                    if (usertimeTags.count>=3) {
                    }else{
                        [usertimeTags addObject:[NSString stringWithFormat:@"%ld",indexPath.row+1]];
                        self.priceView.hidden = NO;
                        self.backGroundView.hidden = NO;
                    }
                }
            }
        
        }else{

            self.priceView.hidden = YES;
            self.backGroundView.hidden = YES;
            indexpathother = indexPath.row;
            [self animationView:cell index:indexpath];
        }
        
    }
    
}
- (void)jiaoChuangButtonClick:(UIButton *)sender
{
    
    switch (indexpath.row) {
        case 0:
        {
            if (sender.tag+1>level) {
                [self showMessageAlert:@"级别不够"];
            }else{
                Jiaoview.hidden = YES;
                self.backGroundView.hidden = YES;

                NSUserDefaults * jiaoPrice = [NSUserDefaults standardUserDefaults];
                [jiaoPrice setObject:[NSNumber numberWithInteger:sender.tag] forKey:@"senderID"];
                [jiaoPrice synchronize];
                
                CGContextRef context=UIGraphicsGetCurrentContext();
                [UIView beginAnimations:nil context:context];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:0.3];
                [UIView setAnimationRepeatCount:1];
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:cell cache:YES];
                [UIView commitAnimations];
                [self animationStop1:sender.tag];
            }
        }
            break;
        case 1:
        {
            if (sender.tag+1>level) {
                [self showMessageAlert:@"级别不够"];
            }else{
                Jiaoview.hidden = YES;
                self.backGroundView.hidden = YES;

                NSUserDefaults * jiaoPrice = [NSUserDefaults standardUserDefaults];
                [jiaoPrice setObject:[NSNumber numberWithInteger:sender.tag] forKey:@"senderID"];
                [jiaoPrice synchronize];
                
                CGContextRef context=UIGraphicsGetCurrentContext();
                [UIView beginAnimations:nil context:context];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:0.3];
                [UIView setAnimationRepeatCount:1];
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:cell cache:YES];
                [UIView commitAnimations];
                [self animationStop1:sender.tag];
            }

        }
            break;
        case 3:
        {
            if (sender.tag+1>level) {
                [self showMessageAlert:@"级别不够"];
            }else{
                Jiaoview.hidden = YES;
                self.backGroundView.hidden = YES;

                NSUserDefaults * jiaoPrice = [NSUserDefaults standardUserDefaults];
                [jiaoPrice setObject:[NSNumber numberWithInteger:sender.tag] forKey:@"senderID"];
                [jiaoPrice synchronize];
                
                CGContextRef context=UIGraphicsGetCurrentContext();
                [UIView beginAnimations:nil context:context];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:0.3];
                [UIView setAnimationRepeatCount:1];
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:cell cache:YES];
                [UIView commitAnimations];
                [self animationStop1:sender.tag];
            }

        }
            break;
        case 5:
        {
            if (sender.tag+1>level) {
                [self showMessageAlert:@"级别不够"];
            }else{
                Jiaoview.hidden = YES;
                self.backGroundView.hidden = YES;

                NSUserDefaults * jiaoPrice = [NSUserDefaults standardUserDefaults];
                [jiaoPrice setObject:[NSNumber numberWithInteger:sender.tag] forKey:@"senderID"];
                [jiaoPrice synchronize];
                
                CGContextRef context=UIGraphicsGetCurrentContext();
                [UIView beginAnimations:nil context:context];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:0.3];
                [UIView setAnimationRepeatCount:1];
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:cell cache:YES];
                [UIView commitAnimations];
                [self animationStop1:sender.tag];
            }

        }
            break;
            
        default:
            break;
    }
   
}

- (void)animationView:(UIView *)animationview index:(NSIndexPath *)indexpaths
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:animationview cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationStop)];
    [UIView commitAnimations];
    indexpath = indexpaths;
}
- (void)animationView:(UIView *)ani
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:ani cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationStop)];
    [UIView commitAnimations];
}

- (void)animationStop
{
    cell = [tableview cellForRowAtIndexPath:indexpath];
    if (cell.shanchu.hidden == NO) {
        cell.shanchu.hidden = YES;
        cell.tianjia.hidden = NO;
        cell.showImage.hidden = YES;
        cell.priceLabel.hidden = NO;
        [self deleteNetWorking:indexpath.row+1 price:nil];
    }else{
        cell.shanchu.hidden = NO;
        cell.tianjia.hidden = YES;
        cell.showImage.hidden = NO;
        cell.priceLabel.hidden = YES;
        NSInteger intege = [priceArray[indexpathother] integerValue];
        [self registerNetWorking:indexpath.row+1 price:[NSNumber numberWithInteger:intege]];

    }
}
- (void)animationStop1:(NSInteger)senderID
{
    cell = [tableview cellForRowAtIndexPath:indexpath];
    if (cell.shanchu.hidden == NO) {
        cell.shanchu.hidden = YES;
        cell.tianjia.hidden = NO;
        cell.showImage.hidden = YES;
        cell.priceLabel.hidden = NO;
        [self deleteNetWorking:indexpath.row+1 price:nil];
    }else{
        cell.shanchu.hidden = NO;
        cell.tianjia.hidden = YES;
        cell.showImage.hidden = NO;
        cell.priceLabel.hidden = YES;
        [self registerNetWorking:indexpath.row+1 price:priceArray[senderID]];
    }
}

- (void)registerNetWorking:(NSInteger)integer price:(NSNumber *)price
{
    
    NSDictionary *userInfo = [PersistenceManager getLoginUser];
    NSString *thesame = [NSString stringWithFormat:@"%ld",[[userInfo objectForKey:@"id"]longValue]];
    if ([thesame isEqualToString:@"100000"] || [thesame isEqualToString:@"100001"]) {
        NSString * session = [PersistenceManager getLoginSession];
        NSNumber * number = [NSNumber numberWithInteger:integer];

        
        [UserConnector addUserTimeTag:session tagIndex:number price:price receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
          
            if (error) {
                [ShowMessage showMessage:@"添加失败"];
            }else{
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];
               
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    [ShowMessage showMessage:@"添加成功"];
                }else{
                    
                }
            }
        }];
        
    }else{
        
        NSString *session = [PersistenceManager getLoginSession];
        NSNumber * number = [NSNumber numberWithInteger:integer];
        
        [UserConnector addUserTimeTag:session tagIndex:number price:price receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@",error);
                [ShowMessage showMessage:@"添加失败"];
            }else{
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    [ShowMessage showMessage:@"添加成功"];
                }else{
                    
                }
            }
        }];
        
    }
}
- (void)deleteNetWorking:(NSInteger)integer price:(NSString *)price
{
    NSString *session = [PersistenceManager getLoginSession];
    NSNumber * number = [NSNumber numberWithInteger:integer];
    [UserConnector deleteUserTimeTag:session tagIndex:number price:nil receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            [ShowMessage showMessage:@"删除失败"];

        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                [ShowMessage showMessage:@"删除成功"];
            }else{
                
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

@end
