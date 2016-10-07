//
//  RecordTableViewCell.h
//  MeiWan
//
//  Created by apple on 15/9/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *howMany;
@property (strong, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) NSDictionary *infodic;
@end
