//
//  XYView.h
//  XY键盘自适应
//
//  Created by qingyun on 16/6/4.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYView : UIView
@property (weak, nonatomic) IBOutlet UITextField *textTF;

@property (weak, nonatomic) IBOutlet UIButton *btn;
+(instancetype)XYveiw;


@end
