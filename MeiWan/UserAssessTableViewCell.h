//
//  UserAssessTableViewCell.h
//  MeiWan
//
//  Created by apple on 15/8/12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"

@protocol userAssessTapdelegate <NSObject>

- (void)tapUserAssessImage:(NSDictionary*)assessDic;

@end
@interface UserAssessTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headIg;
@property (strong, nonatomic) IBOutlet UILabel *assess;
@property (strong, nonatomic) IBOutlet UITextView *assessText;
@property (strong, nonatomic) IBOutlet UIView *starView;
@property (strong, nonatomic) IBOutlet UILabel *assessTime;
@property (strong, nonatomic) IBOutlet UILabel *nicename;
@property (strong, nonatomic) CWStarRateView *starRateView;
@property (strong, nonatomic) NSDictionary *assessDic;
@property (nonatomic, weak) id<userAssessTapdelegate> delegate;
@end
