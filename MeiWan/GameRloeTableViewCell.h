//
//  GameRloeTableViewCell.h
//  MeiWan
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meiwan-Swift.h"
@interface GameRloeTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *headig;
@property (strong, nonatomic) IBOutlet UILabel *niceName;
@property (strong, nonatomic) IBOutlet UILabel *gameRole;
@property (strong, nonatomic) IBOutlet UILabel *sword;
@property (strong, nonatomic) NSDictionary *roleInfo;
@property (strong, nonatomic) LOLInfo *lolInfo;
@end
