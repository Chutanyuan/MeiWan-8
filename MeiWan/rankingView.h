//
//  PlayerView.h
//  MeiWan
//
//  Created by apple on 15/8/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PalyListViewController.h"
@protocol rankingviewdelegate <NSObject>
@optional
-(void)showPlayerInfo:(NSDictionary*)PlayerInfo;
@end

@interface rankingView : UIView
@property (nonatomic,weak) id<rankingviewdelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *hot;
@property (strong, nonatomic) IBOutlet UIImageView *Head;
@property (strong, nonatomic) IBOutlet UILabel *signature;
@property (strong, nonatomic) IBOutlet UILabel *nicename;
@property (strong, nonatomic) IBOutlet UIView *ageAndsex;
@property (strong, nonatomic) IBOutlet UIImageView *sex;
@property (strong, nonatomic) IBOutlet UILabel *age;
@property (strong, nonatomic) IBOutlet UIImageView *location;
@property (strong, nonatomic) IBOutlet UILabel *distance;
@property (strong, nonatomic) IBOutlet UILabel *logintime;
@property (strong, nonatomic) IBOutlet UILabel *ranklab;
@property (strong, nonatomic) IBOutlet UIImageView *rankImage;
@property (weak, nonatomic) IBOutlet UIImageView *grayColorView;

@property (strong, nonatomic) NSDictionary *playerInfo;
@end
