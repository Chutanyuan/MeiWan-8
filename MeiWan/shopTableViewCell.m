//
//  shopTableViewCell.m
//  MeiWan
//
//  Created by user_kevin on 16/8/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "shopTableViewCell.h"
#import "CorlorTransform.h"
@implementation shopTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.goodsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 90, 90)];
        self.goodsImageView.image = [UIImage imageNamed:@"baiyin"];
        [self addSubview:self.goodsImageView];
        
        self.goodsTitleLabel = [[UILabel alloc]init];
        self.goodsTitleLabel.numberOfLines = 2;
        self.goodsTitleLabel.text = @"商品标题名称";
        self.goodsTitleLabel.font = [UIFont systemFontOfSize:14.0];
        CGSize size_title = [self.goodsTitleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.goodsTitleLabel.font,NSFontAttributeName, nil]];
        size_title.width = dtScreenWidth-100-10;
        self.goodsTitleLabel.frame = CGRectMake(100, 5, dtScreenWidth-100-10, size_title.height*2);
        [self addSubview:self.goodsTitleLabel];
        
        self.goodsConnectLabel = [[UILabel alloc]init];
        self.goodsConnectLabel.numberOfLines = 0;
        self.goodsConnectLabel.font = [UIFont systemFontOfSize:13.0];
        self.goodsConnectLabel.textColor = [UIColor grayColor];
        self.goodsConnectLabel.text = @"内容品标题名称品标题名称品标题名称品标题名称品标题名称品标题名称品标题名称";
//        CGSize size_connect = [self.goodsConnectLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.goodsConnectLabel.font,NSFontAttributeName, nil]];
        self.goodsConnectLabel.frame = CGRectMake(100, self.goodsTitleLabel.frame.size.height+self.goodsTitleLabel.frame.origin.y, self.goodsTitleLabel.frame.size.width, 100-5-20-(self.goodsTitleLabel.frame.size.height+self.goodsTitleLabel.frame.origin.y));

        [self addSubview:self.goodsConnectLabel];
        
        self.goodsPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 100-25, self.goodsTitleLabel.frame.size.width, 20)];
        self.goodsPriceLabel.font = [UIFont systemFontOfSize:15.0];
        self.goodsPriceLabel.textColor = [CorlorTransform colorWithHexString:@"ff3333"];
        self.goodsPriceLabel.text = @"1.00元";
        [self addSubview:self.goodsPriceLabel];
    }
    return self;
}

@end
