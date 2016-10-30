//
//  PhotosHeaderView.m
//  MeiWan
//
//  Created by user_kevin on 16/10/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PhotosHeaderView.h"
#import "MeiWan-Swift.h"
#import "SBJsonParser.h"
#import "ShowMessage.h"

@interface PhotosHeaderView ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView * scrollview;
@property(nonatomic,strong)UIImageView * imageview;
@property(nonatomic,strong)UIPageControl * pagecontrol;
@property(nonatomic,strong)UILabel * nikename;
@property(nonatomic,strong)UILabel * age;
@property(nonatomic,strong)UIImageView * sex;
@property(nonatomic,strong)UILabel * distance;
@property(nonatomic,strong)UIImageView * locationImage;
@property(nonatomic,strong)UILabel * ID;
@property(nonatomic,assign)NSMutableArray * array;
@property(nonatomic,strong)UIView * bottomView;
@property (strong, nonatomic) UIImageView *biaoqianImage1;
@property (strong, nonatomic) UIImageView *biaoqianImage2;
@property (strong, nonatomic) UIImageView *biaoqianImage3;

@property (nonatomic, strong) NSMutableArray * MyfriendArray;
@property(nonatomic,strong)NSDictionary * othersDic;


@end

@implementation PhotosHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.MyfriendArray = [[NSMutableArray alloc]initWithCapacity:0];
        self.othersDic = [[NSDictionary alloc]init];
        UIScrollView * scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenWidth)];
        [self addSubview:scrollview];
        scrollview.showsVerticalScrollIndicator = NO;
        scrollview.showsHorizontalScrollIndicator = NO;
        scrollview.pagingEnabled = YES;
        scrollview.delegate = self;
        self.scrollview = scrollview;
        
        self.pagecontrol = [[UIPageControl alloc]initWithFrame:CGRectMake(0, dtScreenWidth-30-12, dtScreenWidth, 10)];
        [self.pagecontrol addTarget:self action:@selector(clickPageController:event:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.pagecontrol];
        
        UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, dtScreenWidth-30, dtScreenWidth, 30)];
        bottomView.backgroundColor = [CorlorTransform colorWithHexString:@"#418fc0"];
        bottomView.alpha = 0.5;
        [self addSubview:bottomView];
        self.bottomView = bottomView;
        self.nikename = [[UILabel alloc]init];
        self.nikename.font = [FontOutSystem fontWithFangZhengSize:15.0];
        self.nikename.textColor = [UIColor whiteColor];
        [self addSubview:self.nikename];
        self.age = [[UILabel alloc]init];
        self.age.textColor = [UIColor whiteColor];
        self.age.font = [FontOutSystem fontWithFangZhengSize:15.0];
        [self addSubview:self.age];
        self.sex = [[UIImageView alloc]init];
        [self addSubview:self.sex];
        self.locationImage = [[UIImageView alloc]init];
        self.locationImage.image = [UIImage imageNamed:@"peiwan_locationWhite"];
        self.locationImage.frame = CGRectMake(10, dtScreenWidth-30
                                              -10-16, 16, 16);
        [self addSubview:self.locationImage];
        self.distance = [[UILabel alloc]init];
        self.distance.font = [FontOutSystem fontWithFangZhengSize:12.0];
        self.distance.textColor = [UIColor whiteColor];
        [self addSubview:self.distance];
        
        self.concern = [UIButton buttonWithType:UIButtonTypeCustom];

        [self.concern setTitle:@"＋ 关注" forState:UIControlStateNormal];
        self.concern.titleLabel.font = [FontOutSystem fontWithFangZhengSize:17.0];
        self.concern.titleLabel.textColor = [UIColor whiteColor];
        self.concern.backgroundColor = [CorlorTransform colorWithHexString:@"#ed5b5b"];
        self.concern.layer.cornerRadius = 5;
        self.concern.frame = CGRectMake(dtScreenWidth-10-80, dtScreenWidth-30-10-30, 80, 30);
        [self.concern addTarget:self action:@selector(concernClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.concern];
        
        self.biaoqian1 = [[UILabel alloc]init];
        self.biaoqian2 = [[UILabel alloc]init];
        self.biaoqian3 = [[UILabel alloc]init];
        self.biaoqianImage1 = [[UIImageView alloc]init];
        self.biaoqianImage2 = [[UIImageView alloc]init];
        self.biaoqianImage3 = [[UIImageView alloc]init];
        
        [self addSubview:_biaoqianImage1];
        [self addSubview:_biaoqianImage2];
        [self addSubview:_biaoqianImage3];
        
        [self addSubview:self.biaoqian1];
        [self addSubview:self.biaoqian2];
        [self addSubview:self.biaoqian3];

        self.ID = [[UILabel alloc]init];
        self.ID.font = [FontOutSystem fontWithFangZhengSize:15.0];
        self.ID.textColor = [UIColor whiteColor];
        [self addSubview:self.ID];
        
        UIImageView * whiteView = [[UIImageView alloc]initWithFrame:CGRectMake(0, dtScreenWidth, dtScreenWidth, 40)];
        whiteView.image = [UIImage imageNamed:@"whiteView"];
        [self addSubview:whiteView];
        NSArray * titleLabal = @[@"资料",@"动态",@"粉丝",@"认证"];
        for (int i = 0; i<4; i++) {
            UIButton * fourButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [fourButton setTitle:[NSString stringWithFormat:@"%@",titleLabal[i]] forState:UIControlStateNormal];
            fourButton.titleLabel.font = [FontOutSystem fontWithFangZhengSize:13.0];
            fourButton.frame = CGRectMake(i*dtScreenWidth/4, dtScreenWidth, dtScreenWidth/4, 40);
            [fourButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            fourButton.tag = i+1;
            [fourButton addTarget:self action:@selector(fourButtonClickWithTitle:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:fourButton];
        }
        
        UIView * redLine = [[UIView alloc]initWithFrame:CGRectMake(0, dtScreenWidth+39, dtScreenWidth/4, 2)];
        redLine.backgroundColor = [UIColor redColor];
        [self addSubview: redLine];
        self.redLine = redLine;
        
    }
    return self;
}
-(void)setUserMessage:(NSDictionary *)userMessage
{
    
    NSString * session = [PersistenceManager getLoginSession];
    [UserConnector findMyFans:session offset:0 limit:99 receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [json[@"status"] intValue];
            if (status == 0) {
                
                self.MyfriendArray = json[@"entity"];
                [self.MyfriendArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if ([obj[@"id"] isEqual:userMessage[@"id"]]) {
                        [self.concern setTitle:@"取消关注" forState:UIControlStateNormal];
                    }
                }];
                
            }else{}
            
        }
    }];

    self.othersDic = userMessage;
    self.array = userMessage[@"userPhotos"];
    if (self.array.count<1) {
        
    }
    self.scrollview.contentSize = CGSizeMake(dtScreenWidth*self.array.count+dtScreenWidth, dtScreenWidth);
    
    self.pagecontrol.numberOfPages = self.array.count+1;
    self.pagecontrol.currentPage = 0;
    [self.pagecontrol setCurrentPageIndicatorTintColor:[CorlorTransform colorWithHexString:@"#ed5b5b"]];
    [self.pagecontrol setPageIndicatorTintColor:[CorlorTransform colorWithHexString:@"#ffcccc"]];
    for (int i = 0; i<self.array.count+1; i++) {
        if (i == 0) {
            UIImageView * headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenWidth)];
            headerImage.contentMode = UIViewContentModeScaleAspectFill;
            [headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!1",userMessage[@"headUrl"]]]];
            [self.scrollview addSubview:headerImage];
        }else{
            self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake(i*dtScreenWidth, 0, dtScreenWidth, dtScreenWidth)];
            self.imageview.contentMode = UIViewContentModeScaleAspectFill;
            [self.imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!1",self.array[i-1][@"url"]]]];
            [self.scrollview addSubview:self.imageview];
        }
    }
    self.nikename.text = [NSString stringWithFormat:@"%@",userMessage[@"nickname"]];
    CGSize size_name = [self.nikename.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.nikename.font,NSFontAttributeName, nil]];
    self.nikename.frame = CGRectMake(10, self.locationImage.frame.origin.y-14-size_name.height, size_name.width, size_name.height);
    
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy";
    NSString *year = [formatter stringFromDate:today];
    int yearnow = year.intValue;
    int birthyear = [[userMessage objectForKey:@"year"]intValue];
    int age = yearnow - birthyear;
    self.age.text = [NSString stringWithFormat:@"%d",age];
    CGSize size_age = [self.age.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.age.font,NSFontAttributeName, nil]];
    self.age.frame = CGRectMake(self.nikename.frame.origin.x+self.nikename.frame.size.width+10, self.nikename.frame.origin.y+self.nikename.frame.size.height-size_age.height, size_age.width, size_age.height);
    
    self.sex.frame = CGRectMake(self.age.frame.origin.x+5+self.age.frame.size.width, self.age.frame.origin.y, size_age.height, size_age.height);
    if ([userMessage[@"gender"] intValue]==0) {
        self.sex.image = [UIImage imageNamed:@"peiwan_male"];
    }else{
        self.sex.image = [UIImage imageNamed:@"peiwan_female"];
    }
    
    if ([userMessage[@"distance"] doubleValue]>1000) {
        self.distance.text = [NSString stringWithFormat:@"%.2f公里",[userMessage[@"distance"] doubleValue]/1000];
    }else{
        self.distance.text = [NSString stringWithFormat:@"%.2f米",[userMessage[@"distance"] doubleValue]];
    }
    CGSize size_distance = [self.distance.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.distance.font,NSFontAttributeName, nil]];
    self.distance.frame = CGRectMake(31, self.locationImage.center.y-size_distance.height/2, size_distance.width, size_distance.height);
    
    
    self.ID.text = [NSString stringWithFormat:@"ID:%@",userMessage[@"id"]];
    CGSize size_id = [self.ID.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.ID.font,NSFontAttributeName, nil]];
    self.ID.frame = CGRectMake(dtScreenWidth-10-size_id.width, dtScreenWidth-30+(30-size_id.height)/2, size_id.width, size_id.height);

    
    NSArray * titlelabel = @[@"线上点歌",@"视屏聊天",@"聚餐",@"线下K歌",@"夜店达人",@"叫醒服务",@"影伴",@"运动健身",@"LOL"];

    
    NSArray * usertimeTags = [userMessage objectForKey:@"userTimeTags"];
    if (usertimeTags.count==1) {
        NSDictionary * dic1 = usertimeTags[0];
        
        NSString * index = dic1[@"index"];
        
        self.biaoqian1.text = [titlelabel objectAtIndex:[index integerValue]-1];
        self.biaoqian1.font = [FontOutSystem fontWithFangZhengSize:10.0];
        self.biaoqian1.textColor = [UIColor whiteColor];
        CGSize biao1size = [self.biaoqian1.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.biaoqian1.font,NSFontAttributeName, nil]];
        self.biaoqian1.frame = CGRectMake(10, self.bottomView.frame.origin.y+10, biao1size.width, biao1size.height);
        
        self.biaoqianImage1.frame = CGRectMake(self.biaoqian1.frame.origin.x-2,self.biaoqian1.frame.origin.y-6 , biao1size.width + 4, biao1size.height + 8);
        self.biaoqianImage1.image = [UIImage imageNamed:@"biaoqian"];
        self.biaoqian1.tag = [dic1[@"price"] integerValue];

        
    }else if (usertimeTags.count==2){
        
        NSDictionary * dic1 = usertimeTags[0];
        
        NSString * index = dic1[@"index"];
        
        self.biaoqian1.text = [titlelabel objectAtIndex:[index integerValue]-1];
        self.biaoqian1.font = [FontOutSystem fontWithFangZhengSize:10.0];
        self.biaoqian1.textColor = [UIColor whiteColor];
        CGSize biao1size = [self.biaoqian1.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.biaoqian1.font,NSFontAttributeName, nil]];
        self.biaoqian1.frame = CGRectMake(10, self.bottomView.frame.origin.y+10, biao1size.width, biao1size.height);
        
        self.biaoqianImage1.frame = CGRectMake(self.biaoqian1.frame.origin.x-2,self.biaoqian1.frame.origin.y-6 , biao1size.width + 4, biao1size.height + 8);
        self.biaoqianImage1.image = [UIImage imageNamed:@"biaoqian"];
        
        NSDictionary * dic2 = usertimeTags[1];
        NSString * index2 = dic2[@"index"];
        self.biaoqian2.text = [titlelabel objectAtIndex:[index2 integerValue]-1];
        self.biaoqian2.font = [FontOutSystem fontWithFangZhengSize:10.0];
        self.biaoqian2.textColor = [UIColor whiteColor];
        CGSize biao2size = [self.biaoqian2.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.biaoqian2.font,NSFontAttributeName, nil]];
        self.biaoqian2.frame = CGRectMake(self.biaoqian1.frame.origin.x+self.biaoqian1.frame.size.width+7, self.biaoqian1.frame.origin.y, biao2size.width, biao2size.height);
        
        self.biaoqianImage2.frame = CGRectMake(self.biaoqian2.frame.origin.x-2,self.biaoqian2.frame.origin.y-6 , biao2size.width + 4, biao2size.height + 8);
        self.biaoqianImage2.image = [UIImage imageNamed:@"biaoqian"];
        
        self.biaoqian1.tag = [dic1[@"price"] integerValue];
        self.biaoqian2.tag = [dic2[@"price"] integerValue];

        
    }else if (usertimeTags.count==3){
        NSDictionary * dic1 = usertimeTags[0];
        
        NSString * index = dic1[@"index"];
        
        self.biaoqian1.text = [titlelabel objectAtIndex:[index integerValue]-1];
        self.biaoqian1.font = [FontOutSystem fontWithFangZhengSize:10.0];
        self.biaoqian1.tag = [dic1[@"price"] integerValue];
        self.biaoqian1.textColor = [UIColor whiteColor];
        CGSize biao1size = [self.biaoqian1.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.biaoqian1.font,NSFontAttributeName, nil]];
        self.biaoqian1.frame = CGRectMake(10, self.bottomView.frame.origin.y+10, biao1size.width, biao1size.height);
        
        self.biaoqianImage1.frame = CGRectMake(self.biaoqian1.frame.origin.x-2,self.biaoqian1.frame.origin.y-6 , biao1size.width + 4, biao1size.height + 8);
        self.biaoqianImage1.image = [UIImage imageNamed:@"biaoqian"];
        
        NSDictionary * dic2 = usertimeTags[1];
        NSString * index2 = dic2[@"index"];
        self.biaoqian2.text = [titlelabel objectAtIndex:[index2 integerValue]-1];
        self.biaoqian2.font = [FontOutSystem fontWithFangZhengSize:10.0];
        self.biaoqian2.tag = [dic2[@"price"] integerValue];

        self.biaoqian2.textColor = [UIColor whiteColor];
        CGSize biao2size = [self.biaoqian2.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.biaoqian2.font,NSFontAttributeName, nil]];
        self.biaoqian2.frame = CGRectMake(self.biaoqian1.frame.origin.x+self.biaoqian1.frame.size.width+7, self.biaoqian1.frame.origin.y, biao2size.width, biao2size.height);
        
        self.biaoqianImage2.frame = CGRectMake(self.biaoqian2.frame.origin.x-2,self.biaoqian2.frame.origin.y-6 , biao2size.width + 4, biao2size.height + 8);
        self.biaoqianImage2.image = [UIImage imageNamed:@"biaoqian"];
        
        NSDictionary * dic3 = usertimeTags[2];
        NSString * index3 = dic3[@"index"];
        self.biaoqian3.text = [titlelabel objectAtIndex:[index3 integerValue]-1];
        self.biaoqian3.font = [FontOutSystem fontWithFangZhengSize:10.0];
        self.biaoqian3.tag = [dic3[@"price"] integerValue];

        self.biaoqian3.textColor = [UIColor whiteColor];
        CGSize biao3size = [self.biaoqian3.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.biaoqian3.font,NSFontAttributeName, nil]];
        self.biaoqian3.frame = CGRectMake(self.biaoqian2.frame.origin.x+self.biaoqian2.frame.size.width+7, self.biaoqian2.frame.origin.y, biao3size.width, biao3size.height);
        
        self.biaoqianImage3.frame = CGRectMake(self.biaoqian3.frame.origin.x-2,self.biaoqian3.frame.origin.y-6 , biao3size.width + 4, biao3size.height + 8);
        self.biaoqianImage3.image = [UIImage imageNamed:@"biaoqian"];
        
    }else{
        
    }

    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/dtScreenWidth;
    self.pagecontrol.currentPage = page;
}
- (void)clickPageController:(UIPageControl *)pageController event:(UIEvent *)touchs{
    UITouch *touch = [[touchs allTouches] anyObject];
    CGPoint p = [touch locationInView:self.pagecontrol];
    CGFloat centerX = pageController.center.x;
    CGFloat left = centerX-15.0*pageController.numberOfPages/2;
    [self.pagecontrol setCurrentPage:(int ) (p.x-left)/15];    
    [self.scrollview setContentOffset:CGPointMake(pageController.currentPage*dtScreenWidth, 0)];
}
- (void)concernClick:(UIButton *)sender
{
    NSString *sesstion = [PersistenceManager getLoginSession];
    
    if ([sender.titleLabel.text isEqualToString:@"取消关注"]) {
        
        [UserConnector deleteFriend:sesstion friendId:[self.othersDic objectForKey:@"id"] receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    [ShowMessage showMessage:@"取消关注成功"];
                    [sender setTitle:@"关注" forState:UIControlStateNormal];
                }else if (status == 1){

                }else{
                    
                }
            }
        }];
    }else{
        NSLog(@"%@",self.othersDic);
        [UserConnector addFriend:sesstion friendId:[self.othersDic objectForKey:@"id"] receiver:^(NSData *data,NSError *error){
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];

                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    [ShowMessage showMessage:@"关注成功"];
                    [sender setTitle:@"取消关注" forState:UIControlStateNormal];
                }else if (status == 1){

                }else{
                    
                }
            }
        }];
        
    }

    
}

- (void)fourButtonClickWithTitle:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqual:@"资料"]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.redLine.frame = CGRectMake(0, dtScreenWidth+39, dtScreenWidth/4, 2);
        }];
    }
    if ([sender.titleLabel.text isEqual:@"动态"]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.redLine.frame = CGRectMake(dtScreenWidth/4, dtScreenWidth+39, dtScreenWidth/4, 2);
        }];
    }
    if ([sender.titleLabel.text isEqual:@"粉丝"]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.redLine.frame = CGRectMake(dtScreenWidth/2, dtScreenWidth+39, dtScreenWidth/4, 2);
        }];
    }
    if ([sender.titleLabel.text isEqual:@"认证"]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.redLine.frame = CGRectMake(dtScreenWidth/4*3, dtScreenWidth+39, dtScreenWidth/4, 2);
        }];
    }
    
    [self.delegate fourButtonWithTitle:sender];
}
@end
