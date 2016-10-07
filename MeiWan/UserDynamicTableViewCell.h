//
//  UserDynamicTableViewCell.h
//  beautity_play
//
//  Created by Fox on 16/7/13.
//  Copyright © 2016年 user_kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserDynamicDelegate <NSObject>

@optional

-(void)showChat;
-(void)showInvite;
-(void)showState;
-(void)showpicture;
- (void)showPicture:(UITapGestureRecognizer*)gesture imageArray:(NSArray *)array;

@end

@interface UserDynamicTableViewCell : UITableViewCell

@property (nonatomic,weak) id<UserDynamicDelegate> delegate;

@property (nonatomic, strong)NSDictionary *dynamicDatas;

@property (nonatomic, strong)UIImageView *titleImage;

@property (nonatomic, strong)UILabel *dynamicTitleLabel;

@property (nonatomic, strong)UILabel *dynamicLabel;

@property (nonatomic, strong)UIImageView *dynamicImage;

@property (nonatomic, strong)UILabel *errerLabel;

@property (nonatomic, strong)UILabel *imageErrer;
@property (nonatomic, strong)NSArray * imageArray;


@end
