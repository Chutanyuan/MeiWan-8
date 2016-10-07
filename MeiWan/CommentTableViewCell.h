//
//  CommentTableViewCell.h
//  beautity_play
//
//  Created by Fox on 16/7/13.
//  Copyright © 2016年 user_kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

/***/
@property (nonatomic,strong)NSDictionary * evaluateDictionary;
/**TA的评价图片*/
@property (nonatomic, strong)UIImageView *titleImage;
/**TA的评价*/
@property (nonatomic, strong)UILabel *commentTitleLabel;
/**没有数据*/
@property (nonatomic, strong)UILabel *commentLabel;
/**评价人头像*/
@property (nonatomic, strong)UIImageView *headerImage;
/**评价人昵称*/
@property (nonatomic, strong)UILabel * userName;
/**评价人年龄*/
@property (nonatomic, strong)UILabel * userAge;
/**评价人性别*/
@property (nonatomic, strong)UIImageView * userSex;
/**评价人评价时间*/
@property (nonatomic, strong)UILabel * sendTime;
/**评价星级*/
@property (nonatomic, strong)UIImageView * pointImage;
/**评价内容*/
@property (nonatomic, strong)UILabel * connecttext;

@end
