//
//  MoveActionViewCell.h
//  MeiWan
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoveAction.h"
#import "MoveActionFrame.h"
@class ButtonLable;
@protocol MoveActionCellDelegate <NSObject>

@optional
-(void)tapHeadImg:(MoveActionFrame*)moveActionFrame;
-(void)tapImage:(NSInteger)imageTag AndMoveActionFrame:(MoveActionFrame*)moveActionFrame;
-(void)praise;
-(void)discuss:(MoveActionFrame*)moveActionFrame andIndexPathRow:(NSInteger)row;
@end

@interface MoveActionViewCell : UITableViewCell
@property (nonatomic,weak) id<MoveActionCellDelegate> delegate;
@property (strong, nonatomic)  UIImageView *icon;
@property (strong, nonatomic)  UILabel *name;
@property (strong, nonatomic)  UILabel *UnionTitle;
@property (strong, nonatomic)  UILabel *time;
@property (strong, nonatomic)  UIView *ageAndSex;
@property (strong, nonatomic)  UIImageView *seximage;
@property (strong, nonatomic)  UILabel *age;
@property (strong, nonatomic)  UILabel *textview;
@property (strong, nonatomic)  UIImageView *image1;
@property (strong, nonatomic)  UIImageView *image2;
@property (strong, nonatomic)  UIImageView *image3;
@property (strong, nonatomic)  ButtonLable * praise;
@property (strong, nonatomic)  ButtonLable * discuss;
@property (assign, nonatomic)  NSInteger indexRow;
@property (nonatomic, strong) MoveActionFrame *moveActionFrame;
@end
