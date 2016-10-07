//
//  UserInfoTableViewCell.h
//  beautity_play
//
//  Created by mac on 16/6/30.
//  Copyright © 2016年 user_kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong)UILabel *userInfoTitle;
@property (nonatomic, strong)UILabel *userInfoDetail;
@property (nonatomic, strong)UIButton *manButton;
@property (nonatomic, strong)UIButton *WomanButton;
@property (nonatomic, strong)UITextField *userInfoEdit;
@property (nonatomic, strong)UITextField *userInfoEditSign;
@property (nonatomic, strong)UILabel *line;

@property (nonatomic, strong)UIImageView *timeImage1;
@property (nonatomic, strong)UILabel *timeTitle1;

@property (nonatomic, strong)UIImageView *timeImage2;
@property (nonatomic, strong)UILabel *timeTitle2;

@property (nonatomic, strong)UIImageView *timeImage3;
@property (nonatomic, strong)UILabel *timeTitle3;

@property (strong, nonatomic)NSDictionary *timeDic;

@property (strong, nonatomic)UILabel *timeerrer;

@end
