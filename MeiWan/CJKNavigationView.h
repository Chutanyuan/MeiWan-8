//
//  CJKNavigationView.h
//  text
//
//  Created by user_kevin on 16/6/23.
//  Copyright © 2016年 user_kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CJKNavigationViewDelegate <NSObject>

-(void)leftButtonClick:(UIButton *)sender;
-(void)rightButtonClick:(UIButton *)sender; 

@end

@interface CJKNavigationView : UIView

@property(nonatomic,strong)UIButton * leftButton;
@property(nonatomic,strong)UIButton * rightButton;
@property(nonatomic,strong)UILabel * titleLabel;

@property(nonatomic,weak)id<CJKNavigationViewDelegate>delegate;

@end
