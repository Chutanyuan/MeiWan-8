//
//  DiscussTableViewController.h
//  MeiWan
//
//  Created by apple on 15/11/12.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MoveActionFrame;
@protocol DiscussTabViewDelegate <NSObject>

-(void)countDidChange:(int)count atIndexPathRow:(NSInteger)row;
-(void)praiseDidChange:(BOOL)isPraise atIndexPathRow:(NSInteger)row;
@end
@interface DiscussTableViewController : UITableViewController
@property (nonatomic,weak)id<DiscussTabViewDelegate>delegate;
@property (nonatomic,strong) MoveActionFrame * maf;
@property (nonatomic,assign) BOOL isFromDiscuss;
@property (nonatomic,assign) BOOL isPrised;
@property (nonatomic,assign) NSInteger indexPathrow;
@end
