//
//  DiscussCell.h
//  MeiWan
//
//  Created by apple on 15/11/12.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DiscussCellDelegate <NSObject>
@optional
- (void)tapHeadImg:(NSDictionary *)discussDic;

@end

@interface DiscussCell : UITableViewCell
@property (weak,nonatomic)id<DiscussCellDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIImageView *headImg;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) IBOutlet UILabel *publicationTime;
@property (strong, nonatomic) IBOutlet UILabel *content;
@property (strong, nonatomic) NSDictionary * discussDic;
@end
