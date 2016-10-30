//
//  showImageController.h
//  MeiWan
//
//  Created by user_kevin on 16/9/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface showImageController : UIViewController

/** 图片展示的数组 */
@property(nonatomic,strong)NSArray * imagesArray;
/** 图片偏移量的定位 */
@property(nonatomic,assign)NSInteger imageNumber;
/** 跳转类型 */
@property(nonatomic,assign)NSInteger flagType;

@end
