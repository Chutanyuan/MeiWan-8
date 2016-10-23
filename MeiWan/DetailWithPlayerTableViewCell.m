//
//  DetailWithPlayerTableViewCell.m
//  MeiWan
//
//  Created by user_kevin on 16/10/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DetailWithPlayerTableViewCell.h"
#import "MeiWan-Swift.h"

@interface DetailWithPlayerTableViewCell ()

@property(nonatomic,strong)NSMutableArray * statePhotots;
@property(nonatomic,strong)UILabel * contentText;
@property(nonatomic,strong)UILabel * dateLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UIScrollView * scrollview;
@property(nonatomic,strong)UIImageView * photosImage;

@property(nonatomic,strong)UIButton * zan;
@property(nonatomic,strong)UIButton * pinglun;
@property(nonatomic,strong)UIButton * fenxiang;

@property(nonatomic,strong)UILabel * likelabel;
@property(nonatomic,strong)UILabel * countlabel;

@end

@implementation DetailWithPlayerTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.statePhotots = [[NSMutableArray alloc]initWithCapacity:0];
        self.contentText = [[UILabel alloc]init];
        self.contentText.numberOfLines = 0;
        self.contentText.textColor = [CorlorTransform colorWithHexString:@"#686868"];
        [self addSubview:self.contentText];
        
        self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 30, 40)];
        [self addSubview:self.dateLabel];
        
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.font = [FontOutSystem fontWithFangZhengSize:10.0];
        self.timeLabel.textColor = [CorlorTransform colorWithHexString:@"#D1DADA"];
        [self addSubview:self.timeLabel];
        
        self.scrollview = [[UIScrollView alloc]init];
        [self addSubview:self.scrollview];
        _zan = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_zan];
        _pinglun = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_pinglun];
        _fenxiang = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_fenxiang];
        _countlabel = [[UILabel alloc]init];
        [self addSubview:_countlabel];
        _likelabel = [[UILabel alloc]init];
        [self addSubview:_likelabel];
        
    }
    return self;
}

-(void)setDetailDictionary:(NSDictionary *)detailDictionary
{
    NSLog(@"%@",detailDictionary);
    self.statePhotots = detailDictionary[@"statePhotos"];
    [self.statePhotots removeObject:[NSNull null]];
    int height_photos;
    
    _contentText.text = detailDictionary[@"content"];
    _contentText.font = [FontOutSystem fontWithFangZhengSize:15.0];
    CGRect frame = [self frame];
    _contentText.text = detailDictionary[@"content"];
    _contentText.font = [FontOutSystem fontWithFangZhengSize:15.0];
    CGSize size = CGSizeMake(dtScreenWidth-(self.dateLabel.frame.origin.x+self.dateLabel.frame.size.width+10)-10, 1000);
    CGSize labelsize = [self.contentText.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:_contentText.font,NSFontAttributeName, nil] context:nil].size;
    _contentText.frame =  CGRectMake(self.dateLabel.frame.origin.x+self.dateLabel.frame.size.width+10, 10, labelsize.width, labelsize.height);
    
    _timeLabel.text = [DateTool getTimeDescription:[detailDictionary[@"createTime"] doubleValue]];
    CGSize size_timelabel = [_timeLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_timeLabel.font,NSFontAttributeName, nil]];
    _timeLabel.frame = CGRectMake(_contentText.frame.origin.x, _contentText.frame.origin.y+_contentText.frame.size.height+2.5, size_timelabel.width, size_timelabel.height);
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yy-MM"];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[detailDictionary[@"createTime"] doubleValue]/1000.0];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    NSArray * dateArray = [confromTimespStr componentsSeparatedByString:@"-"];
    NSString * chineseMonth = [self getMonth:[[dateArray lastObject] integerValue]];
    NSMutableAttributedString * changetext = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@",[dateArray firstObject],chineseMonth]];
    NSRange range  = [[changetext string]rangeOfString:[dateArray firstObject]];
    [changetext addAttribute:NSFontAttributeName value:[FontOutSystem fontWithFangZhengSize:22.0] range:range];
    NSRange range2 = [[changetext string]rangeOfString:chineseMonth];
    [changetext addAttribute:NSFontAttributeName value:[FontOutSystem fontWithFangZhengSize:11.0] range:range2];
    self.dateLabel.textColor = [CorlorTransform colorWithHexString:@"#979595"];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    self.dateLabel.numberOfLines = 2;
    self.dateLabel.attributedText = changetext;
    
    if (self.statePhotots.count>0) {
        self.scrollview.frame = CGRectMake(self.timeLabel.frame.origin.x, self.timeLabel.frame.origin.y+self.timeLabel.frame.size.height+5, (dtScreenWidth-self.timeLabel.frame.origin.x-11), (dtScreenWidth-self.timeLabel.frame.origin.x-11)/2);
        [self.statePhotots enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            self.photosImage = [[UIImageView alloc]init];
            self.photosImage.frame = CGRectMake(idx*(dtScreenWidth-self.timeLabel.frame.origin.x-11)/2, 0, (dtScreenWidth-self.timeLabel.frame.origin.x-11)/2, (dtScreenWidth-self.timeLabel.frame.origin.x-11)/2);
            [self.photosImage sd_setImageWithURL:[NSURL URLWithString:obj]];
            self.photosImage.contentMode = UIViewContentModeScaleAspectFill;
            [self.scrollview addSubview:self.photosImage];

        }];
    }
    
    if (self.statePhotots.count>0) {
        height_photos = (dtScreenWidth-self.timeLabel.frame.origin.x-11)/2;
    }else{
        height_photos = 0;
        
    }
    
    
    
    
//    _zan
    
    frame.size.height = labelsize.height+height_photos+20+size_timelabel.height+5+40;
    
    _pinglun.frame = CGRectMake(dtScreenWidth-10-20-5-10, frame.size.height-30, 20, 20);
    [_pinglun setImage:[UIImage imageNamed:@"peiwan_discuss"] forState:UIControlStateNormal];
    _countlabel.frame = CGRectMake(_pinglun.frame.origin.x+20+5, _pinglun.frame.origin.y, 10, 20);
    _countlabel.text = [NSString stringWithFormat:@"%@",detailDictionary[@"count"]];
    _countlabel.font = [FontOutSystem fontWithFangZhengSize:10];
    
//    _zan.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    self.frame = frame;
}
-(NSString*)getMonth:(NSInteger)Month
{
    NSString*weekStr=nil;
    if(Month==1)
    {
        weekStr=@"一月";
    }else if(Month==2){
        weekStr=@"二月";
        
    }else if(Month==3){
        weekStr=@"三月";
        
    }else if(Month==4){
        weekStr=@"四月";
        
    }else if(Month==5){
        weekStr=@"五月";
        
    }else if(Month==6){
        weekStr=@"六月";
        
    }else if(Month==7){
        weekStr=@"七月";
        
    }else if(Month==8){
        weekStr=@"八月";
        
    }else if(Month==9){
        weekStr=@"九月";
        
    }else if(Month==10){
        weekStr=@"十月";
        
    }else if(Month==11){
        weekStr=@"十一";
        
    }else if(Month==12){
        weekStr=@"十二";
        
    }
    return weekStr;
}
@end
