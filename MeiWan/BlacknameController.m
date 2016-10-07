//
//  BlacknameController.m
//  MeiWan
//
//  Created by user_kevin on 16/6/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BlacknameController.h"
#import "EMSDK.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "ShowMessage.h"
#import "blackNameTableViewCell.h"
#import "blackModel.h"

@interface BlacknameController ()<UITableViewDelegate,UITableViewDataSource>
{
    blackNameTableViewCell * nameCell;
    NSMutableArray * _blackFriend;
    UITableView * _tableView;
    blackModel * model;
}
@end

@implementation BlacknameController

-(void)viewWillAppear:(BOOL)animated
{
    [self getBlackName];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self creat_tableView];
  
}
- (void)creat_tableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    [self.view addSubview:_tableView];
    
}
- (void)getBlackName
{
    //获取黑名单
    _blackFriend = [[NSMutableArray alloc]initWithCapacity:0];
    
    _blackFriend = [[EMClient sharedClient].contactManager getBlackListFromDB];
    
}
#pragma mark--- mark----tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_blackFriend.count!=0) {
        return _blackFriend.count;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    nameCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!nameCell) {
        nameCell = [[blackNameTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (_blackFriend.count!=0) {

           model = [[blackModel alloc]initWithDictionary:_blackFriend[indexPath.row]];
           [nameCell.headerImage sd_setImageWithURL:[NSURL URLWithString:model.headerUrl]];
            nameCell.nickName.text = model.nickName;
    }
    nameCell.backgroundColor = [UIColor grayColor];
    nameCell.backgroundView.alpha = 0.7;
    nameCell.accessoryType = UITableViewCellAccessoryDetailButton;
    return nameCell;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",[NSString stringWithFormat:@"product_%@",[_blackFriend objectAtIndex:indexPath.row][@"id"]]);
    
    EMError *error = [[EMClient sharedClient].contactManager removeUserFromBlackList:[NSString stringWithFormat:@"product_%@",[_blackFriend objectAtIndex:indexPath.row][@"id"]]];
    if (!error) {
        NSLog(@"发送成功");
    }
    
    [_blackFriend removeObjectAtIndex:indexPath.row];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
@end
