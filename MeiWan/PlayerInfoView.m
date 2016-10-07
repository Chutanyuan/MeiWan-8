//
//  PlayerInfoView.m
//  MeiWan
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "PlayerInfoView.h"
#import "UIImageView+WebCache.h"
#import "CorlorTransform.h"
#import "Meiwan-Swift.h"

@implementation PlayerInfoView

-(void)setPlayerInfoDic:(NSDictionary *)playerInfoDic{
    _playerInfoDic = playerInfoDic;
    NSURL *headUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",[playerInfoDic objectForKey:@"headUrl"]]];
    [self.head setImageWithURL:headUrl placeholderImage:nil];
    
    long myid = [[playerInfoDic objectForKey:@"id"]longValue];
    NSString *userIdtext = [NSString stringWithFormat:@"ID%ld",myid];
    self.userId.text = userIdtext;
    self.signature.text=[playerInfoDic objectForKey:@"description"];
    if ([[playerInfoDic objectForKey:@"gender"]intValue] == 0) {
        self.sexImage.image = [UIImage imageNamed:@"peiwan_male"];
        self.ageAndSex.backgroundColor = [CorlorTransform colorWithHexString:@"#007aff" andAlpha:88/255.0];
    }else{
        self.sexImage.image = [UIImage imageNamed:@"peiwan_female"];
        self.ageAndSex.backgroundColor = [CorlorTransform colorWithHexString:@"#ffc0cb"];
    }
    
    NSArray *assess = [playerInfoDic objectForKey:@"userTags"];
    
    if (assess.count == 1) {
        NSDictionary *assess1Dic = assess[0];
        NSURL *assess1url = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",[assess1Dic objectForKey:@"url"]]];
        //NSLog(@"%@",[assess1Dic objectForKey:@"url"]);
        [self.labImage3 setImageWithURL:assess1url];
    }else if(assess.count == 2){
        NSDictionary *assess1Dic = assess[0];
        NSURL *assess1url = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",[assess1Dic objectForKey:@"url"]]];
        // NSLog(@"%@",[assess1Dic objectForKey:@"url"]);
        [self.labImage3 setImageWithURL:assess1url];
        NSDictionary *assess2Dic = assess[1];
        NSURL *assess2url = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",[assess2Dic objectForKey:@"url"]]];
        [self.labImage1 setImageWithURL:assess2url];
    }else if(assess.count >= 3){
        NSDictionary *assess1Dic = assess[0];
        NSURL *assess1url = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",[assess1Dic objectForKey:@"url"]]];
        // NSLog(@"%@",[assess1Dic objectForKey:@"url"]);
        [self.labImage3 setImageWithURL:assess1url];
        NSDictionary *assess2Dic = assess[1];
        NSURL *assess2url = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",[assess2Dic objectForKey:@"url"]]];
        [self.labImage1 setImageWithURL:assess2url];
        NSDictionary *assess3Dic = assess[2];
        NSURL *assess3url = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",[assess3Dic objectForKey:@"url"]]];
        [self.labImage2 setImageWithURL:assess3url];
    }else{
        
    }
    
    
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy";
    NSString *year = [formatter stringFromDate:today];
    int yearnow = year.intValue;
    int birthyear = [[playerInfoDic objectForKey:@"year"]intValue];
    int age = yearnow - birthyear;
    NSString *userAge = [NSString stringWithFormat:@"%d",age];
    self.age.textColor = [UIColor whiteColor];
    self.age.text = userAge;
    
    float rateAmount = [[playerInfoDic objectForKey:@"rateAmount"]floatValue];
    float rateNumber = [[playerInfoDic objectForKey:@"rateNumber"]floatValue];
    self.starRateView = [[CWStarRateView alloc] initWithFrame:self.starView.bounds numberOfStars:5];
    self.starRateView.scorePercent = rateAmount/rateNumber/5.0;
    self.starRateView.allowIncompleteStar = YES;
    self.starRateView.hasAnimation = YES;
    self.starRateView.userInteractionEnabled = NO;
    [self.starView addSubview:self.starRateView];
    
    self.scroce.text = [NSString stringWithFormat:@"%0.1f",rateAmount/rateNumber*1.0];
    
    if ([[playerInfoDic objectForKey:@"distance"]intValue]>1000) {
        self.distance.text = [NSString stringWithFormat:@"%.1f km", [[playerInfoDic objectForKey:@"distance"] doubleValue]/1000];
    }else{
        self.distance.text = [NSString stringWithFormat:@"%.1f m", [[playerInfoDic objectForKey:@"distance"]doubleValue]];
    }
    
    
}

-(void)setStateDic:(NSDictionary *)stateDic{
    _stateDic = stateDic;
    NSString * stateText = [stateDic objectForKey:@"content"];
    if (stateText.length != 0 && stateText) {
        self.stateContent.text = stateText;
    }else if(stateText.length == 0 && stateText){
        self.stateContent.text = @"未发布文字";
    }
    
    NSArray *images = [stateDic objectForKey:@"statePhotos"];
    if (images) {
        if (images.count == 3) {
            if ([images[0] isKindOfClass:[NSNull class]] && [images[1] isKindOfClass:[NSNull class]] && [images[2] isKindOfClass:[NSNull class]]){
                self.noticeUser.text = @"未发布图片";
            }else if (![images[0] isKindOfClass:[NSNull class]] && [images[1] isKindOfClass:[NSNull class]] && [images[2] isKindOfClass:[NSNull class]]){
                
                NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",images[0]]];
                [self.stateImage1 setImageWithURL:url1];
            }else if (![images[0] isKindOfClass:[NSNull class]] && ![images[1] isKindOfClass:[NSNull class]] && [images[2] isKindOfClass:[NSNull class]]){
                
                NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",images[0]]];
                [self.stateImage1 setImageWithURL:url1];
                NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",images[1]]];
                [self.stateImage2 setImageWithURL:url2];
            }else if (![images[0] isKindOfClass:[NSNull class]] && ![images[0] isKindOfClass:[NSNull class]] && ![images[0] isKindOfClass:[NSNull class]]){
                
                NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",images[0]]];
                [self.stateImage1 setImageWithURL:url1];
                NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",images[1]]];
                [self.stateImage2 setImageWithURL:url2];
                NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",images[2]]];
                [self.stateImage3 setImageWithURL:url3];
                
            }else{
                
            }
        }else if (images.count == 1){
            NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",images[0]]];
            [self.stateImage1 setImageWithURL:url1];
        }
        
    }else{
        self.noticeUser.text = @"尚未发布动态";
    }
}
-(void)awakeFromNib{
    
    [self setUpLoadUserInfo];
    
   
    UIButton * buttonone = [UIButton buttonWithType:UIButtonTypeCustom];
    if (IS_IPHONE_4_OR_LESS) {
        NSLog(@"4s版本");
        buttonone.frame = CGRectMake(self.playWithView.frame.origin.x, self.playWithView.frame.origin.y+self.playWithView.frame.size.height-30, [UIScreen mainScreen].bounds.size.width/2-10, 30);
    }else if (IS_IPHONE_5){
        NSLog(@"5-5S版本");
        buttonone.frame = CGRectMake(self.playWithView.frame.origin.x, self.playWithView.frame.origin.y+self.playWithView.frame.size.height-30, [UIScreen mainScreen].bounds.size.width/2-10, 30);
    }else if (IS_IPHONE_6){
        NSLog(@"6-6S版本");
        buttonone.frame = CGRectMake(self.playWithView.frame.origin.x, self.playWithView.frame.origin.y+self.playWithView.frame.size.height-12, [UIScreen mainScreen].bounds.size.width/2-10, 30);
    }else if (IS_IPHONE_6P){
        NSLog(@"6P-版本");
        buttonone.frame = CGRectMake(self.playWithView.frame.origin.x, self.playWithView.frame.origin.y+self.playWithView.frame.size.height, [UIScreen mainScreen].bounds.size.width/2-10, 30);
    }
    
    buttonone.backgroundColor = [CorlorTransform colorWithHexString:@"#36C8FF"];
    [buttonone setTitle:@"约TA" forState:UIControlStateNormal];
    [self addSubview:buttonone];
    [buttonone addTarget:self action:@selector(getInvie:) forControlEvents:UIControlEventTouchUpInside];
    self.orderButton = buttonone;
    
    UIButton * buttonotwo = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonotwo.frame = CGRectMake(buttonone.frame.size.width+10, buttonone.frame.origin.y, [UIScreen mainScreen].bounds.size.width-(buttonone.frame.size.width+10), 30);
    buttonotwo.backgroundColor = [CorlorTransform colorWithHexString:@"#36C8FF"];
    [buttonotwo setTitle:@"打招呼" forState:UIControlStateNormal];
    [buttonotwo addTarget:self action:@selector(getChat2:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:buttonotwo];
    self.helloButton = buttonotwo;

    
    self.orderButton.hidden = YES;
    self.hello2button.hidden = YES;
    self.helloButton.hidden = YES;
    
    NSString *thesame = [NSString stringWithFormat:@"%ld",self.userinfo.userId];
    
    if ([thesame isEqualToString:@"100000"] || [thesame isEqualToString:@"100001"]) {
        self.orderButton.hidden = YES;
        self.hello2button.hidden = NO;
        self.helloButton.hidden = YES;
    }else{
        self.orderButton.hidden = NO;
        self.hello2button.hidden = YES;
        self.helloButton.hidden = NO;
    }
    
    self.head.layer.cornerRadius = self.head.bounds.size.width/2;
    self.head.layer.masksToBounds = YES;
    
    self.stateImage1.clipsToBounds = YES;
    self.stateImage2.clipsToBounds = YES;
    self.stateImage3.clipsToBounds = YES;
    
    [self.orderButton setBackgroundColor:[CorlorTransform colorWithHexString:@"#36C8FF"]];
    [self.orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.helloButton setBackgroundColor:[CorlorTransform colorWithHexString:@"#36C8FF"]];
    [self.helloButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.hello2button setBackgroundColor:[CorlorTransform colorWithHexString:@"#36C8FF"]];
    [self.hello2button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.talkWith setBackgroundColor:[CorlorTransform colorWithHexString:@"#36C8FF"]];
    [self.talkWith setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.ageAndSex.layer.cornerRadius = 3.0;

}

- (IBAction)showPicture:(UITapGestureRecognizer *)sender {
    [self.delegate showpicture];
}

- (IBAction)getState:(UITapGestureRecognizer *)sender {
    [self.delegate showState];
}
- (IBAction)getInChat:(UIButton *)sender {
    [self.delegate showChat];
}

- (void)getInvie:(id)sender {
    [self.delegate showInvite];
}

- (void)getChat2:(id)sender {
    [self.delegate showChat];
}

- (void)setUpLoadUserInfo{
    self.userInfoDic = [PersistenceManager getLoginUser];
    self.userinfo = [[UserInfo alloc]initWithDictionary: [PersistenceManager getLoginUser]];

}
@end
