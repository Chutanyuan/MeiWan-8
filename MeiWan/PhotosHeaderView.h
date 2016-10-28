//
//  PhotosHeaderView.h
//  MeiWan
//
//  Created by user_kevin on 16/10/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhohtsHeaderViewDelegate <NSObject>

-(void)fourButtonWithTitle:(UIButton *)sender;

@end

@interface PhotosHeaderView : UIView

@property(nonatomic,strong)NSDictionary * userMessage;
@property (strong, nonatomic) UILabel *biaoqian1;
@property (strong, nonatomic) UILabel *biaoqian2;
@property (strong, nonatomic) UILabel *biaoqian3;
@property(nonatomic,strong)UIView * redLine;
@property(nonatomic,strong)UIButton * concern;//关注

@property(nonatomic,weak)id<PhohtsHeaderViewDelegate>delegate;

@end
