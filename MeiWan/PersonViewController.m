//
//  PersonViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/10/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PersonViewController.h"
#import "MeiWan-Swift.h"

@interface PersonViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray * cellTitleArray;
@property(nonatomic,strong)NSDictionary * userMessage;

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人";
    [self.navigationController.navigationBar setBarTintColor:[CorlorTransform colorWithHexString:@"78cdf8"]];
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor]forKey:NSForegroundColorAttributeName];
    
    self.userMessage = [PersistenceManager getLoginUser];
    self.cellTitleArray =@[
                           @{@"title":@"我要出售时间",@"image":@"chushou"},
                           @{@"title":@"我的钱包",@"image":@"qianbao"},
                           @{@"title":@"记录中心",@"image":@"jilu"},
                           @{@"title":@"公会管理",@"image":@"gonghui"},
                           @{@"title":@"设置",@"image":@"shezhi"}
                           ];
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
//        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, cell.frame.size.height-1, dtScreenWidth-10, 1)];
//        label.backgroundColor = [UIColor grayColor];
//        [cell.contentView addSubview:label];
        UIImageView * jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(dtScreenWidth-35, cell.frame.size.height/2-7.5, 15, 15)];
        jiantou.image = [UIImage imageNamed:@"jiantou"];
        [cell.contentView addSubview:jiantou];
    }
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",_cellTitleArray[indexPath.row][@"image"]]];
    cell.textLabel.text =[NSString stringWithFormat:@"%@",_cellTitleArray[indexPath.row][@"title"]];
    cell.textLabel.font = [FontOutSystem fontWithFangZhengSize:15.0];
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellTitleArray.count;
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
    UIImageView * headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 17, 86, 86)];
    [headerImage sd_setImageWithURL:[NSURL URLWithString:self.userMessage[@"headUrl"]]];
    headerImage.layer.cornerRadius = 43;
    headerImage.clipsToBounds = YES;
    [view addSubview:headerImage];
    
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
        threeNumber.font = [FontOutSystem fontWithFangZhengSize:15.0];
        threeNumber.text = @"0";
        threeNumber.textColor = [UIColor whiteColor];
        [view addSubview:threeNumber];
        
    }
    
    UILabel * nickname = [[UILabel alloc]init];
    nickname.text = self.userMessage[@"nickname"];
    nickname.font = [FontOutSystem fontWithFangZhengSize:15.0];
    nickname.textColor = [UIColor whiteColor];
    CGSize size_nickname = [nickname.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:nickname.font,NSFontAttributeName, nil]];
    nickname.frame = CGRectMake(headerImage.frame.origin.x+headerImage.frame.size.width+10, headerImage.center.y, size_nickname.width, size_nickname.height);
    [view addSubview:nickname];
    
    UILabel * age = [[UILabel alloc]init];
    age.font = [FontOutSystem fontWithFangZhengSize:12.0];
    age.textColor = [UIColor grayColor];
    
    
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy";
    NSString *year = [formatter stringFromDate:today];
    int yearnow = year.intValue;
    int userage = yearnow - [self.userMessage[@"year"] doubleValue];
    NSString *userAge = [NSString stringWithFormat:@"%d",userage];
    
    age.text = userAge;
    CGSize size_age = [age.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:age.font,NSFontAttributeName, nil]];
    age.frame = CGRectMake(nickname.frame.size.width+nickname.frame.origin.x+10, nickname.center.y-size_age.height/2, size_age.width, size_age.height);
    
    [view addSubview:age];
    
    UIImageView * sexImage = [[UIImageView alloc]init];
    if ([self.userMessage[@"sex"] isEqualToString:@"男"]) {
        sexImage.image = [UIImage imageNamed:@"nansheng_logo"];
    }else{
        sexImage.image = [UIImage imageNamed:@"nvsheng_logo"];
    }
    sexImage.frame = CGRectMake(age.center.x+age.frame.size.width, age.center.y-6, 12, 12);
    [view addSubview: sexImage];
    
    UILabel * qianming = [[UILabel alloc]initWithFrame:CGRectMake(nickname.frame.origin.x, nickname.frame.size.height+nickname.frame.origin.y+10, dtScreenWidth-nickname.frame.origin.x-40, 14)];
    qianming.font = [FontOutSystem fontWithFangZhengSize:14.0];
    qianming.text = self.userMessage[@"description"];
    qianming.textColor = [UIColor whiteColor];
    [view addSubview: qianming];
    
    return view;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
