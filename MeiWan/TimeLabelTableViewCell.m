//
//  TimeLabelTableViewCell.m
//  beautity_play
//
//  Created by Fox on 16/7/13.
//  Copyright © 2016年 user_kevin. All rights reserved.
//

#import "TimeLabelTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Meiwan-Swift.h"

@implementation TimeLabelTableViewCell

- (void)setPlayerInfo:(NSDictionary *)playerInfo{
    
    _playerInfo = playerInfo;

    
    
    //图片拉伸
    UIImage *image = [UIImage imageNamed:@"biaoqian.png"];
    NSInteger leftCapWidth = image.size.width * 0.9;
    NSInteger topCapHeight = image.size.height * 0.9;
    UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    
    NSArray *labelTitle = [_playerInfo objectForKey:@"userTimeTags"];
    
    if (labelTitle.count == 0) {
        
        self.noneLabel.frame = CGRectMake((dtScreenWidth-90)/2, (85-40)/2, 90, 40);
        self.noneLabel.text = @"用户暂无标签";
        self.noneLabel.font = [UIFont systemFontOfSize:13.0f];
        
    }else if (labelTitle.count == 1){
        self.noneLabel.hidden = YES;
        
        NSDictionary *label1Dic = labelTitle[0];
        //三个标签label
        NSString *indexstr = [NSString stringWithFormat:@"%@",[label1Dic objectForKey:@"index"]];
        if ([indexstr isEqualToString: @"1"]) {
            self.timeTitle1.text = @"线上点歌";
        }else if([indexstr isEqualToString: @"2"]){
            self.timeTitle1.text = @"视频聊天";
        }else if([indexstr isEqualToString: @"3"]){
            self.timeTitle1.text = @"聚餐";
        }else if([indexstr isEqualToString:@"4"]){
            self.timeTitle1.text = @"线下K歌";
        }else if([indexstr isEqualToString:@"5"]){
            self.timeTitle1.text = @"夜店达人";
        }else if([indexstr isEqualToString:@"6"]){
            self.timeTitle1.text = @"叫醒服务";
        }else if([indexstr isEqualToString:@"7"]){
            self.timeTitle1.text = @"影伴";
        }else if([indexstr isEqualToString:@"8"]){
            self.timeTitle1.text = @"运动健身";
        }else if([indexstr isEqualToString:@"9"]){
            self.timeTitle1.text = @"LOL";
        }
        self.timeTitle1.textColor = [UIColor whiteColor];
        self.timeTitle1.textAlignment = NSTextAlignmentCenter;
        self.timeTitle1.font = [UIFont systemFontOfSize:9.0];
        CGSize nick2Size = [self.timeTitle1.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.timeTitle1.font,NSFontAttributeName, nil]];
        CGFloat name2H = nick2Size.height;
        CGFloat name2W = nick2Size.width;
        self.timeTitle1.frame = CGRectMake(5, 8, name2W,name2H);
        
        self.timeImage1.frame = CGRectMake(10, _titleImage.frame.origin.y+_titleImage.frame.size.height+6, self.timeTitle1.frame.size.width+10, self.timeTitle1.frame.size.height+10);
        self.timeImage1.image = newImage;
        
        
        self.priseLabel1.frame = CGRectMake(self.timeImage1.frame.origin.x+self.timeImage1.frame.size.width+4, self.timeImage1.frame.origin.y+self.timeImage1.frame.size.height/2-2, 100, self.timeTitle1.frame.size.height);
        NSString *priseStr = [label1Dic objectForKey:@"price"];
        NSString *priseText;
        if ([indexstr isEqualToString:@"6"]||[indexstr isEqualToString:@"1"]) {
            priseText = @"元／次";
        }else{
            priseText = @"元/小时";
            
        }
        self.priseLabel1.text = [NSString stringWithFormat:@"%@%@",priseStr,priseText];
        self.priseLabel1.font = [UIFont systemFontOfSize:12.0f];

    }else if (labelTitle.count == 2){
        self.noneLabel.hidden = YES;
        
        NSDictionary *label1Dic = labelTitle[0];
        //三个标签label
        NSString *indexstr = [NSString stringWithFormat:@"%@",[label1Dic objectForKey:@"index"]];
        if ([indexstr isEqualToString: @"1"]) {
            self.timeTitle1.text = @"线上点歌";
        }else if([indexstr isEqualToString: @"2"]){
            self.timeTitle1.text = @"视频聊天";
        }else if([indexstr isEqualToString: @"3"]){
            self.timeTitle1.text = @"聚餐";
        }else if([indexstr isEqualToString:@"4"]){
            self.timeTitle1.text = @"线下K歌";
        }else if([indexstr isEqualToString:@"5"]){
            self.timeTitle1.text = @"夜店达人";
        }else if([indexstr isEqualToString:@"6"]){
            self.timeTitle1.text = @"叫醒服务";
        }else if([indexstr isEqualToString:@"7"]){
            self.timeTitle1.text = @"影伴";
        }else if([indexstr isEqualToString:@"8"]){
            self.timeTitle1.text = @"运动健身";
        }else if([indexstr isEqualToString:@"9"]){
            self.timeTitle1.text = @"LOL";
        }
        self.timeTitle1.textColor = [UIColor whiteColor];
        self.timeTitle1.textAlignment = NSTextAlignmentCenter;
        self.timeTitle1.font = [UIFont systemFontOfSize:9.0];
        CGSize nick2Size = [self.timeTitle1.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.timeTitle1.font,NSFontAttributeName, nil]];
        CGFloat name2H = nick2Size.height;
        CGFloat name2W = nick2Size.width;
        self.timeTitle1.frame = CGRectMake(5, 8, name2W,name2H);
        
        self.timeImage1.frame = CGRectMake(10, _titleImage.frame.origin.y+_titleImage.frame.size.height+6, self.timeTitle1.frame.size.width+10, self.timeTitle1.frame.size.height+10);
        self.timeImage1.image = newImage;

        
        self.priseLabel1.frame = CGRectMake(self.timeImage1.frame.origin.x+self.timeImage1.frame.size.width+4, self.timeImage1.frame.origin.y+self.timeImage1.frame.size.height/2-2, 100, self.timeTitle1.frame.size.height);
        NSString *priseStr = [label1Dic objectForKey:@"price"];
        NSString *priseText;
        if ([indexstr isEqualToString:@"6"]||[indexstr isEqualToString:@"1"]) {
            priseText = @"元／次";
        }else{
            priseText = @"元/小时";
            
        }
        self.priseLabel1.text = [NSString stringWithFormat:@"%@%@",priseStr,priseText];
        self.priseLabel1.font = [UIFont systemFontOfSize:12.0f];
        
        
        
        
        
        
        NSDictionary *label2Dic = labelTitle[1];
        NSString *indexstr2 = [NSString stringWithFormat:@"%@",[label2Dic objectForKey:@"index"]];

        if ([indexstr2 isEqualToString:@"1"]) {
            self.timeTitle2.text = @"线上点歌";
        }else if([indexstr2 isEqualToString:@"2"]){
            self.timeTitle2.text = @"视频聊天";
        }else if([indexstr2 isEqualToString:@"3"]){
            self.timeTitle2.text = @"聚餐";
        }else if([indexstr2 isEqualToString:@"4"]){
            self.timeTitle2.text = @"线下K歌";
        }else if([indexstr2 isEqualToString:@"5"]){
            self.timeTitle2.text = @"夜店达人";
        }else if([indexstr2 isEqualToString:@"6"]){
            self.timeTitle2.text = @"叫醒服务";
        }else if([indexstr2 isEqualToString:@"7"]){
            self.timeTitle2.text = @"影伴";
        }else if([indexstr2 isEqualToString:@"8"]){
            self.timeTitle2.text = @"运动健身";
        }else if([indexstr2 isEqualToString:@"9"]){
            self.timeTitle2.text = @"LOL";
        }
        self.timeTitle2.textColor = [UIColor whiteColor];
        self.timeTitle2.textAlignment = NSTextAlignmentCenter;
        self.timeTitle2.font = [UIFont systemFontOfSize:9.0];
        CGSize twoSize = [self.timeTitle2.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.timeTitle2.font,NSFontAttributeName, nil]];
        CGFloat twoSizeH = twoSize.height;
        CGFloat twoSizeW = twoSize.width;
        self.timeTitle2.frame = CGRectMake(5, 8, twoSizeW,twoSizeH);

        NSString *priseStr2 = [label2Dic objectForKey:@"price"];
        NSString *priseText2;
        if ([indexstr2 isEqualToString:@"6"]||[indexstr2 isEqualToString:@"1"]) {
            priseText2 = @"元／次";
        }else{
            priseText2 = @"元/小时";
            
        }
        self.priseLabel2.text = [NSString stringWithFormat:@"%@%@",priseStr2,priseText2];
        self.priseLabel2.font = [UIFont systemFontOfSize:12.0f];
        CGSize prisetwoSize = [self.priseLabel2.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.priseLabel2.font,NSFontAttributeName, nil]];
        CGFloat prisetwoSizeH = prisetwoSize.height;
        CGFloat prisetwoSizeW = prisetwoSize.width;
        self.priseLabel2.frame = CGRectMake(self.frame.size.width-prisetwoSizeW-20, self.timeImage1.frame.origin.y+self.timeImage1.frame.size.height/2-4, prisetwoSizeW,prisetwoSizeH);
//
        self.timeImage2.frame = CGRectMake(self.frame.size.width-prisetwoSizeW-20-self.timeTitle2.frame.size.width-15,_titleImage.frame.origin.y+_titleImage.frame.size.height+6,self.timeTitle2.frame.size.width+10, self.timeTitle2.frame.size.height+10);
        self.timeImage2.image = newImage;

    }else if (labelTitle.count == 3){
        self.noneLabel.hidden = YES;
        
        NSDictionary *label1Dic = labelTitle[0];
        //三个标签label
        NSString *indexstr = [NSString stringWithFormat:@"%@",[label1Dic objectForKey:@"index"]];
        if ([indexstr isEqualToString: @"1"]) {
            self.timeTitle1.text = @"线上点歌";
        }else if([indexstr isEqualToString: @"2"]){
            self.timeTitle1.text = @"视频聊天";
        }else if([indexstr isEqualToString: @"3"]){
            self.timeTitle1.text = @"聚餐";
        }else if([indexstr isEqualToString:@"4"]){
            self.timeTitle1.text = @"线下K歌";
        }else if([indexstr isEqualToString:@"5"]){
            self.timeTitle1.text = @"夜店达人";
        }else if([indexstr isEqualToString:@"6"]){
            self.timeTitle1.text = @"叫醒服务";
        }else if([indexstr isEqualToString:@"7"]){
            self.timeTitle1.text = @"影伴";
        }else if([indexstr isEqualToString:@"8"]){
            self.timeTitle1.text = @"运动健身";
        }else if([indexstr isEqualToString:@"9"]){
            self.timeTitle1.text = @"LOL";
        }
        self.timeTitle1.textColor = [UIColor whiteColor];
        self.timeTitle1.textAlignment = NSTextAlignmentCenter;
        self.timeTitle1.font = [UIFont systemFontOfSize:9.0];
        CGSize nick2Size = [self.timeTitle1.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.timeTitle1.font,NSFontAttributeName, nil]];
        CGFloat name2H = nick2Size.height;
        CGFloat name2W = nick2Size.width;
        self.timeTitle1.frame = CGRectMake(5, 8, name2W,name2H);
        
        self.timeImage1.frame = CGRectMake(10, _titleImage.frame.origin.y+_titleImage.frame.size.height+6, self.timeTitle1.frame.size.width+10, self.timeTitle1.frame.size.height+10);
        self.timeImage1.image = newImage;
        
        
        self.priseLabel1.frame = CGRectMake(self.timeImage1.frame.origin.x+self.timeImage1.frame.size.width+4, self.timeImage1.frame.origin.y+self.timeImage1.frame.size.height/2-2, 100, self.timeTitle1.frame.size.height);
        NSString *priseStr = [label1Dic objectForKey:@"price"];
        NSString *priseText;
        if ([indexstr isEqualToString:@"6"]||[indexstr isEqualToString:@"1"]) {
            priseText = @"元／次";
        }else{
            priseText = @"元/小时";
            
        }
        self.priseLabel1.text = [NSString stringWithFormat:@"%@%@",priseStr,priseText];
        self.priseLabel1.font = [UIFont systemFontOfSize:12.0f];
        
        
        
        
        
        
        NSDictionary *label2Dic = labelTitle[1];
        NSString *indexstr2 = [NSString stringWithFormat:@"%@",[label2Dic objectForKey:@"index"]];
        
        if ([indexstr2 isEqualToString:@"1"]) {
            self.timeTitle2.text = @"线上点歌";
        }else if([indexstr2 isEqualToString:@"2"]){
            self.timeTitle2.text = @"视频聊天";
        }else if([indexstr2 isEqualToString:@"3"]){
            self.timeTitle2.text = @"聚餐";
        }else if([indexstr2 isEqualToString:@"4"]){
            self.timeTitle2.text = @"线下K歌";
        }else if([indexstr2 isEqualToString:@"5"]){
            self.timeTitle2.text = @"夜店达人";
        }else if([indexstr2 isEqualToString:@"6"]){
            self.timeTitle2.text = @"叫醒服务";
        }else if([indexstr2 isEqualToString:@"7"]){
            self.timeTitle2.text = @"影伴";
        }else if([indexstr2 isEqualToString:@"8"]){
            self.timeTitle2.text = @"运动健身";
        }else if([indexstr2 isEqualToString:@"9"]){
            self.timeTitle2.text = @"LOL";
        }
        self.timeTitle2.textColor = [UIColor whiteColor];
        self.timeTitle2.textAlignment = NSTextAlignmentCenter;
        self.timeTitle2.font = [UIFont systemFontOfSize:9.0];
        CGSize twoSize = [self.timeTitle2.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.timeTitle2.font,NSFontAttributeName, nil]];
        CGFloat twoSizeH = twoSize.height;
        CGFloat twoSizeW = twoSize.width;
        self.timeTitle2.frame = CGRectMake(5, 8, twoSizeW,twoSizeH);
        
        NSString *priseStr2 = [label2Dic objectForKey:@"price"];
        NSString *priseText2;
        if ([indexstr2 isEqualToString:@"6"]||[indexstr2 isEqualToString:@"1"]) {
            priseText2 = @"元／次";
        }else{
            priseText2 = @"元/小时";
            
        }
        self.priseLabel2.text = [NSString stringWithFormat:@"%@%@",priseStr2,priseText2];
        self.priseLabel2.font = [UIFont systemFontOfSize:12.0f];
        CGSize prisetwoSize = [self.priseLabel2.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.priseLabel2.font,NSFontAttributeName, nil]];
        CGFloat prisetwoSizeH = prisetwoSize.height;
        CGFloat prisetwoSizeW = prisetwoSize.width;
        self.priseLabel2.frame = CGRectMake(self.frame.size.width-prisetwoSizeW-20, self.timeImage1.frame.origin.y+self.timeImage1.frame.size.height/2-4, prisetwoSizeW,prisetwoSizeH);
        //
        self.timeImage2.frame = CGRectMake(self.frame.size.width-prisetwoSizeW-20-self.timeTitle2.frame.size.width-15,_titleImage.frame.origin.y+_titleImage.frame.size.height+6,self.timeTitle2.frame.size.width+10, self.timeTitle2.frame.size.height+10);
        self.timeImage2.image = newImage;
        
        
        NSDictionary *label3Dic = labelTitle[2];
        NSString *indexstr3 = [NSString stringWithFormat:@"%@",[label3Dic objectForKey:@"index"]];
        if ([indexstr3 isEqualToString:@"1"]) {
            self.timeTitle3.text = @"线上点歌";
        }else if([indexstr3 isEqualToString:@"2"]){
            self.timeTitle3.text = @"视频聊天";
        }else if([indexstr3 isEqualToString:@"3"]){
            self.timeTitle3.text = @"聚餐";
        }else if([indexstr3 isEqualToString:@"4"]){
            self.timeTitle3.text = @"线下K歌";
        }else if([indexstr3 isEqualToString:@"5"]){
            self.timeTitle3.text = @"夜店达人";
        }else if([indexstr3 isEqualToString:@"6"]){
            self.timeTitle3.text = @"叫醒服务";
        }else if([indexstr3 isEqualToString:@"7"]){
            self.timeTitle3.text = @"影伴";
        }else if([indexstr3 isEqualToString:@"8"]){
            self.timeTitle3.text = @"运动健身";
        }else if([indexstr3 isEqualToString:@"9"]){
            self.timeTitle3.text = @"LOL";
        }
        self.timeTitle3.textColor = [UIColor whiteColor];
        self.timeTitle3.textAlignment = NSTextAlignmentCenter;
        self.timeTitle3.font = [UIFont systemFontOfSize:9.0];
        CGSize threeSize = [self.timeTitle3.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.timeTitle3.font,NSFontAttributeName, nil]];
        CGFloat threeSizeH = threeSize.height;
        CGFloat threeSizeW = threeSize.width;
        self.timeTitle3.frame = CGRectMake(5, threeSizeH-2, threeSizeW,threeSizeH);
        
        self.timeImage3.frame = CGRectMake(self.timeImage1.frame.origin.x,self.timeImage1.frame.origin.y+self.timeImage1.frame.size.height+10, self.timeTitle3.frame.size.width+10, self.timeTitle3.frame.size.height+12);
        self.timeImage3.image = newImage;
        
        self.priseLabel3.frame = CGRectMake(self.timeImage3.frame.origin.x+self.timeImage3.frame.size.width+2, self.timeImage3.frame.origin.y+self.timeImage3.frame.size.height/2-2, 100, self.timeTitle3.frame.size.height);
        NSString *priseStr3 = [label3Dic objectForKey:@"price"];
        NSString *priseText3;
        if ([indexstr3 isEqualToString:@"6"]||[indexstr3 isEqualToString:@"1"]) {
            priseText3 = @"元／次";
        }else{
            priseText3 = @"元/小时";
            
        }
        self.priseLabel3.text = [NSString stringWithFormat:@"%@%@",priseStr3,priseText3];
        self.priseLabel3.font = [UIFont systemFontOfSize:12.0f];
    }
    
    self.priseLabel3.hidden = YES;
    self.priseLabel2.hidden = YES;
    self.priseLabel1.hidden = YES;
    
    NSDictionary *userInfo = [PersistenceManager getLoginUser];
    NSString *thesame = [NSString stringWithFormat:@"%ld",[[userInfo objectForKey:@"id"]longValue]];
    if ([thesame isEqualToString:@"100000"] || [thesame isEqualToString:@"100001"]){
        self.priseLabel3.hidden = YES;
        self.priseLabel2.hidden = YES;
        self.priseLabel1.hidden = YES;
    }else{
        self.priseLabel3.hidden = NO;
        self.priseLabel2.hidden = NO;
        self.priseLabel1.hidden = NO;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 10, 14)];
        titleImage.image = [UIImage imageNamed:@"time"];
        [self addSubview:titleImage];
        self.titleImage = titleImage;
        
        UILabel *timeTitle = [[UILabel alloc] initWithFrame:CGRectMake(titleImage.frame.origin.x+12, titleImage.frame.origin.y+2, 60, 10)];
        timeTitle.text = @"达人标签";
        timeTitle.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:timeTitle];
        self.timeTitleLabel = timeTitle;
        
        _timeImage1 = [[UIImageView alloc]init];
        _timeImage2 = [[UIImageView alloc]init];
        _timeImage3 = [[UIImageView alloc]init];
        
        _timeTitle1 = [[UILabel alloc]init];
        _timeTitle2 = [[UILabel alloc]init];
        _timeTitle3 = [[UILabel alloc]init];
        
        _priseLabel1 = [[UILabel alloc]init];
        _priseLabel2 = [[UILabel alloc]init];
        _priseLabel3 = [[UILabel alloc]init];
        
        [self.timeImage1 addSubview:self.timeTitle1];
        [self.timeImage2 addSubview:self.timeTitle2];
        [self.timeImage3 addSubview:self.timeTitle3];
        
        [self addSubview:_timeImage1];
        [self addSubview:_timeImage2];
        [self addSubview:_timeImage3];
        
        [self addSubview:_priseLabel1];
        [self addSubview:_priseLabel2];
        [self addSubview:_priseLabel3];
        
        self.noneLabel = [[UILabel alloc]init];
        [self addSubview:self.noneLabel];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
