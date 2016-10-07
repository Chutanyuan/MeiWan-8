//
//  MoveActionFrame.m
//  MeiWan
//
//  Created by apple on 15/8/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MoveActionFrame.h"
#define MANameFont [UIFont systemFontOfSize:14]
#define MATextFont [UIFont systemFontOfSize:15]
@implementation MoveActionFrame
-(void)setMoveActionModel:(MoveAction *)moveActionModel{
    _moveActionModel = moveActionModel;
    
    //子控件之间的间距
    CGFloat padding = 10;
    
    //头像
    CGFloat iconX = padding;
    CGFloat iconY = padding;
    CGFloat iconW = 50;
    CGFloat iconH = 50;
    
    //成员是readonly属性,也就相当于没有setter方法,不能用.语法方法,只能通过_方式来访问
    _iconF = CGRectMake(iconX, iconY, iconW, iconH);

    //昵称
    CGSize nameSize = [self sizeWithText:self.moveActionModel.nackname font:MANameFont maxSize:CGSizeMake(MAXFLOAT,MAXFLOAT)];
    CGFloat nameX = CGRectGetMaxX(_iconF) +padding;
    CGFloat nameY = padding;
    _nameF = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    
    //性别
    CGFloat sexImageX = CGRectGetMaxX(_iconF) + padding + 2;
    CGFloat sexImageY = CGRectGetMaxY(_nameF)+ 8+2;
    _sexImageF = CGRectMake(sexImageX, sexImageY, 12, 12) ;
    //年龄
    CGFloat ageX = CGRectGetMaxX(_sexImageF) + 2;
    CGFloat ageY = CGRectGetMaxY(_nameF)+ 8;
    CGSize ageSize = [self sizeWithText:self.moveActionModel.age font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    _ageF =CGRectMake(ageX, ageY, ageSize.width, ageSize.height);
    //年龄性别
    CGFloat ageAndsexX = CGRectGetMaxX(_iconF)+padding;;
    CGFloat ageAndsexY = CGRectGetMaxY(_nameF)+8;
    CGFloat ageAndsexW = ageSize.width + 18;
    CGFloat ageAndsexH = 16;
    _ageAndSexF = CGRectMake(ageAndsexX, ageAndsexY, ageAndsexW, ageAndsexH);
    
    //发布时间
    CGSize timeSize = [self sizeWithText:self.moveActionModel.time font:MANameFont maxSize:CGSizeMake(MAXFLOAT,MAXFLOAT)];
    CGFloat timeX = [UIScreen mainScreen].bounds.size.width-timeSize.width-padding;
    CGFloat timeY = CGRectGetMaxY(_nameF)/2+8;
    _timeF = CGRectMake(timeX, timeY, timeSize.width, timeSize.height);
    
//    //点赞
//    CGFloat praiseX = [UIScreen mainScreen].bounds.size.width - 100;
//    CGFloat praiseY =  20;
//    CGFloat praiseW =  40;
//    CGFloat praiseH = 20;
//    _praiseF = CGRectMake(praiseX, praiseY, praiseW, praiseH);
//    
//    //评论
//    CGFloat discussX = [UIScreen mainScreen].bounds.size.width - 50;
//    CGFloat discussY =  20;
//    CGFloat discussW =  40;
//    CGFloat discussH = 20;
//    _discussF = CGRectMake(discussX, discussY, discussW,discussH);
    
    //正文
    CGFloat textX = CGRectGetMaxX(_iconF) +padding;
    CGFloat textY = CGRectGetMaxY(_iconF) + 5;
    CGSize textSize = [self sizeWithText:self.moveActionModel.text font:MATextFont maxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20 - CGRectGetMaxX(_iconF) - padding, 0)];
    _textF = CGRectMake(textX ,textY, textSize.width, textSize.height);
    if (self.moveActionModel.text.length == 0) {
        _textF = CGRectMake(textX ,textY, textSize.width,0);
    }

    //配图
    CGFloat width = ([[UIScreen mainScreen] applicationFrame].size.width-CGRectGetMaxX(_iconF) - padding)/3-8;
    if (self.moveActionModel.images) {
        CGFloat image1X = textX;
        CGFloat image1Y = CGRectGetMaxY(_textF)+8;
        CGFloat image1W = width;
        CGFloat image1H = width;
        _image1F = CGRectMake(image1X, image1Y, image1W, image1H);
       // NSLog(@"");
        CGFloat image2X = CGRectGetMaxX(_image1F)+5;
        CGFloat image2Y = CGRectGetMaxY(_textF)+8;
        CGFloat image2W = width;
        CGFloat image2H = width;
        _image2F = CGRectMake(image2X, image2Y, image2W, image2H);
        CGFloat image3X = CGRectGetMaxX(_image2F)+5;
        CGFloat image3Y = CGRectGetMaxY(_textF)+8;
        CGFloat image3W = width;
        CGFloat image3H = width;
        _image3F = CGRectMake(image3X, image3Y, image3W, image3H);
        if (self.moveActionModel.images.count == 1) {
            _image2F = CGRectZero;
            _image3F = CGRectZero;
        }else if (self.moveActionModel.images.count == 2){
            _image3F = CGRectZero;
        }
        //点赞
        CGFloat praiseX = [UIScreen mainScreen].bounds.size.width - 110;
        CGFloat praiseY =  CGRectGetMaxY(_image1F)+padding;
        CGFloat praiseW =  40;
        CGFloat praiseH = 20;
        _praiseF = CGRectMake(praiseX, praiseY, praiseW, praiseH);
        //评论
        CGFloat discussX = [UIScreen mainScreen].bounds.size.width - 60;
        CGFloat discussY =  CGRectGetMaxY(_image1F)+padding;
        CGFloat discussW =  40;
        CGFloat discussH = 20;
        _discussF = CGRectMake(discussX, discussY, discussW,discussH);

        _grayViewF = CGRectMake(0, CGRectGetMaxY(_praiseF)+padding, [UIScreen mainScreen].bounds.size.width, 10);
        _cellHeight = CGRectGetMaxY(_praiseF) + padding;
    }else{
        //点赞
        CGFloat praiseX = [UIScreen mainScreen].bounds.size.width - 110;
        CGFloat praiseY =  CGRectGetMaxY(_textF)+padding;
        CGFloat praiseW =  40;
        CGFloat praiseH = 20;
        _praiseF = CGRectMake(praiseX, praiseY, praiseW, praiseH);
        //评论
        CGFloat discussX = [UIScreen mainScreen].bounds.size.width - 60;
        CGFloat discussY =  CGRectGetMaxY(_textF)+padding;
        CGFloat discussW =  40;
        CGFloat discussH = 20;
        _discussF = CGRectMake(discussX, discussY, discussW,discussH);

        _grayViewF = CGRectMake(0, CGRectGetMaxY(_praiseF)+padding, [UIScreen mainScreen].bounds.size.width, 10);
        _cellHeight = CGRectGetMaxY(_praiseF) + padding;
    }
    
}

-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return  [text boundingRectWithSize: maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


@end
