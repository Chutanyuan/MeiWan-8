//
//  emotionalState.m
//  MeiWan
//
//  Created by user_kevin on 16/9/6.
//  Copyright © 2016年 apple. All rights reserved.
//
//
//  editdescription.m
//  MeiWan
//
//  Created by user_kevin on 16/9/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "emotionalState.h"
#import "MeiWan-Swift.h"
#import "ShowMessage.h"
#import "SBJsonParser.h"

@interface emotionalState ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSArray * pickviewOneArray;
    NSString * selectHeight;
}
@end

@implementation emotionalState

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor whiteColor];
    
    pickviewOneArray =@[@"150",@"151",@"152",@"153",@"154",@"155",@"157",@"158",@"159",@"160",@"161",@"162",@"163",@"164",@"165",@"166",@"167",@"168",@"169",@"170",@"171",@"172",@"173",@"174",@"175",@"176",@"177",@"178",@"179",@"180",@"181",@"182",@"183",@"184",@"185",@"186",@"187",@"188",@"189",@"190"];

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
        return @"CM";
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
    NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:selectHeight,@"height", nil];
    [UserConnector update:session parameters:userInfoDic receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            SBJsonParser * parser = [[SBJsonParser alloc]init];
            NSDictionary * json = [parser objectWithData:data];
            int status = [json[@"status"] intValue];
            if (status==0) {
                [PersistenceManager setLoginUser:json[@"entity"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"finish_height" object:selectHeight];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        }
    }];
}

@end

