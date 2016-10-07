//
//  Myorder.m
//  MeiWan
//
//  Created by apple on 15/8/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "Myorder.h"
#import "Meiwan-Swift.h"
#import "CorlorTransform.h"
@implementation Myorder

-(void)setOrderDic:(NSDictionary *)orderDic{
    
    _orderDic = orderDic;

    UILabel *timeTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 60, 20)];
    timeTitle.text = @"邀约时间:";
    timeTitle.font = [UIFont systemFontOfSize:13.0f];
    [self addSubview:timeTitle];
    
    UILabel *time = [[UILabel alloc] init];
    double lastActiveTime = [[orderDic objectForKey:@"createTime"]doubleValue];
    time.text = [DateTool getTimeDescription:lastActiveTime];
    time.font = [UIFont systemFontOfSize:13.0f];
    CGSize timeSize = [time.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:time.font,NSFontAttributeName, nil]];
    CGFloat timeH = timeSize.height;
    CGFloat timeW = timeSize.width;
    time.frame = CGRectMake(timeTitle.frame.origin.x+timeTitle.frame.size.width+4, 7, timeW, timeH);
    [self addSubview:time];
    self.orderTime = time;
    
    UILabel *nickTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, timeTitle.frame.origin.y+timeTitle.frame.size.height+5, 60, 20)];
    nickTitle.text = @"达人昵称:";
    nickTitle.font = [UIFont systemFontOfSize:13.0f];
    [self addSubview:nickTitle];
    UILabel *nick = [[UILabel alloc] init];
    if (self.mytag == 666) {
        NSDictionary *peiwan = [orderDic objectForKey:@"user"];
        nick.text = [peiwan objectForKey:@"nickname"];
    }else{
        NSDictionary *peiwan = [orderDic objectForKey:@"peiwan"];
        nick.text = [peiwan objectForKey:@"nickname"];
    }
    nick.font = [UIFont systemFontOfSize:13.0f];
    CGSize nickSize = [nick.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:nick.font,NSFontAttributeName, nil]];
    CGFloat nickH = nickSize.height;
    CGFloat nickW = nickSize.width;
    nick.frame = CGRectMake(nickTitle.frame.origin.x+nickTitle.frame.size.width+4, timeTitle.frame.origin.y+timeTitle.frame.size.height+7, nickW, nickH);
    [self addSubview:nick];
    self.playnick = nick;
    
    UILabel *timesTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, nickTitle.frame.origin.y+nickTitle.frame.size.height+5, 60, 20)];
    timesTitle.text = @"所选时间:";
    timesTitle.font = [UIFont systemFontOfSize:13.0f];
    [self addSubview:timesTitle];

    UILabel *times = [[UILabel alloc] init];
    double type = [[orderDic objectForKey:@"type"]doubleValue];
    NSString *housStr;
    if (type == 6) {
        housStr = @"次";
    }else{
        housStr = @"小时";
    }
    NSString *timesString = [NSString stringWithFormat:@"%@%@",[orderDic objectForKey:@"hours"],housStr];
    times.text = timesString;
    times.font = [UIFont systemFontOfSize:13.0f];
    CGSize timesSize = [times.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:times.font,NSFontAttributeName, nil]];
    CGFloat timesH = timesSize.height;
    CGFloat timesW = timesSize.width;
    times.frame = CGRectMake(timesTitle.frame.origin.x+timesTitle.frame.size.width+4, nickTitle.frame.origin.y+nickTitle.frame.size.height+7, timesW, timesH);
    [self addSubview:times];
    self.times = times;
    
    UILabel *categoryTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, timesTitle.frame.origin.y+timesTitle.frame.size.height+5, 60, 20)];
    categoryTitle.text = @"所选类别:";
    categoryTitle.font = [UIFont systemFontOfSize:13.0f];
    [self addSubview:categoryTitle];
    
    UILabel *category = [[UILabel alloc] init];
    double typedouble = [[orderDic objectForKey:@"tagIndex"]doubleValue];
    if (typedouble == 1) {
        category.text = @"线上点歌";
    }else if(typedouble == 2){
        category.text = @"视频聊天";
    }else if(typedouble == 3){
        category.text = @"聚餐";
    }else if(typedouble == 4){
        category.text = @"线下K歌";
    }else if(typedouble == 5){
        category.text = @"夜店达人";
    }else if(typedouble == 6){
        category.text= @"叫醒服务";
    }else if(typedouble == 7){
        category.text = @"影伴";
    }else if(typedouble == 8){
        category.text = @"运动健身";
    }else if(typedouble == 9){
        category.text = @"LOL";
    }
    category.font = [UIFont systemFontOfSize:13.0f];
    CGSize categorySize = [category.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:category.font,NSFontAttributeName, nil]];
    CGFloat categoryH = categorySize.height;
    CGFloat categoryW = categorySize.width;
    category.frame = CGRectMake(categoryTitle.frame.origin.x+categoryTitle.frame.size.width+4, timesTitle.frame.origin.y+timesTitle.frame.size.height+7, categoryW, categoryH);
    [self addSubview:category];
    self.category = category;

    UILabel *priseNumberTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, categoryTitle.frame.origin.y+categoryTitle.frame.size.height+5, 60, 20)];
    priseNumberTitle.text = @"所需费用:";
    priseNumberTitle.font = [UIFont systemFontOfSize:13.0f];
    [self addSubview:priseNumberTitle];
    
    UILabel *priseNumber = [[UILabel alloc] init];
    double priseDouble = [[orderDic objectForKey:@"price"]doubleValue];
    NSString *priseNumberString = [NSString stringWithFormat:@"%.1f",priseDouble];
    priseNumber.text = priseNumberString;
    priseNumber.font = [UIFont systemFontOfSize:13.0f];
    CGSize priseNumberSize = [priseNumber.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:priseNumber.font,NSFontAttributeName, nil]];
    CGFloat priseNumberH = priseNumberSize.height;
    CGFloat priseNumberW = priseNumberSize.width;
    priseNumber.frame = CGRectMake(priseNumberTitle.frame.origin.x+priseNumberTitle.frame.size.width+4, categoryTitle.frame.origin.y+categoryTitle.frame.size.height+7, priseNumberW, priseNumberH);
    [self addSubview:priseNumber];
    self.priseNumber = priseNumber;

    UILabel *priseSunitle = [[UILabel alloc] initWithFrame:CGRectMake(10, priseNumberTitle.frame.origin.y+priseNumberTitle.frame.size.height+5, 60, 20)];
    priseSunitle.text = @"总应支付:";
    priseSunitle.font = [UIFont systemFontOfSize:13.0f];
    [self addSubview:priseSunitle];
    
    UILabel *priseSun = [[UILabel alloc] init];
    double priseSunTimeDouble = [[orderDic objectForKey:@"hours"]doubleValue];
    double prisesDouble = [[orderDic objectForKey:@"price"]doubleValue];
    NSString *priseSunString = [NSString stringWithFormat:@"%.1f",priseSunTimeDouble*prisesDouble];
    priseSun.text = priseSunString;
    priseSun.font = [UIFont systemFontOfSize:13.0f];
    CGSize priseSunSize = [priseSun.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:priseSun.font,NSFontAttributeName, nil]];
    CGFloat priseSunH = priseSunSize.height;
    CGFloat priseSunW = priseSunSize.width;
    priseSun.frame = CGRectMake(priseSunitle.frame.origin.x+priseSunitle.frame.size.width+4, priseNumberTitle.frame.origin.y+priseNumberTitle.frame.size.height+7, priseSunW, priseSunH);
    [self addSubview:priseSun];
    self.priseSum = priseSun;
    
    UILabel *currentStateTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, priseSunitle.frame.origin.y+priseSunitle.frame.size.height+5, 60, 20)];
    currentStateTitle.text = @"当前状态:";
    currentStateTitle.font = [UIFont systemFontOfSize:13.0f];
    [self addSubview:currentStateTitle];
    
    UILabel *currentState = [[UILabel alloc] init];
    
    NSDictionary *evaluationDic = [orderDic objectForKey:@"evaluation"];
    int status = [[orderDic objectForKey:@"status"]intValue];
    if (self.mytag == 888) {
        if (status == 100) {
            currentState.text = @"等待接受";
            currentState.textColor = [UIColor grayColor];
        }else if (status == 101){
            currentState.text = @"已撤回";
            currentState.textColor = [UIColor orangeColor];
        }else if (status == 200){
            currentState.text = @"已经接受";
            currentState.textColor = [UIColor orangeColor];
        }else if (status == 200){
            currentState.text = @"等待确认";
            currentState.textColor = [UIColor orangeColor];
        }else if (status == 400||status==600){
            currentState.text = @"等待评价";
            if (evaluationDic) {
                currentState.textColor = [UIColor grayColor];
                currentState.text = @"完成";
            }else{
                currentState.textColor = [UIColor orangeColor];
            }
        }else if (status == 500){
            currentState.text = @"等待仲裁结果";
            currentState.textColor = [UIColor grayColor];
        }else if (status == 600){
            currentState.text = @"达人胜诉";
            currentState.textColor = [UIColor grayColor];
        }else if (status == 700){
            currentState.text = @"用户胜诉";
            currentState.textColor = [UIColor grayColor];
        }else if (status == 800){
            currentState.text = @"已评价";
            currentState.textColor = [UIColor grayColor];
        }else if (status == 300){
            currentState.text = @"已拒绝";
            currentState.textColor = [UIColor grayColor];
        }
    }else if(self.mytag == 666){
        if (status == 100) {
            currentState.text = @"等待接受";
            currentState.textColor = [UIColor orangeColor];
        }else if (status == 101){
            currentState.text = @"被撤回";
            currentState.textColor = [UIColor orangeColor];
        }else if (status == 200){
            currentState.text = @"已经接受";
            currentState.textColor = [UIColor grayColor];
        }else if (status == 2){
            currentState.text = @"已支付";
            currentState.textColor = [CorlorTransform  colorWithHexString:@"#00bb9c"];
        }else if (status == 400||status==600){
            currentState.text = @"等待评价";
            if (evaluationDic) {
                currentState.textColor = [UIColor grayColor];
                currentState.text = @"完成";
            }else{
                currentState.textColor = [UIColor grayColor];
            }
         }else if (status == 500){
            currentState.text = @"等待仲裁结果";
            currentState.textColor = [UIColor grayColor];
        }else if (status == 600){
            currentState.text = @"达人胜诉";
            currentState.textColor = [UIColor grayColor];
        }else if (status == 700){
            currentState.text = @"用户胜诉";
            currentState.textColor = [UIColor grayColor];
        }else if (status == 800){
            currentState.text = @"已评价";
            currentState.textColor = [UIColor grayColor];
        }else if (status == 300){
            currentState.text = @"已拒绝";
            currentState.textColor = [UIColor grayColor];
        }
    }
    currentState.font = [UIFont systemFontOfSize:13.0f];
    CGSize currentSize = [currentState.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:currentState.font,NSFontAttributeName, nil]];
    CGFloat currentStateH = currentSize.height;
    CGFloat currentStateW = currentSize.width;
    currentState.frame = CGRectMake(currentStateTitle.frame.origin.x+currentStateTitle.frame.size.width+4, priseSunitle.frame.origin.y+priseSunitle.frame.size.height+7, currentStateW, currentStateH);
    [self addSubview:currentState];
    self.currentState = currentState;
    
    UILabel *orderIdTitle = [[UILabel alloc] initWithFrame:CGRectMake(currentStateTitle.frame.origin.x+currentState.frame.origin.x+currentStateTitle.frame.size.width+10, priseSunitle.frame.origin.y+priseSunitle.frame.size.height+5, 50, 20)];
    orderIdTitle.text = @"订单ID:";
    orderIdTitle.font = [UIFont systemFontOfSize:13.0f];
    [self addSubview:orderIdTitle];
    
    UILabel *orderId = [[UILabel alloc] init];
    NSString *orderIdString = [NSString stringWithFormat:@"%d",[[orderDic objectForKey:@"id"]intValue]];
    orderId.text = orderIdString;
    orderId.font = [UIFont systemFontOfSize:13.0f];
    CGSize orderIdSize = [orderId.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:orderId.font,NSFontAttributeName, nil]];
    CGFloat orderIdSunH = orderIdSize.height;
    CGFloat orderIdSunW = orderIdSize.width;
    orderId.frame = CGRectMake(orderIdTitle.frame.origin.x+orderIdTitle.frame.size.width, priseSunitle.frame.origin.y+priseSunitle.frame.size.height+7, orderIdSunW, orderIdSunH);
    [self addSubview:orderId];
    self.orderId = orderId;
}
- (IBAction)userDetail:(UIButton *)sender {
    NSDictionary *peiwan = nil;
    if (self.mytag == 666) {
        peiwan = [self.orderDic objectForKey:@"user"];
    }else{
        peiwan = [self.orderDic objectForKey:@"peiwan"];
     }
    [self.delegate userdetail:peiwan AndTag:self.mytag];
}

- (IBAction)detailOrder:(UITapGestureRecognizer *)sender {
    [self.delegate detailOrder:self.orderDic AndTag:self.mytag];
}

@end
