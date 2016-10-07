//
//  chatOrderView.m
//  MeiWan
//
//  Created by user_kevin on 16/8/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "chatOrderView.h"
#import "MeiWan-Swift.h"

@implementation chatOrderView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

-(void)setOrderMessage:(NSDictionary *)orderMessage
{
    
    int status = [orderMessage[@"status"] intValue];
    
    NSArray * titlelabel = @[@"全部",@"线上点歌",@"视屏聊天",@"聚餐",@"线下K歌",@"夜店达人",@"叫醒服务",@"影伴",@"运动健身",@"LOL"];
  
    NSArray * imageArray =  @[@"all",@"sing",@"video-chat",@"dining",@"sing-expert",@"go-nightclubbing",@"clock",@"shadow-with",@"sports",@"lol"];
    /** 下单的项目 */
    UIImageView * invitImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 35, 35)];
    int tagindex = [orderMessage[@"tagIndex"] intValue];
  
    [self addSubview:invitImage];
    
    UILabel * contentText = [[UILabel alloc]initWithFrame:CGRectMake(invitImage.frame.origin.x+invitImage.frame.size.width+10, invitImage.center.y-10, dtScreenWidth-10-80-(invitImage.frame.origin.x+invitImage.frame.size.width+10), 20)];
    
    contentText.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:contentText];

    
    switch (tagindex) {
        case 1:
        {
            invitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[tagindex]]];
            contentText.text = [NSString stringWithFormat:@"%@/%@首",titlelabel[tagindex],orderMessage[@"hours"]];
        }
            break;
        case 2:
        {
            invitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[tagindex]]];
            contentText.text = [NSString stringWithFormat:@"%@/%@小时",titlelabel[tagindex],orderMessage[@"hours"]];
            
        }
            break;
        case 3:
        {
            invitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[tagindex]]];
            contentText.text = [NSString stringWithFormat:@"%@/%@小时",titlelabel[tagindex],orderMessage[@"hours"]];
        }
            break;
        case 4:
        {
            invitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[tagindex]]];
            contentText.text = [NSString stringWithFormat:@"%@/%@小时",titlelabel[tagindex],orderMessage[@"hours"]];
        }
            break;
        case 5:
        {
            invitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[tagindex]]];
            contentText.text = [NSString stringWithFormat:@"%@/%@小时",titlelabel[tagindex],orderMessage[@"hours"]];
        }
            break;
        case 6:
        {
            invitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[tagindex]]];
            contentText.text = [NSString stringWithFormat:@"%@/%@次",titlelabel[tagindex],orderMessage[@"hours"]];
        }
            break;
        case 7:
        {
            invitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[tagindex]]];
            contentText.text = [NSString stringWithFormat:@"%@/%@小时",titlelabel[tagindex],orderMessage[@"hours"]];
        }
            break;
        case 8:
        {
            invitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[tagindex]]];
            contentText.text = [NSString stringWithFormat:@"%@/%@小时",titlelabel[tagindex],orderMessage[@"hours"]];
        }
            break;
        case 9:
        {
            invitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[tagindex]]];
            contentText.text = [NSString stringWithFormat:@"%@/%@小时",titlelabel[tagindex],orderMessage[@"hours"]];
        }
            break;
        default:
            break;
    }
    
    
    //
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(dtScreenWidth-10-70, invitImage.center.y-15, 70, 30);
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont  systemFontOfSize:15.0];
    rightButton.backgroundColor = [CorlorTransform colorWithHexString:@"33cc66"];
    rightButton.layer.cornerRadius = 5;
    rightButton.clipsToBounds = YES;
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightButton];
    self.DoneButton = rightButton;
    
    UIButton * TouSuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    TouSuButton.frame = CGRectMake(rightButton.frame.origin.x-10-80, rightButton.frame.origin.y, 80, 30);
    [TouSuButton setTitle:@"申请退款" forState:UIControlStateNormal];
    [TouSuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    TouSuButton.titleLabel.font = [UIFont  systemFontOfSize:15.0];
    TouSuButton.backgroundColor = [CorlorTransform colorWithHexString:@"3366cc"];
    TouSuButton.layer.cornerRadius = 5;
    TouSuButton.clipsToBounds = YES;
    TouSuButton.hidden = YES;
    [TouSuButton addTarget:self action:@selector(TouSuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:TouSuButton];
    
        /**  */

    /**
     标签图片直接通过循环创建
     */
    
    UIImageView * ColorLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 45, dtScreenWidth,1)];
    ColorLine.backgroundColor = [CorlorTransform colorWithHexString:@"66ccff"];
    [self addSubview:ColorLine];
    
    for (int i = 0; i<4; i++) {
        
        UIImageView * pointImage = [[UIImageView alloc]initWithFrame:CGRectMake(dtScreenWidth/8+i*(dtScreenWidth/8*2), -5, 10, 10)];
        
        pointImage.backgroundColor = [UIColor whiteColor];
        pointImage.image = [UIImage imageNamed:@"pw_dot2"];
        
        
        UILabel * Statuslabel = [[UILabel alloc]init];
        Statuslabel.font = [UIFont systemFontOfSize:10.0];
        if (i==0) {
            Statuslabel.center = CGPointMake(pointImage.center.x, pointImage.center.y+10);
            Statuslabel.bounds = CGRectMake(0, 0, 30, 10);
            Statuslabel.text = @"待确定";
            [ColorLine addSubview:Statuslabel];
        }else if (i==1){
            Statuslabel.center = CGPointMake(pointImage.center.x, pointImage.center.y+10);
            Statuslabel.bounds = CGRectMake(0, 0, 30, 10);
            Statuslabel.text = @"进行中";
            [ColorLine addSubview:Statuslabel];
        }else if (i==2){
            Statuslabel.center = CGPointMake(pointImage.center.x, pointImage.center.y+10);
            Statuslabel.bounds = CGRectMake(0, 0, 30, 10);
            Statuslabel.text = @"已完成";
            [ColorLine addSubview:Statuslabel];
        }else{
            Statuslabel.center = CGPointMake(pointImage.center.x, pointImage.center.y+10);
            Statuslabel.bounds = CGRectMake(0, 0, 30, 10);
            Statuslabel.text = @"待评价";
            [ColorLine addSubview:Statuslabel];
        }
        
        /** 刚开始的时候 -- 待确定*/
        if (status==0||status==100) {
            if (i==0) {
                pointImage.image = [UIImage imageNamed:@"pw_dot"];
            }
        }
        /** 玩家已支付或者是陪玩已经同意接单 -- 进行中 */
        if (status==200) {
            if (i==1) {
                pointImage.image = [UIImage imageNamed:@"pw_dot"];
            }
        }
        
        if (status==500) {
            if (i==2) {
                Statuslabel.text = @"仲裁中";
                pointImage.image = [UIImage imageNamed:@"pw_dot"];
            }
        }
        /** 交易完成或者是陪玩胜诉 -- 已完成 */
        if (status==400||status==600||status==700) {
            if (i==3) {
                
                pointImage.image = [UIImage imageNamed:@"pw_dot"];
            }
            
        }
        /**  */
        [ColorLine addSubview:pointImage];
        
    }
    
    NSDictionary * userDic = [PersistenceManager getLoginUser];
    NSString * userId = [NSString stringWithFormat:@"%@",userDic[@"id"]];
    NSString * peiwanID = [NSString stringWithFormat:@"%@",orderMessage[@"peiwanId"]];
    
    if ([userId isEqualToString:peiwanID]) {
        NSLog(@"陪玩");
        /** 玩家已支付 -- 进行中 */
        if (status==100) {
            rightButton.hidden = NO;
            [rightButton setTitle:@"接受" forState:UIControlStateNormal];
            TouSuButton.hidden = NO;
            [TouSuButton setTitle:@"拒绝" forState:UIControlStateNormal];
        }
        /** 陪玩已接受 */
        if (status==200||status==500) {
            rightButton.hidden = NO;
            [rightButton setTitle:@"进行中" forState:UIControlStateNormal];
            rightButton.backgroundColor = [UIColor grayColor];
        }
        /** 交易完成或者是陪玩胜诉 -- 已完成 */
        if (status==400||status==600||status==500||status==700) {
            
            [rightButton setTitle:@"求评价" forState:UIControlStateNormal];
            
            if (status==500) {
                [rightButton setTitle:@"仲裁中" forState:UIControlStateNormal];
                rightButton.backgroundColor = [UIColor grayColor];
            }
            
            
        }

    }else{
        NSLog(@"玩家");
        
        rightButton.backgroundColor = [CorlorTransform colorWithHexString:@"3399ff"];
        /** 玩家已支付 -- 进行中 */
        if (status==100) {
            rightButton.hidden = NO;
            [rightButton setTitle:@"撤回" forState:UIControlStateNormal];
        }
        /** 陪玩已接受 */
        if (status==200) {
            TouSuButton.hidden = NO;
            
            [TouSuButton setTitle:@"申请退款" forState:UIControlStateNormal];
            
            [rightButton setTitle:@"完成" forState:UIControlStateNormal];
        }
        /** 交易完成或者是陪玩胜诉 -- 已完成 */
        if (status==400||status==500||status==600||status==700) {
            [rightButton setTitle:@"去评价" forState:UIControlStateNormal];
            if (status==500) {
                TouSuButton.hidden = YES;
                [rightButton setTitle:@"仲裁中" forState:UIControlStateNormal];
            }
        }

    }

}

/** 接受 */
- (void)rightButtonClick:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"接受"]) {

        [self.delegate acceptOrderButtonClick:sender];
    
    }else if ([sender.titleLabel.text isEqualToString:@"完成"]){
        
        [self.delegate doneOrderButtonClick:sender];
        
    }else{
        
    }
    
    if ([sender.titleLabel.text isEqualToString:@"去评价"]) {
        [self.delegate evaluateButtonClick:sender];
    }
    if ([sender.titleLabel.text isEqualToString:@"求评价"]) {
        [self.delegate pleaseEvaluateButtonClick:sender];
    }
    if ([sender.titleLabel.text isEqualToString:@"撤回"]) {
        [self.delegate revokeRequestButtonClick:sender];
    }
}

/** 拒绝、申请退款 */
- (void)TouSuButtonClick:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"拒绝"]) {
        
        [self.delegate RejectButtonClick:sender];
        self.hidden = YES;
        
    }
    if ([sender.titleLabel.text isEqualToString:@"申请退款"]) {
        [self.delegate applyRequestButtonClick:sender];
    }
}
@end
