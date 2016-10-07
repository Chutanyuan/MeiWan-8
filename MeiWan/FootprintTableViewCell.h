//
//  FootprintTableViewCell.h
//  beautity_play
//
//  Created by Fox on 16/7/13.
//  Copyright © 2016年 user_kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotosTouchImageDelegate <NSObject>

- (void)PhotosTouchImage:(UITapGestureRecognizer *)gesture images:(NSArray *)imagesArray;

@end

@interface FootprintTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView * imageview;
@property(nonatomic,strong)UILabel * label;
@property(nonatomic,strong)UIScrollView * scrollview;
@property(nonatomic,strong)NSMutableArray * photosarray;
@property(nonatomic,strong)NSDictionary * photos;

@property(nonatomic,weak)id<PhotosTouchImageDelegate>delegate;

@end
