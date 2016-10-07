//
//  HotCountCellChange.h
//  MeiWan
//
//  Created by user_kevin on 16/6/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotCountCellChange : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) IBOutlet UILabel *distanceAndTime;
@property (strong, nonatomic) IBOutlet UIImageView *sexImage;
@property (strong, nonatomic) IBOutlet UILabel *age;
@property (strong, nonatomic) IBOutlet UIView *ageAndSex;
@property (strong, nonatomic) IBOutlet UIImageView *hotImage;
@property (strong, nonatomic) IBOutlet UILabel *hotCount;
@property (strong, nonatomic) IBOutlet UILabel *signTure;
@property (strong, nonatomic) IBOutlet UILabel *rank;

@property (strong, nonatomic) NSDictionary * personInfo;

@end
