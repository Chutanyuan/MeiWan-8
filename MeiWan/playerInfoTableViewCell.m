//
//  playerInfoTableViewCell.m
//  beautity_play
//
//  Created by mac on 16/7/5.
//  Copyright © 2016年 user_kevin. All rights reserved.
//

#import "playerInfoTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Meiwan-Swift.h"

@implementation playerInfoTableViewCell

-(void)setPlayerInfo:(NSDictionary *)playerInfo{
    _playerInfo = playerInfo;
    
    UIImageView *head = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 50, 50)];
    NSURL *headUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",[_playerInfo objectForKey:@"headUrl"]]];
    [head setImageWithURL:headUrl placeholderImage:nil];
    head.layer.masksToBounds = YES;
    head.layer.cornerRadius = 25.f;
    head.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:head];
    self.playerHeadImage = head;
    
    UILabel *name = [[UILabel alloc]init];
    name.text = [_playerInfo objectForKey:@"nickname"];
    name.font = [UIFont systemFontOfSize:13.0f];
    CGSize nameSize = [name.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:name.font,NSFontAttributeName, nil]];
    CGFloat nameSizeH = nameSize.height;
    CGFloat nameSizeW = nameSize.width;
    if (nameSizeW>[UIScreen mainScreen].bounds.size.width/3) {
        name.frame = CGRectMake(head.frame.origin.x+head.frame.size.width+10, 10, [UIScreen mainScreen].bounds.size.width/3, nameSizeH);
    }else{
        name.frame = CGRectMake(head.frame.origin.x+head.frame.size.width+10, 10, nameSizeW, nameSizeH);
    }
    [self addSubview:name];
    self.playerName = name;
    
    UILabel *age = [[UILabel alloc] init];
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy";
    NSString *year = [formatter stringFromDate:today];
    int yearnow = year.intValue;
    int birthyear = [[_playerInfo objectForKey:@"year"]intValue];
    int ageNum = yearnow - birthyear;
    NSString *userAge = [NSString stringWithFormat:@"%d",ageNum];
    age.textColor = [UIColor whiteColor];
    age.text = userAge;
    age.font = [UIFont systemFontOfSize:13.0f];
    age.textColor = [UIColor grayColor];
    CGSize ageSize = [age.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:age.font,NSFontAttributeName, nil]];
    CGFloat ageSizeH = ageSize.height;
    CGFloat ageSizeW = ageSize.width;
    age.frame = CGRectMake(name.frame.origin.x+name.frame.size.width+5, 10, ageSizeW, ageSizeH);
    [self addSubview:age];
    self.playerAge = age;
    
    UIImageView *sexImage = [[UIImageView alloc] initWithFrame:CGRectMake(age.frame.origin.x+ageSizeW+5, 10, 14, 14)];
    if ([[_playerInfo objectForKey:@"gender"]intValue] == 0) {
        sexImage.image = [UIImage imageNamed:@"nansheng_logo"];
    }else{
        sexImage.image = [UIImage imageNamed:@"nvsheng_logo"];
    }
    
    [self addSubview:sexImage];
    self.playerSex = sexImage;
    
    UILabel *userID = [[UILabel alloc] init];
    long myid = [[_playerInfo objectForKey:@"id"]longValue];
    NSString *userIdtext = [NSString stringWithFormat:@"ID%ld",myid];
    userID.text = userIdtext;
    userID.font = [UIFont systemFontOfSize:13.0f];
    CGSize userIDSize = [userID.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:userID.font,NSFontAttributeName, nil]];
    CGFloat userIDSizeH = userIDSize.height;
    CGFloat userIDSizeW = userIDSize.width;
    userID.frame = CGRectMake(head.frame.origin.x+head.frame.size.width+10, (66-userIDSizeH)/2+2, userIDSizeW, userIDSizeH);
    [self addSubview:userID];
    self.playerID = userID;
    
    UILabel *sign = [[UILabel alloc] init];
    sign.text = [_playerInfo objectForKey:@"description"];
    sign.font = [UIFont systemFontOfSize:13.0f];
    CGSize signSize = [sign.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:sign.font,NSFontAttributeName, nil]];
    CGFloat signSizeH = signSize.height;
    // CGFloat signSizeW = signSize.width;
    sign.frame = CGRectMake(head.frame.origin.x+head.frame.size.width+10, userID.frame.origin.y+userIDSizeH+2,self.frame.size.width-85,signSizeH);
    [self addSubview:sign];
    self.playerSign = sign;
    
    //        CGSize threeSize = [threeLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:threeLabel.font,NSFontAttributeName, nil]];
    //        CGFloat threeSizeH = threeSize.height;
    //        CGFloat threeSizeW = threeSize.width;
    
    UILabel *lastTime = [[UILabel alloc] init];
    double lastActiveTime = [[_playerInfo objectForKey:@"lastActiveTime"]doubleValue];
    lastTime.text = [DateTool getTimeDescription:lastActiveTime];
    lastTime.font = [UIFont systemFontOfSize:10.0f];
    CGSize lastTimeSize = [lastTime.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:lastTime.font,NSFontAttributeName, nil]];
    CGFloat lastTimeSizeH = lastTimeSize.height;
    CGFloat lastTimeSizeW = lastTimeSize.width;
    lastTime.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-lastTimeSizeW-10, 8, lastTimeSizeW, lastTimeSizeH);
    [self addSubview:lastTime];
    self.lastLoginTime = lastTime;
    
    UILabel *location = [[UILabel alloc] init];
    if ([[_playerInfo objectForKey:@"distance"]intValue]>1000) {
        
        location.text = [NSString stringWithFormat:@"%.1f km", [[_playerInfo objectForKey:@"distance"] doubleValue]/1000];
        
    }else{
        location.text = [NSString stringWithFormat:@"%.1f m", [[_playerInfo objectForKey:@"distance"]doubleValue]];
    }
    location.font = [UIFont systemFontOfSize:10.0f];
    CGSize locationSize = [location.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:location.font,NSFontAttributeName, nil]];
    CGFloat locationSizeH = locationSize.height;
    CGFloat locationSizeW = locationSize.width;
    location.textColor = [UIColor grayColor];
    location.frame = CGRectMake(lastTime.frame.origin.x-locationSizeW-5, self.lastLoginTime.frame.origin.y, locationSizeW, locationSizeH);
    [self addSubview:location];
    self.locationLabel = location;
    
    UIImageView *locationImage = [[UIImageView alloc] initWithFrame:CGRectMake(location.frame.origin.x-18, 7, 15, 15)];
    locationImage.image = [UIImage imageNamed:@"juli"];
    [self addSubview:locationImage];
    self.locationImage = locationImage;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        _playerInfo = [defaults objectForKey:@"playerinfo"];
        
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
