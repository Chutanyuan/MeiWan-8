//
//  DiscussView.h
//  MeiWan
//
//  Created by apple on 15/11/12.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoveAction.h"
#import "MoveActionFrame.h"
@class ButtonLable;
@protocol DiscussViewDelegate <NSObject>
@optional
-(void)tapHeadImage:(MoveActionFrame*)moveActionframe;
-(void)tapImage:(NSInteger)imageTag AndMoveActionFrame:(MoveActionFrame*)moveActionFrame;
-(void)praise;
-(void)discuss:(MoveActionFrame*)moveActionFrame;
-(void)praiseDidChange:(BOOL)isPraise;

@end

@interface DiscussView : UIView
@property (nonatomic,weak) id<DiscussViewDelegate> delegate;
@property (strong, nonatomic)  UIImageView *icon;
@property (strong, nonatomic)  UILabel *name;
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
@property (strong, nonatomic)  UIView * grayView;
@property (nonatomic, strong) MoveActionFrame *moveActionFrame;
@end
