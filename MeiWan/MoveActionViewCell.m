//
//  MoveActionViewCell.m
//  MeiWan
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MoveActionViewCell.h"
#import "CorlorTransform.h"
#import "UIImageView+WebCache.h"
#import "ButtonLable.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "ShowMessage.h"
@implementation MoveActionViewCell

- (void)awakeFromNib {
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, [[UIScreen mainScreen] applicationFrame].size.width, frame.size.height);

    UIImageView *icon = [[UIImageView alloc]init];
    icon.layer.cornerRadius = 25;
    icon.clipsToBounds = YES;
    icon.contentMode = UIViewContentModeScaleAspectFill;
    icon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeadImg:)];
    [icon addGestureRecognizer:tap];
    [self.contentView addSubview:icon];
    self.icon = icon;
    
    UILabel *name = [[UILabel alloc]init];
    name.font = [UIFont systemFontOfSize:14];
     [self.contentView addSubview:name];
    self.name = name;
    
    self.UnionTitle = [[UILabel alloc]init];
    self.UnionTitle.font = [UIFont systemFontOfSize:12];
    self.UnionTitle.textColor = [CorlorTransform colorWithHexString:@"ff3333"];
    [self.contentView addSubview:self.UnionTitle];
    
    UILabel *time = [[UILabel alloc]init];
    time.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:time];
    time.textColor = [CorlorTransform colorWithHexString:@"a9b7b7"];
    self.time = time;
    
    UIView *ageAndSex = [[UIView alloc]init];
    [self.contentView addSubview:ageAndSex];
    ageAndSex.layer.cornerRadius = 3;
    ageAndSex.layer.masksToBounds = YES;
    self.ageAndSex = ageAndSex;
    
    UIImageView *sexImage = [[UIImageView alloc]init];
    [self.contentView addSubview:sexImage];
    self.seximage = sexImage;
    
    UILabel *age = [[UILabel alloc]init];
    age.font = [UIFont systemFontOfSize:12];
    age.textColor = [UIColor whiteColor];
    [self.contentView addSubview:age];
    self.age = age;
    
    UILabel *textview = [[UILabel alloc]init];
    textview.numberOfLines = 0;
    textview.font = [UIFont systemFontOfSize:14];
    textview.userInteractionEnabled = NO;
    //textview.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:textview];
    self.textview = textview;
    
    UIImageView *image1 = [[UIImageView alloc]init];
    image1.contentMode = UIViewContentModeScaleAspectFill;
    image1.clipsToBounds = YES;
    image1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
    [image1 addGestureRecognizer:tap1];
    image1.tag = 111;
    //image1.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:image1];
     self.image1 = image1;

    
    UIImageView *image2 = [[UIImageView alloc]init];
    image2.contentMode = UIViewContentModeScaleAspectFill;
    image2.clipsToBounds = YES;
    image2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
    [image2 addGestureRecognizer:tap2];
    //image2.backgroundColor = [UIColor redColor];
    image2.tag = 222;
    [self.contentView addSubview:image2];
    self.image2 = image2;
    
    UIImageView *image3 = [[UIImageView alloc]init];
    image3.contentMode = UIViewContentModeScaleAspectFill;
    image3.clipsToBounds = YES;
    image3.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
    [image3 addGestureRecognizer:tap3];
    //image3.backgroundColor = [UIColor redColor];
    image3.tag = 333;
    [self.contentView addSubview:image3];
    self.image3 = image3;
    
    ButtonLable *praiseBtn = [ButtonLable buttonWithType:UIButtonTypeCustom];
    praiseBtn.lyTitleLable.frame = CGRectMake(20, 0, 20, 20);
    [praiseBtn.lyTitleLable setFont:[UIFont systemFontOfSize:10]];
    praiseBtn.lyTitleLable.textColor = [CorlorTransform colorWithHexString:@"a9b7b7"];
    [praiseBtn setImageEdgeInsets:UIEdgeInsetsMake(2.5, 0, 2.5, 25)];
    [praiseBtn setImage:[UIImage imageNamed:@"peiwan_praise"] forState:UIControlStateNormal];
    [praiseBtn setImage:[UIImage imageNamed:@"peiwan_praise1"] forState:UIControlStateSelected];
    [self.contentView addSubview:praiseBtn];
    [praiseBtn addTarget:self action:@selector(praiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.praise = praiseBtn;

    ButtonLable *discussBtn = [ButtonLable buttonWithType:UIButtonTypeCustom];
    discussBtn.lyTitleLable.frame = CGRectMake(20, 0, 20, 20);
    discussBtn.lyTitleLable.font = [UIFont systemFontOfSize:10];
    discussBtn.lyTitleLable.textColor = [CorlorTransform colorWithHexString:@"a9b7b7"];
    [discussBtn setImage:[UIImage imageNamed:@"peiwan_discuss"] forState:UIControlStateNormal];
//    [discussBtn setImage:[UIImage imageNamed:@"peiwan_discuss1"] forState:UIControlStateSelected];
    [discussBtn setImageEdgeInsets:UIEdgeInsetsMake(2.5, 0, 2.5, 25)];
    [self.contentView addSubview:discussBtn];
    [discussBtn addTarget:self action:@selector(discussBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.discuss = discussBtn;

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
                    self.moveActionFrame.moveActionModel.praiseCount += 1;
                    self.moveActionFrame.moveActionModel.isPraise=YES;
                    self.praise.lyTitleLable.text = [NSString stringWithFormat:@"%d",count + 1];
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
                    self.moveActionFrame.moveActionModel.praiseCount -= 1;
                    self.moveActionFrame.moveActionModel.isPraise =  NO;
                    if (count-1 == 0) {
                        self.praise.lyTitleLable.text = @"赞";
                    }else{
                        self.praise.lyTitleLable.text = [NSString stringWithFormat:@"%d",count - 1];
                    }
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
    [self.delegate discuss:self.moveActionFrame andIndexPathRow:self.indexRow];
}
-(void)tapHeadImg:(UITapGestureRecognizer*)tap{
    [self.delegate tapHeadImg:self.moveActionFrame];
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
        self.praise.lyTitleLable.text = @"赞";
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
    self.UnionTitle.text = moveActionModel.unionTitle;
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
    
    CGSize size_union = [self.UnionTitle.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.UnionTitle.font,NSFontAttributeName, nil]];
    self.UnionTitle.frame = CGRectMake(self.name.frame.size.width+self.name.frame.origin.x+10, self.name.center.y-size_union.height/2, size_union.width, size_union.height);
    
    self.time.frame = self.moveActionFrame.timeF;
    self.ageAndSex.frame = self.moveActionFrame.ageAndSexF;
    self.seximage.frame = self.moveActionFrame.sexImageF;
    self.age.frame = self.moveActionFrame.ageF;
    self.praise.frame = self.moveActionFrame.praiseF;
    self.discuss.frame = self.moveActionFrame.discussF;
    self.textview.frame = self.moveActionFrame.textF;
    if(![self.moveActionFrame.moveActionModel.image1 isKindOfClass:[NSNull class]] && [self.moveActionFrame.moveActionModel.image2 isKindOfClass:[NSNull class]] && [self.moveActionFrame.moveActionModel.image3 isKindOfClass:[NSNull class]]){
        self.image1.frame = self.moveActionFrame.image1F;
    }else if(![self.moveActionFrame.moveActionModel.image1 isKindOfClass:[NSNull class]] && ![self.moveActionFrame.moveActionModel.image2 isKindOfClass:[NSNull class]] && [self.moveActionFrame.moveActionModel.image3 isKindOfClass:[NSNull class]]){
        self.image1.frame = self.moveActionFrame.image1F;
        self.image2.frame = self.moveActionFrame.image2F;
    }else if(![self.moveActionFrame.moveActionModel.image1 isKindOfClass:[NSNull class]] && ![self.moveActionFrame.moveActionModel.image2 isKindOfClass:[NSNull class]] && ![self.moveActionFrame.moveActionModel.image3 isKindOfClass:[NSNull class]]){
        self.image1.frame = self.moveActionFrame.image1F;
        self.image2.frame = self.moveActionFrame.image2F;
        self.image3.frame = self.moveActionFrame.image3F;
    }else{

    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
