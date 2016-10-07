//
//  PlayerView.h
//  MeiWan
//
//  Created by apple on 15/8/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PalyListViewController.h"
@protocol playerviewdelegate <NSObject>
@optional
-(void)showPlayerInfo:(NSDictionary*)PlayerInfo;
@end

@interface PlayerView : UIView
@property (nonatomic,weak) id<playerviewdelegate> delegate;

@property (strong, nonatomic)  UILabel *login_time;

@property (strong, nonatomic) UILabel *hot;
@property (strong, nonatomic) UIImageView *Head;
@property (strong, nonatomic) UILabel *signature;
@property (strong, nonatomic) UILabel *nicename;
@property (strong, nonatomic) UIView *ageAndsex;
@property (strong, nonatomic) UIImageView *sex;
@property (strong, nonatomic) UILabel *age;
@property (strong, nonatomic) UIImageView *location;
@property (strong, nonatomic) UILabel *distance;
@property (strong, nonatomic) UIImageView *assess1;
@property (strong, nonatomic) UIImageView *assess2;
@property (strong, nonatomic) UIImageView *assess3;
@property (strong, nonatomic) UILabel * offlinePrice;
@property (strong, nonatomic) UILabel *biaoqian1;
@property (strong, nonatomic) UILabel *biaoqian2;
@property (strong, nonatomic) UILabel *biaoqian3;
@property (strong, nonatomic) UIImageView *biaoqianImage1;
@property (strong, nonatomic) UIImageView *biaoqianImage2;
@property (strong, nonatomic) UIImageView *biaoqianImage3;
@property (assign, nonatomic) NSArray * titlelabel;


@property (strong, nonatomic) NSDictionary *playerInfo;
@end
