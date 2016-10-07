//
//  PlagerinfoViewController.h
//  MeiWan
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlagerinfoViewController : UIViewController

@property(nonatomic,strong)NSDictionary *playerInfo;
@property (strong, nonatomic)  UIScrollView *playSv;
@property (nonatomic, assign) int friendList;

@end
