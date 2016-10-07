//
//  blackModel.h
//  MeiWan
//
//  Created by user_kevin on 16/6/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface blackModel : NSObject

@property(nonatomic,assign)NSString * headerUrl;
@property(nonatomic,assign)NSString * nickName;
@property(nonatomic,assign)NSNumber * ID;


-(id)initWithDictionary:(NSDictionary *)dic;

@end
