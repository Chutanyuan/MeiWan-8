//
//  PlayerBeingTableViewController.m
//  MeiWan
//
//  Created by apple on 15/8/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "PlayerBeingTableViewController.h"
#import "AddPlayerBeingViewController.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "GameRloeTableViewCell.h"
#import "ExploitsTableViewController.h"
#import "UIImageView+WebCache.h"
#import "ShowMessage.h"
#import "LoginViewController.h"
#import "AddPlayGameViewController.h"

@interface PlayerBeingTableViewController ()
@property (nonatomic,strong) NSMutableArray *playerRoleArray;
@property (nonatomic,strong) NSMutableArray *playerRoleInfoArray;
@end

@implementation PlayerBeingTableViewController

- (void)viewDidLoad {
//    UIBarButtonItem *leftBtn = [ [ UIBarButtonItem alloc ]
//                                initWithBarButtonSystemItem: UIBarButtonSystemItemAdd
//                                target: self
//                                action: @selector(leftBtnInfo:)
//                                ];
    //    UIButton* leftBtn= [UIButton buttonWithType:UIButtonTypeContactAdd];
    //    [leftBtn addTarget:self action:@selector(leftBtnInfo:) forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.rightBarButtonItem = leftBtn;
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)leftBtnInfo:(UIButton *)sender{
    AddPlayGameViewController *addGame = [[AddPlayGameViewController alloc] init];
    [self.navigationController pushViewController:addGame animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     NSDictionary *userDic = [PersistenceManager getLoginUser];
    [UserConnector findRoles:[userDic objectForKey:@"id"] receiver:^(NSData *data,NSError *error){
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                self.playerRoleArray = [json objectForKey:@"entity"];
                //NSLog(@"%ld",self.playerRoleArray.count);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                
            }else if (status == 1){
            }else{
                
            }
        }
    }];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.playerRoleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identyfier = @"mycell";
    GameRloeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identyfier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"GameRloeTableViewCell" owner:self options:nil]firstObject];
    }
    cell.roleInfo = self.playerRoleArray[indexPath.row];
    [LOLHelper queryRoleInfo:[self.playerRoleArray[indexPath.row] objectForKey:@"name"] departion:[self.playerRoleArray[indexPath.row] objectForKey:@"part"] receiver:^(LOLInfo *lolInfo,NSError *error){
        NSString *url = lolInfo.headUrl;
        NSURL *headurl = [NSURL URLWithString:url];
        [cell.headig setImageWithURL:headurl];
        cell.sword.text = lolInfo.capacity;
        [self.playerRoleInfoArray addObject:lolInfo];
    }];
    return cell;


}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     NSDictionary *roleInfo = self.playerRoleArray[indexPath.row];
    [self performSegueWithIdentifier:@"roledetail" sender:roleInfo];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[self.array removeObjectAtIndex:indexPath.row];
        NSString *session = [PersistenceManager getLoginSession];
        [UserConnector deleteRole:session lolRoleId:[self.playerRoleArray[indexPath.row] objectForKey:@"id"] receiver:^(NSData *data,NSError *error){
            //SBJsonParser*parser=[[SBJsonParser alloc]init];
            //NSMutableDictionary *json=[parser objectWithData:data];
            //NSLog(@"%@",json);
        }];
        [self.playerRoleArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"roledetail"]) {
        ExploitsTableViewController *ev = segue.destinationViewController;
        ev.hidesBottomBarWhenPushed = YES;
        ev.exploitsInfo = sender;
    }
}


@end
