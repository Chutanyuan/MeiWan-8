
//
//  schoolChooseVC.m
//  MeiWan
//
//  Created by user_kevin on 16/9/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "schoolChooseVC.h"
#import "MeiWan-Swift.h"
#import "ShowMessage.h"
#import "SBJsonParser.h"
@interface schoolChooseVC ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSArray * pickviewOneArray;
    NSString * selectHeight;
}
@end

@implementation schoolChooseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.navigationController.navigationBar.backgroundColor;
    pickviewOneArray =@[@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60",@"61",@"62",@"63",@"64",@"65",@"66",@"67",@"68",@"69",@"70",@"71",@"72",@"73",@"74",@"75",@"76",@"77",@"78",@"79",@"80"];
    
    UIPickerView * pickview = [[UIPickerView alloc]init];
    pickview.center = self.view.center;
    pickview.bounds = CGRectMake(0, 0, dtScreenWidth/4*3, dtScreenWidth/4*3);
    pickview.showsSelectionIndicator = YES;
    pickview.dataSource = self;
    pickview.delegate = self;
    [self.view addSubview:pickview];
    [pickview selectRow:pickviewOneArray.count/2 inComponent:0 animated:NO];
    selectHeight = [NSString stringWithFormat:@"%@",pickviewOneArray[pickviewOneArray.count/2]];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(pickview.frame.origin.x, pickview.frame.origin.y+pickview.frame.size.height, pickview.frame.size.width, 40);
    [button setTitle:@"选中" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 3;
    [button.layer setBorderColor:[UIColor grayColor].CGColor];
    [button.layer setBorderWidth:0.4];
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component==0) {
        return pickerView.frame.size.width/3*2;
    }else{
        return 60;
    }
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return pickviewOneArray.count;
    }else{
        return 1;
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0) {
        return pickviewOneArray[row];
    }else{
        return @"KG";
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0) {
        selectHeight = [NSString stringWithFormat:@"%@",pickviewOneArray[row]];
    }
}
- (void)buttonClick:(UIButton *)sender
{
    NSString * session = [PersistenceManager getLoginSession];
    NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:selectHeight,@"weight", nil];
    [UserConnector update:session parameters:userInfoDic receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            SBJsonParser * parser = [[SBJsonParser alloc]init];
            NSDictionary * json = [parser objectWithData:data];
            int status = [json[@"status"] intValue];
            if (status==0) {
                [PersistenceManager setLoginUser:json[@"entity"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"finish_weight" object:selectHeight];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        }
    }];
}
@end
