//
//  TAauthenticateCell.m
//  MeiWan
//
//  Created by user_kevin on 16/10/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TAauthenticateCell.h"

@interface TAauthenticateCell ()

@property(nonatomic,strong)UILabel * label1;
@property(nonatomic,strong)UILabel * label2;
@property(nonatomic,strong)UILabel * label3;
@property(nonatomic,strong)UIScrollView * scrollview;

@end

@implementation TAauthenticateCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        NSArray * imagearray = @[@"weixin_edit",@"QQ_edit",@"renzheng_edit"];
        if ([reuseIdentifier isEqualToString:@"indexpath1"]) {
            NSLog(@"QQ 微信 身份认证");
            for (int i = 0; i<3; i++) {
                UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(80, 10+i*40, 20, 20)];
                imageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imagearray[i]]];
                [self addSubview:imageview];
                
                UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(80, 40*i+40, dtScreenWidth-100, 1)];
                line.backgroundColor = [CorlorTransform colorWithHexString:@"#d5d5d5"];
                [self addSubview:line];
                
                UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(110, 40*i, 100, 40)];
                label.text = @"微信未认证";
                label.textColor = [CorlorTransform colorWithHexString:@"#d5d5d5"];
                label.font = [FontOutSystem fontWithFangZhengSize:15.0];
                [self addSubview:label];
                
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setTitle:@"查看" forState:UIControlStateNormal];
                [button setTitleColor:[CorlorTransform colorWithHexString:@"#78cdf8"] forState:UIControlStateNormal];
                button.frame = CGRectMake(dtScreenWidth-20-60, i*40, 60, 40);
                button.titleLabel.font = [FontOutSystem fontWithFangZhengSize:15];
                button.tag = i;
                [button addTarget:self action:@selector(chakan:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview: button];
                
                if (i==0) {
                    self.label1 = label;
                }else if (i==1){
                    self.label2 = label;
                }else if (i==2){
                    self.label3 = label;
                }
            }
        }else{
            NSLog(@"商家认证");
            UIScrollView * scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, 200)];
            [self addSubview:scrollview];
            self.scrollview = scrollview;
            
        }
    }
    return self;
}
- (void)chakan:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
        {
            self.label1.text = @"wx10000001";
        }
            break;
        case 1:
        {
            self.label2.text = @"QQ29282370";
        }
            break;
        case 2:
        {
            self.label3.text = @"237093507057";
        }
            break;
            
        default:
            break;
    }
}

@end
