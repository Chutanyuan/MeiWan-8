//
//  CorlorTransform.h
//  MeiWan
//
//  Created by apple on 15/8/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CorlorTransform : NSObject
+(UIColor *) colorWithHexString: (NSString *)color;
+(UIColor *) colorWithHexString: (NSString *)color andAlpha:(float)alpha;
@end
