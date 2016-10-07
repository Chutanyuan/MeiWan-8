//
//  MoveActionViewController.h
//  MeiWan
//
//  Created by apple on 15/8/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol moveAction <NSObject>

-(void)back;

@end
@interface MoveActionViewController : UIViewController
@property (nonatomic,weak)id<moveAction> delegate;
@end
