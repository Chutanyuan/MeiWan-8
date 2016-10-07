//
//  PeiwanHeadViewController.m
//  MeiWan
//
//  Created by apple on 15/9/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "PeiwanHeadViewController.h"
#import "UIImageView+WebCache.h"
#import "creatAlbum.h"
@interface PeiwanHeadViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIScrollView *scrollerview;

@end

@implementation PeiwanHeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.scrollerview = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollerview.backgroundColor = [UIColor blackColor];
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [self.scrollerview addSubview:self.imageView];
    [self.view addSubview:self.scrollerview];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    NSURL *headUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",[self.peiwanInfoDic objectForKey:@"headUrl"]]];
    [self.imageView setImageWithURL:headUrl placeholderImage:nil];
    self.imageView.userInteractionEnabled = YES;
    //放大倍数
    self.scrollerview.maximumZoomScale=3.0;
    self.scrollerview.minimumZoomScale=1.0;
    //隐藏滚动条
    self.scrollerview. showsHorizontalScrollIndicator=NO;
    self.scrollerview.showsVerticalScrollIndicator=NO;
    self.scrollerview.delegate=self;

    //创建双击手势用于放大缩小图片
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    //设置点击数量
    tap.numberOfTapsRequired = 2;
    //设置触摸手指的数量
    tap.numberOfTouchesRequired = 1;
    [self.scrollerview addGestureRecognizer:tap];
    
    //创建隐藏\显示导航栏和状态栏的手势
    UITapGestureRecognizer *taphidden = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taphiddenAction:)];
    [self.scrollerview addGestureRecognizer:taphidden];
    
    //当tap手势触发时，让tap1手势失效
    [taphidden requireGestureRecognizerToFail:tap];

    // Do any additional setup after loading the view.
}
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (self .scrollerview.zoomScale > 1) {//大于1，说明已经放大了
        [self .scrollerview setZoomScale:1 animated:YES];
    }else
    {
        [self .scrollerview setZoomScale:3 animated:YES];
    }
    
}
- (void)taphiddenAction:(UITapGestureRecognizer *)tap
{
    [[self navigationController] setNavigationBarHidden:![[self navigationController] isNavigationBarHidden] animated:YES];
}

#pragma mark -UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
