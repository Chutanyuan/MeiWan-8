//
//  NetBarViewController.h
//  MeiWan
//
//  Created by apple on 15/9/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetBarViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *nameOfNetBar;
@property (strong, nonatomic) IBOutlet UIImageView *locationIg;
@property (strong, nonatomic) IBOutlet UILabel *locationlable;
@property (strong, nonatomic) IBOutlet UIImageView *phoneIg;
@property (strong, nonatomic) NSDictionary *barInfo;
@end
