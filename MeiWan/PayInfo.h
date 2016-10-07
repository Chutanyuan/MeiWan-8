//
//  PayInfo.h
//  MeiWan
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol superviewdelegate <NSObject>

-(void)resetSuperview:(NSMutableDictionary*)search;
-(void)moveBackview;

@end

@interface PayInfo : UIView
{
    BOOL isSelect[5];
}
@property (nonatomic,weak) id<superviewdelegate> delegate;

@property (nonatomic,strong) NSMutableDictionary *searchDic;

@property(nonatomic,strong)UIButton * chooseSexButton;
@property(nonatomic,strong)UIButton * buttonPriceChoose;

@end