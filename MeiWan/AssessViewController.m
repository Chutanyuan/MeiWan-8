//
//  AssessViewController.m
//  MeiWan
//
//  Created by apple on 15/9/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AssessViewController.h"
#import "CWStarRateView.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "LoginViewController.h"
#import "ShowMessage.h"
@interface AssessViewController ()<CWStarRateViewDelegate,UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *starView;
@property (strong, nonatomic) IBOutlet UIView *btnView;
@property (strong, nonatomic) IBOutlet UIButton *btn666;
@property (strong, nonatomic) IBOutlet UIButton *btnCarry;
@property (strong, nonatomic) IBOutlet UIButton *btnMvp;
@property (strong, nonatomic) IBOutlet UIButton *btnFly;
@property (strong, nonatomic) IBOutlet UIButton *btnGirl;
@property (strong, nonatomic) IBOutlet UIButton *btnSister;
@property (strong, nonatomic) IBOutlet UIButton *btnDanger;
@property (strong, nonatomic) IBOutlet UIButton *btnKeng;
@property (strong, nonatomic) IBOutlet UIButton *btnLift;
@property (strong, nonatomic)  UILabel *placehode;
@property (strong, nonatomic)  UITextView *assessText;
@property (strong, nonatomic) NSNumber *point;
@property (strong, nonatomic) NSMutableArray *tags;
@property (strong, nonatomic) NSArray *btns;
@property (assign, nonatomic) CGPoint mycenter;
@property (strong, nonatomic) UIButton *keyboardClearBtn;
@property (strong, nonatomic) CWStarRateView *starRateView;
@end

@implementation AssessViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.btns = [NSArray arrayWithObjects:self.btn666,self.btnCarry,self.btnMvp,self.btnFly,self.btnGirl,self.btnSister,self.btnDanger,self.btnKeng,self.btnLift, nil];
    self.tags = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.mycenter = self.view.center;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

    CWStarRateView *starRateView = [[CWStarRateView alloc] initWithFrame:self.starView.bounds numberOfStars:5];
    starRateView.scorePercent = 0.6;
    self.point = [NSNumber numberWithFloat:starRateView.scorePercent*5];
    starRateView.allowIncompleteStar = YES;
    starRateView.hasAnimation = YES;
    starRateView.delegate = self;
    self.starRateView = starRateView;
    [self.starView addSubview:starRateView];
    
}
- (IBAction)allScoreBtn:(UIButton *)sender {
    self.starRateView.scorePercent = 1;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    _assessText = [[UITextView alloc]initWithFrame:CGRectMake(16, self.btnView.frame.origin.y + self.btnView.frame.size.height + 20, self.view.bounds.size.width - 32, 100)];
     _assessText.delegate = self;
    _placehode = [[UILabel alloc]initWithFrame:CGRectMake(3, 5, 100, 20)];
    _placehode.font = [UIFont systemFontOfSize:14];
    _placehode.textColor = [UIColor lightGrayColor];
    self.placehode.text = @"我的评价...";
    [_assessText addSubview:_placehode];
    [self.view addSubview:_assessText];

}
#pragma mark CWStarRateViewDelegate
-(void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent{
    //NSLog(@"%f",newScorePercent);
    self.point = [NSNumber numberWithFloat:newScorePercent*5];
}
-(void)WillChangeFrame:(NSNotification *)notif{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
   
    if (value.CGRectValue.origin.y > self.view.bounds.size.height - 200) {
        if (!self.keyboardClearBtn) {
            self.keyboardClearBtn = [[UIButton alloc]initWithFrame:self.view.bounds];
            [self.keyboardClearBtn addTarget:self action:@selector(disappearKeyborad) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.keyboardClearBtn];
            
        }
         [UIView animateWithDuration:.2 animations:^{
              _assessText.frame = CGRectMake(16, self.btnView.frame.origin.y + self.btnView.frame.size.height + 20, self.view.bounds.size.width - 32, 100);

         }];
    }else{
        if (!self.keyboardClearBtn) {
            self.keyboardClearBtn = [[UIButton alloc]initWithFrame:self.view.bounds];
            [self.keyboardClearBtn addTarget:self action:@selector(disappearKeyborad) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.keyboardClearBtn];

        }
        if (_assessText.frame.origin.y + _assessText.frame.size.height > value.CGRectValue.origin.y) {
            [UIView animateWithDuration:.2 animations:^{
                
                //self.view.center = self.mycenter;
                CGRect frame ;
                frame = CGRectMake(16,self.view.frame.size.height - keyboardSize.height - _assessText.frame.size.height, self.view.frame.size.width - 32, 100);
                _assessText.frame = frame;
                //NSLog(@"%f",keyboardSize.height);
            }];

        }
        
        
    }
}
- (void)disappearKeyborad{
    [self.assessText resignFirstResponder];
    [self.keyboardClearBtn removeFromSuperview];
    self.keyboardClearBtn = nil;
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.placehode.text = @"我的评价...";
    }else{
        self.placehode.text = @"";
    }
}
- (IBAction)accusationBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
    }else{
        [sender setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

- (IBAction)accusaionAction:(UIBarButtonItem *)sender {
    for (UIButton *btn in self.btns) {
        if (btn.selected) {
            [self.tags addObject:[NSNumber numberWithInteger:btn.tag]];
        }
    }
    //NSLog(@"%@---%@",self.tags,self.point);
    
    SBJsonWriter *writer = [[SBJsonWriter alloc]init];
    NSString *tags = [writer stringWithObject:self.tags];
    
    NSString *session = [PersistenceManager getLoginSession];
    [UserConnector evaluationOrder:session orderId:[self.orderDic objectForKey:@"id"] peiwanId:[self.orderDic objectForKey:@"peiwanId"] point:self.point tagIndexs:tags content:self.assessText.text receiver:^(NSData *data, NSError *error){
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableDictionary *json = [parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            //NSLog(@"%@",json);
            if (status == 0) {
                //NSLog(@"%@",json);
                [ShowMessage showMessage:@"评价成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else if (status == 1){
                dispatch_async(dispatch_get_main_queue()
                               , ^{
                                   [PersistenceManager setLoginSession:@""];
                                   LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                                   lv.hidesBottomBarWhenPushed = YES;
                                   [self.navigationController pushViewController:lv animated:YES];
                                   
                               });
            }else if (status == 3){
                [ShowMessage showMessage:@"已经评价过了，只能评价一次"];
                
            }else{
                
            }
            
        }
    }];
}

@end
