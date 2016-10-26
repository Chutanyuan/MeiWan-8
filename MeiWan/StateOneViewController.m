//
//  StateOneViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/10/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "StateOneViewController.h"
#import "MeiWan-Swift.h"
#import "DetailWithPlayerTableViewCell.h"
#import "XYView.h"
#import "ShowMessage.h"
#import "stateRepliesTableViewCell.h"

@interface StateOneViewController ()<UITableViewDelegate,UITableViewDataSource,dongtaiZanDelegate,UITextFieldDelegate>
{
    DetailWithPlayerTableViewCell * cell;
}
@property(nonatomic,assign)NSInteger number;
@property(nonatomic,strong)NSMutableArray * countsArrays;
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)UITextView * pinglunKuang;

@property (nonatomic ,strong)XYView *views;

@end

@implementation StateOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.countsArrays = [[NSMutableArray alloc]initWithCapacity:0];
    [self findStateComment];

    self.view.backgroundColor = [UIColor whiteColor];
    UITableView * tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource =  self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    self.tableview = tableview;
    
    //利用通知中心监听键盘的显示和消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardAction:) name:UIKeyboardWillHideNotification object:nil];
    
    self.views = [XYView XYveiw];
    self.views.frame = CGRectMake(0, self.view.frame.size.height- 40, self.view.frame.size.width, 40);
    [self.views.btn addTarget:self action:@selector(ceacllBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.views];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[DetailWithPlayerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.detailDictionary = self.stateMessage;
        cell.delegate = self;
        return cell;
    }else{
        stateRepliesTableViewCell * cellOther = [tableView dequeueReusableCellWithIdentifier:@"pingluncell"];
        if (!cellOther) {
            cellOther = [[stateRepliesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pingluncell"];
        }
        cellOther.stateMessage = self.countsArrays[indexPath.row-1];
        return cellOther;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.countsArrays.count+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        DetailWithPlayerTableViewCell * cell1 = [self tableView:self.tableview cellForRowAtIndexPath:indexPath];
        return cell1.frame.size.height;
    }else{
        stateRepliesTableViewCell * cellOther = [self tableView:self.tableview cellForRowAtIndexPath:indexPath];
        return cellOther.frame.size.height;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row>0) {
        [self.views.textTF becomeFirstResponder];
        self.views.textTF.placeholder = [NSString stringWithFormat:@"回复 %@",self.countsArrays[indexPath.row-1][@"fromUser"][@"nickname"]];
        self.views.textTF.delegate = self;
        
        self.views.btn.tag = indexPath.row-1;
        [self.views.btn addTarget:self action:@selector(sendRemessage:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)sendRemessage:(UIButton *)sender
{
    NSDictionary * sendDic = self.countsArrays[sender.tag];
    /**
     发送 评论
     */
    NSString * session = [PersistenceManager getLoginSession];
    [UserConnector insertStateComment:session toId:[NSNumber numberWithDouble:[sendDic[@"fromId"] doubleValue]] content:self.views.textTF.text stateId:[NSNumber numberWithDouble:[sendDic[@"stateId"] doubleValue]] receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            SBJsonParser * parser = [[SBJsonParser alloc]init];
            NSDictionary * json = [parser objectWithData:data];
            int state = [json[@"state"] intValue];
            if (state == 0) {
                self.views.textTF.text = nil;
                [self.views.textTF resignFirstResponder];
                [self.tableview reloadData];
                
            }
        }else{
            [ShowMessage showMessage:@"服务器未响应"];
        }
    }];

}


#pragma mark---键盘处理
- (void)handleKeyBoardAction:(NSNotification *)notification {
    NSLog(@"%@",notification);
    //1、计算动画前后的差值
    CGRect beginFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat detalY = endFrame.origin.y - beginFrame.origin.y;
    
    //2、根据差值更改_textView的高度
    CGFloat frame = self.views.frame.origin.y;
    frame += detalY;
    self.views.frame = CGRectMake(0, frame, self.view.frame.size.width, 40);
    
}
- (void)ceacllBtn:(id)sender {
    int number = [cell.countlabel.text intValue];
    cell.countlabel.text = [NSString stringWithFormat:@"%d",number+1];

    [_views.textTF resignFirstResponder];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#define mark 所有动态回复

- (void)findStateComment
{
    NSString * session = [PersistenceManager getLoginSession];
    [UserConnector findStateComment:session stateId:[NSNumber numberWithDouble:[self.stateMessage[@"id"] doubleValue]] receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            SBJsonParser * parser = [[SBJsonParser alloc]init];
            NSDictionary * json = [parser objectWithData:data];
            int status = [json[@"status"] intValue];
            if (status==0) {
                
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
                self.countsArrays = [NSMutableArray arrayWithArray:states];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableview reloadData];
                });
            }
        }else{
            [ShowMessage showMessage:@"服务器未响应"];
        }
    }];
}
@end
