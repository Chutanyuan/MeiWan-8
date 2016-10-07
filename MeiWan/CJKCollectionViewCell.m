//
//  CJKCollectionViewCell.m
//  beautity_play
//
//  Created by user_kevin on 16/6/26.
//  Copyright © 2016年 user_kevin. All rights reserved.
//

#import "CJKCollectionViewCell.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@implementation CJKCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        //用户图片
        UIImageView * userImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-29)];
        userImage.backgroundColor = [UIColor orangeColor];
        [self addSubview:userImage];
        self.userImage = userImage;
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
        self.hotNumber = fireNumber;
        //昵称
        UILabel * nickLabel = [[UILabel alloc]init];
        nickLabel.font = [UIFont systemFontOfSize:12.0];;
        nickLabel.text = @"Ivan_blank";
        CGSize size = [nickLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:nickLabel.font,NSFontAttributeName, nil]];
        CGFloat nameH = size.height;
        CGFloat nameW = size.width;
        nickLabel.frame = CGRectMake(7, 200-29 , nameW ,nameH );
        nickLabel.textColor = [UIColor blackColor];
        [self addSubview:nickLabel];
        self.nickNameLabel = nickLabel;
        //用户年龄
        UILabel * userAge = [[UILabel alloc]init];
        userAge.font = [UIFont systemFontOfSize:12.0];
        userAge.text = @"22";
        userAge.textColor = RGB(174, 174, 174);
        CGSize ageSize = [userAge.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:userAge.font,NSFontAttributeName, nil]];
        userAge.frame = CGRectMake(nickLabel.frame.size.width+nickLabel.frame.origin.x+5, nickLabel.frame.origin.y, ageSize.width, ageSize.height);
        [self addSubview:userAge];
        self.ageLabel = userAge;
        //性别图标
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(userAge.frame.size.width+userAge.frame.origin.x+5, userAge.frame.origin.y+2, 10, 10)];
        imageView.image = [UIImage imageNamed:@"nvsheng_logo"];
        [self addSubview:imageView];
        //定位图标
        UIImageView * locationImage = [[UIImageView alloc]initWithFrame:CGRectMake(imageView.frame.size.width+imageView.frame.origin.x+5, imageView.frame.origin.y, 10, 10)];
        locationImage.image = [UIImage imageNamed:@"juli"];
        [self addSubview:locationImage];
        //定位标签
        UILabel * locationLabel = [[UILabel alloc]init];
        locationLabel.text = @"3.7 km";
        locationLabel.textColor = userAge.textColor;
        locationLabel.font = [UIFont systemFontOfSize:12.0];
        CGSize locationSize = [locationLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:locationLabel.font,NSFontAttributeName, nil]];
        locationLabel.frame = CGRectMake(locationImage.frame.origin.x+locationImage.frame.size.width, userAge.frame.origin.y, locationSize.width, locationSize.height);
        [self addSubview:locationLabel];
        self.locationLabel = locationLabel;
        //时间金钱
        UILabel * moneyAndHour = [[UILabel alloc]init];
        moneyAndHour.text = @"39元/小时";
        moneyAndHour.font = [UIFont systemFontOfSize:8.0];
        moneyAndHour.textColor = RGB(110, 110, 110);
        CGSize moneyAndHourSize = [moneyAndHour.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:moneyAndHour.font,NSFontAttributeName, nil]];
        moneyAndHour.frame = CGRectMake(7, nickLabel.frame.size.height+nickLabel.frame.origin.y+2.5, moneyAndHourSize.width, moneyAndHourSize.height);
        [self addSubview:moneyAndHour];
        self.priceLabel = moneyAndHour;
        
        //图片拉伸
        UIImage *image = [UIImage imageNamed:@"biaoqian"];
        NSInteger leftCapWidth = image.size.width * 0.9;
        NSInteger topCapHeight = image.size.height * 0.9;
        UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];

        //三个标签label
        UILabel * oneLabel = [[UILabel alloc]init];
        oneLabel.text = @"电影";
        oneLabel.textColor = [UIColor whiteColor];
        oneLabel.textAlignment = NSTextAlignmentCenter;
        oneLabel.font = [UIFont systemFontOfSize:9.0];
        CGSize oneSize = [oneLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:oneLabel.font,NSFontAttributeName, nil]];
        oneLabel.frame = CGRectMake(CGRectGetWidth(self.bounds)-oneSize.width-6, CGRectGetHeight(self.userImage.frame)-oneSize.height-4, oneSize.width+6, oneSize.height+5);
        UIImageView * oneImage = [[UIImageView alloc]initWithFrame:CGRectMake(oneLabel.frame.origin.x, oneLabel.frame.origin.y-3, oneLabel.frame.size.width, oneLabel.frame.size.height+2)];
        oneImage.image = newImage;
        [self addSubview:oneImage];
        [self addSubview:oneLabel];
        self.rightlabel = oneLabel;
        //
        UILabel * centerlabel = [[UILabel alloc]init];
        centerlabel.font = oneLabel.font;
        centerlabel.textAlignment = NSTextAlignmentCenter;
        centerlabel.textColor = [UIColor whiteColor];
        centerlabel.text = @"与TA共餐";
        CGSize centerSize = [centerlabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:centerlabel.font,NSFontAttributeName, nil]];
        centerlabel.frame = CGRectMake(oneLabel.frame.origin.x - 5 - centerSize.width - 6, oneLabel.frame.origin.y, centerSize.width + 6, centerSize.height + 5);
        UIImageView * centerImage = [[UIImageView alloc]initWithFrame:CGRectMake(centerlabel.frame.origin.x, centerlabel.frame.origin.y-3, centerlabel.frame.size.width, centerlabel.frame.size.height+2)];
        centerImage.image = newImage;
        [self addSubview:centerImage];
        [self addSubview:centerlabel];
        self.centerlabel = centerlabel;
        //
        UILabel * leftLabel = [[UILabel alloc]init];
        leftLabel.font = centerlabel.font;
        leftLabel.textColor = centerlabel.textColor;
        leftLabel.textAlignment = NSTextAlignmentCenter;
        leftLabel.text = @"下午茶";
        CGSize leftSize = [leftLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:leftLabel.font,NSFontAttributeName, nil]];
        leftLabel.frame = CGRectMake(centerlabel.frame.origin.x-5-leftSize.width-6, oneLabel.frame.origin.y, leftSize.width+6, leftSize.height+5);
        UIImageView * leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(leftLabel.frame.origin.x, leftLabel.frame.origin.y-3, leftLabel.frame.size.width, leftLabel.frame.size.height+2)];
        leftImage.image = newImage;
        [self addSubview:leftImage];
        [self addSubview:leftLabel];
        self.leftlabel = leftLabel;
        
    }
    return self;
}

@end
