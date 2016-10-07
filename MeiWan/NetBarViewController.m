//
//  NetBarViewController.m
//  MeiWan
//
//  Created by apple on 15/9/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "NetBarViewController.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "UIImageView+WebCache.h"
#import "ShowMessage.h"
#import "LoginViewController.h"
@interface NetBarViewController ()
@property (nonatomic,strong) NSDictionary *nerBarInfo;
@property (nonatomic,strong) NSArray *photos;
@end
@implementation NetBarViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.nerBarInfo = [self.barInfo objectForKey:@"netbar"];
    self.title = [self.nerBarInfo objectForKey:@"name"];
    //NSLog(@"%@",self.barInfo);
    self.nameOfNetBar.text = [self.nerBarInfo objectForKey:@"name"];
    self.locationlable.text = [self.nerBarInfo objectForKey:@"address"];

    [UserConnector findNetbarPhoto:[self.barInfo objectForKey:@"netbarId"] receiver:^(NSData *data,NSError *error){
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                self.photos = [json objectForKey:@"entity"];
                [self addImageScrollView];
            }else if (status == 1){
                
            }else{
                
            }
             //NSLog(@"%@",self.photos);
        }
    }];
    
    
 }
-(void)addImageScrollView{
    //NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    //CGSize textSize = [self.locationlable.text boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 91, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size ;
    //NSLog(@"%f",textSize.height);
    UIScrollView *barImage = [[UIScrollView alloc]initWithFrame:CGRectMake(5, self.contentView.frame.origin.y+self.contentView.frame.size.height+5, self.view.bounds.size.width-10, self.view.bounds.size.height - self.contentView.frame.origin.y-self.contentView.frame.size.height-5)];
    //barImage.backgroundColor = [UIColor redColor];
    barImage.showsVerticalScrollIndicator = NO;
    for (int i = 0; i<self.photos.count; i++) {
        UIImageView *photo = [[UIImageView alloc]initWithFrame:CGRectMake(0, (barImage.bounds.size.width+5)*i, barImage.bounds.size.width, barImage.bounds.size.width)];
        NSString *url = [self.photos[i] objectForKey:@"url"];
        NSURL *photoUrl = [NSURL URLWithString:url];
        [photo setImageWithURL:photoUrl placeholderImage:nil];
        [barImage addSubview:photo];
        
    }
    barImage.contentSize = CGSizeMake(barImage.bounds.size.width, (barImage.bounds.size.width+5)*self.photos.count-5);
    [self.view addSubview:barImage];
}
- (IBAction)tapPhone:(UITapGestureRecognizer *)sender {
    NSString *phone = [NSString stringWithFormat:@"tel://%@",[self.nerBarInfo objectForKey:@"phone"]];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
    UIWebView *callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:phone];// 貌似tel:// 或者 tel: 都行
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上
    [self.view addSubview:callWebview];
}
@end
