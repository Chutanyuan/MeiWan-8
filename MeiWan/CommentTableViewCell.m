//
//  CommentTableViewCell.m
//  beautity_play
//
//  Created by Fox on 16/7/13.
//  Copyright © 2016年 user_kevin. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "MeiWan-Swift.h"


#define FOREGROUND_STAR_IMAGE_NAME @"b27_icon_star_yellow"

@implementation CommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _headerImage = [[UIImageView alloc]init];
        [self addSubview:_headerImage];
        
        _userName = [[UILabel alloc]init];
        [self addSubview:_userName];
        
        _sendTime = [[UILabel alloc]init];
        [self addSubview:_sendTime];
        
        _connecttext = [[UILabel alloc]init];
        [self addSubview:_connecttext];
        
    }
    return self;
}

-(void)setEvaluateDictionary:(NSDictionary *)evaluateDictionary
{
    NSDictionary * userDic = evaluateDictionary[@"user"];
    _headerImage.frame = CGRectMake(10, 10, 60, 60);
    _headerImage.layer.cornerRadius = 30;
    _headerImage.contentMode = UIViewContentModeScaleAspectFill;
    _headerImage.clipsToBounds = YES;
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!1",userDic[@"headUrl"]]]];
    
    _userName.text = [NSString stringWithFormat:@"%@",userDic[@"nickname"]];
    _userName.font = [FontOutSystem fontWithFangZhengSize:15.0];
    _userName.textColor = [CorlorTransform colorWithHexString:@"#79D3FA"];
    CGSize size_name = [_userName.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_userName.font,NSFontAttributeName, nil]];
    _userName.frame = CGRectMake(_headerImage.frame.origin.x+_headerImage.frame.size.width+10, 15, size_name.width, size_name.height);
    
    _connecttext.text = evaluateDictionary[@"content"];
    _connecttext.textColor = [UIColor grayColor];
    _connecttext.font = [UIFont systemFontOfSize:13.0];
    _connecttext.numberOfLines = 0;
    CGSize size_connect = [_connecttext.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_connecttext.font,NSFontAttributeName, nil]];
    _connecttext.frame = CGRectMake(_headerImage.frame.origin.x+_headerImage.frame.size.width+10, _userName.frame.origin.y+_userName.frame.size.height, dtScreenWidth-(_headerImage.frame.origin.x+_headerImage.frame.size.width+10+20), size_connect.height);
    
    double lastActiveTime = [evaluateDictionary[@"createTime"] doubleValue];
    _sendTime.text = [DateTool getTimeDescription:lastActiveTime];
    _sendTime.font = [FontOutSystem fontWithFangZhengSize:12.0];
    _sendTime.textColor = [CorlorTransform colorWithHexString:@"#ABDAEC"];
    CGSize size_sendTime = [_sendTime.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_sendTime.font,NSFontAttributeName, nil]];
    _sendTime.frame = CGRectMake(dtScreenWidth-20-size_sendTime.width, _userName.frame.origin.y, size_sendTime.width, size_sendTime.height);
    
    int point = [evaluateDictionary[@"point"] intValue];
    CGFloat points = [evaluateDictionary[@"point"] floatValue];
    if (points>point+0.5) {
        point=point+1;
    }
    if (point==1) {
        for (int i = 0; i<point; i++) {
            UIImageView * testImageView = [[UIImageView alloc]init];
            testImageView.frame = CGRectMake(_connecttext.frame.origin.x + i*20, _connecttext.frame.origin.y+size_connect.height, 20, 20);
            testImageView.image = [UIImage imageNamed:FOREGROUND_STAR_IMAGE_NAME];
            [self addSubview:testImageView];
        }
    }else if (point==2){
        for (int i = 0; i<point; i++) {
            UIImageView * testImageView = [[UIImageView alloc]init];
            testImageView.frame = CGRectMake(_connecttext.frame.origin.x + i*20, _connecttext.frame.origin.y+size_connect.height, 20, 20);
            testImageView.image = [UIImage imageNamed:FOREGROUND_STAR_IMAGE_NAME];
            [self addSubview:testImageView];
        }
    }else if (point==3){
        for (int i = 0; i<point; i++) {
            UIImageView * testImageView = [[UIImageView alloc]init];
            testImageView.frame = CGRectMake(_connecttext.frame.origin.x + i*20, _connecttext.frame.origin.y+size_connect.height, 20, 20);
            testImageView.image = [UIImage imageNamed:FOREGROUND_STAR_IMAGE_NAME];
            [self addSubview:testImageView];
        }
    }else if (point==4){
        for (int i = 0; i<point; i++) {
            UIImageView * testImageView = [[UIImageView alloc]init];
            testImageView.frame = CGRectMake(_connecttext.frame.origin.x + i*20, _connecttext.frame.origin.y+size_connect.height, 20, 20);
            testImageView.image = [UIImage imageNamed:FOREGROUND_STAR_IMAGE_NAME];
            [self addSubview:testImageView];
        }
    }else if (point==5){
        for (int i = 0; i<point; i++) {
            UIImageView * testImageView = [[UIImageView alloc]init];
            testImageView.frame = CGRectMake(_connecttext.frame.origin.x + i*20, _connecttext.frame.origin.y+size_connect.height, 20, 20);
            testImageView.image = [UIImage imageNamed:FOREGROUND_STAR_IMAGE_NAME];
            [self addSubview:testImageView];
        }
    }
}

@end
