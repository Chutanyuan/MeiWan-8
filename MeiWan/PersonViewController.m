//
//  PersonViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/10/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PersonViewController.h"

@interface PersonViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSDictionary * cellTitleArray;


@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人";
    [self.navigationController.navigationBar setBarTintColor:[CorlorTransform colorWithHexString:@"78cdf8"]];
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor]forKey:NSForegroundColorAttributeName];
    NSLog(@"%f",dtScreenWidth);
    UITableView * tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView * view = [self headeView];
    tableview.tableHeaderView = view;
    tableview.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:tableview];

    // Do any additional setup after loading the view.
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(UIView *)headeView
{
    UIView * view  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, 170)];
    UIImageView * imageview = [[UIImageView alloc]initWithFrame:view.frame];
    imageview.image = [UIImage imageNamed:@"beijin"];
//    imageview.contentMode = UIViewContentModeScaleAspectFill;
    [view addSubview:imageview];

    UIImageView * headerBord = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 90, 100)];
    headerBord.image = [UIImage imageNamed:@"zhuangshi"];
    [view addSubview:headerBord];
    
    UIImageView * bianji = [[UIImageView alloc]initWithFrame:CGRectMake(dtScreenWidth-10-20, 50, 20, 20)];
    bianji.image = [UIImage imageNamed:@"bianji"];
    [view addSubview:bianji];
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 130, dtScreenWidth, 40)];
    bottomView.backgroundColor = [CorlorTransform colorWithHexString:@"418fc0"];
    bottomView.alpha = 0.4;
    [view addSubview:bottomView];
    
    for (int i = 0; i<3; i++) {
        UIImageView * threeImage = [[UIImageView alloc]initWithFrame:CGRectMake((dtScreenWidth/6-12)+i*(dtScreenWidth/3), 138, 24, 24)];
        if (i==0) {
            threeImage.image = [UIImage imageNamed:@"dongtai"];
        }else if (i==1){
            threeImage.image = [UIImage imageNamed:@"fensi"];
        }else{
            threeImage.image = [UIImage imageNamed:@"guanzhu"];
        }
        [view addSubview:threeImage];
        
        UILabel * threeNumber = [[UILabel alloc]initWithFrame:CGRectMake((dtScreenWidth/6+17)+i*(dtScreenWidth/3), 138, 24, 24)];
        threeNumber.font = [UIFont systemFontOfSize:14];
        threeNumber.text = @"0";
        threeNumber.textColor = [UIColor whiteColor];
        [view addSubview:threeNumber];
        
    }
    
    return view;
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
