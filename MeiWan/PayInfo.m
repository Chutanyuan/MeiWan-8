//
//  PayInfo.m
//  MeiWan
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "PayInfo.h"
#import "CorlorTransform.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define height_screen [UIScreen mainScreen].bounds.size.height
#define width_screen [UIScreen mainScreen].bounds.size.width

@implementation PayInfo

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        isSelect[5] = NO;
        self.searchDic = [NSMutableDictionary dictionary];
        
        UIView * baseView = [[UIView alloc]initWithFrame:frame];
        baseView.backgroundColor = [UIColor blackColor];
        baseView.alpha = 0.5;
        [self addSubview:baseView];
        
        //搜索条件View
        UIView * view = [[UIView alloc]init];
        view.center = CGPointMake(self.center.x, self.center.y-20);
        view.bounds = CGRectMake(0, 0, width_screen * 0.64, width_screen* 0.64 *0.74);
        view.layer.cornerRadius = 7;
        view.clipsToBounds = YES;
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        //条件搜索label
        UILabel * tiaojian = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, view.frame.size.width, 20)];
        tiaojian.text = @"条件搜索";
        tiaojian.textColor = RGB(63, 144, 164);
        tiaojian.textAlignment = NSTextAlignmentCenter;
        [view addSubview:tiaojian];
        //line
        UIImageView * lineView = [[UIImageView alloc]initWithFrame:CGRectMake(15, tiaojian.frame.size.height+tiaojian.frame.origin.y+9, view.frame.size.width-30, 0.5)];
        lineView.backgroundColor = RGB(139, 139, 139);
        [view addSubview:lineView];
        //条件
        UIButton * noSex = [UIButton buttonWithType:UIButtonTypeCustom];
        noSex.frame = CGRectMake(lineView.frame.origin.x+10, lineView.frame.size.height+lineView.frame.origin.y+14, 45, 15);
        [noSex setImage:[UIImage imageNamed:@"searchIcon2"] forState:UIControlStateNormal];
        [noSex setTitle:@"不限" forState:UIControlStateNormal];
        noSex.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
        noSex.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        noSex.titleLabel.font = [UIFont systemFontOfSize:10.0];
        [noSex setTitleColor:RGB(166, 166, 166) forState:UIControlStateNormal];
        noSex.tag = 0;
        [noSex addTarget:self action:@selector(sexChooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:noSex];
        self.chooseSexButton = noSex;
        //
        UIButton * man = [UIButton buttonWithType:UIButtonTypeCustom];
        man.center = CGPointMake(tiaojian.center.x+13, noSex.center.y);
        man.bounds = CGRectMake(0, 0, 45, 15);
        [man setImage:[UIImage imageNamed:@"searchIcon2"] forState:UIControlStateNormal];
        [man setTitle:@"男" forState:UIControlStateNormal];
        man.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
        man.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
        [man setTitleColor:RGB(166, 166, 166) forState:UIControlStateNormal];
        man.titleLabel.font = [UIFont systemFontOfSize:10.0];
        man.tag = 1;
        [man addTarget:self action:@selector(sexChooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:man];
        self.chooseSexButton = man;
        //
        UIButton * woman = [UIButton buttonWithType:UIButtonTypeCustom];
        woman.frame = CGRectMake(lineView.frame.size.width+lineView.frame.origin.x-10 - 30, man.frame.origin.y, 45, 15);
        [woman setImage:[UIImage imageNamed:@"searchIcon2"] forState:UIControlStateNormal];
        [woman setTitle:@"女" forState:UIControlStateNormal];
        woman.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
        woman.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
        woman.titleLabel.font = man.titleLabel.font;
        [woman setTitleColor:RGB(166, 166, 166) forState:UIControlStateNormal];
        woman.tag = 2;
        [woman addTarget:self action:@selector(sexChooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:woman];
        self.chooseSexButton = woman;
        
        //价格
        UILabel * pricelabel = [[UILabel alloc]init];
        pricelabel.font = [UIFont systemFontOfSize:10.0];
        pricelabel.textColor = RGB(166, 166, 166);
        pricelabel.text = @"价格";
        pricelabel.textAlignment = NSTextAlignmentCenter;
        CGSize priceSize = [pricelabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:pricelabel.font,NSFontAttributeName, nil]];
        pricelabel.frame = CGRectMake(view.frame.size.width/2-priceSize.width/2, noSex.center.y+7.5+10, priceSize.width +10, priceSize.height);
        [view addSubview:pricelabel];
        
        //线
        UIImageView * leftLine = [[UIImageView alloc]initWithFrame:CGRectMake(lineView.frame.origin.x, lineView.frame.origin.y+14+15+10+priceSize.height/2, (lineView.frame.size.width-pricelabel.frame.size.width-lineView.frame.origin.x)/2, 0.5)];
        leftLine.backgroundColor = pricelabel.textColor;
        [view addSubview:leftLine];
        
        UIImageView * rightLine = [[UIImageView alloc]initWithFrame:CGRectMake(pricelabel.frame.origin.x+pricelabel.frame.size.width, leftLine.frame.origin.y, leftLine.frame.size.width, 0.5)];
        rightLine.backgroundColor = leftLine.backgroundColor;
        [view addSubview:rightLine];
        
        NSArray * priceArray = @[@"39元以下",@"39元-69元",@"69元-99元",@"99元以上",@"不限"];
        //价格区间
        for (int i = 0; i<5; i++) {
            
            UIButton * sectionPrice = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [sectionPrice setTitle:priceArray[i] forState:UIControlStateNormal];
            sectionPrice.titleLabel.textAlignment = NSTextAlignmentCenter;
            sectionPrice.titleLabel.font = [UIFont systemFontOfSize:10.0];
            if (isSelect[i] == NO) {
                sectionPrice.backgroundColor = [UIColor whiteColor];
                [sectionPrice setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else{
                sectionPrice.backgroundColor = tiaojian.textColor;
                [sectionPrice setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            sectionPrice.layer.cornerRadius = 3;
            
            CGSize size = [sectionPrice.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:sectionPrice.titleLabel.font,NSFontAttributeName, nil]];
            int row = i/3;  int low = i%3;
            sectionPrice.frame = CGRectMake((lineView.frame.origin.x) + (70) * low, leftLine.frame.origin.y+13 + (10 +size.height+2) * row, 66, size.height + 2);
            
            sectionPrice.tag = i+10;
            [sectionPrice addTarget:self action:@selector(sectionPriceClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:sectionPrice];
            
            self.buttonPriceChoose = sectionPrice;
            
        }
        
        
        
        //取消确定按钮View
        UIView * buttonBaseView = [[UIView alloc]initWithFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+7+view.frame.size.height, view.frame.size.width, 31)];
        buttonBaseView.backgroundColor = [UIColor whiteColor];
        buttonBaseView.layer.cornerRadius = 7;
        buttonBaseView.clipsToBounds = YES;
        [self addSubview:buttonBaseView];
        
        //取消按钮
        UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, 0, buttonBaseView.frame.size.width/2, buttonBaseView.frame.size.height);
        cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:RGB(64, 144, 164) forState:UIControlStateNormal];
        cancelButton.tag = 0;
        [cancelButton addTarget:self action:@selector(cancle:) forControlEvents:UIControlEventTouchUpInside];
        [buttonBaseView addSubview:cancelButton];
        
        //确定按钮
        UIButton * sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.frame = CGRectMake(cancelButton.frame.size.width, 0, cancelButton.frame.size.width, cancelButton.frame.size.height);
        sureButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [sureButton setTitleColor:RGB(64, 144, 164) forState:UIControlStateNormal];
        sureButton.tag = 1;
        [sureButton addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
        [buttonBaseView addSubview:sureButton];
    }
    return self;
}
- (void)sexChooseButtonClick:(UIButton *)sender
{
    if (sender!=self.chooseSexButton) {
        self.chooseSexButton.selected = NO;
        [self.chooseSexButton setImage:[UIImage imageNamed:@"searchIcon2"] forState:UIControlStateNormal];
        self.chooseSexButton = sender;
    }
    
    self.chooseSexButton.selected = YES;
    [self.chooseSexButton setImage:[UIImage imageNamed:@"searchIcon"] forState:UIControlStateNormal];
    
    switch (sender.tag) {
        case 0:
        {
            [self.searchDic removeObjectForKey:@"gender"];
        }
            break;
        case 1:
        {
            int gender = 0;
            [self.searchDic setObject:[NSNumber numberWithInt:gender] forKey:@"gender"];
        }
            break;
        case 2:
        {
            int gender = 1;
            [self.searchDic setObject:[NSNumber numberWithInt:gender] forKey:@"gender"];
        }
            break;
            
        default:
            break;
    }
}
-(void)sectionPriceClick:(UIButton *)sender
{
    
    if(sender!=self.buttonPriceChoose){
        
        self.buttonPriceChoose.selected=NO;
        [self.buttonPriceChoose setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.buttonPriceChoose setBackgroundColor:[UIColor clearColor]];
        self.buttonPriceChoose=sender;
        
        
    }
    self.buttonPriceChoose.selected=YES;
    [self.buttonPriceChoose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonPriceChoose setBackgroundColor:RGB(64, 144, 164)];
    
    
    
    switch (sender.tag) {
        case 10:
        {
            float minPrice = 0;
            float maxPrice = 39;
            [self.searchDic setObject:[NSNumber numberWithFloat: minPrice] forKey:@"minPrice"];
            [self.searchDic setObject:[NSNumber numberWithFloat:maxPrice] forKey:@"maxPrice"];
        }
            break;
        case 11:
        {
            float minPrice = 39;
            float maxPrice = 69;
            [self.searchDic setObject:[NSNumber numberWithFloat: minPrice] forKey:@"minPrice"];
            [self.searchDic setObject:[NSNumber numberWithFloat:maxPrice] forKey:@"maxPrice"];
        }
            break;
        case 12:
        {
            float minPrice = 69;
            float maxPrice = 99;
            [self.searchDic setObject:[NSNumber numberWithFloat: minPrice] forKey:@"minPrice"];
            [self.searchDic setObject:[NSNumber numberWithFloat:maxPrice] forKey:@"maxPrice"];
        }
            break;
        case 13:
        {
            float minPrice = 99;
            float maxPrice = 1000;
            [self.searchDic setObject:[NSNumber numberWithFloat: minPrice] forKey:@"minPrice"];
            [self.searchDic setObject:[NSNumber numberWithFloat:maxPrice] forKey:@"maxPrice"];
        }
            break;
        case 14:
        {
            [self.searchDic removeObjectForKey:@"minPrice"];
            [self.searchDic removeObjectForKey:@"maxPrice"];
        }
            break;
            
        default:
            break;
    }
}

- (void)cancle:(UIButton *)sender {
    [self.delegate moveBackview];
    [self removeFromSuperview];
}

- (void)sure:(id)sender {
    [self removeFromSuperview];
    [self .delegate resetSuperview:self.searchDic];
}

@end
