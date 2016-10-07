//
//  DiscussView.m
//  MeiWan
//
//  Created by apple on 15/11/12.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "DiscussView.h"
#import "ButtonLable.h"
#import "CorlorTransform.h"
#import "UIImageView+WebCache.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "ShowMessage.h"

@implementation DiscussView

-(instancetype)init{
    if (self = [super init]) {
        UIImageView *icon = [[UIImageView alloc]init];
        icon.layer.cornerRadius = 25;
        icon.layer.masksToBounds = YES;
        icon.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeadImage)];
        [icon addGestureRecognizer:tap];
        icon.userInteractionEnabled = YES;
        [self addSubview:icon];
        self.icon = icon;
        
        UILabel *name = [[UILabel alloc]init];
        name.font = [UIFont systemFontOfSize:14];
        [self addSubview:name];
        self.name = name;
        
        UILabel *time = [[UILabel alloc]init];
        time.font = [UIFont systemFontOfSize:14];
        [self addSubview:time];
        self.time = time;
        
        UIView *ageAndSex = [[UIView alloc]init];
        [self addSubview:ageAndSex];
        ageAndSex.layer.cornerRadius = 3;
        ageAndSex.layer.masksToBounds = YES;
        self.ageAndSex = ageAndSex;
        
        UIImageView *sexImage = [[UIImageView alloc]init];
        [self addSubview:sexImage];
        self.seximage = sexImage;
        
        UILabel *age = [[UILabel alloc]init];
        age.font = [UIFont systemFontOfSize:12];
        age.textColor = [UIColor whiteColor];
        [self addSubview:age];
        self.age = age;
        
        UILabel *textview = [[UILabel alloc]init];
        textview.numberOfLines = 0;
        textview.font = [UIFont systemFontOfSize:15];
        textview.userInteractionEnabled = NO;
        //textview.backgroundColor = [UIColor redColor];
        [self addSubview:textview];
        self.textview = textview;
        
        UIImageView *image1 = [[UIImageView alloc]init];
        [self addSubview:image1];
        image1.contentMode = UIViewContentModeScaleAspectFill;
        image1.clipsToBounds = YES;
        image1.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
        [image1 addGestureRecognizer:tap1];
        image1.tag = 111;
        self.image1 = image1;
        
        
        UIImageView *image2 = [[UIImageView alloc]init];
        [self addSubview:image2];
        image2.contentMode = UIViewContentModeScaleAspectFill;
        image2.clipsToBounds = YES;
        image2.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
        [image2 addGestureRecognizer:tap2];
        image2.tag = 222;
        self.image2 = image2;
        
        UIImageView *image3 = [[UIImageView alloc]init];
        [self addSubview:image3];
        image3.contentMode = UIViewContentModeScaleAspectFill;
        image3.clipsToBounds = YES;
        image3.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
        [image3 addGestureRecognizer:tap3];
        image3.tag = 333;
        self.image3 = image3;
        
        ButtonLable *praiseBtn = [ButtonLable buttonWithType:UIButtonTypeCustom];
        praiseBtn.lyTitleLable.frame = CGRectMake(20, 0, 20, 20);
        [praiseBtn.lyTitleLable setFont:[UIFont systemFontOfSize:10]];
        praiseBtn.lyTitleLable.textColor = [CorlorTransform colorWithHexString:@"a9b7b7"];
        [praiseBtn setImageEdgeInsets:UIEdgeInsetsMake(2.5, 0, 2.5, 25)];
        [praiseBtn setImage:[UIImage imageNamed:@"peiwan_praise"] forState:UIControlStateNormal];
        [praiseBtn setImage:[UIImage imageNamed:@"peiwan_praise1"] forState:UIControlStateSelected];
        [self addSubview:praiseBtn];
        [praiseBtn addTarget:self action:@selector(praiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.praise = praiseBtn;
        
        ButtonLable *discussBtn = [ButtonLable buttonWithType:UIButtonTypeCustom];
        discussBtn.lyTitleLable.frame = CGRectMake(20, 0, 20, 20);
        discussBtn.lyTitleLable.font = [UIFont systemFontOfSize:10];
        discussBtn.lyTitleLable.textColor = [CorlorTransform colorWithHexString:@"a9b7b7"];
        [discussBtn setImage:[UIImage imageNamed:@"peiwan_discuss"] forState:UIControlStateNormal];
//        [discussBtn setImage:[UIImage imageNamed:@"peiwan_discuss1"] forState:UIControlStateSelected];
        [discussBtn setImageEdgeInsets:UIEdgeInsetsMake(2.5, 0, 2.5, 25)];
        [self addSubview:discussBtn];
        [discussBtn addTarget:self action:@selector(discussBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.discuss = discussBtn;
    }
    
    UIView * grayView = [[UIView alloc]init];
    grayView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:grayView];
    self.grayView = grayView;
    
    
    return self;
    
}
- (void)praiseBtnClick:(UIButton*)btn{
    self.praise.selected = !btn.selected;
    if (self.praise.selected) {
        //NSLog(@"%ld---%ld",self.moveActionFrame.moveActionModel.userId,self.moveActionFrame.moveActionModel.stateId);
        [UserConnector likeUserState:[PersistenceManager getLoginSession] toId:[NSNumber numberWithLong:self.moveActionFrame.moveActionModel.userId] stateId:[NSNumber numberWithLong:self.moveActionFrame.moveActionModel.stateId ] receiver:^(NSData * data, NSError * error) {
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser *parser = [[SBJsonParser alloc]init];
                NSMutableDictionary *json = [parser objectWithData:data];
                //NSLog(@"%@",json);
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    int count = self.praise.lyTitleLable.text.intValue;
                    self.praise.lyTitleLable.text = [NSString stringWithFormat:@"%d",count + 1];
                    [self.delegate praiseDidChange:YES];
                }else if(status == 1){
                    [ShowMessage showMessage:@"您的账号已在异地登陆"];
                }else{
                    
                }
            }
            
        }];
        self.praise.lyTitleLable.textColor = [CorlorTransform colorWithHexString:@"56abe4"];
        [UIView animateWithDuration:0.5 animations:^{
            self.praise.alpha = 0.0;
            self.praise.alpha = 1.0;
            self.praise.transform = CGAffineTransformIdentity;
            CGAffineTransform transform1 = CGAffineTransformMakeTranslation(-5.0f, -30.0f);
            CGAffineTransform transform2 = CGAffineTransformMakeScale(2.0f, 2.0f);
            CGAffineTransform transform = CGAffineTransformConcat(transform1, transform2);
            self.praise.transform = transform;
            
        }
        completion:^(BOOL finished)
         {
             self.praise.transform = CGAffineTransformIdentity;
         }];
        
    }else{
        [UserConnector unlikeUserState:[PersistenceManager getLoginSession] toId:[NSNumber numberWithLong:self.moveActionFrame.moveActionModel.userId] stateId:[NSNumber numberWithLong:self.moveActionFrame.moveActionModel.stateId ] receiver:^(NSData * data, NSError * error) {
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser *parser = [[SBJsonParser alloc]init];
                NSMutableDictionary *json = [parser objectWithData:data];
                //NSLog(@"%@",json);
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    int count = self.praise.lyTitleLable.text.intValue;
                    if (count-1 == 0) {
                        self.praise.lyTitleLable.text = @"赞";
                    }else{
                        self.praise.lyTitleLable.text = [NSString stringWithFormat:@"%d",count - 1];
                    }
                    [self.delegate praiseDidChange:NO];
                }else if(status == 1){
                    [ShowMessage showMessage:@"您的账号已在异地登陆"];
                }else{
                    
                }
            }
            
        }];
        self.praise.lyTitleLable.textColor = [CorlorTransform colorWithHexString:@"a9b7b7"];
    }
}
- (void)discussBtnClick:(UIButton*)btn{

    [self.delegate discuss:self.moveActionFrame];
}

-(void)tapHeadImage{
    [self.delegate tapHeadImage:self.moveActionFrame];
}
-(void)tapImage:(UITapGestureRecognizer*)tap{
    [self.delegate tapImage:tap.view.tag AndMoveActionFrame:self.moveActionFrame];
}

-(void)setMoveActionFrame:(MoveActionFrame *)moveActionFrame{
    _moveActionFrame = moveActionFrame;
    [self settingData];
    [self settingFrame];
    
}
-(void)settingData{
    MoveAction *moveActionModel = self.moveActionFrame.moveActionModel;
    if (moveActionModel.discussCount == 0) {
        self.discuss.lyTitleLable.text = @"评论" ;
    }else{
        self.discuss.lyTitleLable.text = [NSString stringWithFormat:@"%d",moveActionModel.discussCount];
    }
    if (moveActionModel.praiseCount == 0) {
        self.praise.lyTitleLable.text = @"赞" ;
    }else{
        self.praise.lyTitleLable.text = [NSString stringWithFormat:@"%d",moveActionModel.praiseCount];
    }
    if (moveActionModel.isPraise) {
        self.praise.selected = YES;
        self.praise.lyTitleLable.textColor = [CorlorTransform colorWithHexString:@"56abe4"];
    }else{
        self.praise.selected = NO;
        self.praise.lyTitleLable.textColor = [CorlorTransform colorWithHexString:@"a9b7b7"];

    }

    self.name.text = moveActionModel.nackname;
    self.time.text = moveActionModel.time;
    if (moveActionModel.sex == 0) {
        self.seximage.image = [UIImage imageNamed:@"peiwan_male"];
        self.ageAndSex.backgroundColor = [CorlorTransform colorWithHexString:@"#007aff" andAlpha:88/255.0];
    }else{
        self.seximage.image = [UIImage imageNamed:@"peiwan_female"];
        self.ageAndSex.backgroundColor = [CorlorTransform colorWithHexString:@"#ffc0cb"];
    }
    self.age.text = moveActionModel.age;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",moveActionModel.headImage]];
    [self.icon setImageWithURL:url];
    //正文
    self.textview.text = moveActionModel.text;
    //配图
    if(![moveActionModel.image1 isKindOfClass:[NSNull class]] && [moveActionModel.image2 isKindOfClass:[NSNull class]] && [moveActionModel.image3 isKindOfClass:[NSNull class]]){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",moveActionModel.image1]];
        [self.image1 setImageWithURL:url];
    }else if(![moveActionModel.image1 isKindOfClass:[NSNull class]] && ![moveActionModel.image2 isKindOfClass:[NSNull class]] && [moveActionModel.image3 isKindOfClass:[NSNull class]]){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",moveActionModel.image1]];
        [self.image1 setImageWithURL:url];
        NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",moveActionModel.image2]];
        [self.image2 setImageWithURL:url2];
        
    }else if(![moveActionModel.image1 isKindOfClass:[NSNull class]] && ![moveActionModel.image2 isKindOfClass:[NSNull class]] && ![moveActionModel.image3 isKindOfClass:[NSNull class]]){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",moveActionModel.image1]];
        [self.image1 setImageWithURL:url];
        NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",moveActionModel.image2]];
        [self.image2 setImageWithURL:url2];
        NSURL *url3 = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",moveActionModel.image3]];
        [self.image3 setImageWithURL:url3];
    }else{
        
    }
}

-(void)settingFrame{
    
    self.icon.frame = self.moveActionFrame.iconF;
    self.name.frame = self.moveActionFrame.nameF;
    self.time.frame = self.moveActionFrame.timeF;
    self.ageAndSex.frame = self.moveActionFrame.ageAndSexF;
    self.seximage.frame = self.moveActionFrame.sexImageF;
    self.age.frame = self.moveActionFrame.ageF;
    self.praise.frame = self.moveActionFrame.praiseF;
    self.discuss.frame = self.moveActionFrame.discussF;
    self.textview.frame = self.moveActionFrame.textF;
    if(self.moveActionFrame.moveActionModel.image1 && !self.moveActionFrame.moveActionModel.image2 && !self.moveActionFrame.moveActionModel.image3){
        self.image1.frame = self.moveActionFrame.image1F;
    }else if(self.moveActionFrame.moveActionModel.image1 && self.moveActionFrame.moveActionModel.image2 && !self.moveActionFrame.moveActionModel.image3){
        self.image1.frame = self.moveActionFrame.image1F;
        self.image2.frame = self.moveActionFrame.image2F;
    }else if(self.moveActionFrame.moveActionModel.image1 && self.moveActionFrame.moveActionModel.image2 && self.moveActionFrame.moveActionModel.image3){
        self.image1.frame = self.moveActionFrame.image1F;
        self.image2.frame = self.moveActionFrame.image2F;
        self.image3.frame = self.moveActionFrame.image3F;
    }else{
        
    }
    self.grayView.frame = self.moveActionFrame.grayViewF;
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.moveActionFrame.cellHeight + 8);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
