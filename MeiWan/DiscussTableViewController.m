//
//  DiscussTableViewController.m
//  MeiWan
//
//  Created by apple on 15/11/12.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "DiscussTableViewController.h"
#import "DiscussCell.h"
#import "DiscussView.h"
#import "MoveAction.h"
#import "MoveActionFrame.h"
#import "ShowMessage.h"
#import "ImageViewController.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "PlagerinfoViewController.h"
#import "ButtonLable.h"
#import "LoginViewController.h"
#import "EMMessage.h"

@interface DiscussTableViewController ()<UITextFieldDelegate,DiscussViewDelegate,DiscussCellDelegate>
@property (nonatomic,strong) NSArray *tableData;
@property (nonatomic,strong) UITableViewCell *prototypeCell;
@property (nonatomic,strong) UIView * contentView;
@property (nonatomic,strong) UITextField *inputField;
@property (nonatomic,strong) UITapGestureRecognizer *tap;
@property (nonatomic,strong) NSDictionary * LZDictionary;
//@property (nonatomic,strong) DiscussView * discussView;
@end

@implementation DiscussTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:@"DiscussCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"discusscell"];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 43, [UIScreen mainScreen].bounds.size.width, 43)];
    footView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = footView;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    DiscussView * discussView = [[DiscussView alloc]init];
    discussView.delegate = self;
    discussView.moveActionFrame = self.maf;
    discussView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = discussView;
    [self reloadTableViewData:UITableViewScrollPositionNone];
}
#pragma  mark - 刷新评论数据
- (void)reloadTableViewData:(UITableViewScrollPosition)position{
    NSString *session = [PersistenceManager getLoginSession];
    [UserConnector findStateComment:session stateId:[NSNumber numberWithLong:self.maf.moveActionModel.stateId]receiver:^(NSData * data, NSError * error) {
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableDictionary *json = [parser objectWithData:data];
            //NSLog(@"%@",json);
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                NSMutableArray * states = [NSMutableArray array];
                NSArray * statesFromJson = [json objectForKey:@"entity"];
                for (NSDictionary *dic in statesFromJson) {
                    [states addObject:dic];
                    NSArray * subStates = [dic objectForKey:@"stateReplies"];
                    if (subStates.count > 0) {
                        for (NSDictionary *dic in subStates) {
                            [states addObject:dic];
                        }
                    }
                }
                self.tableData = [NSArray arrayWithArray:states];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.tableData.count - 1 inSection:0] atScrollPosition:position animated:YES];
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self createToolBarView];
}
#pragma mark - discuss inputView
-(void)createToolBarView{
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 43, [UIScreen mainScreen].bounds.size.width, 43)];
    self.contentView.backgroundColor = [UIColor lightGrayColor];
    UITextField * inputTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 5, self.contentView.bounds.size.width - 40, 30)];
    inputTextField.borderStyle = UITextBorderStyleRoundedRect;
    inputTextField.font = [UIFont systemFontOfSize:14];
    inputTextField.delegate = self;
    inputTextField.returnKeyType = UIReturnKeySend;
    inputTextField.placeholder = @"发布评论";
    [self.contentView addSubview:inputTextField];
    self.inputField = inputTextField;
    if (self.isFromDiscuss) {
        [self.inputField becomeFirstResponder];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[ShowMessage mainWindow] addSubview:self.contentView];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.contentView removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - discussCell delegate
- (void)tapHeadImg:(NSDictionary *)discussDic{
    NSDictionary * infoDic = [discussDic objectForKey:@"fromUser"];
    [self performSegueWithIdentifier:@"personInfo" sender:infoDic];
}
#pragma mark - DiscussViewDelegate
- (void)tapHeadImage:(MoveActionFrame *)moveActionframe{
    NSDictionary *personInfoDic = moveActionframe.moveActionModel.userInfo;
    [self performSegueWithIdentifier:@"personInfo" sender:personInfoDic];

}
- (void)tapImage:(NSInteger)imageTag AndMoveActionFrame:(MoveActionFrame *)moveActionFrame
{
    ImageViewController *iv = [[ImageViewController alloc]init];
    iv.moveActionframe = moveActionFrame;
    iv.imageCount = (int)imageTag/111;
    iv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:iv animated:NO];

}
- (void)discuss:(MoveActionFrame *)moveActionFrame{
    self.inputField.placeholder = @"发布评论";
    [self.inputField becomeFirstResponder];
}
- (void)praiseDidChange:(BOOL)isPraise{
    [self.delegate praiseDidChange:isPraise atIndexPathRow:self.indexPathrow];
}
#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.inputField resignFirstResponder];
    _LZDictionary = [NSDictionary dictionaryWithDictionary:self.maf.moveActionModel.userInfo];

    if (self.inputField.text.length == 0) {
        [ShowMessage showMessage:@"输入不能为空"];
    }else{
        NSString *content = self.inputField.text;
        self.inputField.text = @"";
        if ([self.inputField.placeholder  isEqual: @"发布评论"]) {
            [UserConnector insertStateComment:[PersistenceManager getLoginSession] toId:[NSNumber numberWithLong:self.maf.moveActionModel.userId] content:content stateId:[NSNumber numberWithLong:self.maf.moveActionModel.stateId] receiver:^(NSData * data, NSError * error) {
                if (error) {
                    [ShowMessage showMessage:@"服务器未响应"];
                }else{
                    SBJsonParser *parser = [[SBJsonParser alloc]init];
                    NSMutableDictionary *json = [parser objectWithData:data];
                    //NSLog(@"%@",json);
                    int status = [[json objectForKey:@"status"]intValue];
                    if (status == 0) {
                        [self reloadTableViewData:UITableViewScrollPositionBottom];
                        DiscussView * discussView = (DiscussView*)self.tableView.tableHeaderView;
                        int count = discussView.discuss.lyTitleLable.text.intValue;
                        discussView.discuss.lyTitleLable.text = [NSString stringWithFormat:@"%d",count + 1];
                        [self.delegate countDidChange:count+1 atIndexPathRow:self.indexPathrow];
                        
                        /**
                         
                         发送评论成功。要向被评论者，发送消息通知动态中被评论了
                         
                         */
                        
                        EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:[NSString stringWithFormat:@"评论了您:'%@'",content]];
                        NSString *from = [[EMClient sharedClient] currentUsername];
                        
                        EMMessage * Sendmessage = [[EMMessage alloc]initWithConversationID:[NSString stringWithFormat:@"product_%@",_LZDictionary[@"id"]] from:from to:[NSString stringWithFormat:@"product_%@",_LZDictionary[@"id"]] body:body ext:@{@"动态评论":@"动态回复"}];
                        [[EMClient sharedClient].chatManager sendMessage:Sendmessage progress:^(int progress) {
                            NSLog(@"%d",progress);
                        } completion:^(EMMessage *message, EMError *error) {
                            NSLog(@"发送信息de %@\n%@",message,error);
                        }];
                        
                    }else if(status == 1){
                        [PersistenceManager setLoginSession:@""];
                        LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                        lv.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:lv animated:YES];

                    }else{
                        
                    }
                }
            }];

        }else{
            NSNumber *number = [self.tableData[self.inputField.tag] objectForKey:@"id"];
            if ([self.tableData[self.inputField.tag] objectForKey:@"stateCommentId"]) {
                number = [self.tableData[self.inputField.tag] objectForKey:@"stateCommentId"];
            }
            [UserConnector insertStateReplay:[PersistenceManager getLoginSession] toId:[self.tableData[self.inputField.tag] objectForKey:@"fromId"] content:content stateCommentId:number receiver:^(NSData * data, NSError * error) {
                if (error) {
                    [ShowMessage showMessage:@"服务器未响应"];
                }else{
                    SBJsonParser *parser = [[SBJsonParser alloc]init];
                    NSMutableDictionary *json = [parser objectWithData:data];
                    //NSLog(@"%@",json);
                    int status = [[json objectForKey:@"status"]intValue];
                    if (status == 0) {
                        [self reloadTableViewData:UITableViewScrollPositionBottom];
                        DiscussView * discussView = (DiscussView*)self.tableView.tableHeaderView;
                        int count = discussView.discuss.lyTitleLable.text.intValue;
                        discussView.discuss.lyTitleLable.text = [NSString stringWithFormat:@"%d",count + 1];
                        [self.delegate countDidChange:count+1 atIndexPathRow:self.indexPathrow];
                        
                        
                        /**
                         
                         回复评论同上进行通知。
                         发送给楼主一条信息，发送给评论者一条信息
                         
                         */
                        
                        NSDictionary * fromUserDic = [self.tableData[self.inputField.tag]objectForKey:@"fromUser"];

                        
                        EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:[NSString stringWithFormat:@"评论了您:'%@'",content]];
                        NSString *from = [[EMClient sharedClient] currentUsername];
                        
                        //生成Message
                        EMMessage * Sendmessage = [[EMMessage alloc]initWithConversationID:[NSString stringWithFormat:@"product_%@",_LZDictionary[@"id"]] from:from to:[NSString stringWithFormat:@"product_%@",_LZDictionary[@"id"]] body:body ext:@{@"动态评论":@"动态回复"}];
                        [[EMClient sharedClient].chatManager sendMessage:Sendmessage progress:^(int progress) {
                            NSLog(@"%d",progress);
                        } completion:^(EMMessage *message, EMError *error) {
                            NSLog(@"发送信息de %@\n%@",message,error);
                        }];
                        
                        
                        EMTextMessageBody *body2 = [[EMTextMessageBody alloc] initWithText:[NSString stringWithFormat:@"回复:'%@'",content]];
                        NSString *from2 = [[EMClient sharedClient] currentUsername];
                        
                        EMMessage * Sendmessage2 = [[EMMessage alloc]initWithConversationID:[NSString stringWithFormat:@"product_%@",fromUserDic[@"id"]] from:from2 to:[NSString stringWithFormat:@"product_%@",fromUserDic[@"id"]] body:body2 ext:@{@"动态评论":@"动态回复"}];
                        [[EMClient sharedClient].chatManager sendMessage:Sendmessage2 progress:^(int progress) {
                            NSLog(@"%d",progress);
                        } completion:^(EMMessage *message, EMError *error) {
                            NSLog(@"发送信息de %@\n%@",message,error);
                        }];


                        
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
     }
    return YES;
}
#pragma mark - notification keyboradMethod
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //CGFloat frameY = [UIScreen mainScreen].bounds.size.height-43;
    //CGRect frame = self.contentView.frame;
     if (beginFrame.origin.y >  endFrame.origin.y) {
        //弹出键盘，输入框上移
         if (!self.tap) {
             self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resigntFirstRespond:)];
         }
        [self.tableView addGestureRecognizer:self.tap];
        [UIView animateWithDuration:duration animations:^{
            CGRect frame = self.contentView.frame;
            frame.origin.y = endFrame.origin.y - 43;
            self.contentView.frame = frame;
        }];
    } else {
        //隐藏键盘，输入框下移
        [self.tableView removeGestureRecognizer:self.tap];
        [UIView animateWithDuration:duration animations:^{
            CGRect frame = self.contentView.frame;
            frame.origin.y = endFrame.origin.y - 43;
            self.contentView.frame = frame;
        }];

    }
    
    
}

-(void)resigntFirstRespond:(UITapGestureRecognizer*)tap{
    [self.inputField resignFirstResponder];
 }

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return self.tableData.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscussCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"discusscell"];
    cell.discussDic = self.tableData[indexPath.row];
    cell.delegate = self;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    DiscussCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"DiscussCell" owner:self options:nil]firstObject];
    DiscussCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"discusscell"];
    cell.content.text = [[self.tableData objectAtIndex:indexPath.row]objectForKey:@"content"];
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return 1  + size.height;
 
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.inputField becomeFirstResponder];
    DiscussCell * cell = (DiscussCell*)[tableView cellForRowAtIndexPath:indexPath];
    self.inputField.placeholder = [NSString stringWithFormat:@"回复 %@ : ",cell.nickName.text];
    self.inputField.tag = indexPath.row;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"personInfo"]) {
        PlagerinfoViewController *pv = segue.destinationViewController;
        pv.playerInfo = sender;
    }
}


@end
