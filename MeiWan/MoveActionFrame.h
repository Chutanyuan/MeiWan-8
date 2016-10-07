//
//  MoveActionFrame.h
//  MeiWan
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoveAction.h"
@interface MoveActionFrame : NSObject

@property(nonatomic, assign, readonly) CGRect iconF;

@property(nonatomic, assign, readonly) CGRect nameF;

@property(nonatomic, assign, readonly) CGRect ageAndSexF;

@property(nonatomic, assign, readonly) CGRect sexImageF;

@property(nonatomic, assign, readonly) CGRect ageF;

@property(nonatomic, assign, readonly) CGRect praiseF;

@property(nonatomic, assign, readonly) CGRect discussF;

@property(nonatomic, assign, readonly) CGRect timeF;

@property(nonatomic, assign, readonly) CGRect textF;

@property(nonatomic, assign, readonly) CGRect image1F;

@property(nonatomic, assign, readonly) CGRect image2F;

@property(nonatomic, assign, readonly) CGRect image3F;

@property(nonatomic, assign, readonly) CGRect grayViewF;

@property(nonatomic, assign, readonly) CGFloat cellHeight;

@property(nonatomic, strong) MoveAction *moveActionModel;
@end
