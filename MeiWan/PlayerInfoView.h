//
//  PlayerInfoView.h
//  MeiWan
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"
#import "UserInfo.h"

@protocol pageJumpDelegate <NSObject>

@optional
-(void)showChat;
-(void)showInvite;
-(void)showState;
-(void)showpicture;
@end
@interface PlayerInfoView : UIView
@property (nonatomic,weak) id<pageJumpDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) IBOutlet UIView *playWithView;
@property (strong, nonatomic) IBOutlet UIView *signaTureView;
@property (strong, nonatomic) IBOutlet UIImageView *head;
@property (strong, nonatomic) IBOutlet UILabel *userId;
@property (strong, nonatomic) IBOutlet UIView *ageAndSex;
@property (strong, nonatomic) IBOutlet UIImageView *sexImage;
@property (strong, nonatomic) IBOutlet UILabel *age;
@property (strong, nonatomic) IBOutlet UIView *starView;
@property (strong, nonatomic) CWStarRateView *starRateView;
@property (strong, nonatomic) IBOutlet UIImageView *labImage1;
@property (strong, nonatomic) IBOutlet UIImageView *labImage2;
@property (strong, nonatomic) IBOutlet UIImageView *labImage3;

@property (nonatomic, strong) NSDictionary *userInfoDic;
@property (nonatomic, strong) UserInfo *userinfo;

@property (strong, nonatomic) IBOutlet UILabel *scroce;

@property (strong, nonatomic) IBOutlet UIImageView *location;
@property (strong, nonatomic) IBOutlet UILabel *distance;
@property (strong, nonatomic) IBOutlet UILabel *signature;
@property (strong, nonatomic) IBOutlet UILabel *personInfo;
@property (strong, nonatomic) IBOutlet UIButton *talkWith;
@property (nonatomic,strong) NSDictionary *playerInfoDic;
@property (strong, nonatomic) IBOutlet UILabel *stateContent;
@property (strong, nonatomic) IBOutlet UILabel *noticeUser;
@property (strong, nonatomic) IBOutlet UIImageView *stateImage1;
@property (strong, nonatomic) IBOutlet UIImageView *stateImage2;
@property (strong, nonatomic) IBOutlet UIImageView *stateImage3;
@property (nonatomic,strong) NSDictionary *stateDic;

//下单按钮隐藏
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UIButton *helloButton;
@property (weak, nonatomic) IBOutlet UIButton *hello2button;

@end
