//
//  EditPersonalMessageVC.m
//  MeiWan
//
//  Created by user_kevin on 16/10/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "EditPersonalMessageVC.h"
#import "photosView.h"

@interface EditPersonalMessageVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableview;

@end

@implementation EditPersonalMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableview];

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * zeroname = @[@"用户名",@"身高",@"体重",@"个性签名"];
    NSArray * onename = @[@"职业",@"星座",@"所在地"];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell  alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UIImageView * jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(dtScreenWidth-35, cell.frame.size.height/2-7.5, 15, 15)];
        jiantou.image = [UIImage imageNamed:@"jiantou"];
        [cell.contentView addSubview:jiantou];
    }
    if (indexPath.section==0) {
        cell.textLabel.text = zeroname[indexPath.row];
    }else if (indexPath.section==1){
        cell.textLabel.text = onename[indexPath.row];
    }
    cell.textLabel.font = [FontOutSystem fontWithFangZhengSize:17.0];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        
        return 4;
        
    }else{
        return 3;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return dtScreenWidth;
    }else{
        return 5;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        photosView * view = [[photosView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenWidth)];
        return view;
    }else{
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==1) {
        return dtScreenWidth;
    }else{
        return 5;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==1) {
        UIView * view = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenWidth)];
        return view;
    }else{
        return nil;
    }
}


#pragma mark----保存按钮action
- (void)save
{
    
}

@end
