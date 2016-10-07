//
//  UserInfoTableViewCell.m
//  beautity_play
//
//  Created by mac on 16/6/30.
//  Copyright © 2016年 user_kevin. All rights reserved.
//

#import "UserInfoTableViewCell.h"
#import "CorlorTransform.h"

@implementation UserInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, (self.frame.size.height/2+20/2)/2, 44, 20)];
        [self addSubview:title];
        title.font = [UIFont systemFontOfSize:13.0f];
        self.userInfoTitle = title;
        
        UITextField *editUserInfo = [[UITextField alloc] initWithFrame:CGRectMake(title.frame.origin.x+title.frame.size.width+5, (self.frame.size.height/2+title.frame.size.height/2)/2, self.frame.size.width-title.frame.size.width-15, 20)];
        editUserInfo.textAlignment = NSTextAlignmentLeft;
        editUserInfo.font = [UIFont systemFontOfSize:13.0f];
        editUserInfo.placeholder = @"请输入你的昵称，不大于8个字符";
        [editUserInfo setValue:[UIColor colorWithWhite:0.5 alpha:0.5] forKeyPath:@"_placeholderLabel.textColor"];
        [editUserInfo setValue:[UIFont boldSystemFontOfSize:11.0f] forKeyPath:@"_placeholderLabel.font"];
        editUserInfo.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        NSMutableParagraphStyle *style = [editUserInfo.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
        style.minimumLineHeight = editUserInfo.font.lineHeight - (editUserInfo.font.lineHeight - [UIFont systemFontOfSize:11.0f].lineHeight) / 2.0;
        //[UIFont systemFontOfSize:13.0f]是设置的placeholder的字体
        editUserInfo.attributedPlaceholder = [[NSAttributedString alloc] initWithString:editUserInfo.placeholder
                                                                             attributes:@{NSParagraphStyleAttributeName : style}];
        [self addSubview:editUserInfo];
        self.userInfoEdit = editUserInfo;
        self.userInfoEdit.hidden = YES;
        
        UITextField *editsign = [[UITextField alloc] initWithFrame:CGRectMake(title.frame.origin.x+title.frame.size.width+5, (self.frame.size.height/2+title.frame.size.height/2)/2, self.frame.size.width-title.frame.size.width-15, 20)];
        editsign.textAlignment = NSTextAlignmentLeft;
        editsign.font = [UIFont systemFontOfSize:13.0f];
        editsign.placeholder = @"请输入你的签名，不大于30个字符";
        [editsign setValue:[UIFont boldSystemFontOfSize:11.0f] forKeyPath:@"_placeholderLabel.font"];
        [editsign setValue:[UIColor colorWithWhite:0.5 alpha:0.5] forKeyPath:@"_placeholderLabel.textColor"];
        editsign.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        NSMutableParagraphStyle *signStyle = [editsign.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
        signStyle.minimumLineHeight = editsign.font.lineHeight - (editsign.font.lineHeight - [UIFont systemFontOfSize:11.0f].lineHeight) / 2.0;
        //[UIFont systemFontOfSize:13.0f]是设置的placeholder的字体
        editsign.attributedPlaceholder = [[NSAttributedString alloc] initWithString:editsign.placeholder
                                                                         attributes:@{NSParagraphStyleAttributeName : signStyle}];
        [self addSubview:editsign];
        self.userInfoEditSign = editsign;
        self.userInfoEditSign.hidden = YES;
        
        UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(title.frame.origin.x+title.frame.size.width+10, (self.frame.size.height/2+title.frame.size.height/2)/2, self.frame.size.width-40, 20)];
        detail.textAlignment = NSTextAlignmentLeft;
        detail.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:detail];
        self.userInfoDetail = detail;
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, dtScreenWidth, 1)];
        line.backgroundColor = [CorlorTransform colorWithHexString:@"#d0d0d0"];
        [self addSubview:line];
        self.line = line;
//        
//        UIImage *image = [UIImage imageNamed:@"biaoqian.png"];
//        NSInteger leftCapWidth = image.size.width * 0.9;
//        NSInteger topCapHeight = image.size.height * 0.9;
//        UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
//        
//        UIImageView *oneimage = [[UIImageView alloc]initWithFrame:CGRectMake(title.frame.origin.x+title.frame.size.width+5, (self.frame.size.height/2+title.frame.size.height/2)/2, 44, 20)];
//        oneimage.image = newImage;
//        [self addSubview:oneimage];
//        self.timeImage1 = oneimage;
//        self.timeImage1.hidden = YES;
    }
    return self;
}

- (void)setTimeDic:(NSDictionary *)timeDic{
    _timeDic = timeDic;
    
    //图片拉伸
    UIImage *image = [UIImage imageNamed:@"biaoqian.png"];
    NSInteger leftCapWidth = image.size.width * 0.9;
    NSInteger topCapHeight = image.size.height * 0.9;
    UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    
    NSArray *labelTitle = [_timeDic objectForKey:@"userTimeTags"];
    
    if (labelTitle.count == 1) {
        NSDictionary *label1Dic = labelTitle[0];
        //三个标签label
        UILabel * oneLabel = [[UILabel alloc]init];
        NSString *indexstr = [NSString stringWithFormat:@"%@",[label1Dic objectForKey:@"index"]];
        if ([indexstr isEqualToString: @"1"]) {
            oneLabel.text = @"线上点歌";
        }else if([indexstr isEqualToString: @"2"]){
            oneLabel.text = @"视频聊天";
        }else if([indexstr isEqualToString: @"3"]){
            oneLabel.text = @"聚餐";
        }else if([indexstr isEqualToString:@"4"]){
            oneLabel.text = @"线下K歌";
        }else if([indexstr isEqualToString:@"5"]){
            oneLabel.text = @"夜店达人";
        }else if([indexstr isEqualToString:@"6"]){
            oneLabel.text = @"叫醒服务";
        }else if([indexstr isEqualToString:@"7"]){
            oneLabel.text = @"影伴";
        }else if([indexstr isEqualToString:@"8"]){
            oneLabel.text = @"运动健身";
        }else if([indexstr isEqualToString:@"9"]){
            oneLabel.text = @"LOL";
        }
        oneLabel.textColor = [UIColor whiteColor];
        oneLabel.textAlignment = NSTextAlignmentCenter;
        oneLabel.font = [UIFont systemFontOfSize:9.0];
        CGSize nick2Size = [oneLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:oneLabel.font,NSFontAttributeName, nil]];
        CGFloat name2H = nick2Size.height;
        CGFloat name2W = nick2Size.width;
        oneLabel.frame = CGRectMake(5, 8, name2W,name2H);
        self.timeTitle1 = oneLabel;
        
        UIImageView * oneImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.userInfoTitle.frame.origin.x+self.userInfoTitle.frame.size.width+5, (self.frame.size.height/2+self.userInfoTitle.frame.size.height/2)/2, oneLabel.frame.size.width+10, oneLabel.frame.size.height+10)];
        oneImage.image = newImage;
        [self addSubview:oneImage];
        [oneImage addSubview:oneLabel];
        self.timeImage1 = oneImage;
        self.timeerrer.hidden = YES;

    }else if (labelTitle.count == 2){
        NSDictionary *label1Dic = labelTitle[0];
        //三个标签label
        UILabel * oneLabel = [[UILabel alloc]init];
        NSString *indexstr = [NSString stringWithFormat:@"%@",[label1Dic objectForKey:@"index"]];
        if ([indexstr isEqualToString: @"1"]) {
            oneLabel.text = @"线上点歌";
        }else if([indexstr isEqualToString: @"2"]){
            oneLabel.text = @"视频聊天";
        }else if([indexstr isEqualToString: @"3"]){
            oneLabel.text = @"聚餐";
        }else if([indexstr isEqualToString:@"4"]){
            oneLabel.text = @"线下K歌";
        }else if([indexstr isEqualToString:@"5"]){
            oneLabel.text = @"夜店达人";
        }else if([indexstr isEqualToString:@"6"]){
            oneLabel.text = @"叫醒服务";
        }else if([indexstr isEqualToString:@"7"]){
            oneLabel.text = @"影伴";
        }else if([indexstr isEqualToString:@"8"]){
            oneLabel.text = @"运动健身";
        }else if([indexstr isEqualToString:@"9"]){
            oneLabel.text = @"LOL";
        }
        oneLabel.textColor = [UIColor whiteColor];
        oneLabel.textAlignment = NSTextAlignmentCenter;
        oneLabel.font = [UIFont systemFontOfSize:9.0];
        CGSize nick2Size = [oneLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:oneLabel.font,NSFontAttributeName, nil]];
        CGFloat name2H = nick2Size.height;
        CGFloat name2W = nick2Size.width;
        oneLabel.frame = CGRectMake(5, 8, name2W,name2H);
        //        [self addSubview:oneLabel];
        self.timeTitle1 = oneLabel;
        
        UIImageView * oneImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.userInfoTitle.frame.origin.x+self.userInfoTitle.frame.size.width+5, (self.frame.size.height/2+self.userInfoTitle.frame.size.height/2)/2, oneLabel.frame.size.width+10, oneLabel.frame.size.height+10)];
        oneImage.image = newImage;
        [self addSubview:oneImage];
        [oneImage addSubview:oneLabel];
        self.timeImage1 = oneImage;
        
        NSDictionary *label2Dic = labelTitle[1];
        NSString *indexstr2 = [NSString stringWithFormat:@"%@",[label2Dic objectForKey:@"index"]];
        UILabel * twoLabel = [[UILabel alloc]init];
        if ([indexstr2 isEqualToString:@"1"]) {
            twoLabel.text = @"线上点歌";
        }else if([indexstr2 isEqualToString:@"2"]){
            twoLabel.text = @"视频聊天";
        }else if([indexstr2 isEqualToString:@"3"]){
            twoLabel.text = @"聚餐";
        }else if([indexstr2 isEqualToString:@"4"]){
            twoLabel.text = @"线下K歌";
        }else if([indexstr2 isEqualToString:@"5"]){
            twoLabel.text = @"夜店达人";
        }else if([indexstr2 isEqualToString:@"6"]){
            twoLabel.text = @"叫醒服务";
        }else if([indexstr2 isEqualToString:@"7"]){
            twoLabel.text = @"影伴";
        }else if([indexstr2 isEqualToString:@"8"]){
            twoLabel.text = @"运动健身";
        }else if([indexstr2 isEqualToString:@"9"]){
            twoLabel.text = @"LOL";
        }
        twoLabel.textColor = [UIColor whiteColor];
        twoLabel.textAlignment = NSTextAlignmentCenter;
        twoLabel.font = [UIFont systemFontOfSize:9.0];
        CGSize twoSize = [twoLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:twoLabel.font,NSFontAttributeName, nil]];
        CGFloat twoSizeH = twoSize.height;
        CGFloat twoSizeW = twoSize.width;
        twoLabel.frame = CGRectMake(5, 8, twoSizeW,twoSizeH);
        [self addSubview:twoLabel];
        self.timeTitle2 = twoLabel;
        
        UIImageView * twoImage = [[UIImageView alloc] initWithFrame:CGRectMake(oneImage.frame.origin.x+oneImage.frame.size.width+10,oneImage.frame.origin.y, twoSizeW+10 ,twoSizeH+10)];
        twoImage.image = newImage;
        [twoImage addSubview:twoLabel];
        [self addSubview:twoImage];
        self.timeImage2 = twoImage;
        self.timeerrer.hidden = YES;

    }else if (labelTitle.count>=3){
        
        NSDictionary *label1Dic = labelTitle[0];
        //三个标签label
        UILabel * oneLabel = [[UILabel alloc]init];
        NSString *indexstr = [NSString stringWithFormat:@"%@",[label1Dic objectForKey:@"index"]];
        if ([indexstr isEqualToString: @"1"]) {
            oneLabel.text = @"线上点歌";
        }else if([indexstr isEqualToString: @"2"]){
            oneLabel.text = @"视频聊天";
        }else if([indexstr isEqualToString: @"3"]){
            oneLabel.text = @"聚餐";
        }else if([indexstr isEqualToString:@"4"]){
            oneLabel.text = @"线下K歌";
        }else if([indexstr isEqualToString:@"5"]){
            oneLabel.text = @"夜店达人";
        }else if([indexstr isEqualToString:@"6"]){
            oneLabel.text = @"叫醒服务";
        }else if([indexstr isEqualToString:@"7"]){
            oneLabel.text = @"影伴";
        }else if([indexstr isEqualToString:@"8"]){
            oneLabel.text = @"运动健身";
        }else if([indexstr isEqualToString:@"9"]){
            oneLabel.text = @"LOL";
        }
        oneLabel.textColor = [UIColor whiteColor];
        oneLabel.textAlignment = NSTextAlignmentCenter;
        oneLabel.font = [UIFont systemFontOfSize:9.0];
        CGSize nick2Size = [oneLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:oneLabel.font,NSFontAttributeName, nil]];
        CGFloat name2H = nick2Size.height;
        CGFloat name2W = nick2Size.width;
        oneLabel.frame = CGRectMake(5, 8, name2W,name2H);
        //        [self addSubview:oneLabel];
        self.timeTitle1 = oneLabel;
        
        UIImageView * oneImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.userInfoTitle.frame.origin.x+self.userInfoTitle.frame.size.width+5, (self.frame.size.height/2+self.userInfoTitle.frame.size.height/2)/2, oneLabel.frame.size.width+10, oneLabel.frame.size.height+10)];
        oneImage.image = newImage;
        [self addSubview:oneImage];
        [oneImage addSubview:oneLabel];
        self.timeImage1 = oneImage;
        
        NSDictionary *label2Dic = labelTitle[1];
        NSString *indexstr2 = [NSString stringWithFormat:@"%@",[label2Dic objectForKey:@"index"]];
        UILabel * twoLabel = [[UILabel alloc]init];
        if ([indexstr2 isEqualToString:@"1"]) {
            twoLabel.text = @"线上点歌";
        }else if([indexstr2 isEqualToString:@"2"]){
            twoLabel.text = @"视频聊天";
        }else if([indexstr2 isEqualToString:@"3"]){
            twoLabel.text = @"聚餐";
        }else if([indexstr2 isEqualToString:@"4"]){
            twoLabel.text = @"线下K歌";
        }else if([indexstr2 isEqualToString:@"5"]){
            twoLabel.text = @"夜店达人";
        }else if([indexstr2 isEqualToString:@"6"]){
            twoLabel.text = @"叫醒服务";
        }else if([indexstr2 isEqualToString:@"7"]){
            twoLabel.text = @"影伴";
        }else if([indexstr2 isEqualToString:@"8"]){
            twoLabel.text = @"运动健身";
        }else if([indexstr2 isEqualToString:@"9"]){
            twoLabel.text = @"LOL";
        }
        twoLabel.textColor = [UIColor whiteColor];
        twoLabel.textAlignment = NSTextAlignmentCenter;
        twoLabel.font = [UIFont systemFontOfSize:9.0];
        CGSize twoSize = [twoLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:twoLabel.font,NSFontAttributeName, nil]];
        CGFloat twoSizeH = twoSize.height;
        CGFloat twoSizeW = twoSize.width;
        twoLabel.frame = CGRectMake(5, 8, twoSizeW,twoSizeH);
        [self addSubview:twoLabel];
        self.timeTitle2 = twoLabel;
        
        UIImageView * twoImage = [[UIImageView alloc] initWithFrame:CGRectMake(oneImage.frame.origin.x+oneImage.frame.size.width+10,oneImage.frame.origin.y, twoSizeW+10 ,twoSizeH+10)];
        twoImage.image = newImage;
        [twoImage addSubview:twoLabel];
        [self addSubview:twoImage];
        self.timeImage2 = twoImage;
        
        NSDictionary *label3Dic = labelTitle[2];
        NSString *indexstr3 = [NSString stringWithFormat:@"%@",[label3Dic objectForKey:@"index"]];
        UILabel * threeLabel = [[UILabel alloc]init];
        if ([indexstr3 isEqualToString:@"1"]) {
            threeLabel.text = @"线上点歌";
        }else if([indexstr3 isEqualToString:@"2"]){
            threeLabel.text = @"视频聊天";
        }else if([indexstr3 isEqualToString:@"3"]){
            threeLabel.text = @"聚餐";
        }else if([indexstr3 isEqualToString:@"4"]){
            threeLabel.text = @"线下K歌";
        }else if([indexstr3 isEqualToString:@"5"]){
            threeLabel.text = @"夜店达人";
        }else if([indexstr3 isEqualToString:@"6"]){
            threeLabel.text = @"叫醒服务";
        }else if([indexstr3 isEqualToString:@"7"]){
            threeLabel.text = @"影伴";
        }else if([indexstr3 isEqualToString:@"8"]){
            threeLabel.text = @"运动健身";
        }else if([indexstr3 isEqualToString:@"9"]){
            threeLabel.text = @"LOL";
        }
        threeLabel.textColor = [UIColor whiteColor];
        threeLabel.textAlignment = NSTextAlignmentCenter;
        threeLabel.font = [UIFont systemFontOfSize:9.0];
        CGSize threeSize = [threeLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:threeLabel.font,NSFontAttributeName, nil]];
        CGFloat threeSizeH = threeSize.height;
        CGFloat threeSizeW = threeSize.width;
        threeLabel.frame = CGRectMake(5, threeSizeH-2, threeSizeW,threeSizeH);
        
        UIImageView * threeImage = [[UIImageView alloc]initWithFrame:CGRectMake(twoImage.frame.origin.x+twoImage.frame.size.width+10,twoImage.frame.origin.y, threeSizeW+10, threeSizeH+10)];
        threeImage.image = newImage;
        [threeImage addSubview:threeLabel];
        [self addSubview:threeImage];
        self.timeImage3 = threeImage;
        self.timeerrer.hidden = YES;
    }else{
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.userInfoTitle.frame.origin.x+self.userInfoTitle.frame.size.width+5, (50-40)/2, 90, 40)];
        label.textColor = [CorlorTransform colorWithHexString:@"#B0B0B0"];
        label.text = @"用户暂无标签";
        label.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:label];
        self.timeerrer = label;
        self.timeerrer.hidden = NO;
        self.timeImage1.hidden = YES;
        self.timeImage2.hidden = YES;
        self.timeImage3.hidden = YES;
    }
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
