//
//  PreviewPhotoView.m
//
//
//  Created by Joywii on 13-10-16.
//  Copyright (c) 2013年 Joywii. All rights reserved.
//

#import "PreviewImageView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "creatAlbum.h"

@interface PreviewImageView ()<UIActionSheetDelegate,UIGestureRecognizerDelegate>
{
    CGFloat lastScale;
}
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIImageView *photoImageView;
@property (nonatomic,strong) NSValue *starRectValue;
@property (nonatomic,strong) NSValue *imageRectValue;
@property (nonatomic,strong) UIImage* imageview_image;
@property (nonatomic,strong) NSString * imageUrl;

@end

@implementation PreviewImageView

+ (void)showPreviewImage:(UIImage *)image startImageFrame:(CGRect)startImageFrame inView:(UIView *)inView viewFrame:(CGRect)viewFrame
{
    PreviewImageView *preImageView = [[PreviewImageView alloc] initWithFrame:viewFrame withImage:image startFrame:startImageFrame];
    [inView addSubview:preImageView];
}
- (id)initWithFrame:(CGRect)frame withImage:(UIImage *)image startFrame:(CGRect)startFrame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.opaque = YES;
        
        self.starRectValue =  [NSValue valueWithCGRect:startFrame];
        
        self.contentView = [[UIView alloc] initWithFrame:startFrame];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.userInteractionEnabled = YES;
        self.contentView.clipsToBounds = YES;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 3.0;
        [self addSubview:self.contentView];
        
        CGRect imageFrame = startFrame;
        imageFrame.origin.x = 0;
        imageFrame.origin.y = 0;
        self.imageRectValue = [NSValue valueWithCGRect:imageFrame];
        
        self.photoImageView = [[UIImageView alloc] initWithFrame:imageFrame];
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.photoImageView.image = image;
        self.photoImageView.backgroundColor = [UIColor clearColor];
        self.photoImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.photoImageView];
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapView:)];
        [self.photoImageView addGestureRecognizer:tapGesture];

        [self addLongPressGestureRecognizer];
        [self addPinchGestureRecognizer];
        
        [UIView beginAnimations:@"backgroundcolor" context:nil];
        [UIView setAnimationDuration:0.1];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.backgroundColor = [UIColor blackColor];
        [UIView commitAnimations];
        
        [self startShowAnimation];
        self.imageview_image = image;
        
       
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"查看原图" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        button.frame = CGRectMake(dtScreenWidth/2-50, dtScreenHeight-80, 100, 40);
        [button addTarget:self action:@selector(chaKan:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageUrl:) name:@"image_url" object:nil];
        
    }
    return self;
}
- (void)chaKan:(UIButton *)sender
{
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]];
    sender.hidden = YES;
}
- (void)imageUrl:(NSNotification *)text
{
    self.imageUrl = text.object;
}

- (void)handleTapView:(UIGestureRecognizer *)gestureRecognizer
{
    [self startHideAnimation];
    [self performSelector:@selector(hide) withObject:nil afterDelay:0.4];
}
- (void)hide
{
    [self removeFromSuperview];
}
- (void)startShowAnimation
{
    [UIView beginAnimations:@"scaleImageShow" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.photoImageView.frame = self.bounds;
    self.contentView.frame = self.bounds;
    [UIView commitAnimations];
}
- (void)startHideAnimation
{
    [UIView beginAnimations:@"scaleImageHide" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.photoImageView.frame = [self.imageRectValue CGRectValue];
    self.contentView.frame = [self.starRectValue CGRectValue];
    self.backgroundColor = [UIColor clearColor];
    [UIView commitAnimations];
}

- (void)addPinchGestureRecognizer
{
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaGesture:)];
    [pinchRecognizer setDelegate:self];
    [self addGestureRecognizer:pinchRecognizer];
}
- (void)addLongPressGestureRecognizer
{
    UILongPressGestureRecognizer *longPressGR =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(handleLongPress:)];
    
    [longPressGR setMinimumPressDuration:0.4];
    [self addGestureRecognizer:longPressGR];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:@"保存到相册"
                                                   otherButtonTitles:nil];
        action.actionSheetStyle = UIActionSheetStyleDefault;
        action.tag = 123456;
        
        [action showInView:self];
    }
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 123456 && buttonIndex == 0)
    {
        if (self.photoImageView.image)
        {
            [creatAlbum createAlbumSaveImage:self.photoImageView.image];
        }
        else
        {
            NSLog(@"image is nil");
        }
    }
}
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL)
    {
        NSLog(@"%@",error);
    }
    else
    {
        NSLog(@"save success!");
    }
}
- (void)scaGesture:(UIPinchGestureRecognizer *)sender
{
    
//    [self bringSubviewToFront:[(UIPinchGestureRecognizer*)sender view]];
//    //当手指离开屏幕时,将lastscale设置为1.0
//    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
//        lastScale = 1.0;
//        return;
//    }
//    
//    CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)sender scale]);
//    CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
//    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
//    [[(UIPinchGestureRecognizer*)sender view]setTransform:newTransform];
//    lastScale = [(UIPinchGestureRecognizer*)sender scale];
    
}

//4. 加入手势的代理方法
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}
//#pragma mark - 放大动画
//-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    
////    1.检测手指的个数
//    NSArray * touchesArr=[[event allTouches] allObjects];
//    NSLog(@"手指个数%lu",(unsigned long)[touchesArr count]);
//    
////    2.检测两指的坐标，从而计算两指的距离。
//    CGPoint p1=[[touchesArr objectAtIndex:0] locationInView:self];
//    CGPoint p2=[[touchesArr objectAtIndex:1] locationInView:self];
//    
//
//    CGFloat kuan = sqrt((p1.x-p2.x)*(p1.x-p2.x) + (p1.y-p2.y)*(p1.y-p2.y));
//
//    //    3.计算距离增加，则增大图片，距离减小则缩小图片。用imageview的frame来控制图片的大小。
//    self.frame=CGRectMake(self.frame.origin.x-kuan/2.0f, self.frame.origin.y-kuan/2.0f, self.frame.size.width, self.frame.size.height);
//    
//}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
