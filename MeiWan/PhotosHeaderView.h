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

@property(nonatomic,weak)id<PhohtsHeaderViewDelegate>delegate;

@end
