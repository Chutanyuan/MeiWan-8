//
//  LoginViewController.m
//  MeiWan
//
//  Created by apple on 15/8/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LoginViewController.h"
#import "CorlorTransform.h"
#import "ShowMessage.h"
#import "Meiwan-Swift.h"

@interface LoginViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginbtn;
@property (weak, nonatomic) IBOutlet UIButton *registbtn;
@property (nonatomic, strong) UIWebView *wb;
@end

@implementation LoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //读取沙盒数据
    NSUserDefaults * settings1 = [NSUserDefaults standardUserDefaults];
    NSString *key1 = [NSString stringWithFormat:@"is_first"];
    NSString *value = [settings1 objectForKey:key1];
    if ((!value)) {
        
        UIScrollView * scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight)];
        scrollview.contentSize = CGSizeMake(dtScreenWidth*3, dtScreenHeight);
        scrollview.delegate = self;
        scrollview.pagingEnabled = YES;
        scrollview.showsVerticalScrollIndicator = NO;
        scrollview.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:scrollview];
        
        for (int i = 0; i<3; i++) {
            UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(dtScreenWidth*i, 0, dtScreenWidth, dtScreenHeight)];
            imageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d_loadingҳ",i+2]];
            [scrollview addSubview:imageview];
        }
        
        //写入数据
        NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
        NSString * key = [NSString stringWithFormat:@"is_first"];
        [setting setObject:[NSString stringWithFormat:@"false"] forKey:key];
        [setting synchronize];
    }

    
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //获取偏移量
    CGPoint offset = scrollView.contentOffset;
    NSLog(@"%f",offset.x);
    if (offset.x>760) {
        scrollView.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated{
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginaction:(id)sender {
    [self performSegueWithIdentifier:@"getin" sender:nil];
}
- (IBAction)registaction:(id)sender {
    //[self performSegueWithIdentifier:@"regist" sender:nil];
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
