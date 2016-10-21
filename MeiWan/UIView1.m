//
//  view1.m
//  MeiWan
//
//  Created by user_kevin on 16/10/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIView1.h"

@interface UIView1 ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>


@end

@implementation UIView1

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UITableView * tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, frame.size.width, 180)];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.backgroundColor = self.backgroundColor;
        [self addSubview:tableview];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20, 300, frame.size.width-40, 44);
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        [button setTitleColor:[CorlorTransform colorWithHexString:@""] forState:UIControlStateNormal];
        [button setBackgroundColor:[CorlorTransform colorWithHexString:@""]];
        button.layer.cornerRadius = 5;
        button.clipsToBounds = YES;
        [button addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
    }
    return self;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * titlearray = @[@"原密码:",@"新密码:",@"确认新密码:",@"验证码:"];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        UITextField  * textfiled = [[UITextField alloc]init];
        textfiled.delegate = self;
        self.textfiled = textfiled;
        if (indexPath.row==0) {
            textfiled.tag = 111;
            textfiled.frame = CGRectMake(70, 0, self.frame.size.width-55, 44);
        }else if (indexPath.row==1){
            textfiled.tag = 222;
            textfiled.frame = CGRectMake(70, 0, self.frame.size.width-55, 44);
        }else if (indexPath.row==2){
            textfiled.tag = 333;
            textfiled.frame = CGRectMake(100, 0, self.frame.size.width-85, 44);
        }else{
            textfiled.tag = 444;
            textfiled.frame = CGRectMake(70, 0, self.frame.size.width-55, 44);
        }
        if (textfiled.tag==444) {
            textfiled.keyboardType = UIKeyboardTypeNumberPad;
        }else{
            
        }
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell addSubview:textfiled];
    }
    cell.backgroundColor = self.backgroundColor;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",titlearray[indexPath.row]];
    cell.textLabel.font = [FontOutSystem fontWithFangZhengSize:16.0];
    CGSize size_text = [cell.textLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:cell.textLabel.font,NSFontAttributeName, nil]];
    NSLog(@"%f",size_text.width);
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    [self.delegate textFieldEndEditing:textField];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}
- (void)sendMessage{
    
}

@end
