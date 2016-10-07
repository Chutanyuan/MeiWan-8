//
//  GreatGuildViewController.h
//  MeiWan
//
//  Created by Fox on 16/8/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol greatGuildDelegate <NSObject>

- (void)popViewLoadView;

@end

@interface GreatGuildViewController : UIViewController
@property(nonatomic,weak)id<greatGuildDelegate>delegate;
@end
