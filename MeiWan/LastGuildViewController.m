//
//  LastGuildViewController.m
//  MeiWan
//
//  Created by Fox on 16/8/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LastGuildViewController.h"

#import "MJRefresh.h"
#import "UserInfo.h"
#import "CWStarRateView.h"
#import "Meiwan-Swift.h"
#import "UMUUploaderManager.h"
#import "NSString+NSHash.h"
#import "NSString+Base64Encode.h"
#import "ShowMessage.h"
#import "CorlorTransform.h"
#import "setting.h"
#import "RandNumber.h"
#import "SBJson.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "CompressImage.h"
#import "CorlorTransform.h"

@interface LastGuildViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UIView *createGuild;

@property (nonatomic, strong)UIView *guildCenter;

@property (nonatomic, strong)UITableView *guildCenterTableView;

@property (nonatomic, strong)NSArray *dataSource;

@property (nonatomic, strong)NSDictionary *userInfoDic;



@end

@implementation LastGuildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.guildCenterTableView.tableHeaderView = self.guildCenter;
    
    //    [self guildCenter];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *sectionArray = self.dataSource[section];
    return sectionArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


#pragma mark Get Set

- (UITableView *)guildCenterTableView{
    if (!_guildCenterTableView) {
        _guildCenterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight) style:UITableViewStylePlain];
        _guildCenterTableView.dataSource = self;
        _guildCenterTableView.delegate = self;
        _guildCenterTableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_guildCenterTableView];
    }
    return _guildCenterTableView;
}

//工会
- (UIView *)guildCenter{
    if (!_guildCenter) {
        _guildCenter = [[UIView alloc] initWithFrame:CGRectMake(0, dtNavBarDefaultHeight, dtScreenWidth, 160)];
        _guildCenter.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_guildCenter];
        
        UIView *guildInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dtScreenWidth, 150)];
        guildInfo.backgroundColor = [UIColor whiteColor];
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, dtScreenWidth, 1)];
        line.backgroundColor = [UIColor grayColor];
        [guildInfo addSubview:line];
        [_guildCenter addSubview:guildInfo];
        
        UIImageView *guildHeadImage = [[UIImageView alloc]initWithFrame:CGRectMake((100-60)/2, 20, 60, 60)];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",[self.dictionary objectForKey:@"headUrl"]]];
        [guildHeadImage setImageWithURL:url];
        guildHeadImage.layer.masksToBounds = YES;
        guildHeadImage.layer.cornerRadius = 30.0f;
        [guildInfo addSubview:guildHeadImage];
        
        UILabel *guildNick = [[UILabel alloc] init];
        guildNick.text = [self.dictionary objectForKey:@"name"];
        guildNick.textColor = [CorlorTransform colorWithHexString:@"ff6600"];
        guildNick.font = [UIFont systemFontOfSize:14.0];
        CGSize NickSize = [guildNick.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:guildNick.font,NSFontAttributeName, nil]];
        CGFloat nickSizeH = NickSize.height;
        CGFloat nickSizeW = NickSize.width;
        guildNick.frame = CGRectMake(guildHeadImage.frame.origin.y+guildHeadImage.frame.size.width+10,(100-nickSizeH)/3, nickSizeW, nickSizeH);
        [guildInfo addSubview:guildNick];
        
        
        /**经验条*/
        UILabel *experienceLabel = [[UILabel alloc] initWithFrame:CGRectMake(guildHeadImage.frame.origin.y+guildHeadImage.frame.size.width+10, guildNick.frame.origin.y+guildNick.frame.size.height+5, 100, 10)];
        //        experienceLabel.backgroundColor = [CorlorTransform colorWithHexString:@"#708090"];
        experienceLabel.layer.cornerRadius = 5;
        experienceLabel.layer.borderColor = [UIColor blackColor].CGColor;
        experienceLabel.layer.borderWidth = 1;
        experienceLabel.clipsToBounds = YES;
        [guildInfo addSubview:experienceLabel];
        CGFloat allNeedPeople;
        CGFloat people = [self.dictionary[@"exp"] integerValue];
        if ([self.dictionary[@"level"] integerValue]==1){
            allNeedPeople = 20;
        }else if ([self.dictionary[@"level"] integerValue]==2){
            allNeedPeople = 100;
        }else if ([self.dictionary[@"level"] integerValue]==3){
            allNeedPeople = 500;
        }else if ([self.dictionary[@"level"] integerValue]==4){
            allNeedPeople = 2000;
        }else if ([self.dictionary[@"level"] integerValue]==5){
            allNeedPeople = 5000;
        }else{
            allNeedPeople = 10000;
        }
        CGFloat baifenbi = people/allNeedPeople;
        /**公会人数比例*/
        UILabel * people_allNeedPeople = [[UILabel alloc]init];
        people_allNeedPeople.text = [NSString stringWithFormat:@"%ld/%ld",(long)people,(long)allNeedPeople];
        people_allNeedPeople.textColor = [UIColor grayColor];
        people_allNeedPeople.font = [UIFont systemFontOfSize:14.0];
        CGSize size_people = [people_allNeedPeople.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:people_allNeedPeople.font,NSFontAttributeName, nil]];
        people_allNeedPeople.frame = CGRectMake(experienceLabel.frame.origin.x+experienceLabel.frame.size.width+10, experienceLabel.frame.origin.y-2, size_people.width, size_people.height);
        [guildInfo addSubview:people_allNeedPeople];
        
        UILabel * colorLabel = [[UILabel alloc]initWithFrame:CGRectMake(experienceLabel.frame.origin.x+1, experienceLabel.frame.origin.y+1, (experienceLabel.frame.size.width-2)*baifenbi, experienceLabel.frame.size.height-2)];
        colorLabel.backgroundColor = [CorlorTransform colorWithHexString:@"#3399cc"];
        colorLabel.layer.cornerRadius = 4;
        colorLabel.clipsToBounds = YES;
        [guildInfo addSubview:colorLabel];
        
        UILabel *levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(guildHeadImage.frame.origin.y+guildHeadImage.frame.size.width+10, experienceLabel.frame.origin.y+experienceLabel.frame.size.height+5, 80, 10)];
        NSString *level = [self.dictionary objectForKey:@"level"];
        levelLabel.text = [NSString stringWithFormat:@"%@ 级公会",level];
        levelLabel.font = [UIFont systemFontOfSize:14.0];
        levelLabel.textColor = [CorlorTransform colorWithHexString:@"#ffd700"];
        UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, dtScreenWidth, 1)];
        line2.backgroundColor = [UIColor grayColor];
        [guildInfo addSubview:line2];
        [guildInfo addSubview:levelLabel];
        
        UIView *todayEarnings = [[UIView alloc] initWithFrame:CGRectMake(0, 101, dtScreenWidth/2-1, 49)];
        [_guildCenter addSubview:todayEarnings];
        UILabel *today = [[UILabel alloc] init];
        today.textColor = [UIColor blackColor];
        CGFloat earningsText = [[self.dictionary objectForKey:@"todayMoney"] doubleValue];
        today.text = [NSString stringWithFormat:@"今日收益:%.2f",earningsText];
        today.font = [UIFont systemFontOfSize:16.0];
        CGSize size_today = [today.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:today.font,NSFontAttributeName, nil]];
        today.frame = CGRectMake(todayEarnings.frame.size.width/2-size_today.width/2,todayEarnings.frame.size.height/2-size_today.height/2, size_today.width, size_today.height);
        [todayEarnings addSubview:today];
        
        UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(todayEarnings.frame.origin.x+todayEarnings.frame.size.width, 110, 2, 30)];
        line3.backgroundColor = [UIColor blackColor];
        [guildInfo addSubview:line3];
        
        UIView *sumEarnings = [[UIView alloc] initWithFrame:CGRectMake(dtScreenWidth/2+2, 101, dtScreenWidth/2-1, 49)];
        [_guildCenter addSubview:sumEarnings];
        UILabel *sum = [[UILabel alloc] init];
        sum.textColor = [UIColor blackColor];
        CGFloat sumText = [[self.dictionary objectForKey:@"totalMoney"] doubleValue];
        sum.font = [UIFont systemFontOfSize:16.0];
        sum.text = [NSString stringWithFormat:@"累计收益:%.2f",sumText];
        CGSize size_sum = [sum.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:sum.font,NSFontAttributeName, nil]];
        sum.frame = CGRectMake(sumEarnings.frame.size.width/2-size_sum.width/2,sumEarnings.frame.size.height/2-size_sum.height/2, size_sum.width, size_sum.height);
        [sumEarnings addSubview:sum];
        
    }
    return _guildCenter;
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
