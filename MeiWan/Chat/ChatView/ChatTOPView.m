//
//  ChatTOPView.m
//  MeiWan
//
//  Created by user_kevin on 16/8/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ChatTOPView.h"

@implementation ChatTOPView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(dtScreenWidth-10-70, frame.size.height/2-20, 70, 30);
        [button setTitle:@"邀请" forState:UIControlStateNormal];
        button.backgroundColor = [CorlorTransform colorWithHexString:@"#87CEFA"];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        button.clipsToBounds = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
    }
    return self;
}
-(void)setUserTimeTags:(NSArray *)userTimeTags
{
    NSArray * titlelabel = @[@"全部",@"线上点歌",@"视屏聊天",@"聚餐",@"线下K歌",@"夜店达人",@"叫醒服务",@"影伴",@"运动健身",@"LOL"];
    NSArray * imageArray =  @[@"all",@"sing",@"video-chat",@"dining",@"sing-expert",@"go-nightclubbing",@"clock",@"shadow-with",@"sports",@"lol"];
    
    if (userTimeTags.count==1) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 35, 35)];
        [self addSubview:imageView];
        UILabel * title = [[UILabel alloc]init];
        title.center = CGPointMake(imageView.center.x, imageView.center.y+imageView.frame.size.height/2+5);
        title.bounds = CGRectMake(0, 0, 40, 15);
        title.font = [UIFont systemFontOfSize:10.0];
        title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:title];
        NSDictionary * dic = userTimeTags[0];
        int index = [dic[@"index"] intValue];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[index]]];
        title.text = [NSString stringWithFormat:@"%@",titlelabel[index]];
    }else if (userTimeTags.count==2){
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 35, 35)];
        [self addSubview:imageView];
        UILabel * title = [[UILabel alloc]init];
        title.center = CGPointMake(imageView.center.x, imageView.center.y+imageView.frame.size.height/2+5);
        title.bounds = CGRectMake(0, 0, 40, 15);
        title.font = [UIFont systemFontOfSize:10.0];
        title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:title];
        NSDictionary * dic = userTimeTags[0];
        int index = [dic[@"index"] intValue];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[index]]];
        title.text = [NSString stringWithFormat:@"%@",titlelabel[index]];

        UIImageView * imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+10, 5, 35, 35)];
        [self addSubview:imageView2];
        UILabel * title2 = [[UILabel alloc]init];
        title2.center = CGPointMake(imageView2.center.x, imageView2.center.y+imageView2.frame.size.height/2+5);
        title2.bounds = CGRectMake(0, 0, 40, 15);
        title2.font = [UIFont systemFontOfSize:10.0];
        title2.textAlignment = NSTextAlignmentCenter;
        [self addSubview:title2];
        NSDictionary * dic2 = userTimeTags[1];
        int index2 = [dic2[@"index"] intValue];
        imageView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[index2]]];
        title2.text = [NSString stringWithFormat:@"%@",titlelabel[index2]];

        
    }else{
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 35, 35)];
        [self addSubview:imageView];
        UILabel * title = [[UILabel alloc]init];
        title.center = CGPointMake(imageView.center.x, imageView.center.y+imageView.frame.size.height/2+5);
        title.bounds = CGRectMake(0, 0, 40, 15);
        title.font = [UIFont systemFontOfSize:10.0];
        title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:title];
        NSDictionary * dic = userTimeTags[0];
        int index = [dic[@"index"] intValue];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[index]]];
        title.text = [NSString stringWithFormat:@"%@",titlelabel[index]];
        
        UIImageView * imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+10, 5, 35, 35)];
        [self addSubview:imageView2];
        UILabel * title2 = [[UILabel alloc]init];
        title2.center = CGPointMake(imageView2.center.x, imageView2.center.y+imageView2.frame.size.height/2+5);
        title2.bounds = CGRectMake(0, 0, 40, 15);
        title2.font = [UIFont systemFontOfSize:10.0];
        title2.textAlignment = NSTextAlignmentCenter;
        [self addSubview:title2];
        NSDictionary * dic2 = userTimeTags[1];
        int index2 = [dic2[@"index"] intValue];
        imageView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[index2]]];
        title2.text = [NSString stringWithFormat:@"%@",titlelabel[index2]];
        

        UIImageView * imageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(imageView2.frame.origin.x+imageView2.frame.size.width+10, 5, 35, 35)];
        [self addSubview:imageView3];
        UILabel * title3 = [[UILabel alloc]init];
        title3.center = CGPointMake(imageView3.center.x, imageView3.center.y+imageView3.frame.size.height/2+5);
        title3.bounds = CGRectMake(0, 0, 40, 15);
        title3.font = [UIFont systemFontOfSize:10.0];
        title3.textAlignment = NSTextAlignmentCenter;
        [self addSubview:title3];
        NSDictionary * dic3 = userTimeTags[2];
        int index3 = [dic3[@"index"] intValue];
        imageView3.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[index3]]];
        title3.text = [NSString stringWithFormat:@"%@",titlelabel[index3]];
        
    }
}

- (void)buttonClick:(UIButton *)sender
{
    [self.delegate inviteButtonClick:sender];
}
@end
