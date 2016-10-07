//
//  HotCountCell.h
//  MeiWan
//
//  Created by apple on 15/11/23.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotCountCell : UITableViewCell
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
