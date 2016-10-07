//
//  FansViewController.m
//  MeiWan
//
//  Created by Fox on 16/7/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "FansViewController.h"
#import "fansCell.h"
#import "LoginViewController.h"
#import "PlagerinfoViewController.h"

#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "CorlorTransform.h"
#import "MJRefresh.h"
#import "ShowMessage.h"

@interface FansViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary * fansDic;
}
@property (nonatomic, strong) UITableView *fansTableView;
@property (nonatomic, strong) NSMutableArray *fansArray;
@property (nonatomic ,strong) NSNumber *peiwanId;
@property (nonatomic, strong) fansCell *fansCell;

@end

@implementation FansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的关注";
    fansDic = [[NSDictionary alloc]init];
    _fansTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight) style:UITableViewStylePlain];
    _fansTableView.delegate = self;
    _fansTableView.dataSource = self;
    _fansTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_fansTableView];
    [self fansFollowersBy];

    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fansArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    fansCell * cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
    if (!cell) {
        cell = [[fansCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoCell"];
    }
    
    fansDic = self.fansArray[indexPath.row];
    [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!1",[fansDic objectForKey:@"headUrl"]]]];
    cell.nickname .text = fansDic[@"nickname"];
    cell.nickname.font = [UIFont systemFontOfSize:15.0];
    CGSize size = [cell.nickname.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:cell.nickname.font,NSFontAttributeName, nil]];
    cell.nickname.frame = CGRectMake(70, 35-size.height/2, size.width, size.height);
    cell.sexImage.frame = CGRectMake(cell.nickname.frame.origin.x+cell.nickname.frame.size.width+10, cell.nickname.center.y-8, 15, 15);
    if ([[fansDic objectForKey:@"gender"]intValue] == 0){
        cell.sexImage.image = [UIImage imageNamed:@"nansheng_logo"];
    }else{
        cell.sexImage.image = [UIImage imageNamed:@"nvsheng_logo"];
    }
    cell.ageLabel.frame = CGRectMake(cell.sexImage.frame.origin.x+cell.sexImage.frame.size.width+5, cell.sexImage.frame.origin.y, 30, 15);
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy";
    NSString *year = [formatter stringFromDate:today];
    int yearnow = year.intValue;
    int birthyear = [[fansDic objectForKey:@"year"]intValue];
    int agenumber = yearnow - birthyear;
    NSString *userAge = [NSString stringWithFormat:@"%d",agenumber];
    cell.ageLabel.text = userAge;
    
    cell.fansButton.tag = indexPath.row;
    [cell.fansButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)buttonClick:(UIButton *)sender
{
    NSDictionary * userMessage = self.fansArray[sender.tag];
    NSString * userID =[userMessage objectForKey:@"id"];
    NSLog(@"%@",userID);
    NSInteger userNumber =[userID integerValue];
    NSNumber * number =[NSNumber numberWithUnsignedInteger:userNumber];
    NSString *session = [PersistenceManager getLoginSession];
    [UserConnector deleteFriend:session friendId:number receiver:^(NSData *data,NSError *error){
        if (error!=nil) {
            
            [ShowMessage showMessage:@"服务器未响应"];
            
        }else{
            [self.fansArray removeObject:userMessage];
            NSIndexPath * index =[NSIndexPath indexPathForRow:sender.tag inSection:0];
            [self.fansTableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
            [ShowMessage showMessage:@"取消关注"];
            [self.fansTableView reloadData];
            
        }}];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
    [self performSegueWithIdentifier:@"fansDetail" sender:self.fansArray[indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"fansDetail"]) {
        PlagerinfoViewController *pv = segue.destinationViewController;
        pv.playerInfo = sender;
    }
}

- (void)fansFollowersBy{
    NSString *sesstion = [PersistenceManager getLoginSession];
    [UserConnector findMyFriends:sesstion receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                self.fansArray = [json objectForKey:@"entity"];
                for (int i = 0;  i < self.fansArray.count; i++) {
                    if ([self.fansArray[i] isKindOfClass:[NSNull class]]) {
                        [self.fansArray removeObjectAtIndex:i];
                    }
                }

                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.fansTableView reloadData];
                });
            }else if (status == 1){
                [PersistenceManager setLoginSession:@""];
                
                LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                lv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:lv animated:YES];
                
            }else{
                
            }
            
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end