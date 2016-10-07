//
//  ImageViewController.h
//  MeiWan
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoveActionFrame.h"
@interface ImageViewController : UIViewController
@property (nonatomic,strong) MoveActionFrame *moveActionframe;
@property (nonatomic,assign) int imageCount;
@end
