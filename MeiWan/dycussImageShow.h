//
//  dycussImageShow.h
//  MeiWan
//
//  Created by user_kevin on 16/9/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dycussImageShow : UIViewController

/** 图片展示的数组 */
@property(nonatomic,strong)NSMutableArray * imagesArray;
/** 图片偏移量的定位 */
@property(nonatomic,assign)NSInteger imageNumber;

@end
