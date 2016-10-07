//
//  GameRloeTableViewCell.m
//  MeiWan
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GameRloeTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation GameRloeTableViewCell
- (void)setRoleInfo:(NSDictionary *)roleInfo{
    _roleInfo = roleInfo;
    NSArray *gameRole = [NSArray arrayWithObjects:@"艾欧尼亚",@"祖安",@"洛克萨斯",@"班德尔城",@"皮尔特沃夫",@"战争学院",@"巨神峰",@"雷瑟守备",@"裁决之地",@"黑色玫瑰",@"暗影岛",@"钢铁烈阳",@"水晶之痕",@"均衡教派",@"影流",@"守望之海",@"征服之海",@"卡拉曼达",@"皮城警备",@"比尔吉沃特",@"德玛西亚",@"弗雷尔卓德",@"无畏先锋",@"努瑞玛",@"扭曲丛林",@"巨龙之巢",@"教育网专区", nil];
    NSArray *server = [NSArray arrayWithObjects:@"电信一", @"电信二", @"电信三", @"电信四",@"电信五", @"电信六", @"电信七", @"电信八", @"电信九", @"电信十", @"电信十一",@"电信十二", @"电信十三", @"电信十四", @"电信十五", @"电信十六", @"电信十七",@"电信十八", @"电信十九", @"网通一", @"网通二", @"网通三", @"网通四",@"网通五", @"网通六", @"网通七", @"教育一", nil];
    for (NSInteger i = 0; i<server.count; i++) {
        NSString *serverstr = server[i];
        if ([serverstr isEqualToString:[roleInfo objectForKey:@"part"]]) {
            self.gameRole.text = gameRole[i];
        }
    }
    self.niceName.text = [roleInfo objectForKey:@"name"];
    //self.gameRole.text = [roleInfo objectForKey:@"part"];
    
}
- (void)setLolInfo:(LOLInfo *)lolInfo{
    _lolInfo = lolInfo;
    NSString *url = lolInfo.headUrl;
    NSURL *headurl = [NSURL URLWithString:url];
    [self.headig setImageWithURL:headurl];
    self.sword.text = lolInfo.capacity;
}
- (void)awakeFromNib {
    // Initialization code
    self.headig.layer.cornerRadius = 30;
    self.headig.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
