//
//  FootprintTableViewCell.m
//  beautity_play
//
//  Created by Fox on 16/7/13.
//  Copyright © 2016年 user_kevin. All rights reserved.
//

#import "FootprintTableViewCell.h"

@implementation FootprintTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 10, 14)];
        titleImage.image = [UIImage imageNamed:@"zuji"];
        [self addSubview:titleImage];
        self.imageview = titleImage;
        
        UILabel *dynamic = [[UILabel alloc] initWithFrame:CGRectMake(titleImage.frame.origin.x+12, titleImage.frame.origin.y+2, 80, 10)];
        dynamic.text = @"Ta的展览秀";
        dynamic.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:dynamic];
        self.label = dynamic;
        UIScrollView * scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(dynamic.frame.origin.x, dynamic.frame.origin.y+dynamic.frame.size.height+5, dtScreenWidth-dynamic.frame.origin.x*2, 130-(dynamic.frame.origin.y+dynamic.frame.size.height+10))];
        [self addSubview:scrollview];
        scrollview.showsVerticalScrollIndicator = NO;
        scrollview.showsHorizontalScrollIndicator = NO;
        self.scrollview = scrollview;
    }
    return self;
}
-(void)setPhotos:(NSDictionary *)photos
{
    self.photosarray = photos[@"userPhotos"];
    self.scrollview.contentSize = CGSizeMake((self.scrollview.frame.size.height+5)*self.photosarray.count, 0);

    [self.photosarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(idx*(self.scrollview.frame.size.height+5), 0, self.scrollview.frame.size.height, self.scrollview.frame.size.height)];
        [imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!1",obj[@"url"]]]];
        imageview.tag = idx+1;
        imageview.userInteractionEnabled = YES;
        imageview.contentMode = UIViewContentModeScaleAspectFill;

        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [imageview addGestureRecognizer:tapGesture];
        [self.scrollview addSubview:imageview];
        
    }];
}
- (void)tapGesture:(UITapGestureRecognizer *)gesture
{
    [self.delegate PhotosTouchImage:gesture images:self.photosarray];
}

@end
