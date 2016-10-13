//
//  EditPersonalFootView.m
//  MeiWan
//
//  Created by user_kevin on 16/10/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "EditPersonalFootView.h"

@interface EditPersonalFootView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation EditPersonalFootView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel * myAuthentication = [[UILabel alloc]init];
        myAuthentication.textColor = [CorlorTransform colorWithHexString:@"c4c4c4"];
        myAuthentication.text = @"我的认证";
        myAuthentication.font = [FontOutSystem fontWithFangZhengSize:17.0];
        CGSize size_authentication = [myAuthentication.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:myAuthentication.font,NSFontAttributeName, nil]];
        myAuthentication.frame = CGRectMake(10, 10, size_authentication.width, size_authentication.height);
        [self addSubview:myAuthentication];
        
        UITableView * tableview = [[UITableView alloc]initWithFrame:CGRectMake(myAuthentication.frame.size.width+myAuthentication.frame.origin.x+20, myAuthentication.frame.origin.x, dtScreenWidth-(myAuthentication.frame.size.width+myAuthentication.frame.origin.x+20), 180)];
        tableview.delegate = self;
        tableview.dataSource = self;
        [self addSubview:tableview];
        
        
    }
    return self;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * weiQQImage = @[@"weixin_edit",@"QQ_edit",@"renzheng_edit"];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(dtScreenWidth-tableView.frame.origin.x-20-50, 0, 50, 60);
    button.titleLabel.font = [FontOutSystem fontWithFangZhengSize:17.0];
    [button setTitleColor:[CorlorTransform colorWithHexString:@"a5c4d7"] forState:UIControlStateNormal];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell.contentView addSubview:button];
    }
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",weiQQImage[indexPath.row]]];
    if (indexPath.row==0) {
        [button setTitle:@"修改" forState:UIControlStateNormal];
        cell.textLabel.text = @"微信尚未认证";
    }else if (indexPath.row==1){
        [button setTitle:@"修改" forState:UIControlStateNormal];
        cell.textLabel.text = @"QQ尚未认证";
    }else{
        [button setTitle:@"认证" forState:UIControlStateNormal];
        cell.textLabel.text = @"身份尚未认证";
    }
    cell.textLabel.font = [FontOutSystem fontWithFangZhengSize:15.0];
    cell.textLabel.textColor = [CorlorTransform colorWithHexString:@"c4c4c4"];
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
