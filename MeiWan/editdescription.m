//
//  editdescription.m
//  MeiWan
//
//  Created by user_kevin on 16/9/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "editdescription.h"
#import "MeiWan-Swift.h"
#import "ShowMessage.h"
#import "SBJsonParser.h"

@interface editdescription ()<UITextViewDelegate,MBProgressHUDDelegate>
{
    UITextView * textview;
    MBProgressHUD * HUD;
}
@end

@implementation editdescription

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor whiteColor];
    textview = [[UITextView alloc]initWithFrame:CGRectMake(10, 74, dtScreenWidth-20, 100)];
    textview.delegate = self;
    
    //字体大小
    textview.font = [UIFont systemFontOfSize:16];
    
    //添加滚动区域
    textview.contentInset = UIEdgeInsetsMake(-74, 0, 0, 0);
    //是否可以滚动
    textview.scrollEnabled = NO;
    
    //获得焦点
    [textview becomeFirstResponder];
    [textview.layer setBorderColor:[UIColor grayColor].CGColor];
    [textview.layer setBorderWidth:0.5];
    textview.layer.cornerRadius = 5;
    textview.clipsToBounds = YES;
    [self.view addSubview:textview];
    
    UIButton * saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(20, textview.frame.origin.y+textview.frame.size.height+40, dtScreenWidth-40, 44);
    saveButton.layer.cornerRadius = 5;
    saveButton.clipsToBounds = YES;
    saveButton.backgroundColor = [CorlorTransform colorWithHexString:@"#BCD2EE"];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    // Do any additional setup after loading the view.
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"%@",textView.text);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"finish_nickname" object:textview.text];
}
- (void)saveButton:(UIButton *)sender
{
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"finish_nickname" object:textview.text];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"加载中";
    HUD.delegate = self;
    [HUD showAnimated:YES whileExecutingBlock:^{
        NSString * session = [PersistenceManager getLoginSession];
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:textview.text,@"description", nil];
        [UserConnector update:session parameters:dic receiver:^(NSData *data, NSError *error){
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];
                //NSLog(@"%@",json);
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    [PersistenceManager setLoginUser:json[@"entity"]];
                    [HUD hide:YES afterDelay:0.3];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else if(status == 1){
                    
                }
            }
        }];
        
    }];
    
}

@end
