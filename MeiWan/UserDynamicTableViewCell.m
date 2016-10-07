//
//  UserDynamicTableViewCell.m
//  beautity_play
//
//  Created by Fox on 16/7/13.
//  Copyright © 2016年 user_kevin. All rights reserved.
//

#import "UserDynamicTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation UserDynamicTableViewCell

- (void)setDynamicDatas:(NSDictionary *)dynamicDatas{
    _dynamicDatas = dynamicDatas;
    
    UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 10, 14)];
    titleImage.image = [UIImage imageNamed:@"dongtai1"];
    [self addSubview:titleImage];
    self.titleImage = titleImage;
    
    UILabel *dynamic = [[UILabel alloc] initWithFrame:CGRectMake(titleImage.frame.origin.x+12, titleImage.frame.origin.y+2, 60, 10)];
    dynamic.text = @"Ta的动态";
    dynamic.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:dynamic];
    self.dynamicTitleLabel = dynamic;
    
    NSArray *imagearrs = [_dynamicDatas objectForKey:@"statePhotos"];
    
    UILabel *dynamicLabel = [[UILabel alloc] initWithFrame:CGRectMake(dynamic.frame.origin.x, dynamic.frame.origin.y+dynamic.frame.size.height+8, self.frame.size.width-40, 10)];
    dynamicLabel.font = [UIFont systemFontOfSize:12.0f];
    NSString *dynamictext = [_dynamicDatas objectForKey:@"content"];
    if (dynamictext.length == 0) {
        dynamicLabel.text = @"用户暂未发布文字";
    }else{
        dynamicLabel.text = [_dynamicDatas objectForKey:@"content"];
    }
    self.dynamicLabel = dynamicLabel;
    [self addSubview:dynamicLabel];
    
    if (imagearrs == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-100)/2, (130-40)/2, 100, 40)];
        label.text = @"TA还没有发布动态";
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:label];
        self.errerLabel = label;
        self.dynamicLabel.hidden = YES;
    }else{
        NSString *str = imagearrs[0];
        if ([str isKindOfClass:[NSNull class]]) {
//            UILabel *imageErrer = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-100)/2, (130-40)/2+20, 100, 40)];
//            imageErrer.text = @"用户未发布图片";
//            imageErrer.font = [UIFont systemFontOfSize:13.0f];
//            [self addSubview:imageErrer];
//            self.imageErrer = imageErrer;
        }else{
            CGFloat kuan = ([UIScreen mainScreen].bounds.size.width-24-10-10)/3;
            if (imagearrs.count==0) {
                self.dynamicImage.hidden = YES;
            }
            [imagearrs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj==[NSNull null]) {
                    
                }else{
                    self.imageArray = imagearrs;
                    UIImageView *dynamicImage = [[UIImageView alloc] initWithFrame:CGRectMake(24+idx * (kuan+5), dynamicLabel.frame.origin.y+dynamicLabel.frame.size.height+8, kuan, kuan)];
                    [dynamicImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!1",obj]]];
                    dynamicImage.contentMode = UIViewContentModeScaleAspectFill;
                    dynamicImage.clipsToBounds = YES;
                    dynamicImage.tag = idx;
                    [self addSubview:dynamicImage];
                    self.dynamicImage = dynamicImage;
                    self.dynamicImage.userInteractionEnabled = YES;
                    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPicture:)];
                    [self.dynamicImage addGestureRecognizer:gesture];
                }
                
            }];
        }
        
    }
    
    //    [self.delegate showState];
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    
    return self;
}


- (void)getInvie:(id)sender {
    [self.delegate showInvite];
}

- (void)getChat2:(id)sender {
    [self.delegate showChat];
}

- (void)showState:(id)sender {
    [self.delegate showState];
}
- (void)showPicture:(UITapGestureRecognizer*)gesture
{
    [self.delegate showPicture:gesture imageArray:self.imageArray];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
