//
//  PlayerView.m
//  MeiWan
//
//  Created by apple on 15/8/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "PlayerView.h"
#import "PalyListViewController.h"
#import "UIImageView+WebCache.h"
#import "Meiwan-Swift.h"
#import "CorlorTransform.h"
#import "UMSocial.h"
#import "creatAlbum.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@implementation PlayerView
- (void)setPlayerInfo:(NSDictionary *)playerInfo{
    NSArray * titlelabel = @[@"线上点歌",@"视屏聊天",@"聚餐",@"线下K歌",@"夜店达人",@"叫醒服务",@"影伴",@"运动健身",@"LOL"];
    _playerInfo = playerInfo;
    //NSLog(@"%@",playerInfo);
    self.hot.text = [NSString stringWithFormat:@"%d",[[playerInfo objectForKey:@"hot"]intValue]];
    NSURL *headUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",[playerInfo objectForKey:@"headUrl"]]];
    //NSLog(@"%@",headUrl);
    [self.Head setImageWithURL:headUrl placeholderImage:nil];
    self.Head.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPlayerInfo)];
    [self.Head addGestureRecognizer:tapges];
    
    self.signature.text = [playerInfo objectForKey:@"description"];
    
    self.signature.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    
//达人昵称
    self.nicename.text = [playerInfo objectForKey:@"nickname"];
    //self.nicename.font = [UIFont systemFontOfSize:12.0];
    self.nicename.font = [FontOutSystem fontWithFangZhengSize:12.0];
    CGSize size = [self.nicename.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.nicename.font,NSFontAttributeName, nil]];
    CGFloat nameH = size.height;
    CGFloat nameW = size.width;
    if (nameW>[UIScreen mainScreen].bounds.size.width/4) {
        self.nicename.frame = CGRectMake(7, self.Head.frame.size.height , [UIScreen mainScreen].bounds.size.width/4-20 ,nameH );
    }else{
        self.nicename.frame = CGRectMake(7, self.Head.frame.size.height , nameW ,nameH );
    }
    self.nicename.textColor = [UIColor blackColor];
    [self addSubview:self.nicename];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy";
    NSString *year = [formatter stringFromDate:today];
    int yearnow = year.intValue;
    int birthyear = [[playerInfo objectForKey:@"year"]intValue];
    int age = yearnow - birthyear;
//达人年龄标签
    NSString *userAge = [NSString stringWithFormat:@"%d",age];
    self.age.textColor = RGB(174, 174, 174);
    self.age.text = userAge;
    //self.age.font = [UIFont systemFontOfSize:12.0];
    self.age.font = [FontOutSystem fontWithFangZhengSize:12.0];
    CGSize ageSize = [self.age.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.age.font,NSFontAttributeName, nil]];
    self.age.frame = CGRectMake(self.nicename.frame.size.width+self.nicename.frame.origin.x+5, self.nicename.frame.origin.y, ageSize.width+2, ageSize.height);
    [self addSubview:self.age];
//性别图片
    self.sex = [[UIImageView alloc]initWithFrame:CGRectMake(self.age.frame.size.width+self.age.frame.origin.x, self.age.center.y-5, 10, 10)];
    if ([[playerInfo objectForKey:@"gender"]intValue] == 0) {
        self.sex.image = [UIImage imageNamed:@"nansheng_logo"];
        self.ageAndsex.backgroundColor = [CorlorTransform colorWithHexString:@"#007aff" andAlpha:88/255.0 ];
    }else{
        self.sex.image = [UIImage imageNamed:@"nvsheng_logo"];
        self.ageAndsex.backgroundColor = [CorlorTransform colorWithHexString:@"#ffc0cb" andAlpha:1.0];
    }
    [self addSubview:self.sex];
    
//定位标签
    self.distance = [[UILabel alloc]init];
    if ([[playerInfo objectForKey:@"distance"]doubleValue]>1000)
    {
        if ([[playerInfo objectForKey:@"distance"]doubleValue]/1000>1000) {
            self.distance.text = @"太遥远";
        }else{
        
            self.distance.text = [NSString stringWithFormat:@"%.1f km", [[_playerInfo objectForKey:@"distance"] doubleValue]/1000];
        }
    }
    else
    {
        self.distance.text = [NSString stringWithFormat:@"%.1f m", [[playerInfo objectForKey:@"distance"] doubleValue]];
    }
    self.distance.textColor = self.age.textColor;
    //self.distance.font = [UIFont systemFontOfSize:12.0];
    self.distance.font = [FontOutSystem fontWithFangZhengSize:12.0];
    CGSize locationSize = [self.distance.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.distance.font,NSFontAttributeName, nil]];
    self.distance.frame = CGRectMake(dtScreenWidth/2-5-locationSize.width, self.age.frame.origin.y, locationSize.width, locationSize.height);
    [self addSubview:self.distance];
//定位图标
    UIImageView * locationImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.distance.frame.origin.x-10, self.age.center.y-5, 10, 10)];
    locationImage.image = [UIImage imageNamed:@"juli"];
    [self addSubview:locationImage];
    self.location = locationImage;
    
    self.biaoqian1 = [[UILabel alloc]init];
    self.biaoqian2 = [[UILabel alloc]init];
    self.biaoqian3 = [[UILabel alloc]init];
    self.biaoqianImage1 = [[UIImageView alloc]init];
    self.biaoqianImage2 = [[UIImageView alloc]init];
    self.biaoqianImage3 = [[UIImageView alloc]init];
    
    NSArray * usertimeTags = [playerInfo objectForKey:@"userTimeTags"];
   // NSLog(@"%@",usertimeTags);
    if (usertimeTags.count==1) {
        NSDictionary * dic1 = usertimeTags[0];
        
        NSString * index = dic1[@"index"];

        self.biaoqian1.text = [titlelabel objectAtIndex:[index integerValue]-1];
        self.biaoqian1.textColor = [UIColor whiteColor];
        self.biaoqian1.font = [UIFont systemFontOfSize:9.0];
        
        CGSize biao1size = [self.biaoqian1.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.biaoqian1.font,NSFontAttributeName, nil]];
        self.biaoqian1.frame = CGRectMake(self.Head.frame.size.width-5-biao1size.width, self.Head.frame.size.height-biao1size.height-10, biao1size.width, biao1size.height);
        
        self.biaoqianImage1.frame = CGRectMake(self.biaoqian1.frame.origin.x-2,self.biaoqian1.frame.origin.y-6 , biao1size.width + 4, biao1size.height + 8);
        self.biaoqianImage1.image = [UIImage imageNamed:@"biaoqian"];
        [self addSubview:self.biaoqianImage1];
        [self addSubview:self.biaoqian1];
        
        
    }else if (usertimeTags.count==2){
        
        NSDictionary * dic1 = usertimeTags[0];
        
        NSString * index = dic1[@"index"];
        
        self.biaoqian1.text = [titlelabel objectAtIndex:[index integerValue]-1];
        self.biaoqian1.font = [UIFont systemFontOfSize:9.0];
        self.biaoqian1.textColor = [UIColor whiteColor];
        CGSize biao1size = [self.biaoqian1.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.biaoqian1.font,NSFontAttributeName, nil]];
        self.biaoqian1.frame = CGRectMake(self.Head.frame.size.width-5-biao1size.width, self.Head.frame.size.height-biao1size.height-10, biao1size.width, biao1size.height);
        
        self.biaoqianImage1.frame = CGRectMake(self.biaoqian1.frame.origin.x-2,self.biaoqian1.frame.origin.y-6 , biao1size.width + 4, biao1size.height + 8);
        self.biaoqianImage1.image = [UIImage imageNamed:@"biaoqian"];
        [self addSubview:self.biaoqianImage1];
        [self addSubview:self.biaoqian1];
        
        NSDictionary * dic2 = usertimeTags[1];
        
        NSString * index2 = dic2[@"index"];
        
        self.biaoqian2.text = [titlelabel objectAtIndex:[index2 integerValue]-1];
        self.biaoqian2.font = [UIFont systemFontOfSize:9.0];
        self.biaoqian2.textColor = [UIColor whiteColor];
        CGSize biao2size = [self.biaoqian2.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.biaoqian2.font,NSFontAttributeName, nil]];
        self.biaoqian2.frame = CGRectMake(self.biaoqian1.frame.origin.x-10-biao2size.width, self.biaoqian1.frame.origin.y, biao2size.width, biao2size.height);
        self.biaoqianImage2.frame = CGRectMake(self.biaoqian2.frame.origin.x-2,self.biaoqian2.frame.origin.y-6 , biao2size.width + 4, biao2size.height + 8);
        self.biaoqianImage2.image = [UIImage imageNamed:@"biaoqian"];
        [self addSubview:self.biaoqianImage2];
        [self addSubview:self.biaoqian2];
        
    }else if (usertimeTags.count==3){
        NSDictionary * dic1 = usertimeTags[0];
        
        NSString * index = dic1[@"index"];
        
        self.biaoqian1.text = [titlelabel objectAtIndex:[index integerValue]-1];
        self.biaoqian1.font = [UIFont systemFontOfSize:9.0];
        self.biaoqian1.textColor = [UIColor whiteColor];
        CGSize biao1size = [self.biaoqian1.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.biaoqian1.font,NSFontAttributeName, nil]];
        self.biaoqian1.frame = CGRectMake(self.Head.frame.size.width-5-biao1size.width, self.Head.frame.size.height-biao1size.height-10, biao1size.width, biao1size.height);
        
        self.biaoqianImage1.frame = CGRectMake(self.biaoqian1.frame.origin.x-2,self.biaoqian1.frame.origin.y-6 , biao1size.width + 4, biao1size.height + 8);
        self.biaoqianImage1.image = [UIImage imageNamed:@"biaoqian"];
        [self addSubview:self.biaoqianImage1];
        [self addSubview:self.biaoqian1];
        
        NSDictionary * dic2 = usertimeTags[1];
        NSString * index2 = dic2[@"index"];
        self.biaoqian2.text = [titlelabel objectAtIndex:[index2 integerValue]-1];
        self.biaoqian2.font = [UIFont systemFontOfSize:9.0];
        self.biaoqian2.textColor = [UIColor whiteColor];
        CGSize biao2size = [self.biaoqian2.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.biaoqian2.font,NSFontAttributeName, nil]];
        self.biaoqian2.frame = CGRectMake(self.biaoqian1.frame.origin.x-10-biao2size.width, self.biaoqian1.frame.origin.y, biao2size.width, biao2size.height);
        
        self.biaoqianImage2.frame = CGRectMake(self.biaoqian2.frame.origin.x-2,self.biaoqian2.frame.origin.y-6 , biao2size.width + 4, biao2size.height + 8);
        self.biaoqianImage2.image = [UIImage imageNamed:@"biaoqian"];
        [self addSubview:self.biaoqianImage2];
        [self addSubview:self.biaoqian2];
        
        NSDictionary * dic3 = usertimeTags[2];
        NSString * index3 = dic3[@"index"];
        self.biaoqian3.text = [titlelabel objectAtIndex:[index3 integerValue]-1];
        self.biaoqian3.font = [UIFont systemFontOfSize:9.0];
        self.biaoqian3.textColor = [UIColor whiteColor];
        CGSize biao3size = [self.biaoqian3.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.biaoqian3.font,NSFontAttributeName, nil]];
        self.biaoqian3.frame = CGRectMake(self.biaoqian2.frame.origin.x-biao3size.width-10, self.biaoqian2.frame.origin.y, biao3size.width, biao3size.height);
        
        self.biaoqianImage3.frame = CGRectMake(self.biaoqian3.frame.origin.x-2,self.biaoqian3.frame.origin.y-6 , biao3size.width + 4, biao3size.height + 8);
        self.biaoqianImage3.image = [UIImage imageNamed:@"biaoqian"];
        [self addSubview:self.biaoqianImage3];
        [self addSubview:self.biaoqian3];
        
    }else{
        
    }
    //时间金钱
    self.offlinePrice = [[UILabel alloc]init];
    NSDictionary *userInfo = [PersistenceManager getLoginUser];
    NSString *thesame = [NSString stringWithFormat:@"%ld",[[userInfo objectForKey:@"id"]longValue]];
    if ([thesame isEqualToString:@"100000"] || [thesame isEqualToString:@"100001"]) {
        self.offlinePrice.hidden = YES;
    }else{
        self.offlinePrice.text = [NSString stringWithFormat:@"成功订单数:%@",[playerInfo objectForKey:@"orderAmount"]];
    }
    self.offlinePrice.font = [UIFont systemFontOfSize:10.0];
    self.offlinePrice.textColor = RGB(110, 110, 110);
    CGSize moneyAndHourSize = [self.offlinePrice.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.offlinePrice.font,NSFontAttributeName, nil]];
    self.offlinePrice.frame = CGRectMake(7, self.nicename.frame.size.height+self.nicename.frame.origin.y+2.5, moneyAndHourSize.width, moneyAndHourSize.height);
    [self addSubview:self.offlinePrice];
    
    self.login_time = [[UILabel alloc]init];
    double lastActiveTime = [[playerInfo objectForKey:@"lastActiveTime"]doubleValue];
    self.login_time.text = [DateTool getTimeDescription:lastActiveTime];
    self.login_time.font = [UIFont systemFontOfSize:8.0];
    CGSize loginSize = [self.login_time.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.login_time.font,NSFontAttributeName, nil]];
    self.login_time.frame = CGRectMake(dtScreenWidth/2-5-loginSize.width, self.nicename.frame.size.height+self.nicename.frame.origin.y+2.5, loginSize.width, loginSize.height);
    [self addSubview:self.login_time];
    //NSLog(@"%f",lastActiveTime) ;
    
}
- (IBAction)getPlayerInfo:(UITapGestureRecognizer *)sender {
    [self.delegate showPlayerInfo:self.playerInfo];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.ageAndsex.layer.cornerRadius = 5;
    self.ageAndsex.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    //用户图片
    UIImageView * userImage = [[UIImageView alloc]init];
    if (IS_IPHONE_4_OR_LESS) {
        userImage.frame = CGRectMake(0, 0, dtScreenWidth/2-5, 185);
    }else if (IS_IPHONE_5){
        userImage.frame = CGRectMake(0, 0, dtScreenWidth/2-5, 185);
    }else if (IS_IPHONE_6){
       userImage.frame = CGRectMake(0, 0, dtScreenWidth/2-5, 200);
    }else if (IS_IPHONE_6P){
        userImage.frame = CGRectMake(0, 0, dtScreenWidth/2-5, 200);
    }
    userImage.contentMode = UIViewContentModeScaleAspectFill;
    userImage.clipsToBounds = YES;
    [self addSubview:userImage];
    self.Head = userImage;
    UIImageView * huabian = [[UIImageView alloc]initWithFrame:CGRectMake(0, _Head.frame.size.height-2, _Head.frame.size.width, 2)];
    huabian.image = [UIImage imageNamed:@"huabian"];
    [self.Head addSubview:huabian];
    //热门图片
    UIImageView * fireImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, -7, 14, 30)];
    fireImage.image = [UIImage imageNamed:@"hot"];
    [self addSubview:fireImage];
    //热门数字
    UILabel * fireNumber = [[UILabel alloc]initWithFrame:CGRectMake(fireImage.frame.origin.x+fireImage.frame.size.width+5, 7, self.frame.size.width-40, 18)];
    fireNumber.text = @"18";
    fireNumber.textColor = RGB(248, 24, 24);
    fireNumber.font = [UIFont systemFontOfSize:18];
    [self addSubview:fireNumber];
    self.hot = fireNumber;
    //昵称
    self.nicename = [[UILabel alloc]init];
    //用户年龄
    self.age = [[UILabel alloc]init];

}
- (void)showPlayerInfo
{
    [self.delegate showPlayerInfo:_playerInfo];
}


@end
